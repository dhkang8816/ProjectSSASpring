package com.spring.service;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.Map;

import com.spring.util.RuntimeSettings;

/**
 * Controls only the locally configured Flask runtime.  No request parameter is
 * ever used as a command or executable path, and stopping is performed through
 * Flask's token-protected shutdown endpoint instead of killing arbitrary
 * Python processes.
 */
public class FlaskRuntimeControlService {

    private static final int HEALTH_TIMEOUT_MS = 1500;
    private static final int CONTROL_TIMEOUT_MS = 3000;

    private final Object processMonitor = new Object();
    private volatile Process managedProcess;

    public Map<String, Object> status() {
        boolean online = isFlaskOnline();
        boolean enabled = RuntimeSettings.enabled("SSA_FLASK_CONTROL_ENABLED", false);
        boolean localTarget = isLocalFlaskTarget();
        boolean projectReady = isProjectReady();
        boolean tokenReady = hasControlToken();
        boolean managedProcessAlive = isManagedProcessAlive();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("online", online);
        result.put("controlEnabled", enabled);
        result.put("managedProcess", managedProcessAlive);
        result.put("canStart", enabled && localTarget && projectReady && tokenReady && !online && !managedProcessAlive);
        result.put("canStop", enabled && localTarget && tokenReady && online);
        result.put("message", statusMessage(online, enabled, localTarget, projectReady, tokenReady));
        return result;
    }

    public Map<String, Object> start() {
        synchronized (processMonitor) {
            if (isFlaskOnline()) {
                return actionResult(false, "ALREADY_ONLINE", "Flask 서버가 이미 실행 중입니다.");
            }
            String configurationError = startConfigurationError();
            if (configurationError != null) {
                return actionResult(false, "CONFIGURATION_REQUIRED", configurationError);
            }
            if (isManagedProcessAlive()) {
                return actionResult(false, "STARTING", "Flask 시작 프로세스가 이미 실행 중입니다.");
            }

            try {
                ProcessBuilder processBuilder = new ProcessBuilder(
                        RuntimeSettings.text("SSA_FLASK_PYTHON_EXECUTABLE", ""), "run_server.py");
                processBuilder.directory(projectDirectory().toFile());
                processBuilder.redirectErrorStream(true);
                processBuilder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
                managedProcess = processBuilder.start();
                return actionResult(true, "START_REQUESTED", "Flask 시작을 요청했습니다. 상태 확인을 기다립니다.");
            } catch (IOException error) {
                return actionResult(false, "START_FAILED", "Flask를 시작하지 못했습니다. Python 실행 경로와 프로젝트 경로를 확인하세요.");
            }
        }
    }

    public Map<String, Object> stop() {
        synchronized (processMonitor) {
            if (!isFlaskOnline()) {
                return actionResult(false, "ALREADY_OFFLINE", "Flask 서버가 이미 중지되어 있습니다.");
            }
            String configurationError = controlConfigurationError();
            if (configurationError != null) {
                return actionResult(false, "CONFIGURATION_REQUIRED", configurationError);
            }

            HttpURLConnection connection = null;
            try {
                connection = (HttpURLConnection) URI.create(controlUrl()).toURL().openConnection();
                connection.setRequestMethod("POST");
                connection.setConnectTimeout(CONTROL_TIMEOUT_MS);
                connection.setReadTimeout(CONTROL_TIMEOUT_MS);
                connection.setDoOutput(true);
                connection.setRequestProperty("X-SSA-Flask-Control-Token",
                        RuntimeSettings.text("SSA_FLASK_CONTROL_TOKEN", ""));
                int status = connection.getResponseCode();
                if (status >= 200 && status < 300) {
                    return actionResult(true, "STOP_REQUESTED", "Flask 정상 종료를 요청했습니다.");
                }
                return actionResult(false, "STOP_REJECTED", "Flask 종료 요청이 거부되었습니다. 제어 토큰을 확인하세요.");
            } catch (Exception error) {
                return actionResult(false, "STOP_FAILED", "Flask 종료 요청에 실패했습니다. 서버 연결 상태를 확인하세요.");
            } finally {
                if (connection != null) {
                    connection.disconnect();
                }
            }
        }
    }

    private Map<String, Object> actionResult(boolean success, String action, String message) {
        Map<String, Object> result = status();
        result.put("success", success);
        result.put("action", action);
        result.put("message", message);
        return result;
    }

    private boolean isFlaskOnline() {
        HttpURLConnection connection = null;
        try {
            connection = (HttpURLConnection) URI.create(healthUrl()).toURL().openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(HEALTH_TIMEOUT_MS);
            connection.setReadTimeout(HEALTH_TIMEOUT_MS);
            int status = connection.getResponseCode();
            return status >= 200 && status < 300;
        } catch (Exception ignored) {
            return false;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private boolean isManagedProcessAlive() {
        Process process = managedProcess;
        if (process != null && !process.isAlive()) {
            managedProcess = null;
            process = null;
        }
        return process != null;
    }

    private String statusMessage(boolean online, boolean enabled, boolean localTarget,
            boolean projectReady, boolean tokenReady) {
        if (online) {
            if (!enabled) {
                return "Flask 서버는 실행 중이지만 제어 기능이 비활성화되어 있습니다.";
            }
            if (!localTarget) {
                return "Flask 서버는 실행 중이지만 원격 주소는 이 화면에서 제어할 수 없습니다.";
            }
            if (!tokenReady) {
                return "Flask 서버는 실행 중이지만 제어 토큰 설정이 필요합니다.";
            }
            return "Flask 서버가 실행 중입니다.";
        }
        if (!enabled) {
            return "Flask 제어 기능이 비활성화되어 있습니다.";
        }
        if (!localTarget) {
            return "원격 Flask 주소는 이 화면에서 제어할 수 없습니다.";
        }
        if (!projectReady) {
            return "Flask 프로젝트 경로 또는 run_server.py 설정을 확인하세요.";
        }
        if (!tokenReady) {
            return "Flask 제어 토큰 설정이 필요합니다.";
        }
        return "Flask 서버가 중지되어 있습니다.";
    }

    private String controlConfigurationError() {
        if (!RuntimeSettings.enabled("SSA_FLASK_CONTROL_ENABLED", false)) {
            return "SSA_FLASK_CONTROL_ENABLED=true 설정이 필요합니다.";
        }
        if (!isLocalFlaskTarget()) {
            return "보안을 위해 localhost Flask 서버만 이 화면에서 제어할 수 있습니다.";
        }
        if (!hasControlToken()) {
            return "SSA_FLASK_CONTROL_TOKEN 설정이 필요합니다.";
        }
        return null;
    }

    private String startConfigurationError() {
        String controlError = controlConfigurationError();
        if (controlError != null) {
            return controlError;
        }
        if (!isProjectReady()) {
            return "SSA_FLASK_PROJECT_DIR 및 SSA_FLASK_PYTHON_EXECUTABLE 설정을 확인하세요.";
        }
        return null;
    }

    private boolean isProjectReady() {
        String pythonExecutable = RuntimeSettings.text("SSA_FLASK_PYTHON_EXECUTABLE", "");
        return !pythonExecutable.isBlank() && Files.isRegularFile(projectDirectory().resolve("run_server.py"));
    }

    private boolean hasControlToken() {
        String token = RuntimeSettings.text("SSA_FLASK_CONTROL_TOKEN", "");
        return token.length() >= 24 && !token.contains("CHANGE_ME");
    }

    private boolean isLocalFlaskTarget() {
        try {
            String host = URI.create(streamBaseUrl()).getHost();
            return "localhost".equalsIgnoreCase(host) || "127.0.0.1".equals(host) || "::1".equals(host);
        } catch (Exception ignored) {
            return false;
        }
    }

    private Path projectDirectory() {
        return Path.of(RuntimeSettings.text("SSA_FLASK_PROJECT_DIR", ""));
    }

    private String streamBaseUrl() {
        String value = RuntimeSettings.text("SSA_FLASK_STREAM_URL", "http://localhost:5000/stream");
        return value.endsWith("/") ? value.substring(0, value.length() - 1) : value;
    }

    private String healthUrl() {
        return streamBaseUrl() + "/health";
    }

    private String controlUrl() {
        return streamBaseUrl() + "/admin/shutdown";
    }
}

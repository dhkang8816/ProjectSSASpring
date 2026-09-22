package com.spring.service;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.dto.DiagnosticResultVO;
import com.spring.dto.EnvironmentVO;
import com.spring.util.RuntimeSettings;

/**
 * Read-only application diagnostics. No method in this class writes data,
 * starts a camera, invokes mpremote, or sends a webhook notification.
 */
public class SystemDiagnosticsService {

    private static final int EXTERNAL_CONNECT_TIMEOUT_MS = 1500;
    private static final int EXTERNAL_READ_TIMEOUT_MS = 2000;
    private static final String NOAA_KP_URL =
            "https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json";

    private final DataSource dataSource;
    private final EnvironmentService environmentService;
    private final ObjectMapper objectMapper;
    private final DiagnosticsHttpClient httpClient;

    public SystemDiagnosticsService(DataSource dataSource, EnvironmentService environmentService) {
        this(dataSource, environmentService, new ObjectMapper(), null);
    }

    SystemDiagnosticsService(DataSource dataSource, EnvironmentService environmentService,
            ObjectMapper objectMapper, DiagnosticsHttpClient httpClient) {
        this.dataSource = dataSource;
        this.environmentService = environmentService;
        this.objectMapper = objectMapper;
        this.httpClient = httpClient == null ? this::readHttp : httpClient;
    }

    public List<DiagnosticResultVO> diagnoseAll() {
        List<DiagnosticResultVO> results = new ArrayList<>();
        results.add(pass("spring", "Spring MVC", "진단 서비스가 실행 중입니다.", 0));
        results.add(checkOracle());

        FlaskHealth flaskHealth = null;
        try {
            flaskHealth = readFlaskHealth();
            results.add(pass("flask", "Python/Flask", "상태 API가 정상 응답했습니다.", flaskHealth.elapsedMs));
        } catch (Exception error) {
            results.add(fail("flask", "Python/Flask", "상태 API에 연결할 수 없습니다.", 0));
        }

        results.add(checkYolo(flaskHealth));
        results.add(checkSensor(flaskHealth));
        results.add(checkBuzzer(flaskHealth));
        results.add(checkDiscord(flaskHealth));
        results.add(checkKakaoConfiguration());
        results.add(checkOpenMeteo());
        results.add(checkNoaa());
        return results;
    }

    private DiagnosticResultVO checkOracle() {
        long startedAt = System.nanoTime();
        try (Connection connection = dataSource.getConnection();
                Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery("SELECT 1 FROM DUAL")) {
            if (resultSet.next()) {
                return pass("oracle", "Oracle DB", "읽기 전용 연결 확인에 성공했습니다.", elapsedMs(startedAt));
            }
            return fail("oracle", "Oracle DB", "읽기 전용 확인 결과가 비어 있습니다.", elapsedMs(startedAt));
        } catch (Exception error) {
            return fail("oracle", "Oracle DB", "읽기 전용 연결 확인에 실패했습니다.", elapsedMs(startedAt));
        }
    }

    private DiagnosticResultVO checkYolo(FlaskHealth health) {
        if (health == null) {
            return fail("yolo", "YOLO 워커", "Flask 상태를 확인할 수 없습니다.", 0);
        }
        JsonNode sources = health.payload.path("sources");
        int running = 0;
        int total = 0;
        if (sources.isObject()) {
            java.util.Iterator<JsonNode> values = sources.elements();
            while (values.hasNext()) {
                total++;
                if (values.next().path("running").asBoolean(false)) {
                    running++;
                }
            }
        }
        if (total == 0) {
            return warn("yolo", "YOLO 워커", "등록된 영상 소스를 찾지 못했습니다.", health.elapsedMs);
        }
        if (running == 0) {
            return warn("yolo", "YOLO 워커", "모든 영상 소스가 중지 상태입니다.", health.elapsedMs);
        }
        return pass("yolo", "YOLO 워커", running + "/" + total + "개 영상 소스가 실행 중입니다.", health.elapsedMs);
    }

    private DiagnosticResultVO checkSensor(FlaskHealth health) {
        if (health == null) {
            return fail("sensor", "ESP32 환경센서", "Flask 상태를 확인할 수 없습니다.", 0);
        }
        JsonNode sensor = health.payload.path("sensor");
        if (sensor.path("sensorOnline").asBoolean(false)) {
            return pass("sensor", "ESP32 환경센서", "캐시된 센서 데이터가 온라인입니다.", health.elapsedMs);
        }
        return warn("sensor", "ESP32 환경센서", "센서가 오프라인이거나 최근 데이터가 없습니다.", health.elapsedMs);
    }

    private DiagnosticResultVO checkBuzzer(FlaskHealth health) {
        if (health == null) {
            return fail("buzzer", "ESP32 부저", "Flask 상태를 확인할 수 없습니다.", 0);
        }
        JsonNode buzzer = health.payload.path("buzzer");
        if (!buzzer.path("workerRunning").asBoolean(false)) {
            return warn("buzzer", "ESP32 부저", "부저 작업자가 아직 실행되지 않았습니다.", health.elapsedMs);
        }
        if (!buzzer.path("enabled").asBoolean(true)) {
            return warn("buzzer", "ESP32 부저", "운영자가 알람 소리를 꺼 둔 상태입니다.", health.elapsedMs);
        }
        return pass("buzzer", "ESP32 부저", "부저 작업자와 알람 소리가 활성화되어 있습니다.", health.elapsedMs);
    }

    private DiagnosticResultVO checkDiscord(FlaskHealth health) {
        if (health == null) {
            return fail("discord", "Discord 알림", "Flask 상태를 확인할 수 없습니다.", 0);
        }
        JsonNode discord = health.payload.path("discord");
        if (!discord.path("configured").asBoolean(false)) {
            return warn("discord", "Discord 알림", "Webhook이 설정되어 있지 않습니다.", health.elapsedMs);
        }
        if (!discord.path("workerRunning").asBoolean(false)) {
            return warn("discord", "Discord 알림", "알림 작업자가 아직 실행되지 않았습니다.", health.elapsedMs);
        }
        return pass("discord", "Discord 알림", "Webhook 설정과 알림 작업자가 준비되어 있습니다.", health.elapsedMs);
    }

    private DiagnosticResultVO checkKakaoConfiguration() {
        if (RuntimeSettings.kakaoRestApiKey().isEmpty()) {
            return warn("kakao", "Kakao Local API", "REST API 키가 설정되어 있지 않습니다.", 0);
        }
        return pass("kakao", "Kakao Local API", "REST API 키 설정이 확인되었습니다.", 0);
    }

    private DiagnosticResultVO checkOpenMeteo() {
        long startedAt = System.nanoTime();
        try {
            EnvironmentVO environment = environmentService.getEnvironment();
            if (environment == null || environment.getLatitude() == null || environment.getLongitude() == null) {
                return warn("weather", "Open-Meteo", "활성 관제지역 좌표가 설정되어 있지 않습니다.", elapsedMs(startedAt));
            }
            String url = "https://api.open-meteo.com/v1/forecast?latitude=" + environment.getLatitude()
                    + "&longitude=" + environment.getLongitude() + "&current=temperature_2m";
            httpClient.get(url);
            return pass("weather", "Open-Meteo", "현재 기상 API 응답을 확인했습니다.", elapsedMs(startedAt));
        } catch (Exception error) {
            return fail("weather", "Open-Meteo", "현재 기상 API에 연결할 수 없습니다.", elapsedMs(startedAt));
        }
    }

    private DiagnosticResultVO checkNoaa() {
        long startedAt = System.nanoTime();
        try {
            httpClient.get(NOAA_KP_URL);
            return pass("spaceWeather", "NOAA 우주환경", "우주환경 API 응답을 확인했습니다.", elapsedMs(startedAt));
        } catch (Exception error) {
            return fail("spaceWeather", "NOAA 우주환경", "우주환경 API에 연결할 수 없습니다.", elapsedMs(startedAt));
        }
    }

    private FlaskHealth readFlaskHealth() throws IOException {
        long startedAt = System.nanoTime();
        String streamUrl = RuntimeSettings.text("SSA_FLASK_STREAM_URL", "http://localhost:5000/stream");
        String baseUrl = streamUrl.endsWith("/") ? streamUrl.substring(0, streamUrl.length() - 1) : streamUrl;
        JsonNode payload = objectMapper.readTree(httpClient.get(baseUrl + "/health"));
        return new FlaskHealth(payload, elapsedMs(startedAt));
    }

    private String readHttp(String urlText) throws IOException {
        HttpURLConnection connection = (HttpURLConnection) URI.create(urlText).toURL().openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(EXTERNAL_CONNECT_TIMEOUT_MS);
        connection.setReadTimeout(EXTERNAL_READ_TIMEOUT_MS);
        connection.setRequestProperty("Accept", "application/json");
        try {
            int status = connection.getResponseCode();
            if (status < 200 || status >= 300) {
                throw new IOException("HTTP status " + status);
            }
            try (InputStream input = connection.getInputStream()) {
                return new String(input.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
            }
        } finally {
            connection.disconnect();
        }
    }

    private DiagnosticResultVO pass(String id, String name, String message, long elapsedMs) {
        return result(id, name, "PASS", message, elapsedMs);
    }

    private DiagnosticResultVO warn(String id, String name, String message, long elapsedMs) {
        return result(id, name, "WARN", message, elapsedMs);
    }

    private DiagnosticResultVO fail(String id, String name, String message, long elapsedMs) {
        return result(id, name, "FAIL", message, elapsedMs);
    }

    private DiagnosticResultVO result(String id, String name, String status, String message, long elapsedMs) {
        return new DiagnosticResultVO(id, name, status, message, elapsedMs, Instant.now().toString());
    }

    private long elapsedMs(long startedAt) {
        return (System.nanoTime() - startedAt) / 1_000_000;
    }

    private static final class FlaskHealth {
        private final JsonNode payload;
        private final long elapsedMs;

        private FlaskHealth(JsonNode payload, long elapsedMs) {
            this.payload = payload;
            this.elapsedMs = elapsedMs;
        }
    }
}

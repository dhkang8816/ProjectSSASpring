package com.spring.yolo;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;
import com.spring.dto.FlightHistoryVO;
import com.spring.service.DroneService;
import com.spring.service.FlightHistoryService;
import com.spring.service.VideoDroneMapService;
import com.spring.util.RuntimeSettings;

import jakarta.servlet.http.HttpServletResponse;

@Controller
public class AIStreamBridgeController {

	private static final String FLASK_SERVER_URL = RuntimeSettings.text(
			"SSA_FLASK_STREAM_URL", "http://localhost:5000/stream");
	private static final String FLASK_ESP32_VIDEO_URL = RuntimeSettings.text(
			"SSA_FLASK_ESP32_VIDEO_URL", "http://localhost:5000/esp32_yolov12/video_feed");
	private static final int FLASK_VIDEO_CONNECT_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_VIDEO_CONNECT_TIMEOUT_MS", 3000);
	private static final int FLASK_VIDEO_READ_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_VIDEO_READ_TIMEOUT_MS", 3000);
	private static final int FLASK_LABEL_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_LABEL_TIMEOUT_MS", 1500);
	private static final int FLASK_CONTROL_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_CONTROL_TIMEOUT_MS", 7000);
	private static final boolean LEGACY_LABEL_EVENT_SIDE_EFFECTS_ENABLED =
			RuntimeSettings.enabled("SSA_ENABLE_LEGACY_LABEL_EVENT_SIDE_EFFECTS", false);
	private static String currentMode = "local";
	private static String lastActiveSourceKey = "video_1";
	@Autowired
	private AIStreamBridgeService aiStreamBridgeService;

	@Autowired
	private VideoDroneMapService videoDroneMapService;

	@Autowired
	private DroneService droneService;

	@Autowired
	private FlightHistoryService flightHistoryService;

	private static final Map<String, Long> activeFlightStartMap = new ConcurrentHashMap<>();
	private final ObjectMapper objectMapper = new ObjectMapper();

	@GetMapping("/yolo/view")
	public String showMainControlPage(Model model) {
		model.addAttribute("flaskEsp32VideoUrl", FLASK_ESP32_VIDEO_URL);
		return "main";
	}

	@GetMapping("/yolo/detail")
	public String showYoloDetail(@RequestParam(value = "channel", defaultValue = "video_1") String channel) {
		if (!isKnownYoloChannel(channel)) {
			return "redirect:/yolo/view";
		}
		return "yoloDetail";
	}

	@PostMapping("/yolo/updateMapping")
	@ResponseBody
	public ResponseEntity<String> updateVideoDroneMapping(@RequestParam("sourceKey") String sourceKey,
			@RequestParam("droneId") String droneId) {
		try {
			videoDroneMapService.modifyDroneMapping(sourceKey, droneId);
			aiStreamBridgeService.updateInmemoryDroneCache(sourceKey, droneId);
			return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping("/yolo/videoFeed")
	public void bridgeStream(HttpServletResponse response) {
		if (activeFlightStartMap.putIfAbsent(lastActiveSourceKey, System.currentTimeMillis()) == null) {
			System.out.println(" [최초 화면 진입 이륙] 채널 [" + lastActiveSourceKey + "]의 첫 비행 타이머가 가동되었습니다.");
		}
		String pythonServerUrl = FLASK_SERVER_URL + "/video_feed";
		executeProxy(pythonServerUrl, response, FLASK_VIDEO_CONNECT_TIMEOUT_MS, FLASK_VIDEO_READ_TIMEOUT_MS, false);
	}

	@RequestMapping("/yolo/videoFeed/{sourceKey}")
	public void bridgeSourceStream(@PathVariable("sourceKey") String sourceKey, HttpServletResponse response)
			throws IOException {
		if (!isSafeSourceKey(sourceKey)) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown video source");
			return;
		}
		String pythonServerUrl = FLASK_SERVER_URL + "/video_feed/" + sourceKey;
		executeProxy(pythonServerUrl, response, FLASK_VIDEO_CONNECT_TIMEOUT_MS, FLASK_VIDEO_READ_TIMEOUT_MS, false);
	}

	@PostMapping(value = "/yolo/detection/{sourceKey}/{action}", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> controlSourceDetection(@PathVariable("sourceKey") String sourceKey,
			@PathVariable("action") String action) {
		if (!isSafeSourceKey(sourceKey) || !isDetectionAction(action)) {
			return new ResponseEntity<>("{\"status\":\"FAIL\",\"error\":\"invalid source or action\"}",
					HttpStatus.BAD_REQUEST);
		}
		ResponseEntity<String> flaskResponse = postToFlaskDetection("/" + sourceKey + "/" + action);
		synchronizeFlightLifecycle(sourceKey, action, flaskResponse);
		return flaskResponse;
	}

	@PostMapping(value = "/yolo/detection/{action}", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> controlAllDetection(@PathVariable("action") String action) {
		if (!isDetectionAction(action)) {
			return new ResponseEntity<>("{\"status\":\"FAIL\",\"error\":\"invalid action\"}",
					HttpStatus.BAD_REQUEST);
		}
		ResponseEntity<String> flaskResponse = postToFlaskDetection("/" + action);
		for (String sourceKey : new String[] { "video_1", "video_2", "video_3", "esp32" }) {
			synchronizeFlightLifecycle(sourceKey, action, flaskResponse);
		}
		return flaskResponse;
	}

	@GetMapping(value = "/yolo/detection/status", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> detectionStatus() {
		try {
			ResponseEntity<String> flaskResponse = flaskRestTemplate(FLASK_LABEL_TIMEOUT_MS)
					.getForEntity(FLASK_SERVER_URL + "/status", String.class);
			return ResponseEntity.status(flaskResponse.getStatusCode()).body(flaskResponse.getBody());
		} catch (Exception e) {
			return new ResponseEntity<>("{\"status\":\"FAIL\",\"error\":\"Flask status unavailable\"}",
					HttpStatus.BAD_GATEWAY);
		}
	}

	@GetMapping(value = "/yolo/buzzer/enabled", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> buzzerEnabled() {
		try {
			ResponseEntity<String> flaskResponse = flaskRestTemplate(FLASK_CONTROL_TIMEOUT_MS)
					.getForEntity(FLASK_SERVER_URL + "/buzzer/enabled", String.class);
			return ResponseEntity.status(flaskResponse.getStatusCode()).body(flaskResponse.getBody());
		} catch (Exception e) {
			return new ResponseEntity<>("{\"status\":\"FAIL\",\"error\":\"Flask buzzer service unavailable\"}",
					HttpStatus.BAD_GATEWAY);
		}
	}

	@PostMapping(value = "/yolo/buzzer/enabled", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> setBuzzerEnabled(@RequestParam("enabled") boolean enabled) {
		try {
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			HttpEntity<String> request = new HttpEntity<>("{\"enabled\":" + enabled + "}", headers);
			ResponseEntity<String> flaskResponse = flaskRestTemplate(FLASK_CONTROL_TIMEOUT_MS)
					.postForEntity(FLASK_SERVER_URL + "/buzzer/enabled", request, String.class);
			return ResponseEntity.status(flaskResponse.getStatusCode()).body(flaskResponse.getBody());
		} catch (Exception e) {
			return new ResponseEntity<>("{\"status\":\"FAIL\",\"error\":\"Flask buzzer service unavailable\"}",
					HttpStatus.BAD_GATEWAY);
		}
	}

	@GetMapping(value = "/yolo/envSensor/status", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> environmentSensorStatus() {
		try {
			ResponseEntity<String> flaskResponse = flaskRestTemplate(FLASK_LABEL_TIMEOUT_MS)
					.getForEntity(FLASK_SERVER_URL + "/sensor/status", String.class);
			return ResponseEntity.status(flaskResponse.getStatusCode()).body(flaskResponse.getBody());
		} catch (Exception e) {
			return new ResponseEntity<>(
					"{\"temperature\":0,\"humidity\":0,\"illumination\":0,\"distance\":0,"
							+ "\"collisionWarning\":false,\"collisionLevel\":\"UNKNOWN\",\"sensorOnline\":false}",
					HttpStatus.BAD_GATEWAY);
		}
	}

	@GetMapping(value = "/yolo/flight/status", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> flightStatus() {
		Map<String, Object> result = new LinkedHashMap<>();
		for (String sourceKey : new String[] { "video_1", "video_2", "video_3", "esp32" }) {
			Long startTime = activeFlightStartMap.get(sourceKey);
			Map<String, Object> sourceStatus = new LinkedHashMap<>();
			sourceStatus.put("running", startTime != null);
			sourceStatus.put("startTime", startTime);
			sourceStatus.put("droneId", resolveDroneId(sourceKey));
			result.put(sourceKey, sourceStatus);
		}
		return ResponseEntity.ok(result);
	}

	@RequestMapping("/yolo/changeVideo/{sourceKey}")
	@ResponseBody
	public String changeVideoSource(@PathVariable("sourceKey") String sourceKey) {
		System.out.println(" → [스프링] 사용자가 새로운 채널 전환 요청: " + sourceKey);
		try {
			String prevSourceKey = lastActiveSourceKey;
			completeActiveFlight(prevSourceKey);
			beginActiveFlight(sourceKey);
			System.out.println(" [채널 전환 이륙 감지] 새 채널 [" + sourceKey + "] 비행 타이머 시작.");

			lastActiveSourceKey = sourceKey;
			RestTemplate restTemplate = new RestTemplate();
			currentMode = "esp32".equals(sourceKey) ? "esp32" : "local";

			String flaskApiUrl = FLASK_SERVER_URL + "/change_source/" + sourceKey;
			restTemplate.getForObject(flaskApiUrl, String.class);
		} catch (Exception e) {
			System.err.println("❌ 비행 이력 자동 연동 오류: " + e.getMessage());
		}
		return "OK";
	}

	@RequestMapping(value = "/yolo/labels", produces = "application/json; charset=UTF-8")
	public void bridgeLabels(HttpServletResponse response) {
		String pythonJsonUrl = FLASK_SERVER_URL + "/labels_feed";
		boolean isFlaskAlive = false;
		try {
			URL url = new URL(pythonJsonUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(FLASK_LABEL_TIMEOUT_MS);
			conn.setReadTimeout(FLASK_LABEL_TIMEOUT_MS);

			if (conn.getResponseCode() == 200) {
				isFlaskAlive = true;

				if (LEGACY_LABEL_EVENT_SIDE_EFFECTS_ENABLED) {
				ObjectMapper mapper = new ObjectMapper();
				JsonNode root = mapper.readTree(conn.getInputStream());
				aiStreamBridgeService.processYoloLabels(root, currentMode, lastActiveSourceKey);
				}
			}
		} catch (Exception e) {
		}

		if (isFlaskAlive) {
			executeProxy(pythonJsonUrl, response, FLASK_LABEL_TIMEOUT_MS, FLASK_LABEL_TIMEOUT_MS, true);
		}
	}

	@RequestMapping(value = "/yolo/currentMappings", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getCurrentMappings() {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("activeMappings", aiStreamBridgeService.getRawDroneCache());

			PageMaker dbPageMaker = new PageMaker();
			dbPageMaker.setPage(1);
			dbPageMaker.setPerPageNum(1000);
			List<DroneVO> dbDroneList = droneService.getDroneList(dbPageMaker);

			List<String> droneIdList = new ArrayList<>();
			if (dbDroneList != null) {
				for (DroneVO dvo : dbDroneList) {
					if (dvo.getDroneId() != null) {
						droneIdList.add(dvo.getDroneId());
					}
				}
			}
			resultMap.put("dbDroneList", droneIdList);
			resultMap.put("dbDroneDetails", dbDroneList == null ? new ArrayList<DroneVO>() : dbDroneList);
		} catch (Exception e) {
			System.err.println("❌ 서비스 레이어 재활용 동적 조회 최종 실패: " + e.getMessage());
		}
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}

	private void executeProxy(String targetUrl, HttpServletResponse response, int connectTimeout, int readTimeout,
			boolean isJson) {
		HttpURLConnection connection = null;
		InputStream is = null;
		OutputStream os = null;
		try {
			URL url = new URL(targetUrl);
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setConnectTimeout(connectTimeout);
			connection.setRequestProperty("Connection", "close");
			connection.setReadTimeout(isJson ? readTimeout : 1000);

			int upstreamStatus = connection.getResponseCode();
			if (upstreamStatus != HttpURLConnection.HTTP_OK) {
				if (!response.isCommitted()) {
					response.sendError(HttpServletResponse.SC_BAD_GATEWAY,
							"YOLO upstream returned HTTP " + upstreamStatus);
				}
				return;
			}

			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			response.setContentType(
					isJson ? "application/json; charset=UTF-8" : "multipart/x-mixed-replace; boundary=frame");

			is = new BufferedInputStream(connection.getInputStream());
			os = response.getOutputStream();
			byte[] buffer = new byte[4096];
			int bytesRead;

			while (!Thread.currentThread().isInterrupted()) {
				try {
					bytesRead = is.read(buffer);
					if (bytesRead == -1)
						break;
					os.write(buffer, 0, bytesRead);
					if (!isJson)
						os.flush();
				} catch (SocketTimeoutException e) {
					if (Thread.currentThread().isInterrupted())
						break;
				} catch (IOException ioEx) {
					break;
				}
			}
			if (os != null)
				os.flush();
		} catch (InterruptedIOException e) {
			Thread.currentThread().interrupt();
		} catch (Exception e) {
			System.err.println("[YOLO proxy] " + targetUrl + " 연결 실패: " + e.getMessage());
			if (!response.isCommitted()) {
				try {
					response.sendError(HttpServletResponse.SC_BAD_GATEWAY, "YOLO upstream unavailable");
				} catch (IOException ignored) {
				}
			}
		} finally {
			try {
				if (is != null)
					is.close();
			} catch (Exception e) {
			}

			try {
				if (os != null)
					os.close();
			} catch (Exception e) {
			}
			if (connection != null)
				connection.disconnect();
		}
	}

	private ResponseEntity<String> postToFlaskDetection(String path) {
		try {
			ResponseEntity<String> flaskResponse = flaskRestTemplate(FLASK_CONTROL_TIMEOUT_MS)
					.postForEntity(FLASK_SERVER_URL + "/detection" + path, null, String.class);
			return ResponseEntity.status(flaskResponse.getStatusCode()).body(flaskResponse.getBody());
		} catch (Exception e) {
			System.err.println("[YOLO control] " + path + " 요청 실패: " + e.getMessage());
			return new ResponseEntity<>("{\"status\":\"FAIL\",\"error\":\"Flask detection control unavailable\"}",
					HttpStatus.BAD_GATEWAY);
		}
	}

	private void synchronizeFlightLifecycle(String sourceKey, String action, ResponseEntity<String> flaskResponse) {
		if (flaskResponse == null || !flaskResponse.getStatusCode().is2xxSuccessful()) {
			return;
		}

		try {
			JsonNode sourceStatus = objectMapper.readTree(flaskResponse.getBody()).path("sources").path(sourceKey);
			boolean running = sourceStatus.path("running").asBoolean(false);
			if ("start".equals(action) && running) {
				beginActiveFlight(sourceKey);
			} else if ("stop".equals(action) && !running) {
				completeActiveFlight(sourceKey);
			}
		} catch (Exception e) {
			System.err.println("[비행 이력 동기화] worker 응답을 해석하지 못했습니다: " + sourceKey + " / " + action);
		}
	}

	private void beginActiveFlight(String sourceKey) {
		if (activeFlightStartMap.putIfAbsent(sourceKey, System.currentTimeMillis()) == null) {
			System.out.println("[비행 시작] " + sourceKey + " / " + resolveDroneId(sourceKey));
		}
	}

	private void completeActiveFlight(String sourceKey) {
		Long startTimeMs = activeFlightStartMap.remove(sourceKey);
		if (startTimeMs == null) {
			return;
		}

		long endTimeMs = System.currentTimeMillis();
		double durationHours = (double) (endTimeMs - startTimeMs) / 3600000.0;
		String droneId = resolveDroneId(sourceKey);
		FlightHistoryVO historyVO = FlightHistoryVO.builder()
				.startTime(new Timestamp(startTimeMs))
				.endTime(new Timestamp(endTimeMs))
				.flightDuration(durationHours)
				.droneId(droneId)
				.build();
		try {
			if (flightHistoryService.registerFlightHistory(historyVO) != 1) {
				System.err.println("[비행 이력 미적재] DRONE 기체 ID 또는 source 매핑을 확인하세요: " + droneId);
			}
		} catch (Exception e) {
			System.err.println("[비행 이력 종료 처리 실패] " + sourceKey + ": " + e.getMessage());
		}
	}

	private String resolveDroneId(String sourceKey) {
		return aiStreamBridgeService.resolveActiveDroneId("esp32".equals(sourceKey) ? "esp32" : "local", sourceKey);
	}

	private RestTemplate flaskRestTemplate(int timeoutMs) {
		SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
		requestFactory.setConnectTimeout(timeoutMs);
		requestFactory.setReadTimeout(timeoutMs);
		return new RestTemplate(requestFactory);
	}

	private boolean isSafeSourceKey(String sourceKey) {
		return sourceKey != null && sourceKey.matches("[A-Za-z0-9_-]+");
	}

	private boolean isKnownYoloChannel(String channel) {
		return "video_1".equals(channel) || "video_2".equals(channel)
				|| "video_3".equals(channel) || "esp32".equals(channel);
	}

	private boolean isDetectionAction(String action) {
		return "start".equals(action) || "stop".equals(action);
	}
}

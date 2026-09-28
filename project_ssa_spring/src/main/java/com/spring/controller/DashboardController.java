package com.spring.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.service.AnimalDetailService;
import com.spring.service.CommonCodeService;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;
import com.spring.service.FlightHistoryService; //  비행 이력 서비스 임포트 추가

@Controller
public class DashboardController {

	@Autowired
	private DangerLogService dangerLogService;

	@Autowired
	private DetectionLogService detectionLogService;

	@Autowired
	private FlightHistoryService flightHistoryService;

	@Autowired
	private CommonCodeService commonCodeService;

	@Autowired
	private AnimalDetailService animalDetailService;

	@GetMapping("/dashboard/main")
	public String showDashboardMain() {
		return "dashboard/dashboardMain";
	}

	@RequestMapping(value = "/dashboard/api/ai-briefing", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getAiBriefingReport(
			@RequestParam(value = "date", required = false) String date) {
		Map<String, Object> resultMap = new HashMap<>();
		LocalDate selectedDate;
		try {
			selectedDate = date == null || date.isBlank() ? LocalDate.now() : LocalDate.parse(date);
		} catch (DateTimeParseException e) {
			resultMap.put("message", "기준일 형식이 올바르지 않습니다.");
			return ResponseEntity.badRequest().body(resultMap);
		}
		Date selectedDateValue = java.sql.Date.valueOf(selectedDate);

		double selectedFlightHours = 0.0;
		double cumulativeFlightHours = 0.0;
	    int selectedDetectCount = 0;
	    double actionCompleteRate = 0.0;
	    double cumulativeActionCompleteRate = 0.0;
	    long dangerTotal = 0;
	    long dangerComplete = 0;
	    long detectTotal = 0;
	    long detectComplete = 0;
	    long cumulativeDangerTotal = 0;
	    long cumulativeDangerComplete = 0;
	    long cumulativeDetectTotal = 0;
	    long cumulativeDetectComplete = 0;
	    long animalTotal = 0;
	    long adoptedAnimalCount = 0;
	    double animalAdoptionRate = 0.0;
		List<DangerLogVO> dangerList = null;
		List<DetectionLogVO> detectList = null;
		List<CommonCodeVO> dangerCodes = null;
		List<CommonCodeVO> animalCodes = null;

		try {
			PageMaker dbPageMaker = new PageMaker();
			dbPageMaker.setPage(1);
			dbPageMaker.setPerPageNum(1000); // 페이징 제약 해제
	        dangerCodes = commonCodeService.getCodeListByGroup("DANGER_TYPE");
	        animalCodes = commonCodeService.getCodeListByGroup("ANIMAL_TYPE");
	        dangerList = dangerLogService.getDangerLogList(dbPageMaker);
	        detectList = detectionLogService.getDetectionLogList(dbPageMaker);
	        Map<String, Object> selectedDangerStats = dangerLogService.getDangerStats(selectedDateValue);
	        Map<String, Object> selectedDetectStats = detectionLogService.getDetectionStats(selectedDateValue);
	        Map<String, Object> cumulativeDangerStats = dangerLogService.getDangerStats(null);
	        Map<String, Object> cumulativeDetectStats = detectionLogService.getDetectionStats(null);
	        Map<String, Object> selectedFlightStats = flightHistoryService.getFlightDurationStats(selectedDateValue);
	        Map<String, Object> cumulativeFlightStats = flightHistoryService.getFlightDurationStats(null);
	        Map<String, Object> animalStats = animalDetailService.getAnimalStatusStats();

	        dangerTotal = statValue(selectedDangerStats, "TOTAL_COUNT");
	        dangerComplete = statValue(selectedDangerStats, "COMPLETE_COUNT");
	        detectTotal = statValue(selectedDetectStats, "TOTAL_COUNT");
	        detectComplete = statValue(selectedDetectStats, "COMPLETE_COUNT");
	        cumulativeDangerTotal = statValue(cumulativeDangerStats, "TOTAL_COUNT");
	        cumulativeDangerComplete = statValue(cumulativeDangerStats, "COMPLETE_COUNT");
	        cumulativeDetectTotal = statValue(cumulativeDetectStats, "TOTAL_COUNT");
	        cumulativeDetectComplete = statValue(cumulativeDetectStats, "COMPLETE_COUNT");
	        selectedFlightHours = statDecimalValue(selectedFlightStats, "TOTAL_FLIGHT_HOURS");
	        cumulativeFlightHours = statDecimalValue(cumulativeFlightStats, "TOTAL_FLIGHT_HOURS");
	        animalTotal = statValue(animalStats, "TOTAL_COUNT");
	        adoptedAnimalCount = statValue(animalStats, "ADOPTED_COUNT");

	        selectedDetectCount = (int) (dangerTotal + detectTotal);
	        long selectedCompleteCount = dangerComplete + detectComplete;
	        long cumulativeTotalCount = cumulativeDangerTotal + cumulativeDetectTotal;
	        long cumulativeCompleteCount = cumulativeDangerComplete + cumulativeDetectComplete;

	        if (selectedDetectCount > 0) {
	            actionCompleteRate = ((double) selectedCompleteCount / selectedDetectCount) * 100;
	        }
	        if (cumulativeTotalCount > 0) {
	            cumulativeActionCompleteRate = ((double) cumulativeCompleteCount / cumulativeTotalCount) * 100;
	        }
	        if (animalTotal > 0) {
	            animalAdoptionRate = ((double) adoptedAnimalCount / animalTotal) * 100;
	        }

	    } catch (Exception e) {
	        selectedDetectCount = 0;
	        actionCompleteRate = 0.0;
	        cumulativeActionCompleteRate = 0.0;
	        selectedFlightHours = 0.0;
	        cumulativeFlightHours = 0.0;
	    }

	    long selectedFlightSeconds = Math.max(0L, Math.round(selectedFlightHours * 3600));
	    long cumulativeFlightSeconds = Math.max(0L, Math.round(cumulativeFlightHours * 3600));
	    String formattedFlightHours = String.format("%.2f", selectedFlightHours);
	    // 기존 클라이언트 호환용 시간 값은 유지하고, 화면 표시용 초 단위 값을 함께 제공한다.
	    resultMap.put("flightHours", Double.parseDouble(formattedFlightHours));
	    resultMap.put("flightDurationSeconds", selectedFlightSeconds);
	    resultMap.put("cumulativeFlightDurationSeconds", cumulativeFlightSeconds);
	    resultMap.put("todayDetectCount", selectedDetectCount);
	    resultMap.put("actionCompleteRate", Math.round(actionCompleteRate * 100) / 100.0);
	    resultMap.put("cumulativeActionCompleteRate", Math.round(cumulativeActionCompleteRate * 100) / 100.0);
	    resultMap.put("animalAdoptionRate", Math.round(animalAdoptionRate * 100) / 100.0);
	    resultMap.put("animalTotal", animalTotal);
	    resultMap.put("adoptedAnimalCount", adoptedAnimalCount);
	    resultMap.put("selectedDate", selectedDate.toString());
	    resultMap.put("selectedDateLabel", selectedDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
	    int realTimeDangerCount = (int) dangerTotal;
	    int realTimeDetectionCount = (int) detectTotal;
	    int safetyScore = (realTimeDangerCount * 15) + (realTimeDetectionCount * 5);
	    if (safetyScore > 100) {
	        safetyScore = 100;
	    }
	    resultMap.put("safetyScore", safetyScore);
	    resultMap.put("todayDangerCount", dangerTotal);
	    resultMap.put("dangerCount", cumulativeDangerTotal);
	    resultMap.put("detectionCount", cumulativeDetectTotal);
		List<String> dateLabels = new ArrayList<>();
		List<Integer> dangerWeeklyData = new ArrayList<>();
		List<Integer> detectWeeklyData = new ArrayList<>();

		SimpleDateFormat dbFormat = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat labelFormat = new SimpleDateFormat("MM/dd");
		SimpleDateFormat hourFormat = new SimpleDateFormat("HH");

		Calendar cal = Calendar.getInstance();
		cal.setTime(selectedDateValue);
		String selectedDateStr = dbFormat.format(cal.getTime());

		cal.add(Calendar.DATE, -6);
		for (int i = 0; i < 7; i++) {
			Date targetDate = cal.getTime();
			String targetDateStr = dbFormat.format(targetDate);

			dateLabels.add(labelFormat.format(targetDate));
			int dangerDayCount = 0;
			int detectDayCount = 0;

			if (dangerList != null) {
				for (DangerLogVO vo : dangerList) {
					if (vo.getDangerDate() != null) {
						String voDateStr = dbFormat.format(vo.getDangerDate());
						if (targetDateStr.equals(voDateStr))
							dangerDayCount++;
					}
				}
			}

			if (detectList != null) {
				for (DetectionLogVO vo : detectList) {
					if (vo.getDetectionDate() != null) {
						String voDateStr = dbFormat.format(vo.getDetectionDate());
						if (targetDateStr.equals(voDateStr))
							detectDayCount++;
					}
				}
			}

			dangerWeeklyData.add(dangerDayCount);
			detectWeeklyData.add(detectDayCount);
			cal.add(Calendar.DATE, 1);
		}

		resultMap.put("dateLabels", dateLabels);
		resultMap.put("dangerWeeklyData", dangerWeeklyData);
		resultMap.put("detectWeeklyData", detectWeeklyData);
		List<String> timeLabels = new ArrayList<>();
		List<Integer> dangerTimeData = new ArrayList<>();
		List<Integer> detectTimeData = new ArrayList<>();

		Map<String, Integer> dangerHourMap = new TreeMap<>();
		Map<String, Integer> detectHourMap = new TreeMap<>();

		boolean isSelectedToday = selectedDate.equals(LocalDate.now());
		int lastHour = isSelectedToday ? LocalTime.now().getHour() : 23;
		int firstHour = isSelectedToday ? Math.max(0, lastHour - 5) : 0;

		for (int h = firstHour; h <= lastHour; h++) {
			String hourKey = String.format("%02d:00", h);
			dangerHourMap.put(hourKey, 0);
			detectHourMap.put(hourKey, 0);
		}

		if (dangerList != null) {
			for (DangerLogVO vo : dangerList) {
				if (vo.getDangerTime() != null && selectedDateStr.equals(dbFormat.format(vo.getDangerTime()))) {
					int voHour = Integer.parseInt(hourFormat.format(vo.getDangerTime()));
					String hourKey = String.format("%02d:00", voHour);
					dangerHourMap.put(hourKey, dangerHourMap.getOrDefault(hourKey, 0) + 1);
					if (!detectHourMap.containsKey(hourKey))
						detectHourMap.put(hourKey, 0);
				}
			}
		}

		if (detectList != null) {
			for (DetectionLogVO vo : detectList) {
				if (vo.getDetectTime() != null && selectedDateStr.equals(dbFormat.format(vo.getDetectTime()))) {
					int voHour = Integer.parseInt(hourFormat.format(vo.getDetectTime()));
					String hourKey = String.format("%02d:00", voHour);
					detectHourMap.put(hourKey, detectHourMap.getOrDefault(hourKey, 0) + 1);
					if (!dangerHourMap.containsKey(hourKey))
						dangerHourMap.put(hourKey, 0);
				}
			}
		}

		for (String hourStr : dangerHourMap.keySet()) {
			timeLabels.add(hourStr);
			dangerTimeData.add(dangerHourMap.get(hourStr));
			detectTimeData.add(detectHourMap.getOrDefault(hourStr, 0));
		}

		if (isSelectedToday && !timeLabels.isEmpty()) {
			String lastLabel = timeLabels.get(timeLabels.size() - 1);
			timeLabels.set(timeLabels.size() - 1, lastLabel + "(현재)");
		}

		resultMap.put("timeLabels", timeLabels);
		resultMap.put("dangerTimeData", dangerTimeData);
		resultMap.put("detectTimeData", detectTimeData);
		List<String> animalLabels = new ArrayList<>();
		List<Integer> animalData = new ArrayList<>();

		Map<String, Integer> dynamicAnimalMap = new LinkedHashMap<>();
		Map<String, String> animalNameMap = new HashMap<>();

		if (animalCodes != null) {
			for (CommonCodeVO codeVO : animalCodes) {
				dynamicAnimalMap.put(codeVO.getCode(), 0);
				animalNameMap.put(codeVO.getCode(), codeVO.getCodeName());
			}
		}

		if (detectList != null) {
			for (DetectionLogVO vo : detectList) {
				if (vo.getDetectTime() != null && selectedDateStr.equals(dbFormat.format(vo.getDetectTime()))
						&& vo.getAnimalType() != null && dynamicAnimalMap.containsKey(vo.getAnimalType())) {
					dynamicAnimalMap.put(vo.getAnimalType(), dynamicAnimalMap.get(vo.getAnimalType()) + 1);
				}
			}
		}

		for (String codeKey : dynamicAnimalMap.keySet()) {
			animalLabels.add(animalNameMap.get(codeKey));
			animalData.add(dynamicAnimalMap.get(codeKey));
		}

		resultMap.put("animalLabels", animalLabels);
		resultMap.put("animalData", animalData);
		List<String> dangerTypeLabels = new ArrayList<>();
		List<Integer> dangerTypeData = new ArrayList<>();

		Map<Integer, Integer> dynamicDangerMap = new LinkedHashMap<>();
		Map<Integer, String> dangerNameMap = new HashMap<>();

		if (dangerCodes != null) {
			for (CommonCodeVO codeVO : dangerCodes) {
				int codeNum = Integer.parseInt(codeVO.getCode());
				dynamicDangerMap.put(codeNum, 0);
				dangerNameMap.put(codeNum, codeVO.getCodeName());
			}
		}

		if (dangerList != null) {
			for (DangerLogVO vo : dangerList) {
				int voType = vo.getDangerType();
				if (vo.getDangerTime() != null && selectedDateStr.equals(dbFormat.format(vo.getDangerTime()))
						&& dynamicDangerMap.containsKey(voType)) {
					dynamicDangerMap.put(voType, dynamicDangerMap.get(voType) + 1);
				}
			}
		}

		for (Integer codeKey : dynamicDangerMap.keySet()) {
			dangerTypeLabels.add(dangerNameMap.get(codeKey));
			dangerTypeData.add(dynamicDangerMap.get(codeKey));
		}
		resultMap.put("dangerTypeLabels", dangerTypeLabels);
		resultMap.put("dangerTypeData", dangerTypeData);
		return ResponseEntity.ok(resultMap);
	}

	private long statValue(Map<String, Object> stats, String key) {
		if (stats == null || stats.get(key) == null) {
			return 0L;
		}
		Object value = stats.get(key);
		return value instanceof Number ? ((Number) value).longValue() : 0L;
	}

	private double statDecimalValue(Map<String, Object> stats, String key) {
		if (stats == null || stats.get(key) == null) {
			return 0.0d;
		}
		Object value = stats.get(key);
		return value instanceof Number ? ((Number) value).doubleValue() : 0.0d;
	}

}

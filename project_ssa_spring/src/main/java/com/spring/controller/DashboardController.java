package com.spring.controller;

import java.text.SimpleDateFormat;
import java.time.LocalTime;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.dto.FlightHistoryVO;
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

	@GetMapping("/dashboard/main")
	public String showDashboardMain() {
		return "dashboard/dashboardMain";
	}

	@RequestMapping(value = "/dashboard/api/ai-briefing", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getAiBriefingReport() {
		Map<String, Object> resultMap = new HashMap<>();

		double todayTotalFlightHours = 0.0;
	    int totalTodayDetectCount = 0;
	    double actionCompleteRate = 0.0;
	    long dangerTotal = 0;
	    long dangerComplete = 0;
	    long detectTotal = 0;
	    long detectComplete = 0;
		List<DangerLogVO> dangerList = null;
		List<DetectionLogVO> detectList = null;
		List<FlightHistoryVO> flightList = null;
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
	        flightList = flightHistoryService.getFlightHistoryList(dbPageMaker);
	        if (flightList != null) {
	            Calendar today = Calendar.getInstance();
	            for (FlightHistoryVO fvo : flightList) {
	                if (fvo.getFlightDate() == null) {
	                    continue;
	                }
	                Calendar flightDate = Calendar.getInstance();
	                flightDate.setTime(fvo.getFlightDate());
	                if (today.get(Calendar.ERA) == flightDate.get(Calendar.ERA)
	                        && today.get(Calendar.YEAR) == flightDate.get(Calendar.YEAR)
	                        && today.get(Calendar.DAY_OF_YEAR) == flightDate.get(Calendar.DAY_OF_YEAR)) {
	                    todayTotalFlightHours += fvo.getFlightDuration();
	                }
	            }
	        }
	        Map<String, Object> dangerStats = dangerLogService.getTodayDangerStats();
	        Map<String, Object> detectStats = detectionLogService.getTodayDetectionStats();

	        if (dangerStats != null) {
	            dangerTotal = dangerStats.get("TOTAL_COUNT") != null ? ((Number) dangerStats.get("TOTAL_COUNT")).longValue() : 0;
	            dangerComplete = dangerStats.get("COMPLETE_COUNT") != null ? ((Number) dangerStats.get("COMPLETE_COUNT")).longValue() : 0;
	        }

	        if (detectStats != null) {
	            detectTotal = detectStats.get("TOTAL_COUNT") != null ? ((Number) detectStats.get("TOTAL_COUNT")).longValue() : 0;
	            detectComplete = detectStats.get("COMPLETE_COUNT") != null ? ((Number) detectStats.get("COMPLETE_COUNT")).longValue() : 0;
	        }
	        totalTodayDetectCount = (int) (dangerTotal + detectTotal); 
	        long totalCompleteCount = dangerComplete + detectComplete;

	        if (totalTodayDetectCount > 0) {
	            actionCompleteRate = ((double) totalCompleteCount / totalTodayDetectCount) * 100;
	        }

	    } catch (Exception e) {
	        totalTodayDetectCount = 0;
	        actionCompleteRate = 0.0;
	        todayTotalFlightHours = 0.0;
	    }

	    long todayTotalFlightSeconds = Math.max(0L, Math.round(todayTotalFlightHours * 3600));
	    String formattedFlightHours = String.format("%.2f", todayTotalFlightHours);
	    // 기존 클라이언트 호환용 시간 값은 유지하고, 화면 표시용 초 단위 값을 함께 제공한다.
	    resultMap.put("flightHours", Double.parseDouble(formattedFlightHours));
	    resultMap.put("flightDurationSeconds", todayTotalFlightSeconds);
	    resultMap.put("todayDetectCount", totalTodayDetectCount);                // 당일 탐지 총 건수
	    resultMap.put("actionCompleteRate", Math.round(actionCompleteRate * 100) / 100.0); // 당일 조치 완료율(소수점 둘째자리 반올림)
	    int realTimeDangerCount = (int) dangerTotal;   // 오늘 발생한 위험객체 건수
	    int realTimeDetectionCount = (int) detectTotal; // 오늘 발생한 미달경보 건수
	    int safetyScore = (realTimeDangerCount * 15) + (realTimeDetectionCount * 5);
	    if (safetyScore > 100) {
	        safetyScore = 100;
	    }
	    resultMap.put("safetyScore", safetyScore);
	    resultMap.put("todayDangerCount", dangerTotal);
	    resultMap.put("dangerCount", dangerList != null ? dangerList.size() : 0);
	    resultMap.put("detectionCount", detectList != null ? detectList.size() : 0);
		List<String> dateLabels = new ArrayList<>();
		List<Integer> dangerWeeklyData = new ArrayList<>();
		List<Integer> detectWeeklyData = new ArrayList<>();

		SimpleDateFormat dbFormat = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat labelFormat = new SimpleDateFormat("MM/dd");
		SimpleDateFormat hourFormat = new SimpleDateFormat("HH");

		Calendar cal = Calendar.getInstance();
		Date todayDate = cal.getTime();
		String todayStr = dbFormat.format(todayDate);

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

		LocalTime currentTime = LocalTime.now();
		int currentHour = currentTime.getHour();

		for (int h = Math.max(0, currentHour - 5); h <= currentHour; h++) {
			String hourKey = String.format("%02d:00", h);
			dangerHourMap.put(hourKey, 0);
			detectHourMap.put(hourKey, 0);
		}

		if (dangerList != null) {
			for (DangerLogVO vo : dangerList) {
				if (vo.getDangerTime() != null && todayStr.equals(dbFormat.format(vo.getDangerTime()))) {
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
				if (vo.getDetectTime() != null && todayStr.equals(dbFormat.format(vo.getDetectTime()))) {
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

		if (!timeLabels.isEmpty()) {
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
				if (vo.getDetectTime() != null && todayStr.equals(dbFormat.format(vo.getDetectTime()))
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
				if (vo.getDangerTime() != null && todayStr.equals(dbFormat.format(vo.getDangerTime()))
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

}

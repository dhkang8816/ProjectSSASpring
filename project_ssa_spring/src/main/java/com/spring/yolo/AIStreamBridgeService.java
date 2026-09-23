package com.spring.yolo;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.fasterxml.jackson.databind.JsonNode;
import com.spring.cmd.PageMaker;
import com.spring.dao.VideoDroneMapDAO;
import com.spring.dto.AlertLogVO;
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.dto.VideoDroneMapVO;
import com.spring.service.AlertLogService;
import com.spring.service.AnimalCounterService;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;
import com.spring.service.AlertMessageTemplateService;

public class AIStreamBridgeService {

	private DetectionLogService detectionLogService;

	private DangerLogService dangerLogService;

	private AnimalCounterService animalCounterService;

	private AlertLogService alertLogService;
	private final AlertMessageTemplateService alertMessageTemplateService;
	
	private VideoDroneMapDAO videoDroneMapDAO;
	private final Map<String, String> videoDroneCache = new ConcurrentHashMap<>();
	private boolean isDroneCacheLoaded = false;
	private int cachedDogCount = -1;
	private int cachedCatCount = -1;
	private boolean isMetadataLoaded = false;

	private final Map<Integer, Long> lastNormalInsertTimeMap = new ConcurrentHashMap<>();
	private final Map<Integer, Long> lastInsertTimeMap = new ConcurrentHashMap<>();
	private final long ALARM_COOLDOWN_MS = 10000;

    public AIStreamBridgeService(VideoDroneMapDAO videoDroneMapDAO,
            AlertMessageTemplateService alertMessageTemplateService) {
        this.videoDroneMapDAO = videoDroneMapDAO;
		this.alertMessageTemplateService = alertMessageTemplateService;
        System.out.println("✈ [인프라 도킹 완료] XML 설정을 통해 순수 클래스 기반으로 AI 중계 서비스 가동!");
    }
	
	public void updateInmemoryDroneCache(String sourceKey, String droneId) {
		videoDroneCache.put(sourceKey, droneId);
		System.out.println("✈ [캐시 동기화] 영상 소스 변경 감지: " + sourceKey + " -> " + droneId);
	}

    private synchronized void initDroneCache() {
        if (!isDroneCacheLoaded) {
            try {
                List<VideoDroneMapVO> list = videoDroneMapDAO.selectAllMappings();
                if (list != null) {
                    for (VideoDroneMapVO vo : list) {
                        videoDroneCache.put(vo.getSourceKey(), vo.getDroneId());
                    }
                }
                isDroneCacheLoaded = true;
            } catch (Exception e) {
                System.err.println("❌ 캐싱 실패: " + e.getMessage());
            }
        }
    }

	public String resolveActiveDroneId(String currentMode, String lastActiveSourceKey) {
		if (!isDroneCacheLoaded) {
			initDroneCache();
		}
		String activeKey = "esp32".equals(currentMode) ? "esp32" : lastActiveSourceKey;
		return videoDroneCache.getOrDefault(activeKey, "DRONE01");
	}

	public void refreshAnimalCounterCache(int dogCount, int catCount) {
		this.cachedDogCount = dogCount;
		this.cachedCatCount = catCount;
		this.isMetadataLoaded = true;
	}

	public Map<String, String> getRawDroneCache() {
		if (!isDroneCacheLoaded)
			initDroneCache();
		return this.videoDroneCache;
	}
	public void processYoloLabels(JsonNode root, String currentMode, String lastActiveSourceKey) throws Exception {
		long currentTime = System.currentTimeMillis();
		if (!isMetadataLoaded) {
			PageMaker dummyPageMaker = new PageMaker();
			dummyPageMaker.setPage(1);
			List<AnimalCounterVO> dbCounterList = animalCounterService.getAnimalCounterList(dummyPageMaker);
			if (dbCounterList != null) {
				for (AnimalCounterVO cvo : dbCounterList) {
					if (cvo.getCounterId() == 0)
						cachedDogCount = cvo.getCurrentCount();
					if (cvo.getCounterId() == 1)
						cachedCatCount = cvo.getCurrentCount();
				}
			}
			if (cachedDogCount == -1)
				cachedDogCount = 2;
			if (cachedCatCount == -1)
				cachedCatCount = 1;
			isMetadataLoaded = true;
		}
		JsonNode boxesNode = root.get("boxes");
		List<String> detectedLabels = new ArrayList<>();
		if (boxesNode != null && boxesNode.isArray()) {
			for (JsonNode box : boxesNode) {
				if (box.size() >= 5) {
					detectedLabels.add(box.get(4).asText());
				}
			}
		}
		String currentActiveDroneId = resolveActiveDroneId(currentMode, lastActiveSourceKey);
		int dogTargetLimit = 2;
		int catTargetLimit = 1;

		synchronized (lastNormalInsertTimeMap) {
			if (cachedDogCount < dogTargetLimit) {
				long lastDogTime = lastNormalInsertTimeMap.getOrDefault(0, 0L);
				if ((currentTime - lastDogTime) >= ALARM_COOLDOWN_MS) {
					lastNormalInsertTimeMap.put(0, currentTime);
					DetectionLogVO nvo = new DetectionLogVO();
					nvo.setAnimalType("0");
					nvo.setDetectCount(cachedDogCount);
					nvo.setDroneId(currentActiveDroneId);
					nvo.setActionStatus("0");
					nvo.setActionReason("반려견 개체수 부족 자동 감지 로그");
					detectionLogService.registerDetectionLog(nvo);

					try {
						Integer finalDlogId = (nvo.getDlogId() > 0) ? nvo.getDlogId() : null;
						AlertLogVO avo = AlertLogVO.builder().alertType("0")
								.alertMsg(alertMessageTemplateService.formatAnimalShortage("반려견(dog)")).sendStatus("1")
								.dlogId(finalDlogId).firstSendTime(new Timestamp(System.currentTimeMillis())).build();
						alertLogService.registerAlertLog(avo);
						System.out.println(" [10초 쿨다운] '반려견 미달(0)' 동적 드론 [" + currentActiveDroneId + "] 연동 성공!");
					} catch (Exception ex) {
						System.err.println("❌ 반려견 경보 적재 에러: " + ex.getMessage());
					}
				}
			}

			if (cachedCatCount < catTargetLimit) {
				long lastCatTime = lastNormalInsertTimeMap.getOrDefault(1, 0L);
				if ((currentTime - lastCatTime) >= ALARM_COOLDOWN_MS) {
					lastNormalInsertTimeMap.put(1, currentTime);
					DetectionLogVO nvo = new DetectionLogVO();
					nvo.setAnimalType("1");
					nvo.setDetectCount(cachedCatCount);
					nvo.setDroneId(currentActiveDroneId);
					nvo.setActionStatus("0");
					nvo.setActionReason("고양이 개체수 부족 자동 감지 로그");
					detectionLogService.registerDetectionLog(nvo);

					try {
						Integer finalDlogId = (nvo.getDlogId() > 0) ? nvo.getDlogId() : null;
						AlertLogVO avo = AlertLogVO.builder().alertType("0")
								.alertMsg(alertMessageTemplateService.formatAnimalShortage("고양이(cat)")).sendStatus("1")
								.dlogId(finalDlogId).firstSendTime(new Timestamp(System.currentTimeMillis())).build();
						alertLogService.registerAlertLog(avo);
						System.out.println(" [10초 쿨다운] '고양이 미달(1)' 동적 드론 [" + currentActiveDroneId + "] 연동 성공!");
					} catch (Exception ex) {
						System.err.println("❌ 고양이 경보 적재 에러: " + ex.getMessage());
					}
				}
			}
		}
		if (detectedLabels.contains("pink_dragon") || detectedLabels.contains("tiger")
				|| detectedLabels.contains("blue_alien")) {
			int currentDangerType = 0;
			String dangerName = "이상 객체";

			if (detectedLabels.contains("blue_alien")) {
				currentDangerType = 2;
				dangerName = "외계 생물(블루)";
			} else if (detectedLabels.contains("pink_dragon")) {
				currentDangerType = 4;
				dangerName = "유해 비행체(드래곤)";
			} else if (detectedLabels.contains("tiger")) {
				currentDangerType = 5;
				dangerName = "맹수(호랑이)";
			}

			if (currentDangerType != 0) {
				long lastInsertTime = lastInsertTimeMap.getOrDefault(currentDangerType, 0L);
				if ((currentTime - lastInsertTime) >= ALARM_COOLDOWN_MS) {
					DangerLogVO dvo = new DangerLogVO();
					dvo.setDangerType(currentDangerType);
					dvo.setDactionStatus("0");
					dvo.setDactionReason("스프링 고속 라벨 중계 허브 엔진 실시간 객체 가로채기 기록");
					dvo.setDroneId(currentActiveDroneId);
					dangerLogService.registerDangerLog(dvo);

					try {
						Integer finalDanlogId = (dvo.getDanlogId() > 0) ? dvo.getDanlogId() : null;
						AlertLogVO avo = AlertLogVO.builder().alertType("1")
								.alertMsg(alertMessageTemplateService.formatDangerObject(dangerName))
								.sendStatus("1").danlogId(finalDanlogId)
								.firstSendTime(new Timestamp(System.currentTimeMillis())).build();
						alertLogService.registerAlertLog(avo);
						System.out.println(" [통합 연동] '이상객체(1)' 동적 드론 [" + currentActiveDroneId + "] 연동 성공!");
					} catch (Exception ex) {
						System.err.println("❌ 위험 경보 적재 에러: " + ex.getMessage());
					}
				}
				lastInsertTimeMap.put(currentDangerType, currentTime);
			}
		}
	}
}

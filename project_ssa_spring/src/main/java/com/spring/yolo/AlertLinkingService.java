package com.spring.yolo;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.AlertLogDAO;
import com.spring.dto.AlertLogVO;
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AlertLinkingService {

    private final DetectionLogService detectionLogService;
    private final DangerLogService dangerLogService;
    private final AlertLogDAO alertLogDAO;

    @Transactional(rollbackFor = Exception.class)
    public AlertLogVO recordDetectionAlert(DetectionLogVO detectionLog, AlertLogVO alertLog) throws Exception {
        detectionLogService.registerDetectionLog(detectionLog);
        alertLog.setDlogId(detectionLog.getDlogId());
        alertLog.setDanlogId(null);
        alertLogDAO.insertAlertLog(alertLog);
        return alertLog;
    }

    @Transactional(rollbackFor = Exception.class)
    public AlertLogVO recordDangerAlert(DangerLogVO dangerLog, AlertLogVO alertLog) throws Exception {
        dangerLogService.registerDangerLog(dangerLog);
        alertLog.setDlogId(null);
        alertLog.setDanlogId(dangerLog.getDanlogId());
        alertLogDAO.insertAlertLog(alertLog);
        return alertLog;
    }
}

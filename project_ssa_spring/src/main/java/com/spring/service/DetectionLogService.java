package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.Date;

import com.spring.cmd.PageMaker;
import com.spring.dto.DetectionLogVO;

public interface DetectionLogService {
    public void registerDetectionLog(DetectionLogVO dlv);
    public List<DetectionLogVO> getDetectionLogList(PageMaker pageMaker);
    public DetectionLogVO getDetectionLogById(int dlogId);
    public DetectionLogVO getRequiredDetectionLogById(int dlogId);
    public void modifyActionStatus(DetectionLogVO dlv);
    public Map<String, Object> getTodayDetectionStats() throws Exception;
    public Map<String, Object> getDetectionStats(Date targetDate);
    public List<Map<String, Object>> getDetectionAlertCountByDrone(Date targetDate);
}

package com.spring.dao;

import java.util.List;
import java.util.Map;

import com.spring.cmd.PageMaker;
import com.spring.dto.DetectionLogVO;

public interface DetectionLogDAO {
    public int insertDetectionLog(DetectionLogVO dlv);
    public List<DetectionLogVO> selectDetectionLogList(PageMaker pageMaker);
    public int selectDetectionLogCount(PageMaker pageMaker);
    public DetectionLogVO selectDetectionLogById(int dlogId);
    public int updateActionStatus(DetectionLogVO dlv);
    public Map<String, Object> selectTodayDetectionStats() throws Exception;
    public Map<String, Object> selectDetectionStats(Map<String, Object> parameters);
    public List<Map<String, Object>> selectDetectionAlertCountByDrone(Map<String, Object> parameters);
}

package com.spring.dao;

import java.util.List;
import java.util.Map;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;

public interface DangerLogDAO {
    public int insertDangerLog(DangerLogVO dlv);
    public List<DangerLogVO> selectDangerLogList(PageMaker pageMaker);
    public int selectDangerLogCount(PageMaker pageMaker);
    public DangerLogVO selectDangerLogById(int danlogId);
    public int updateDactionStatus(DangerLogVO dlv);
    public Map<String, Object> selectTodayDangerStats() throws Exception;
    public Map<String, Object> selectDangerStats(Map<String, Object> parameters);
    public List<Map<String, Object>> selectDangerAlertCountByDrone(Map<String, Object> parameters);
}

package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.Date;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;

public interface DangerLogService {
    public void registerDangerLog(DangerLogVO dlv);
    public List<DangerLogVO> getDangerLogList(PageMaker pageMaker);
    public DangerLogVO getDangerLogById(int danlogId);
    public void modifyDactionStatus(DangerLogVO dlv);
    public Map<String, Object> getTodayDangerStats() throws Exception;
    public Map<String, Object> getDangerStats(Date targetDate);
    public List<Map<String, Object>> getDangerAlertCountByDrone(Date targetDate);
}

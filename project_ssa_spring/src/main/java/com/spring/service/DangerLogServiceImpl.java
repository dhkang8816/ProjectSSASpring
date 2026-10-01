package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.Date;
import java.util.HashMap;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DangerLogDAO;
import com.spring.dto.DangerLogVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DangerLogServiceImpl implements DangerLogService {

    private final DangerLogDAO dangerLogDAO;

    @Override
    @Transactional
    public void registerDangerLog(DangerLogVO dlv) {
        if (dangerLogDAO.insertDangerLog(dlv) != 1) {
            throw new IllegalStateException("Danger log was not inserted.");
        }
    }

    @Override
    public List<DangerLogVO> getDangerLogList(PageMaker pageMaker) {
        int totalCount = dangerLogDAO.selectDangerLogCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return dangerLogDAO.selectDangerLogList(pageMaker);
    }

    @Override
    public DangerLogVO getDangerLogById(int danlogId) {
        return dangerLogDAO.selectDangerLogById(danlogId);
    }

    @Override
    @Transactional
    public void modifyDactionStatus(DangerLogVO dlv) {
        dangerLogDAO.updateDactionStatus(dlv);
    }
    
    @Override
    public Map<String, Object> getTodayDangerStats() throws Exception {
        return dangerLogDAO.selectTodayDangerStats();
    }

    @Override
    public Map<String, Object> getDangerStats(Date targetDate) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("targetDate", targetDate);
        return dangerLogDAO.selectDangerStats(parameters);
    }

    @Override
    public List<Map<String, Object>> getDangerAlertCountByDrone(Date targetDate) {
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("targetDate", targetDate);
        return dangerLogDAO.selectDangerAlertCountByDrone(parameters);
    }
}

package com.spring.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DetectionLogDAO;
import com.spring.dto.DetectionLogVO;
import com.spring.exception.DetectionNotFoundException;
import com.spring.exception.InvalidRequestException;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DetectionLogServiceImpl implements DetectionLogService {

    private final DetectionLogDAO detectionLogDAO;

    @Override
    @Transactional
    public void registerDetectionLog(DetectionLogVO dlv) {
        if (detectionLogDAO.insertDetectionLog(dlv) != 1) {
            throw new IllegalStateException("Detection log was not inserted.");
        }
    }

    @Override
    public List<DetectionLogVO> getDetectionLogList(PageMaker pageMaker) {
        int totalCount = detectionLogDAO.selectDetectionLogCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return detectionLogDAO.selectDetectionLogList(pageMaker);
    }

    @Override
    public DetectionLogVO getDetectionLogById(int dlogId) {
        return detectionLogDAO.selectDetectionLogById(dlogId);
    }

    @Override
    public DetectionLogVO getRequiredDetectionLogById(int dlogId) {
        validateDetectionLogId(dlogId);
        DetectionLogVO detectionLog = detectionLogDAO.selectDetectionLogById(dlogId);
        if (detectionLog == null) {
            throw new DetectionNotFoundException(dlogId);
        }
        return detectionLog;
    }

    @Override
    @Transactional
    public void modifyActionStatus(DetectionLogVO dlv) {
        if (dlv == null) {
            throw new InvalidRequestException("탐지 이력 정보가 없습니다.");
        }
        getRequiredDetectionLogById(dlv.getDlogId());
        if (detectionLogDAO.updateActionStatus(dlv) != 1) {
            throw new DetectionNotFoundException(dlv.getDlogId());
        }
    }
    
    @Override
    public Map<String, Object> getTodayDetectionStats() throws Exception {
        return detectionLogDAO.selectTodayDetectionStats();
    }

    private void validateDetectionLogId(int dlogId) {
        if (dlogId <= 0) {
            throw new InvalidRequestException("유효하지 않은 탐지 이력 ID입니다.");
        }
    }
}

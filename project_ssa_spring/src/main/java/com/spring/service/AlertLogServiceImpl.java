package com.spring.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j2;

import com.spring.cmd.PageMaker;
import com.spring.dao.AlertLogDAO;
import com.spring.dto.AlertLogVO;

@Log4j2
@Service
@AllArgsConstructor
public class AlertLogServiceImpl implements AlertLogService {

    private AlertLogDAO alertLogDAO;

    
    @Override
    @Transactional(readOnly = true) // 읽기 전용 트랜잭션 최적화
    public List<AlertLogVO> getAlertLogList(PageMaker pageMaker) throws Exception {
        log.info("getAlertLogList 서비스 호출 - 검색 타입: {}, 키워드: {}, 현재 페이지: {}", 
                 pageMaker.getSearchType(), pageMaker.getKeyword(), pageMaker.getPage());
        int totalCount = alertLogDAO.getTotalCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        log.debug("PageMaker 연산 완료 값 - StartRow: {}, EndRow: {}, TotalPage: {}", 
                  pageMaker.getStartRow(), pageMaker.getEndRow(), pageMaker.getRealEndPage());
        return alertLogDAO.getAlertLogListWithPaging(pageMaker);
    }

    
    @Override
    @Transactional(readOnly = true)
    public AlertLogVO getAlertLogDetail(int alertId) throws Exception {
        log.info("getAlertLogDetail 서비스 호출 - 경보 ID: {}", alertId);
        
        AlertLogVO vo = alertLogDAO.getAlertLog(alertId);
        if (vo == null) {
            log.warn("해당 경보 ID의 데이터를 찾을 수 없습니다: {}", alertId);
            throw new IllegalArgumentException("존재하지 않는 경보 이력입니다.");
        }
        return vo;
    }

    
    @Override
    @Transactional // 쓰기 작업 트랜잭션 보장
    public void registerAlertLog(AlertLogVO vo) throws Exception {
        log.info("registerAlertLog 서비스 호출 - 등록 메시지: {}", vo.getAlertMsg());
        if (vo.getAlertMsg() == null || vo.getAlertMsg().trim().isEmpty()) {
            throw new RuntimeException("경보 알림 메시지 내용은 필수입니다.");
        }
        
        alertLogDAO.insertAlertLog(vo);
        log.info("경보 이력 등록 성공 - 배정된 데이터 검증 완료");
    }
}

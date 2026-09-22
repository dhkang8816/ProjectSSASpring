package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.PatrolReportVO;

public interface PatrolReportDAO {
    int insertReport(PatrolReportVO reportVO);
    PatrolReportVO getReportById(int reportId);
    List<PatrolReportVO> getReportList();
    int getReportListCount(PageMaker pageMaker);
    int updateReport(PatrolReportVO reportVO);
    int deletePdfCachesByReportId(int reportId);
    int deleteReport(int reportId);
    public List<PatrolReportVO> getReportListWithPaging(PageMaker pageMaker) throws Exception;
    public int getReportTotalCount(PageMaker pageMaker) throws Exception;
    List<PatrolReportVO> getPendingReportListWithPaging(PageMaker pageMaker) throws Exception;
    int getPendingReportTotalCount(PageMaker pageMaker) throws Exception;
    int updateConfirmStatus(int reportId, String confirmStatus);
}

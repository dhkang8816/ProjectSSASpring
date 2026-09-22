package com.spring.service;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.PatrolReportVO;

public interface PatrolReportService {
	void insertReport(PatrolReportVO reportVO) throws Exception;
	void insertReportWithWorkflow(PatrolReportVO reportVO, String approverId) throws Exception;
    PatrolReportVO getReportById(int reportId) throws Exception;
    List<PatrolReportVO> getReportList() throws Exception;
    void updateReport(PatrolReportVO reportVO) throws Exception;
    void reviseRejectedReport(PatrolReportVO reportVO, String currentMemberId) throws Exception;
    void deleteReport(int reportId) throws Exception;
    public List<PatrolReportVO> getReportListWithPaging(PageMaker pageMaker) throws Exception;

    List<PatrolReportVO> getPendingReportListWithPaging(PageMaker pageMaker) throws Exception;
}

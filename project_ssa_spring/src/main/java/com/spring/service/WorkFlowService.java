package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.WorkFlowVO;

public interface WorkFlowService {
    List<WorkFlowVO> getWorkFlowList(PageMaker pageMaker, String approverId) throws Exception;
    WorkFlowVO getWorkFlowById(Long approvalId) throws Exception;
    WorkFlowVO getWorkFlowByReportId(Long reportId) throws Exception;
    void approve(Long approvalId, String currentMemberId) throws Exception;
    void reject(Long approvalId, String currentMemberId, String rejectReason) throws Exception;
}

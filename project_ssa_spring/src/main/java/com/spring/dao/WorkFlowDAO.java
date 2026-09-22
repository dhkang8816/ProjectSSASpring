package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.WorkFlowVO;

public interface WorkFlowDAO {
    List<WorkFlowVO> selectWorkFlowList(PageMaker pageMaker, String approverId);
    int selectWorkFlowTotalCount(String approverId);
    int insertWorkFlow(WorkFlowVO workFlow);
    WorkFlowVO selectWorkFlowById(Long approvalId);
    WorkFlowVO selectWorkFlowByReportId(Long reportId);
    int approveWorkFlow(Long approvalId, String approverId);
    int rejectWorkFlow(Long approvalId, String approverId, String rejectReason);
    int resubmitWorkFlowByReportId(int reportId, String drafterId);
    int deleteWorkFlowsByReportId(int reportId);
}

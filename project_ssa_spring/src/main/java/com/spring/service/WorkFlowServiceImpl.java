package com.spring.service;

import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import com.spring.cmd.PageMaker;
import com.spring.dao.MemberDAO;
import com.spring.dao.PatrolReportDAO;
import com.spring.dao.WorkFlowDAO;
import com.spring.dto.WorkFlowVO;
import lombok.AllArgsConstructor;

@AllArgsConstructor
public class WorkFlowServiceImpl implements WorkFlowService {
    private final WorkFlowDAO workFlowDAO;
    private final MemberDAO memberDAO;
    private final PatrolReportDAO patrolReportDAO;

    @Override public List<WorkFlowVO> getWorkFlowList(PageMaker pageMaker, String approverId) throws Exception {
        pageMaker.setTotalCount(workFlowDAO.selectWorkFlowTotalCount(approverId));
        return workFlowDAO.selectWorkFlowList(pageMaker, approverId);
    }
    @Override public WorkFlowVO getWorkFlowById(Long approvalId) throws Exception {
        return workFlowDAO.selectWorkFlowById(approvalId);
    }
    @Override public WorkFlowVO getWorkFlowByReportId(Long reportId) throws Exception {
        return workFlowDAO.selectWorkFlowByReportId(reportId);
    }
    @Transactional
    @Override public void approve(Long approvalId, String currentMemberId) throws Exception {
        WorkFlowVO workflow = validatePendingAssignment(approvalId, currentMemberId);
        if (workFlowDAO.approveWorkFlow(approvalId, currentMemberId) != 1) throw new IllegalStateException("Approval was already processed.");
        patrolReportDAO.updateConfirmStatus(workflow.getReportId().intValue(), "1");
    }
    @Transactional
    @Override public void reject(Long approvalId, String currentMemberId, String rejectReason) throws Exception {
        if (rejectReason == null || rejectReason.trim().isEmpty()) throw new IllegalArgumentException("A rejection reason is required.");
        WorkFlowVO workflow = validatePendingAssignment(approvalId, currentMemberId);
        if (workFlowDAO.rejectWorkFlow(approvalId, currentMemberId, rejectReason.trim()) != 1) throw new IllegalStateException("Approval was already processed.");
        patrolReportDAO.updateConfirmStatus(workflow.getReportId().intValue(), "2");
    }
    private WorkFlowVO validatePendingAssignment(Long approvalId, String currentMemberId) throws Exception {
        if (currentMemberId == null || !memberDAO.isAdminMember(currentMemberId)) throw new SecurityException("Only administrators can process approvals.");
        WorkFlowVO workflow = workFlowDAO.selectWorkFlowById(approvalId);
        if (workflow == null || !"0".equals(workflow.getAppStatus())) throw new IllegalStateException("Only pending approvals can be processed.");
        if (!currentMemberId.equals(workflow.getApproverId())) throw new SecurityException("This approval is assigned to another administrator.");
        return workflow;
    }
}

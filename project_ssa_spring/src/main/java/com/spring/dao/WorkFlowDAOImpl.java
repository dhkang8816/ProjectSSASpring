package com.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import com.spring.cmd.PageMaker;
import com.spring.dto.WorkFlowVO;
import lombok.AllArgsConstructor;

@AllArgsConstructor
public class WorkFlowDAOImpl implements WorkFlowDAO {
    private final SqlSession sqlSession;
    private static final String NAMESPACE = "WorkFlow-Mapper.";

    @Override
    public List<WorkFlowVO> selectWorkFlowList(PageMaker pageMaker, String approverId) {
        Map<String, Object> params = new HashMap<>();
        params.put("pageMaker", pageMaker);
        params.put("approverId", approverId);
        return sqlSession.selectList(NAMESPACE + "selectWorkFlowList", params);
    }

    @Override public int selectWorkFlowTotalCount(String approverId) {
        Map<String, Object> params = new HashMap<>();
        params.put("approverId", approverId);
        return sqlSession.selectOne(NAMESPACE + "selectWorkFlowTotalCount", params);
    }
    @Override public int insertWorkFlow(WorkFlowVO workFlow) {
        return sqlSession.insert(NAMESPACE + "insertWorkFlow", workFlow);
    }
    @Override public WorkFlowVO selectWorkFlowById(Long approvalId) {
        return sqlSession.selectOne(NAMESPACE + "selectWorkFlowById", approvalId);
    }
    @Override public WorkFlowVO selectWorkFlowByReportId(Long reportId) {
        return sqlSession.selectOne(NAMESPACE + "selectWorkFlowByReportId", reportId);
    }
    @Override public int approveWorkFlow(Long approvalId, String approverId) {
        Map<String, Object> params = new HashMap<>();
        params.put("approvalId", approvalId); params.put("approverId", approverId);
        return sqlSession.update(NAMESPACE + "approveWorkFlow", params);
    }
    @Override public int rejectWorkFlow(Long approvalId, String approverId, String rejectReason) {
        Map<String, Object> params = new HashMap<>();
        params.put("approvalId", approvalId); params.put("approverId", approverId); params.put("rejectReason", rejectReason);
        return sqlSession.update(NAMESPACE + "rejectWorkFlow", params);
    }
    @Override public int resubmitWorkFlowByReportId(int reportId, String drafterId) {
        Map<String, Object> params = new HashMap<>();
        params.put("reportId", reportId); params.put("drafterId", drafterId);
        return sqlSession.update(NAMESPACE + "resubmitWorkFlowByReportId", params);
    }
    @Override public int deleteWorkFlowsByReportId(int reportId) {
        return sqlSession.delete(NAMESPACE + "deleteWorkFlowsByReportId", reportId);
    }
}

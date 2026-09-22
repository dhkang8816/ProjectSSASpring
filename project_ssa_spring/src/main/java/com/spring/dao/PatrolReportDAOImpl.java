package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.PatrolReportVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class PatrolReportDAOImpl implements PatrolReportDAO {
    private final SqlSession sqlSession;
    private static final String NAMESPACE = "PatrolReport-Mapper";

    @Override
    public int insertReport(PatrolReportVO reportVO) {
        return sqlSession.insert(NAMESPACE + ".insertReport", reportVO);
    }

    @Override
    public PatrolReportVO getReportById(int reportId) {
        return sqlSession.selectOne(NAMESPACE + ".getReportById", reportId);
    }

    @Override
    public List<PatrolReportVO> getReportList() {
        return sqlSession.selectList(NAMESPACE + ".getReportList");
    }
    public int getReportListCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".getReportListCount", pageMaker);
    }

    @Override
    public int updateReport(PatrolReportVO reportVO) {
        return sqlSession.update(NAMESPACE + ".updateReport", reportVO);
    }

    @Override
    public int deletePdfCachesByReportId(int reportId) {
        return sqlSession.delete(NAMESPACE + ".deletePdfCachesByReportId", reportId);
    }

    @Override
    public int deleteReport(int reportId) {
        return sqlSession.delete(NAMESPACE + ".deleteReport", reportId);
    }
    @Override
    public List<PatrolReportVO> getReportListWithPaging(PageMaker pageMaker) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".getReportListWithPaging", pageMaker);
    }

    @Override
    public int getReportTotalCount(PageMaker pageMaker) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getReportTotalCount", pageMaker);
    }

    @Override
    public List<PatrolReportVO> getPendingReportListWithPaging(PageMaker pageMaker) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".getPendingReportListWithPaging", pageMaker);
    }

    @Override
    public int getPendingReportTotalCount(PageMaker pageMaker) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getPendingReportTotalCount", pageMaker);
    }

    @Override
    public int updateConfirmStatus(int reportId, String confirmStatus) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("reportId", reportId);
        params.put("confirmStatus", confirmStatus);
        return sqlSession.update(NAMESPACE + ".updateConfirmStatus", params);
    }
}

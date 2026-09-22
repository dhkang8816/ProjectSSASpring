package com.spring.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DetectionLogVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DetectionLogDAOImpl implements DetectionLogDAO {

    private final SqlSession sqlSession;
    private static final String NAMESPACE = "DetectionLog-Mapper";

    @Override
    public int insertDetectionLog(DetectionLogVO dlv) {
        return sqlSession.insert(NAMESPACE + ".insertDetectionLog", dlv);
    }

    @Override
    public List<DetectionLogVO> selectDetectionLogList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectDetectionLogList", pageMaker);
    }

    @Override
    public int selectDetectionLogCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectDetectionLogCount", pageMaker);
    }

    @Override
    public DetectionLogVO selectDetectionLogById(int dlogId) {
        return sqlSession.selectOne(NAMESPACE + ".selectDetectionLogById", dlogId);
    }

    @Override
    public int updateActionStatus(DetectionLogVO dlv) {
        return sqlSession.update(NAMESPACE + ".updateActionStatus", dlv);
    }
    
    @Override
    public Map<String, Object> selectTodayDetectionStats() throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".selectTodayDetectionStats");
    }
}

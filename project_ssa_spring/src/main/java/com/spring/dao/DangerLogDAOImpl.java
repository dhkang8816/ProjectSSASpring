package com.spring.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DangerLogDAOImpl implements DangerLogDAO {

    private final SqlSession sqlSession;
    private static final String NAMESPACE = "DangerLog-Mapper";

    @Override
    public int insertDangerLog(DangerLogVO dlv) {
        return sqlSession.insert(NAMESPACE + ".insertDangerLog", dlv);
    }

    @Override
    public List<DangerLogVO> selectDangerLogList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectDangerLogList", pageMaker);
    }

    @Override
    public int selectDangerLogCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectDangerLogCount", pageMaker);
    }

    @Override
    public DangerLogVO selectDangerLogById(int danlogId) {
        return sqlSession.selectOne(NAMESPACE + ".selectDangerLogById", danlogId);
    }

    @Override
    public int updateDactionStatus(DangerLogVO dlv) {
        return sqlSession.update(NAMESPACE + ".updateDactionStatus", dlv);
    }
    
    @Override
    public Map<String, Object> selectTodayDangerStats() throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".selectTodayDangerStats");
    }

    @Override
    public Map<String, Object> selectDangerStats(Map<String, Object> parameters) {
        return sqlSession.selectOne(NAMESPACE + ".selectDangerStats", parameters);
    }
}

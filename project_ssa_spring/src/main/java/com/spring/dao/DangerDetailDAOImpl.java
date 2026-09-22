package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DangerDetailDAOImpl implements DangerDetailDAO {

    private final SqlSession sqlSession;
    private static final String NAMESPACE = "DangerDetail-Mapper";

    @Override
    public int insertDanger(DangerDetailVO ddv) {
        return sqlSession.insert(NAMESPACE + ".insertDanger", ddv);
    }

    @Override
    public List<DangerDetailVO> selectDangerList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectDangerList", pageMaker);
    }

    @Override
    public int selectDangerCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectDangerCount", pageMaker);
    }

    @Override
    public DangerDetailVO selectDangerById(int dangerId) {
        return sqlSession.selectOne(NAMESPACE + ".selectDangerById", dangerId);
    }

    @Override
    public int updateDanger(DangerDetailVO ddv) {
        return sqlSession.update(NAMESPACE + ".updateDanger", ddv);
    }

    @Override
    public int deleteDanger(int dangerId) {
        return sqlSession.delete(NAMESPACE + ".deleteDanger", dangerId);
    }
}

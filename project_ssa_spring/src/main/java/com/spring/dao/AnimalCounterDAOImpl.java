package com.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class AnimalCounterDAOImpl implements AnimalCounterDAO {

    private final SqlSession sqlSession;
    private static final String NAMESPACE = "AnimalCounter-Mapper";

    @Override
    public List<AnimalCounterVO> selectAnimalCounterList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectAnimalCounterList", pageMaker);
    }

    @Override
    public int selectAnimalCounterCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalCounterCount", pageMaker);
    }

    @Override
    public int updateAnimalCount(int counterId, int countDiff) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("counterId", counterId);
        paramMap.put("countDiff", countDiff);
        
        return sqlSession.update(NAMESPACE + ".updateAnimalCount", paramMap);
    }

    @Override
    public int insertNewCounter(AnimalCounterVO acv) {
        return sqlSession.insert(NAMESPACE + ".insertNewCounter", acv);
    }
}

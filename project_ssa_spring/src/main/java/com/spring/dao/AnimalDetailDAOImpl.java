package com.spring.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalDetailVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class AnimalDetailDAOImpl implements AnimalDetailDAO {

    private SqlSession sqlSession;
    private static final String NAMESPACE = "AnimalDetail-Mapper";

    @Override
    public int insertAnimal(AnimalDetailVO adv) {
        return sqlSession.insert(NAMESPACE + ".insertAnimal", adv);
    }

    @Override
    public List<AnimalDetailVO> selectAnimalList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectAnimalList", pageMaker);
    }

    @Override
    public int selectAnimalCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalCount", pageMaker);
    }

    @Override
    public AnimalDetailVO selectAnimalById(int animalId) {
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalById", animalId);
    }

    @Override
    public int updateAnimal(AnimalDetailVO adv) {
        return sqlSession.update(NAMESPACE + ".updateAnimal", adv);
    }

    @Override
    public int deleteAnimal(int animalId) {
        return sqlSession.delete(NAMESPACE + ".deleteAnimal", animalId);
    }

    @Override
    public Map<String, Object> selectAnimalStatusStats() {
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalStatusStats");
    }
}

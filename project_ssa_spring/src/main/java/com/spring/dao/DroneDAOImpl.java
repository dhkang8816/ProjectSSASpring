package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DroneDAOImpl implements DroneDAO {

    private final SqlSession sqlSession;
    private static final String NAMESPACE = "Drone-Mapper";

    @Override
    public int insertDrone(DroneVO dvo) {
        return sqlSession.insert(NAMESPACE + ".insertDrone", dvo);
    }

    @Override
    public List<DroneVO> selectDroneList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectDroneList", pageMaker);
    }

    @Override
    public int selectDroneCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectDroneCount", pageMaker);
    }

    @Override
    public DroneVO selectDroneById(String droneId) {
        return sqlSession.selectOne(NAMESPACE + ".selectDroneById", droneId);
    }

    @Override
    public int updateDrone(DroneVO dvo) {
        return sqlSession.update(NAMESPACE + ".updateDrone", dvo);
    }

    @Override
    public int deleteDrone(String droneId) {
        return sqlSession.delete(NAMESPACE + ".deleteDrone", droneId);
    }
}

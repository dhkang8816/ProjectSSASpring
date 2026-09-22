package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class FlightHistoryDAOImpl implements FlightHistoryDAO {

    private final SqlSession sqlSession;
    private static final String NAMESPACE = "FlightHistory-Mapper";

    @Override
    public int insertFlightHistory(FlightHistoryVO fhv) {
        return sqlSession.insert(NAMESPACE + ".insertFlightHistory", fhv);
    }

    @Override
    public List<FlightHistoryVO> selectFlightHistoryList(PageMaker pageMaker) {
        return sqlSession.selectList(NAMESPACE + ".selectFlightHistoryList", pageMaker);
    }

    @Override
    public int selectFlightHistoryCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".selectFlightHistoryCount", pageMaker);
    }

    @Override
    public FlightHistoryVO selectFlightHistoryById(int flightId) {
        return sqlSession.selectOne(NAMESPACE + ".selectFlightHistoryById", flightId);
    }

    @Override
    public int deleteFlightHistory(int flightId) {
        return sqlSession.delete(NAMESPACE + ".deleteFlightHistory", flightId);
    }
}

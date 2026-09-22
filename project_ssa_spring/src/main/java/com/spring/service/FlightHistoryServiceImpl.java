package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.FlightHistoryDAO;
import com.spring.dto.FlightHistoryVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class FlightHistoryServiceImpl implements FlightHistoryService {

    private final FlightHistoryDAO flightHistoryDAO;

    @Override
    @Transactional
    public int registerFlightHistory(FlightHistoryVO fhv) {
        return flightHistoryDAO.insertFlightHistory(fhv);
    }

    @Override
    public List<FlightHistoryVO> getFlightHistoryList(PageMaker pageMaker) {
        int totalCount = flightHistoryDAO.selectFlightHistoryCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return flightHistoryDAO.selectFlightHistoryList(pageMaker);
    }

    @Override
    public FlightHistoryVO getFlightHistoryById(int flightId) {
        return flightHistoryDAO.selectFlightHistoryById(flightId);
    }

    @Override
    @Transactional
    public void removeFlightHistory(int flightId) {
        flightHistoryDAO.deleteFlightHistory(flightId);
    }
}

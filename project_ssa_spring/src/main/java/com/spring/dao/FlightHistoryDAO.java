package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

public interface FlightHistoryDAO {
    public int insertFlightHistory(FlightHistoryVO fhv);
    public List<FlightHistoryVO> selectFlightHistoryList(PageMaker pageMaker);
    public int selectFlightHistoryCount(PageMaker pageMaker);
    public FlightHistoryVO selectFlightHistoryById(int flightId);
    public int deleteFlightHistory(int flightId);
}

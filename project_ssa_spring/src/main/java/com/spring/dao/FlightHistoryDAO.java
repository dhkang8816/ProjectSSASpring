package com.spring.dao;

import java.util.List;
import java.util.Map;
import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

public interface FlightHistoryDAO {
    public int insertFlightHistory(FlightHistoryVO fhv);
    public List<FlightHistoryVO> selectFlightHistoryList(PageMaker pageMaker);
    public int selectFlightHistoryCount(PageMaker pageMaker);
    public FlightHistoryVO selectFlightHistoryById(int flightId);
    public int deleteFlightHistory(int flightId);
    public Map<String, Object> selectFlightDurationStats(Map<String, Object> parameters);
}

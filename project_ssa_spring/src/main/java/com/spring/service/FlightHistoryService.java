package com.spring.service;

import java.util.List;
import java.util.Date;
import java.util.Map;
import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

public interface FlightHistoryService {
    public int registerFlightHistory(FlightHistoryVO fhv);
    public List<FlightHistoryVO> getFlightHistoryList(PageMaker pageMaker);
    public FlightHistoryVO getFlightHistoryById(int flightId);
    public void removeFlightHistory(int flightId);
    public Map<String, Object> getFlightDurationStats(Date targetDate);
}

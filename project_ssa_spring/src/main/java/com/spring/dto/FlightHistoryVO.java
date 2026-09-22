package com.spring.dto;

import java.sql.Timestamp;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class FlightHistoryVO {

    private int flightId;               // 비행이력시퀀스 
    private Timestamp startTime;
    private Timestamp endTime;              // 비행종료일시
    private double flightDuration;      // 총비행시간
    private double batteryConsumption;  // 배터리소모량
    private Date flightDate;            // 데이터등록일시 
    private String droneId;             // 드론 기체 ID 

}

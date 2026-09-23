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
    private Double startBatteryPercent;
    private Double endBatteryPercent;
    private Double batteryConsumption;  // 배터리소모량
    private Date flightDate;            // 데이터등록일시 
    private String droneId;             // 드론 기체 ID 

    /**
     * DB에는 기존 호환성을 위해 시간을 단위로 저장하고, 화면에서는 분/초로 표시한다.
     */
    public String getFlightDurationText() {
        long totalSeconds = Math.max(0L, Math.round(flightDuration * 3600));
        long minutes = totalSeconds / 60;
        long seconds = totalSeconds % 60;
        return minutes + "분 " + String.format("%02d", seconds) + "초";
    }

}

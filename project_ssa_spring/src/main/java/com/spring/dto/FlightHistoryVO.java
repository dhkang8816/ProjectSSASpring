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

    /**
     * 시작/종료 배터리는 잔량이 높을수록 안전하다.
     * 70% 초과는 정상, 40% 초과~70% 이하는 주의, 40% 이하는 위험으로 표시한다.
     */
    public String getStartBatteryStatusClass() {
        return batteryPercentStatusClass(startBatteryPercent);
    }

    public String getEndBatteryStatusClass() {
        return batteryPercentStatusClass(endBatteryPercent);
    }

    /**
     * 소모량은 값이 낮을수록 안전하다.
     * 20% 이하는 정상, 21~40%는 주의, 40% 초과는 위험으로 표시한다.
     */
    public String getBatteryConsumptionStatusClass() {
        if (batteryConsumption == null) {
            return "unavailable";
        }
        if (batteryConsumption <= 20.0d) {
            return "good";
        }
        if (batteryConsumption <= 40.0d) {
            return "warning";
        }
        return "danger";
    }

    private String batteryPercentStatusClass(Double batteryPercent) {
        if (batteryPercent == null) {
            return "unavailable";
        }
        if (batteryPercent > 70.0d) {
            return "good";
        }
        if (batteryPercent > 40.0d) {
            return "warning";
        }
        return "danger";
    }

}

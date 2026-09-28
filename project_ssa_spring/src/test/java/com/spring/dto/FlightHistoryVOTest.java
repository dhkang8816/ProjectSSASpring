package com.spring.dto;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class FlightHistoryVOTest {

    @Test
    void batteryRemainingUsesGreenYellowRedBoundaries() {
        assertEquals("good", FlightHistoryVO.builder().startBatteryPercent(100.0d).build()
                .getStartBatteryStatusClass());
        assertEquals("warning", FlightHistoryVO.builder().endBatteryPercent(70.0d).build()
                .getEndBatteryStatusClass());
        assertEquals("danger", FlightHistoryVO.builder().endBatteryPercent(40.0d).build()
                .getEndBatteryStatusClass());
        assertEquals("danger", FlightHistoryVO.builder().endBatteryPercent(39.9d).build()
                .getEndBatteryStatusClass());
    }

    @Test
    void batteryConsumptionUsesInverseGreenYellowRedBoundaries() {
        assertEquals("good", FlightHistoryVO.builder().batteryConsumption(20.0d).build()
                .getBatteryConsumptionStatusClass());
        assertEquals("warning", FlightHistoryVO.builder().batteryConsumption(40.0d).build()
                .getBatteryConsumptionStatusClass());
        assertEquals("danger", FlightHistoryVO.builder().batteryConsumption(40.1d).build()
                .getBatteryConsumptionStatusClass());
        assertEquals("unavailable", FlightHistoryVO.builder().build().getBatteryConsumptionStatusClass());
    }
}

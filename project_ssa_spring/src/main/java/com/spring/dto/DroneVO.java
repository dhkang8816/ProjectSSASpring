package com.spring.dto;

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
public class DroneVO {

    private String droneId;            // DRONE_ID - 드론
    private String memberId;           // MEMBER_ID - 사번

    private String camera;             // CAMERA - 카메라
    private Integer batteryCapacity;   // BATTERY_CAPACITY - 배터리용량(mAh)
    private Double droneLength;  		// LENGTH
    private Double droneWidth;   		// WIDTH       
    private String brand;              // BRAND - 브랜드
    private Integer maintenanceCount;  // MAINTENANCE_COUNT - 정비횟수
}
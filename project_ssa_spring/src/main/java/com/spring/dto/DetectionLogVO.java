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
public class DetectionLogVO {
    private int dlogId;            // 탐지이력시퀀스
    private Timestamp detectTime;  // 탐지시각
    private String animalType;     // 축종구분
    private String snapshotPath;   // 포착스냅샷경로
    private Date detectionDate;    // 로그적재일시
    private String droneId;        // 드론 기체 ID
    private String actionStatus;   // 조치상태
    private String actionReason;   // 현장조치사유
    private int detectCount;       // 개체수
}

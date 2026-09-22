package com.spring.dto;

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
public class PatrolReportVO {
    private Long reportId;            // REPORT_ID (NUMBER -> Long 또는 BigDecimal)
    private Date reportDate;          // REPORT_DATE
    private Double totalFlightTime;   // TOTAL_FLIGHT_TIME (소수점 대응)
    private Long totalDetectCount;    // TOTAL_DETECT_COUNT
    private Double completionRate;    // COMPLETION_RATE (소수점 대응)
    private String confirmStatus;     // CONFIRM_STATUS
    private Date patrolDate;          // PATROL_DATE
    private Date modDate;             // MOD_DATE
    private String memberId;          // MEMBER_ID
    private String actionTaken;       // ACTION_TAKEN (추가)
    private String remark;            // REMARK (추가)
}
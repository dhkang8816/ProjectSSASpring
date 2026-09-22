package com.spring.dto;

import java.util.Date; // DATE 타입 매핑

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class LoginLogVO {
    private int logId;            // LOG_ID (NUMBER -> int로 자동 언박싱 매핑)
    private String loginIp;       // LOGIN_IP (VARCHAR2)
    private String loginStatus;   // LOGIN_STATUS (VARCHAR2 - 'SUCCESS', 'FAIL' 등)
    private Date loginDate;       // LOGIN_DATE (DATE)
    private String memberId;      // MEMBER_ID (VARCHAR2 - 사번)
}

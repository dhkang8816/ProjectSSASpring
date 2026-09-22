package com.spring.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class MemberLogVO {

    private int memberLogId;     // 로그인 이력 시퀀스 (INT, PK)
    private String memberId;     // 사번 (VARCHAR2(20), FK)
    private String loginIp;      // 접속 요청 IP 주소 (VARCHAR2(50))
    private String loginStatus;  // 로그인 결과 상태 (VARCHAR2(20))
    private Date loginDate;      // 로그인 시도 일시 (DATE, 기본값 SYSDATE)
}

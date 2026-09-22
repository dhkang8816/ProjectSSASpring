package com.spring.dto;

import java.sql.Timestamp;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString; // 디버깅용 로그 확인을 위해 추가 추천합니다!

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class AlertLogVO {
    private int alertId;
    private String alertMsg;
    private String sendStatus;
    private Date sendDate;
    private Integer dlogId;
    private Timestamp firstSendTime;
    private String alertType;
    private Integer danlogId;
}

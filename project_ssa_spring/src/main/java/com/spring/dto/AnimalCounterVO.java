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
public class AnimalCounterVO {
    private int counterId;        // COUNTER_ID (NUMBER(38,0) -> long) 코멘트: 개체수시퀀스
    private int currentCount;     // CURRENT_COUNT (NUMBER(38,0) -> long) 코멘트: 현재보호개체수
    private Date lastUpdate;       // LAST_UPDATE (DATE, DEFAULT SYSDATE) 코멘트: 최종갱신일지
}

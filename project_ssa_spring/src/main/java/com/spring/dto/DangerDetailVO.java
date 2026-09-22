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
public class DangerDetailVO {

    private int dangerId;          // DANGER_ID (이상객체식별시퀀스)
    private String dangerName;     // DANGER_NAME (이상객체이름 - 예: 멧돼지, 고라니 등)
    private Date dangerDate;       // DANGER_DATE (등록일자, DEFAULT SYSDATE)
}

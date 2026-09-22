package com.spring.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class WeatherStatusVO {

    private Double temperature;
    private Double humidity;
    private Double windSpeed;

    private Integer weatherCode;
    private String weatherCondition;

    private Double ghi;
    private Double dni;
    private Double dhi;

    private String weatherTime;
}
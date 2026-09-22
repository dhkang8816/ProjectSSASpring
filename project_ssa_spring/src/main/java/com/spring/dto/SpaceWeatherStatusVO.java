package com.spring.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

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
public class SpaceWeatherStatusVO {

    private Double solarWindSpeed;
    private Double bz;
    private Double kp;

    @JsonProperty("gScale")
    private String gScale;

    @JsonProperty("rScale")
    private String rScale;

    @JsonProperty("sScale")
    private String sScale;

    private String solarWindTime;
    private String kpTime;
    private String scaleTime;
}
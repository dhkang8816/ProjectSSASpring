package com.spring.dto;

import java.util.Date;

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
public class EnvironmentVO {

    private Integer environmentId;
    private String locationName;
    private String address;
    private Double latitude;
    private Double longitude;
    private String timezone;
    private String useYn;
    private Date updateDate;
}
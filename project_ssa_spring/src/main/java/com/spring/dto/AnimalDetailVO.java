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
public class AnimalDetailVO {

    private int animalId;          // 동물식별시퀀스
    private String animalType;      // 축종구분
    private String animalBreed;     // 품종구분
    private String animalName;      // 동물이름
    private Date entranceDate;      // 입소날자
    private String animalStatus;    // 보호상태
}

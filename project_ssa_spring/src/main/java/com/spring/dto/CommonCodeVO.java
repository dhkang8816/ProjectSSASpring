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
public class CommonCodeVO {

    private String grpCode;   
    private String code;       
    private String codeName;   
    private int sortSeq;     
    private String useYn;   
    private Date codeDate; 
}

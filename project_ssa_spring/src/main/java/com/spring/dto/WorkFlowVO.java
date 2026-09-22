package com.spring.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class WorkFlowVO {
    private Long approvalId;
    private String appStatus;
    private String rejectReason;
    private String adminSign;
    private Date requestDate;
    private Date completeDate;
    private String drafterId;
    private String approverId;
    private Long reportId;
    private String drafterName;
    private String approverName;
    private Date reportDate;
    private String actionTaken;
    private String remark;
}

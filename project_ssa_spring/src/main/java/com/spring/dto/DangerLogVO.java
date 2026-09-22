package com.spring.dto;

import java.sql.Timestamp;
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
public class DangerLogVO {

	 	private int danlogId;             // 이상객체탐지시퀀스 
	    private int dangerType;           // 탐지된이상객체 
	    private Timestamp dangerTime;     // 탐지시각
	    private String dactionStatus;     // 조치상태
	    private String dactionReason;     // 현장조치사유
	    private String dsnapshotPath;     // 포착스냅샷이미지
	    private Date dangerDate;          // 시스템로그적재일
	    private String droneId;           // 드론 
	    private String dangerName;			// 프론트앤드용
}

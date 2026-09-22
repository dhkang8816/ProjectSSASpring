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
public class MemberVO {

	private String memberId;       // 사번 (VARCHAR2(20), Not Null)
    private String name;           // 이름 (VARCHAR2(50), Not Null)
    private String department;     // 소속 (VARCHAR2(20), Not Null)
    private String password;       // 비밀번호 (VARCHAR2(100), Not Null)
    private String status;         // 계정상태 (VARCHAR2(1), Not Null, Default '0')
    private int failCount;        // 로그인실패횟수 (NUMBER(38,0), Not Null, Default 0)
    private Date pwdChgDate; // 마지막비밀번호변경일 (DATE, Not Null, Default SYSDATE)
    private Date lastLongDate; // 마지막로그인일시 (DATE, Nullable)
    private Date regDate;    // 계정등록일 (DATE, Not Null, Default SYSDATE)
    private String phone;          // 전화번호 (VARCHAR2(100), Nullable)
    private String email;          // 이메일 (VARCHAR2(300), Not Null)
    private String picture;        // 사진경로 (VARCHAR2(200), Not Null, Default 'noImage.jpg')

    private String role; // 💡 권한 필드 추가
}

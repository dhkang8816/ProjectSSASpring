package com.spring.dto;

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
public class MemberRoleVO {

    private int roleId;       // 권한번호 (INT, PK)
    private String memberId;  // 사번 (VARCHAR2(20), FK)
    private String roleCode;  // 권한 명칭 (VARCHAR2(20), 기본값 'ROLE_GUEST')
}

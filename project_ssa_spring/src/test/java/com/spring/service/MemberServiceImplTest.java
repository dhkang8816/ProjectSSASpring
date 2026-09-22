package com.spring.service;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.spring.dao.MemberDAO;
import com.spring.dto.MemberVO;

class MemberServiceImplTest {

    @Test
    void loginFailureDoesNothingWhenMemberDoesNotExist() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        PasswordEncoder encoder = mock(PasswordEncoder.class);
        when(dao.selectMemberById("unknown")).thenReturn(null);

        new MemberServiceImpl(dao, encoder).loginFailure("unknown", "127.0.0.1");

        verify(dao).selectMemberById("unknown");
        verify(dao, never()).incrementFailCount("unknown");
        verify(dao, never()).insertMemberLog("unknown", "127.0.0.1", "FAIL");
        verify(dao, never()).updateMemberStatus(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void loginFailureKeepsExistingIncrementLockAndAuditFlowForKnownMember() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        PasswordEncoder encoder = mock(PasswordEncoder.class);
        MemberVO existing = MemberVO.builder().memberId("member01").status("0").failCount(4).build();
        MemberVO incremented = MemberVO.builder().memberId("member01").status("0").failCount(5).build();
        when(dao.selectMemberById("member01")).thenReturn(existing, incremented);

        new MemberServiceImpl(dao, encoder).loginFailure("member01", "127.0.0.1");

        verify(dao).incrementFailCount("member01");
        ArgumentCaptor<MemberVO> memberCaptor = ArgumentCaptor.forClass(MemberVO.class);
        verify(dao).updateMemberStatus(memberCaptor.capture());
        verify(dao).insertMemberLog("member01", "127.0.0.1", "FAIL");
        org.junit.jupiter.api.Assertions.assertEquals("1", memberCaptor.getValue().getStatus());
    }
}

package com.spring.service;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.spring.dao.MemberDAO;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;
import com.spring.exception.InvalidRequestException;

class MemberServiceImplTest {

    @Test
    void administratorAccountUpdateChangesStatusAndReplacesTheEffectiveRole() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        PasswordEncoder encoder = mock(PasswordEncoder.class);
        MemberVO target = MemberVO.builder().memberId("user01").status("0").build();
        when(dao.selectMemberById("user01")).thenReturn(target);
        when(dao.selectMemberRoles("user01"))
                .thenReturn(List.of(MemberRoleVO.builder().memberId("user01").roleCode("ROLE_USER").build()));

        new MemberServiceImpl(dao, encoder)
                .updateMemberAccount("user01", "1", "ROLE_GUEST", "admin01");

        ArgumentCaptor<MemberVO> statusCaptor = ArgumentCaptor.forClass(MemberVO.class);
        ArgumentCaptor<MemberRoleVO> roleCaptor = ArgumentCaptor.forClass(MemberRoleVO.class);
        verify(dao).updateMemberStatus(statusCaptor.capture());
        verify(dao).deleteMemberRoles("user01");
        verify(dao).insertMemberRole(roleCaptor.capture());
        assertEquals("1", statusCaptor.getValue().getStatus());
        assertEquals("ROLE_GUEST", roleCaptor.getValue().getRoleCode());
    }

    @Test
    void accountUpdateRejectsTheCurrentAdministratorsOwnAccount() {
        MemberDAO dao = mock(MemberDAO.class);
        PasswordEncoder encoder = mock(PasswordEncoder.class);

        assertThrows(InvalidRequestException.class, () -> new MemberServiceImpl(dao, encoder)
                .updateMemberAccount("admin01", "0", "ROLE_USER", "admin01"));
    }

    @Test
    void accountUpdateCannotRemoveTheLastActiveAdministrator() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        PasswordEncoder encoder = mock(PasswordEncoder.class);
        MemberVO target = MemberVO.builder().memberId("admin02").status("0").build();
        when(dao.selectMemberById("admin02")).thenReturn(target);
        when(dao.selectMemberRoles("admin02"))
                .thenReturn(List.of(MemberRoleVO.builder().memberId("admin02").roleCode("ROLE_ADMIN").build()));
        when(dao.countActiveAdminMembers()).thenReturn(1);

        assertThrows(InvalidRequestException.class, () -> new MemberServiceImpl(dao, encoder)
                .updateMemberAccount("admin02", "0", "ROLE_USER", "admin01"));
        verify(dao, never()).updateMemberStatus(org.mockito.ArgumentMatchers.any());
        verify(dao, never()).deleteMemberRoles("admin02");
    }

    @Test
    void profileUpdateUsesTheStatusFreeMapperStatement() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        PasswordEncoder encoder = mock(PasswordEncoder.class);
        MemberVO member = MemberVO.builder().memberId("member01").status("1").build();
        when(dao.updateMemberProfile(member)).thenReturn(1);

        int result = new MemberServiceImpl(dao, encoder).modifyMemberProfile(member);

        assertEquals(1, result);
        verify(dao).updateMemberProfile(member);
        verify(dao, never()).updateMember(member);
    }

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

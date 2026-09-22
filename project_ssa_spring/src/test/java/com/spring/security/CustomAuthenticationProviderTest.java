package com.spring.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.spring.dao.MemberDAO;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;

class CustomAuthenticationProviderTest {

    @Test
    void missingMemberUsesGenericBadCredentialsMessage() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        when(dao.selectMemberById("unknown")).thenReturn(null);
        CustomAuthenticationProvider provider = new CustomAuthenticationProvider(dao, new BCryptPasswordEncoder());

        BadCredentialsException error = assertThrows(BadCredentialsException.class,
                () -> provider.authenticate(new UsernamePasswordAuthenticationToken("unknown", "password")));

        assertEquals("아이디 또는 비밀번호가 올바르지 않습니다.", error.getMessage());
    }

    @Test
    void lockedMemberIsRejectedWithoutPasswordComparison() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        MemberVO member = MemberVO.builder().memberId("locked").status("1").password("unused").build();
        when(dao.selectMemberById("locked")).thenReturn(member);
        CustomAuthenticationProvider provider = new CustomAuthenticationProvider(dao, new BCryptPasswordEncoder());

        assertThrows(LockedException.class,
                () -> provider.authenticate(new UsernamePasswordAuthenticationToken("locked", "password")));
    }

    @Test
    void successfulAuthenticationDoesNotKeepCredentialsOrPasswordHashInPrincipal() throws Exception {
        MemberDAO dao = mock(MemberDAO.class);
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        MemberVO member = MemberVO.builder()
                .memberId("member01")
                .status("0")
                .password(encoder.encode("correct-password"))
                .build();
        when(dao.selectMemberById("member01")).thenReturn(member);
        when(dao.selectMemberRoles("member01"))
                .thenReturn(List.of(MemberRoleVO.builder().memberId("member01").roleCode("ROLE_USER").build()));
        CustomAuthenticationProvider provider = new CustomAuthenticationProvider(dao, encoder);

        Authentication result = provider.authenticate(
                new UsernamePasswordAuthenticationToken("member01", "correct-password"));

        assertNull(result.getCredentials());
        CustomUser principal = (CustomUser) result.getPrincipal();
        assertEquals("member01", principal.getUsername());
        assertNull(principal.getMember().getPassword());
        verify(dao).selectMemberRoles("member01");
    }
}

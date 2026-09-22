package com.spring.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import com.spring.service.MemberService;

class LoginFailureHandlerTest {

    @Test
    void badCredentialsUsesSafeMessageAndDelegatesFailureProcessing() throws Exception {
        MemberService memberService = mock(MemberService.class);
        LoginFailureHandler handler = handler(memberService);
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/login");
        request.setContextPath("/project_ssa_spring");
        request.setParameter("memberId", "member01");
        MockHttpServletResponse response = new MockHttpServletResponse();

        handler.onAuthenticationFailure(request, response, new BadCredentialsException("internal detail"));

        verify(memberService).loginFailure(org.mockito.ArgumentMatchers.eq("member01"), anyString());
        assertEquals("아이디 또는 비밀번호가 올바르지 않습니다.",
                request.getSession().getAttribute("ERROR_MSG"));
        assertEquals("member01", request.getSession().getAttribute("LOGIN_MEMBER_ID"));
        assertEquals("/project_ssa_spring/login?error=true", response.getRedirectedUrl());
    }

    @Test
    void lockedAccountDoesNotIncrementFailureCountAgain() throws Exception {
        MemberService memberService = mock(MemberService.class);
        LoginFailureHandler handler = handler(memberService);
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/login");
        request.setParameter("memberId", "locked");
        MockHttpServletResponse response = new MockHttpServletResponse();

        handler.onAuthenticationFailure(request, response, new LockedException("internal detail"));

        verify(memberService, never()).loginFailure(anyString(), anyString());
        assertEquals("잠긴 계정입니다. 관리자에게 문의해 주세요.",
                request.getSession().getAttribute("ERROR_MSG"));
    }

    private LoginFailureHandler handler(MemberService memberService) {
        LoginFailureHandler handler = new LoginFailureHandler();
        ReflectionTestUtils.setField(handler, "memberService", memberService);
        return handler;
    }
}

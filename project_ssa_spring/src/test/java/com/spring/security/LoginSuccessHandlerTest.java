package com.spring.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;
import org.springframework.security.core.Authentication;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import com.spring.service.MemberService;

import jakarta.servlet.http.Cookie;

class LoginSuccessHandlerTest {

    @Test
    void savedIdCreatesOneDayIdOnlyCookieAfterSuccessfulLogin() throws Exception {
        MemberService memberService = mock(MemberService.class);
        LoginSuccessHandler handler = handler(memberService);
        Authentication authentication = mock(Authentication.class);
        when(authentication.getName()).thenReturn("member01");
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/login");
        request.setContextPath("/project_ssa_spring");
        request.setRemoteAddr("127.0.0.1");
        request.setParameter("saveId", "on");
        MockHttpServletResponse response = new MockHttpServletResponse();

        handler.onAuthenticationSuccess(request, response, authentication);

        Cookie cookie = response.getCookie("saveId");
        assertNotNull(cookie);
        assertEquals("member01", cookie.getValue());
        assertEquals(86400, cookie.getMaxAge());
        assertEquals("/project_ssa_spring", cookie.getPath());
        assertEquals("/project_ssa_spring/", response.getRedirectedUrl());
        verify(memberService).loginSuccess("member01", "127.0.0.1");
    }

    @Test
    void uncheckedSaveIdDeletesExistingCookieAfterSuccessfulLogin() throws Exception {
        MemberService memberService = mock(MemberService.class);
        LoginSuccessHandler handler = handler(memberService);
        Authentication authentication = mock(Authentication.class);
        when(authentication.getName()).thenReturn("member01");
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/login");
        MockHttpServletResponse response = new MockHttpServletResponse();

        handler.onAuthenticationSuccess(request, response, authentication);

        Cookie cookie = response.getCookie("saveId");
        assertNotNull(cookie);
        assertEquals("", cookie.getValue());
        assertEquals(0, cookie.getMaxAge());
    }

    private LoginSuccessHandler handler(MemberService memberService) {
        LoginSuccessHandler handler = new LoginSuccessHandler();
        ReflectionTestUtils.setField(handler, "memberService", memberService);
        return handler;
    }
}

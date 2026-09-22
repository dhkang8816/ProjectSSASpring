package com.spring.security;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.spring.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;

@Log4j2
public class LoginFailureHandler implements AuthenticationFailureHandler {

    private static final String INVALID_CREDENTIALS_MESSAGE =
            "아이디 또는 비밀번호가 올바르지 않습니다.";
    private static final String LOCKED_ACCOUNT_MESSAGE =
            "잠긴 계정입니다. 관리자에게 문의해 주세요.";
    private static final String DISABLED_ACCOUNT_MESSAGE = "사용할 수 없는 계정입니다.";
    private static final String AUTHENTICATION_ERROR_MESSAGE =
            "로그인 처리 중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.";

    @Autowired
    private MemberService memberService;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException exception) throws IOException, ServletException {

        String memberId = request.getParameter("memberId");
        String ip = resolveClientIp(request);
        if (exception instanceof BadCredentialsException
                && memberId != null && !memberId.trim().isEmpty()) {
            try {
                memberService.loginFailure(memberId.trim(), ip);
            } catch (Exception e) {
                log.error("Login failure audit could not be recorded for memberId={}", memberId.trim(), e);
            }
        }

        if (memberId != null && !memberId.trim().isEmpty()) {
            request.getSession().setAttribute("LOGIN_MEMBER_ID", memberId.trim());
        }
        request.getSession().setAttribute("ERROR_MSG", resolveUserMessage(exception));
        response.sendRedirect(request.getContextPath() + "/login?error=true");
    }

    private String resolveClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip != null && ip.contains(",") ? ip.substring(0, ip.indexOf(',')).trim() : ip;
    }

    private String resolveUserMessage(AuthenticationException exception) {
        if (exception instanceof LockedException) {
            return LOCKED_ACCOUNT_MESSAGE;
        }
        if (exception instanceof DisabledException) {
            return DISABLED_ACCOUNT_MESSAGE;
        }
        if (exception instanceof BadCredentialsException) {
            return INVALID_CREDENTIALS_MESSAGE;
        }
        return AUTHENTICATION_ERROR_MESSAGE;
    }
}

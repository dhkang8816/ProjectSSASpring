package com.spring.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.spring.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.log4j.Log4j2;

@Log4j2
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    private static final String SAVE_ID_COOKIE = "saveId";
    private static final int SAVE_ID_MAX_AGE_SECONDS = 24 * 60 * 60;

    @Autowired
    private MemberService memberService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        String memberId = authentication.getName();
        String ip = resolveClientIp(request);
        try {
            memberService.loginSuccess(memberId, ip);
        } catch (Exception e) {
            log.error("Login success audit could not be recorded for memberId={}", memberId, e);
        }

        updateSavedIdCookie(request, response, memberId);
        response.sendRedirect(request.getContextPath() + "/");
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

    private void updateSavedIdCookie(HttpServletRequest request, HttpServletResponse response, String memberId) {
        Cookie cookie;
        if (request.getParameter("saveId") != null) {
            cookie = new Cookie(SAVE_ID_COOKIE, URLEncoder.encode(memberId, StandardCharsets.UTF_8));
            cookie.setMaxAge(SAVE_ID_MAX_AGE_SECONDS);
        } else {
            cookie = new Cookie(SAVE_ID_COOKIE, "");
            cookie.setMaxAge(0);
        }
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setSecure(request.isSecure());
        response.addCookie(cookie);
    }
}

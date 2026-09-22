package com.spring.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.spring.dao.MemberDAO;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;

import lombok.extern.log4j.Log4j2;

@Log4j2
public class CustomAuthenticationProvider implements AuthenticationProvider {

    private static final String INVALID_CREDENTIALS_MESSAGE =
            "아이디 또는 비밀번호가 올바르지 않습니다.";

    private final MemberDAO memberDAO;
    private final BCryptPasswordEncoder encoder;

    public CustomAuthenticationProvider(MemberDAO memberDAO, BCryptPasswordEncoder encoder) {
        this.memberDAO = memberDAO;
        this.encoder = encoder;
    }

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String memberId = authentication.getName();
        String password = (String) authentication.getCredentials();

        try {
            MemberVO member = memberDAO.selectMemberById(memberId);
            if (member == null) {
                throw new BadCredentialsException(INVALID_CREDENTIALS_MESSAGE);
            }
            if ("1".equals(member.getStatus())) {
                throw new LockedException("잠긴 계정입니다. 관리자에게 문의해 주세요.");
            }
            if (!"0".equals(member.getStatus())) {
                throw new DisabledException("사용할 수 없는 계정입니다.");
            }
            if (!encoder.matches(password, member.getPassword())) {
                throw new BadCredentialsException(INVALID_CREDENTIALS_MESSAGE);
            }

            List<MemberRoleVO> roleList = memberDAO.selectMemberRoles(memberId);
            List<GrantedAuthority> authorities = new ArrayList<>();
            if (roleList != null && !roleList.isEmpty()) {
                for (MemberRoleVO roleVo : roleList) {
                    if (roleVo != null && roleVo.getRoleCode() != null) {
                        authorities.add(new SimpleGrantedAuthority(roleVo.getRoleCode()));
                    }
                }
            }
            if (authorities.isEmpty()) {
                authorities.add(new SimpleGrantedAuthority("ROLE_GUEST"));
            }

            CustomUser principal = new CustomUser(member);
            member.setPassword(null);
            return new UsernamePasswordAuthenticationToken(principal, null, authorities);
        } catch (AuthenticationException e) {
            throw e;
        } catch (Exception e) {
            log.error("Authentication data lookup failed for memberId={}", memberId, e);
            throw new AuthenticationServiceException("Authentication service is unavailable.", e);
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}

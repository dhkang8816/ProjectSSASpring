package com.spring.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.spring.security.CustomUser;
import com.spring.dto.MemberVO;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserApiController {

    @GetMapping("/user/me")
    public ResponseEntity<Map<String, Object>> getCurrentUser() {
        Map<String, Object> response = new HashMap<>();
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() 
                || "anonymousUser".equals(authentication.getPrincipal())) {
            response.put("isLoggedIn", false);
            return ResponseEntity.ok(response);
        }
        try {
            CustomUser customUser = (CustomUser) authentication.getPrincipal();
            MemberVO memberVO = customUser.getMember(); 
            
            response.put("isLoggedIn", true);
            response.put("memberId", memberVO.getMemberId());   // 사번
            response.put("name", memberVO.getName());           // 이름
            response.put("picture", memberVO.getPicture());     // 사진 파일명
            
        } catch (ClassCastException e) {
            response.put("isLoggedIn", false);
        }
        
        return ResponseEntity.ok(response);
    }
    @GetMapping("/main") // 메인 주소에 맞게 변경하세요
    public String mainPage() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("====== 로그인 상태 확인 ======");
        System.out.println("현재 로그인된 사용자: " + auth.getName());
        System.out.println("권한 목록: " + auth.getAuthorities());
        System.out.println("============================");
        
        return "main"; 
    }

}

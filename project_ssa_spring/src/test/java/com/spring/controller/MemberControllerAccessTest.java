package com.spring.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.ui.ExtendedModelMap;

import com.spring.dto.MemberVO;
import com.spring.security.CustomUser;
import com.spring.service.CommonCodeService;
import com.spring.service.MemberService;

class MemberControllerAccessTest {

    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void userCanOpenOnlyTheirOwnModifyFormAndDoesNotReceiveAccountFields() throws Exception {
        MemberService memberService = mock(MemberService.class);
        CommonCodeService commonCodeService = mock(CommonCodeService.class);
        MemberController controller = controller(memberService, commonCodeService);
        MemberVO member = MemberVO.builder().memberId("user01").status("0").build();
        when(memberService.getRequiredMemberById("user01")).thenReturn(member);
        authenticate("user01", "ROLE_USER");

        ExtendedModelMap model = new ExtendedModelMap();
        String viewName = controller.modifyForm("user01", model);

        assertEquals("member/memberModify", viewName);
        assertFalse((Boolean) model.get("canManageAccount"));
        verify(memberService).getRequiredMemberById("user01");
        verify(commonCodeService, never()).getCodeListByGroup("ACCOUNT_STATUS");
        verify(commonCodeService, never()).getCodeListByGroup("USER_ROLE");
    }

    @Test
    void userCannotOpenAnotherMembersProfile() throws Exception {
        MemberService memberService = mock(MemberService.class);
        MemberController controller = controller(memberService, mock(CommonCodeService.class));
        authenticate("user01", "ROLE_USER");

        assertThrows(AccessDeniedException.class,
                () -> controller.getMemberDetail("user02", new ExtendedModelMap()));
        verify(memberService, never()).getRequiredMemberById("user02");
    }

    @Test
    void administratorCanOpenAnotherMembersModifyForm() throws Exception {
        MemberService memberService = mock(MemberService.class);
        CommonCodeService commonCodeService = mock(CommonCodeService.class);
        MemberController controller = controller(memberService, commonCodeService);
        MemberVO member = MemberVO.builder().memberId("user01").status("0").build();
        when(memberService.getRequiredMemberById("user01")).thenReturn(member);
        when(commonCodeService.getCodeListByGroup("ACCOUNT_STATUS")).thenReturn(List.of());
        when(commonCodeService.getCodeListByGroup("USER_ROLE")).thenReturn(List.of());
        authenticate("admin01", "ROLE_ADMIN");

        ExtendedModelMap model = new ExtendedModelMap();
        String viewName = controller.modifyForm("user01", model);

        assertEquals("member/memberModify", viewName);
        assertEquals(Boolean.TRUE, model.get("canManageAccount"));
        verify(commonCodeService).getCodeListByGroup("ACCOUNT_STATUS");
        verify(commonCodeService).getCodeListByGroup("USER_ROLE");
    }

    @Test
    void administratorAccountEndpointDelegatesTheSecuredUpdate() throws Exception {
        MemberService memberService = mock(MemberService.class);
        MemberController controller = controller(memberService, mock(CommonCodeService.class));
        authenticate("admin01", "ROLE_ADMIN");

        var response = controller.updateMemberAccount("user01", "1", "ROLE_GUEST");

        assertEquals(200, response.getStatusCode().value());
        assertEquals(Boolean.TRUE, response.getBody().get("success"));
        verify(memberService).updateMemberAccount("user01", "1", "ROLE_GUEST", "admin01");
    }

    @Test
    void nonAdministratorCannotUseTheAccountEndpoint() {
        MemberController controller = controller(mock(MemberService.class), mock(CommonCodeService.class));
        authenticate("user01", "ROLE_USER");

        assertThrows(AccessDeniedException.class,
                () -> controller.updateMemberAccount("user02", "1", "ROLE_GUEST"));
    }

    private MemberController controller(MemberService memberService, CommonCodeService commonCodeService) {
        MemberController controller = new MemberController();
        ReflectionTestUtils.setField(controller, "memberService", memberService);
        ReflectionTestUtils.setField(controller, "commonCodeService", commonCodeService);
        return controller;
    }

    private void authenticate(String memberId, String authority) {
        MemberVO loggedInMember = MemberVO.builder().memberId(memberId).status("0").build();
        CustomUser principal = new CustomUser(loggedInMember);
        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                principal, null, List.of(new SimpleGrantedAuthority(authority)));
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }
}

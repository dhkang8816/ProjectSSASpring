package com.spring.service;

import java.util.Set;

import java.util.List; // 💡 List 임포트 추가

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.MemberDAO;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;
import com.spring.exception.InvalidRequestException;
import com.spring.exception.MemberNotFoundException;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service("memberService")
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberDAO memberDAO;

    @Autowired
    @Qualifier("encoder")
    private PasswordEncoder passwordEncoder;
    @Transactional
    @Override
    public void regist(MemberVO member) throws Exception {
        String encodedPwd = passwordEncoder.encode(member.getPassword());
        member.setPassword(encodedPwd);
        if (member.getPicture() == null || member.getPicture().trim().isEmpty()) {
            member.setPicture("noImage.jpg");
        }
        memberDAO.insertMember(member);
        MemberRoleVO role = MemberRoleVO.builder()
                .memberId(member.getMemberId())
                .roleCode(member.getRole() != null ? member.getRole() : "ROLE_GUEST")
                .build();

        memberDAO.insertMemberRole(role);
    }
    @Override
    public MemberVO getMemberById(String memberId) throws Exception {
        return memberDAO.selectMemberById(memberId);
    }

    @Override
    public MemberVO getRequiredMemberById(String memberId) throws Exception {
        if (memberId == null || memberId.trim().isEmpty()) {
            throw new InvalidRequestException("회원 ID는 필수입니다.");
        }
        MemberVO member = memberDAO.selectMemberById(memberId.trim());
        if (member == null) {
            throw new MemberNotFoundException(memberId);
        }
        return member;
    }
    @Override
    public List<MemberVO> getMemberList(PageMaker pageMaker) throws Exception {
        return memberDAO.selectMemberList(pageMaker);
    }
    
    @Override
    public int getMemberListCount(PageMaker pageMaker) throws Exception {
        return memberDAO.selectMemberListCount(pageMaker);
    }

    @Override
    public List<MemberVO> getAdminMembers() throws Exception {
        return memberDAO.selectAdminMembers();
    }

    @Override
    public boolean isAdminMember(String memberId) throws Exception {
        return memberDAO.isAdminMember(memberId);
    }
    @Transactional
    @Override
    public void loginSuccess(String memberId, String ip) throws Exception {
        memberDAO.resetFailCount(memberId);
        memberDAO.updateLastLogDate(memberId);
        memberDAO.insertMemberLog(memberId, ip, "SUCCESS"); // 이력 적재
    }
    @Transactional
    @Override
    public void loginFailure(String memberId, String ip) throws Exception {
        MemberVO member = memberDAO.selectMemberById(memberId);
        if (member == null) {
            return;
        }

        memberDAO.incrementFailCount(memberId);
        member = memberDAO.selectMemberById(memberId);
        if (member != null && member.getFailCount() >= 5) {
            member.setStatus("1"); // '1'은 정지 상태 코드
            memberDAO.updateMemberStatus(member); // 또는 상태만 변경하는 전용 쿼리 실행
        }
        memberDAO.insertMemberLog(memberId, ip, "FAIL");
    }
    
    
    @Transactional
    @Override
    public int modifyMember(MemberVO memberVO) throws Exception{
        return memberDAO.updateMember(memberVO);
    }

    @Transactional
    @Override
    public int modifyMemberProfile(MemberVO memberVO) throws Exception {
        return memberDAO.updateMemberProfile(memberVO);
    }

    @Transactional
    @Override
    public void updateMemberAccount(String memberId, String status, String roleCode,
            String currentAdminId) throws Exception {
        if (memberId == null || memberId.trim().isEmpty()
                || status == null || roleCode == null) {
            throw new InvalidRequestException("회원 계정 정보가 올바르지 않습니다.");
        }
        if (memberId.trim().equals(currentAdminId)) {
            throw new InvalidRequestException("본인의 권한과 계정 상태는 목록에서 변경할 수 없습니다.");
        }
        if (!Set.of("0", "1", "2").contains(status)
                || !Set.of("ROLE_ADMIN", "ROLE_USER", "ROLE_GUEST").contains(roleCode)) {
            throw new InvalidRequestException("허용되지 않은 계정 상태 또는 권한입니다.");
        }

        MemberVO targetMember = getRequiredMemberById(memberId.trim());
        List<MemberRoleVO> targetRoles = memberDAO.selectMemberRoles(targetMember.getMemberId());
        boolean targetIsActiveAdmin = "0".equals(targetMember.getStatus())
                && targetRoles != null && targetRoles.stream()
                        .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleCode()));
        boolean removesActiveAdmin = targetIsActiveAdmin
                && (!"0".equals(status) || !"ROLE_ADMIN".equals(roleCode));
        if (removesActiveAdmin && memberDAO.countActiveAdminMembers() <= 1) {
            throw new InvalidRequestException("마지막 활성 관리자 계정은 변경할 수 없습니다.");
        }

        memberDAO.updateMemberStatus(MemberVO.builder()
                .memberId(targetMember.getMemberId())
                .status(status)
                .build());
        memberDAO.deleteMemberRoles(targetMember.getMemberId());
        memberDAO.insertMemberRole(MemberRoleVO.builder()
                .memberId(targetMember.getMemberId())
                .roleCode(roleCode)
                .build());
    }
}

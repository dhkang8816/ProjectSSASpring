package com.spring.service;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.MemberVO;

public interface MemberService {
    void regist(MemberVO member) throws Exception;
    MemberVO getMemberById(String memberId) throws Exception;
    MemberVO getRequiredMemberById(String memberId) throws Exception;
    List<MemberVO> getMemberList(PageMaker pageMaker) throws Exception;
    
    int getMemberListCount(PageMaker pageMaker) throws Exception;

    List<MemberVO> getAdminMembers() throws Exception;

    boolean isAdminMember(String memberId) throws Exception;
    void loginSuccess(String memberId, String ip) throws Exception;
    void loginFailure(String memberId, String ip) throws Exception;
    
    int modifyMember(MemberVO member) throws Exception;
    int modifyMemberProfile(MemberVO member) throws Exception;
    void updateMemberAccount(String memberId, String status, String roleCode, String currentAdminId) throws Exception;
}

package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.MemberRoleVO; // 권한VO 임포트
import com.spring.dto.MemberVO;

public interface MemberDAO {
	MemberVO selectMemberById(String memberId) throws Exception;
	List<MemberVO> selectMemberList(PageMaker pageMaker) throws Exception;
	
	int selectMemberListCount(PageMaker pageMaker) throws Exception;
	void incrementFailCount(String memberId) throws Exception;
	void resetFailCount(String memberId) throws Exception;
	void updateLastLogDate(String memberId) throws Exception;
	List<MemberRoleVO> selectMemberRoles(String memberId) throws Exception;
	int countActiveAdminMembers() throws Exception;

	List<MemberVO> selectAdminMembers() throws Exception;

	boolean isAdminMember(String memberId) throws Exception;
	void insertMember(MemberVO member) throws Exception;
	void insertMemberRole(MemberRoleVO memberRole) throws Exception;
	void deleteMemberRoles(String memberId) throws Exception;
	void insertMemberLog(String memberId, String loginIp, String loginStatus) throws Exception;

	int updateMember(MemberVO member) throws Exception;
	int updateMemberProfile(MemberVO member) throws Exception;
    int updateMemberStatus(MemberVO member) throws Exception;
}

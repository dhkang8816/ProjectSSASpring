package com.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class MemberDAOImpl implements MemberDAO {

    private final SqlSession sqlSession;

    private static final String NAMESPACE = "Member-Mapper";

    @Override
    public MemberVO selectMemberById(String memberId) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".selectMemberById", memberId);
    }

    @Override
    public List<MemberVO> selectMemberList(PageMaker pageMaker) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".selectMemberList", pageMaker);
    }
    
    @Override
    public int selectMemberListCount(PageMaker pageMaker) throws Exception {
        return sqlSession.selectOne("Member-Mapper.selectMemberListCount", pageMaker);
    }

    @Override
    public void incrementFailCount(String memberId) throws Exception {
        sqlSession.update(NAMESPACE + ".incrementFailCount", memberId);
    }

    @Override
    public void resetFailCount(String memberId) throws Exception {
        sqlSession.update(NAMESPACE + ".resetFailCount", memberId);
    }

    @Override
    public void updateLastLogDate(String memberId) throws Exception {
        sqlSession.update(NAMESPACE + ".updateLastLogDate", memberId);
    }
    
    @Override
    public List<MemberRoleVO> selectMemberRoles(String memberId) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".selectMemberRoles", memberId);
    }

    @Override
    public List<MemberVO> selectAdminMembers() throws Exception {
        return sqlSession.selectList(NAMESPACE + ".selectAdminMembers");
    }

    @Override
    public boolean isAdminMember(String memberId) throws Exception {
        Integer count = sqlSession.selectOne(NAMESPACE + ".countAdminMember", memberId);
        return count != null && count > 0;
    }
    
    @Override
    public void insertMember(MemberVO member) throws Exception {
        sqlSession.insert(NAMESPACE + ".insertMember", member);
    }

    @Override
    public void insertMemberRole(MemberRoleVO memberRole) throws Exception {
        sqlSession.insert(NAMESPACE + ".insertMemberRole", memberRole);
    }
    
    @Override
    public void insertMemberLog(String memberId, String loginIp, String loginStatus) throws Exception {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("memberId", memberId);
        paramMap.put("loginIp", loginIp);
        paramMap.put("loginStatus", loginStatus);

        sqlSession.insert(NAMESPACE + ".insertMemberLog", paramMap);
    }
    
    @Override
    public int updateMember(MemberVO memberVO) {
        return sqlSession.update("Member-Mapper.updateMember", memberVO);
    }
   
    @Override
    public int updateMemberStatus(MemberVO member) throws Exception {
        return sqlSession.update("Member-Mapper.updateMemberStatus", member);
    }

}

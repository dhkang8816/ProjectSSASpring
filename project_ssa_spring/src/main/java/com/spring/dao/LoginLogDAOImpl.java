package com.spring.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import com.spring.cmd.PageMaker;
import com.spring.dto.LoginLogVO;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Repository("loginLogDAO")
public class LoginLogDAOImpl implements LoginLogDAO {

    private SqlSession session; // 💡 MyBatis 핵심 실행 세션 주입
    private static final String NAMESPACE = "LoginLog-Mapper.";

    @Override
    public List<LoginLogVO> selectLoginLogList(PageMaker pageMaker) throws Exception {
        return session.selectList(NAMESPACE + "selectLoginLogList", pageMaker);
    }

    @Override
    public int selectLoginLogListCount(PageMaker pageMaker) throws Exception {
        return session.selectOne(NAMESPACE + "selectLoginLogListCount", pageMaker);
    }
}

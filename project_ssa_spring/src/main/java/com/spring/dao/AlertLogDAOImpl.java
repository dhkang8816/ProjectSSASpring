package com.spring.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class AlertLogDAOImpl implements AlertLogDAO {

    private SqlSession sqlSession;

    private static final String NAMESPACE = "AlertLog-Mapper.";

    @Override
    public void insertAlertLog(AlertLogVO vo) throws Exception {
        sqlSession.insert(NAMESPACE + "insertAlertLog", vo);
    }

    @Override
    public AlertLogVO getAlertLog(int alertId) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "getAlertLog", alertId);
    }

    @Override
    public List<AlertLogVO> getAlertLogListWithPaging(PageMaker pageMaker) throws Exception {
        return sqlSession.selectList(NAMESPACE + "getAlertLogListWithPaging", pageMaker);
    }

    @Override
    public int getTotalCount(PageMaker pageMaker) throws Exception {
        return sqlSession.selectOne(NAMESPACE + "getTotalCount", pageMaker);
    }
}

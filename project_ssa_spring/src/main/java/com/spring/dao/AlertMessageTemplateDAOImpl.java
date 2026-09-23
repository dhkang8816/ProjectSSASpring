package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.spring.dto.AlertMessageTemplateVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class AlertMessageTemplateDAOImpl implements AlertMessageTemplateDAO {

    private static final String NAMESPACE = "AlertMessageTemplate-Mapper.";

    private final SqlSession sqlSession;

    @Override
    public List<AlertMessageTemplateVO> selectAlertMessageTemplates() {
        return sqlSession.selectList(NAMESPACE + "selectAlertMessageTemplates");
    }

    @Override
    public int mergeAlertMessageTemplate(AlertMessageTemplateVO template) {
        return sqlSession.update(NAMESPACE + "mergeAlertMessageTemplate", template);
    }
}

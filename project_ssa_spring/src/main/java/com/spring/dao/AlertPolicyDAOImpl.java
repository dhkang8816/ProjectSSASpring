package com.spring.dao;

import org.apache.ibatis.session.SqlSession;

import com.spring.dto.AlertPolicyVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class AlertPolicyDAOImpl implements AlertPolicyDAO {

    private static final String NAMESPACE = "AlertPolicy-Mapper.";

    private final SqlSession sqlSession;

    @Override
    public AlertPolicyVO selectAnimalShortagePolicy() {
        return sqlSession.selectOne(NAMESPACE + "selectAnimalShortagePolicy");
    }

    @Override
    public int mergeAnimalShortagePolicy(AlertPolicyVO policy) {
        return sqlSession.update(NAMESPACE + "mergeAnimalShortagePolicy", policy);
    }
}

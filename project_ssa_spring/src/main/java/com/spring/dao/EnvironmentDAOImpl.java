package com.spring.dao;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.dto.EnvironmentVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class EnvironmentDAOImpl implements EnvironmentDAO {

    private static final String NAMESPACE = "Environment-Mapper.";

    private SqlSession session;


    @Override
    public EnvironmentVO selectEnvironment() throws SQLException {

        return session.selectOne(
            NAMESPACE + "selectEnvironment"
        );
    }


    @Override
    public List<EnvironmentVO> selectEnvironmentList() throws SQLException {

        return session.selectList(
            NAMESPACE + "selectEnvironmentList"
        );
    }


    @Override
    public void disableEnvironment() throws SQLException {

        session.update(
            NAMESPACE + "disableEnvironment"
        );
    }


    @Override
    public void insertEnvironment(EnvironmentVO environment)
            throws SQLException {

        session.insert(
            NAMESPACE + "insertEnvironment",
            environment
        );
    }


    @Override
    public void updateEnvironment(EnvironmentVO environment)
            throws SQLException {

        session.update(
            NAMESPACE + "updateEnvironment",
            environment
        );
    }


    @Override
    public void activateEnvironment(int environmentId)
            throws SQLException {

        session.update(
            NAMESPACE + "activateEnvironment",
            environmentId
        );
    }


    @Override
    public void deleteEnvironment(int environmentId)
            throws SQLException {

        session.delete(
            NAMESPACE + "deleteEnvironment",
            environmentId
        );
    }
}
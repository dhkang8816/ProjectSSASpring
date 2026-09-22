package com.spring.dao;

import java.sql.SQLException;
import java.util.List;

import com.spring.dto.EnvironmentVO;

public interface EnvironmentDAO {

    EnvironmentVO selectEnvironment() throws SQLException;
    List<EnvironmentVO> selectEnvironmentList() throws SQLException;
    void disableEnvironment() throws SQLException;
    void insertEnvironment(EnvironmentVO environment) throws SQLException;
    void updateEnvironment(EnvironmentVO environment) throws SQLException;
    void activateEnvironment(int environmentId) throws SQLException;
    void deleteEnvironment(int environmentId) throws SQLException;
}
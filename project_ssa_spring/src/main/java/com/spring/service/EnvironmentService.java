package com.spring.service;

import java.sql.SQLException;
import java.util.List;

import com.spring.dto.EnvironmentVO;

public interface EnvironmentService {
    
	EnvironmentVO getEnvironment() throws SQLException;
    List<EnvironmentVO> getEnvironmentList() throws SQLException;
    void registEnvironment(EnvironmentVO environment) throws SQLException;
    void modifyEnvironment(EnvironmentVO environment) throws SQLException;
    void activateEnvironment(int environmentId) throws SQLException;
    void removeEnvironment(int environmentId) throws SQLException;
}
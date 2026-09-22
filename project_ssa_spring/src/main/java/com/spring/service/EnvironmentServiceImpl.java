package com.spring.service;

import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.EnvironmentDAO;
import com.spring.dto.EnvironmentVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class EnvironmentServiceImpl implements EnvironmentService {

    private EnvironmentDAO environmentDAO;


    @Override
    public EnvironmentVO getEnvironment() throws SQLException {

        return environmentDAO.selectEnvironment();
    }


    @Override
    public List<EnvironmentVO> getEnvironmentList() throws SQLException {

        return environmentDAO.selectEnvironmentList();
    }


    @Override
    @Transactional
    public void registEnvironment(EnvironmentVO environment)
            throws SQLException {
        environmentDAO.disableEnvironment();
        environmentDAO.insertEnvironment(environment);
    }


    @Override
    public void modifyEnvironment(EnvironmentVO environment)
            throws SQLException {

        environmentDAO.updateEnvironment(environment);
    }


    @Override
    @Transactional
    public void activateEnvironment(int environmentId)
            throws SQLException {
        environmentDAO.disableEnvironment();
        environmentDAO.activateEnvironment(environmentId);
    }


    @Override
    public void removeEnvironment(int environmentId)
            throws SQLException {

        environmentDAO.deleteEnvironment(environmentId);
    }
}
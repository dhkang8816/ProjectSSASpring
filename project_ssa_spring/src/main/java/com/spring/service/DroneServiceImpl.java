package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DroneDAO;
import com.spring.dto.DroneVO;
import com.spring.exception.DroneNotFoundException;
import com.spring.exception.InvalidRequestException;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DroneServiceImpl implements DroneService {

    private final DroneDAO droneDAO;

    @Override
    @Transactional
    public void registerDrone(DroneVO dvo) {
        validateDroneId(dvo == null ? null : dvo.getDroneId());
        droneDAO.insertDrone(dvo);
    }

    @Override
    public List<DroneVO> getDroneList(PageMaker pageMaker) {
        int totalCount = droneDAO.selectDroneCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return droneDAO.selectDroneList(pageMaker);
    }

    @Override
    public DroneVO getDroneById(String droneId) {
        return droneDAO.selectDroneById(droneId);
    }

    @Override
    public DroneVO getRequiredDroneById(String droneId) {
        validateDroneId(droneId);
        DroneVO drone = droneDAO.selectDroneById(droneId.trim());
        if (drone == null) {
            throw new DroneNotFoundException(droneId);
        }
        return drone;
    }

    @Override
    @Transactional
    public void modifyDrone(DroneVO dvo) {
        getRequiredDroneById(dvo == null ? null : dvo.getDroneId());
        if (droneDAO.updateDrone(dvo) != 1) {
            throw new DroneNotFoundException(dvo.getDroneId());
        }
    }

    @Override
    @Transactional
    public void removeDrone(String droneId) {
        getRequiredDroneById(droneId);
        if (droneDAO.deleteDrone(droneId.trim()) != 1) {
            throw new DroneNotFoundException(droneId);
        }
    }

    private void validateDroneId(String droneId) {
        if (droneId == null || droneId.trim().isEmpty()) {
            throw new InvalidRequestException("드론 ID는 필수입니다.");
        }
    }
}

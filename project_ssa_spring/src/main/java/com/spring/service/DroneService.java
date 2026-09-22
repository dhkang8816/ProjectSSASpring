package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;

public interface DroneService {
    public void registerDrone(DroneVO dvo);
    public List<DroneVO> getDroneList(PageMaker pageMaker);
    public DroneVO getDroneById(String droneId);
    public DroneVO getRequiredDroneById(String droneId);
    public void modifyDrone(DroneVO dvo);
    public void removeDrone(String droneId);
}

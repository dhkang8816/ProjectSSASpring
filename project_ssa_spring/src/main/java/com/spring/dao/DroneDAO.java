package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;

public interface DroneDAO {
    public int insertDrone(DroneVO dvo);
    public List<DroneVO> selectDroneList(PageMaker pageMaker);
    public int selectDroneCount(PageMaker pageMaker);
    public DroneVO selectDroneById(String droneId);
    public int updateDrone(DroneVO dvo);
    public int deleteDrone(String droneId);
}

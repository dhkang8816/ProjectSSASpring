package com.spring.service;

import java.util.List;
import com.spring.dto.VideoDroneMapVO;

public interface VideoDroneMapService {
    List<VideoDroneMapVO> getAllMappings() throws Exception;
    String getDroneIdBySource(String sourceKey) throws Exception;
    void modifyDroneMapping(String sourceKey, String droneId) throws Exception;
}

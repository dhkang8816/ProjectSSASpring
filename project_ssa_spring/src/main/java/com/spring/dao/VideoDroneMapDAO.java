package com.spring.dao;

import java.util.List;
import com.spring.dto.VideoDroneMapVO;

public interface VideoDroneMapDAO {
    List<VideoDroneMapVO> selectAllMappings() throws Exception;
    String getDroneIdBySource(String sourceKey) throws Exception;
    void updateDroneMapping(VideoDroneMapVO vo) throws Exception;
}

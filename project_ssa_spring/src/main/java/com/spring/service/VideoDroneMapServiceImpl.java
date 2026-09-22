package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.VideoDroneMapDAO;
import com.spring.dto.VideoDroneMapVO;
import com.spring.yolo.AIStreamBridgeService;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class VideoDroneMapServiceImpl implements VideoDroneMapService {

    private final VideoDroneMapDAO videoDroneMapDAO;
    private final AIStreamBridgeService aiStreamBridgeService;

    @Override
    public List<VideoDroneMapVO> getAllMappings() throws Exception {
        return videoDroneMapDAO.selectAllMappings();
    }

    @Override
    public String getDroneIdBySource(String sourceKey) throws Exception {
        return videoDroneMapDAO.getDroneIdBySource(sourceKey);
    }

    @Override
    @Transactional // 정석대로 안전한 트랜잭션 보장
    public void modifyDroneMapping(String sourceKey, String droneId) throws Exception {
        VideoDroneMapVO vo = VideoDroneMapVO.builder()
                .sourceKey(sourceKey)
                .droneId(droneId)
                .build();
        videoDroneMapDAO.updateDroneMapping(vo);
        aiStreamBridgeService.updateInmemoryDroneCache(sourceKey, droneId);
    }
}

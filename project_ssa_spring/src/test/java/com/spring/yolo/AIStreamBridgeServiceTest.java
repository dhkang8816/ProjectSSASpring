package com.spring.yolo;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.dao.VideoDroneMapDAO;
import com.spring.dto.AnimalCounterVO;
import com.spring.service.AlertLogService;
import com.spring.service.AlertMessageTemplateService;
import com.spring.service.AnimalCounterService;
import com.spring.service.DetectionLogService;

class AIStreamBridgeServiceTest {

    @Test
    void shortageCheckRequiresDetectionOfTheMatchingAnimal() throws Exception {
        VideoDroneMapDAO videoDroneMapDAO = mock(VideoDroneMapDAO.class);
        AnimalCounterService animalCounterService = mock(AnimalCounterService.class);
        DetectionLogService detectionLogService = mock(DetectionLogService.class);
        AlertLogService alertLogService = mock(AlertLogService.class);
        AlertMessageTemplateService templateService = mock(AlertMessageTemplateService.class);
        AIStreamBridgeService service = new AIStreamBridgeService(videoDroneMapDAO, templateService);

        ReflectionTestUtils.setField(service, "animalCounterService", animalCounterService);
        ReflectionTestUtils.setField(service, "detectionLogService", detectionLogService);
        ReflectionTestUtils.setField(service, "alertLogService", alertLogService);
        when(animalCounterService.getAnimalCounterList(any())).thenReturn(List.of(
                AnimalCounterVO.builder().counterId(0).currentCount(1).build(),
                AnimalCounterVO.builder().counterId(1).currentCount(1).build()));

        ObjectMapper objectMapper = new ObjectMapper();
        service.processYoloLabels(objectMapper.readTree("{\"boxes\":[]}"), "local", "video_1");

        verifyNoInteractions(detectionLogService);

        service.processYoloLabels(objectMapper.readTree("{\"boxes\":[[0,0,0,0,\"dog\"]]}"), "local", "video_1");

        verify(detectionLogService).registerDetectionLog(any());
    }
}

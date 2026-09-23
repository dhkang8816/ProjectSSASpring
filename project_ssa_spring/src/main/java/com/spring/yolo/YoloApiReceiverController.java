package com.spring.yolo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.sql.Timestamp;
import jakarta.servlet.http.HttpSession; 
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.dto.AlertLogVO;
import com.spring.service.AlertMessageTemplateService;
import lombok.extern.log4j.Log4j2;

@Log4j2
@RestController
@RequestMapping("/yolo/api") 
public class YoloApiReceiverController {

    @Autowired
    private AlertLinkingService alertLinkingService;

    @Autowired
    private AlertMessageTemplateService alertMessageTemplateService;
    
    @Autowired
    private HttpSession session; 

    
    @PostMapping(value = "/report-log", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> receiveNormalDetectionReport(@RequestBody DetectionLogVO vo) {
        synchronized(YoloApiReceiverController.class) {
            try {
                log.info("개체수 미달 신호 유입 확인");
                if (vo.getDroneId() == null || vo.getDroneId().isEmpty()) {
                    vo.setDroneId("DRONE01");
                }
                try {
                    String animalName = "0".equals(vo.getAnimalType()) ? "반려견(dog)" : "고양이(cat)";
                    
                    AlertLogVO avo = AlertLogVO.builder()
                         .alertType("0") // 공통코드 규칙: '0' (동물미달)
                         .alertMsg(alertMessageTemplateService.formatAnimalShortage(animalName))
                         .sendStatus("1") // 공통코드 규칙: '1' (성공)
                         .dlogId(vo.getDlogId() != 0 ? vo.getDlogId() : null) 
                         .firstSendTime(new Timestamp(System.currentTimeMillis()))
                         .build();
                         
                    alertLinkingService.recordDetectionAlert(vo, avo);
                    log.info("'동물미달(0)' 경보 이력이 ALERT_LOG에 안전하게 등록되었습니다.");
                    session.setAttribute("REALTIME_ALERT_FLAG", "TRIGGER");
                    session.setAttribute("REALTIME_ALERT_MSG", avo.getAlertMsg());
             
                } catch (Exception alertEx) {
                    log.error("트랙 A ALERT_LOG 직통 인서트 실패: ", alertEx);
                    throw new IllegalStateException("Detection alert persistence failed.", alertEx);
                }
                return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK);
            } catch (Exception e) {
                log.error("정상 축종 적재 실패: ", e);
                return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }

    
    @PostMapping(value = "/report", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> receiveDangerDetectionReport(@RequestBody DangerLogVO vo) {
        synchronized(YoloApiReceiverController.class) {
            try {
                log.info("위험 객체 신호 유입 성공 ➔ 수신된 코드 번호: {}", vo.getDangerType());
                if (vo.getDroneId() == null || vo.getDroneId().isEmpty()) {
                    vo.setDroneId("DRONE01"); 
                }
                try {
                    String dangerName = "확인불명 이상객체";
                    if (vo.getDangerType() == 2) dangerName = "외계 생물(외계인)";
                    else if (vo.getDangerType() == 3) dangerName = "유해 수중체(상어)"; // 🌟 누락된 상어(3번) 배관 추가 복구
                    else if (vo.getDangerType() == 4) dangerName = "유해 비행체(용)";
                    else if (vo.getDangerType() == 5) dangerName = "맹수(호랑이)";
                    
                    AlertLogVO avo = AlertLogVO.builder()
                         .alertType("1") // 공통코드 규칙: '1' (이상개체)
                         .alertMsg(alertMessageTemplateService.formatDangerObject(dangerName))
                         .sendStatus("1") // 공통코드 규칙: '1' (성공)
                         .danlogId(vo.getDanlogId() != 0 ? vo.getDanlogId() : null) 
                         .firstSendTime(new Timestamp(System.currentTimeMillis()))
                         .build();
                         
                    alertLinkingService.recordDangerAlert(vo, avo);
                    log.info("'이상개체(1)' 경보 이력이 ALERT_LOG에 안전하게 등록되었습니다.");
                    session.setAttribute("REALTIME_ALERT_FLAG", "TRIGGER");
                    session.setAttribute("REALTIME_ALERT_MSG", avo.getAlertMsg());
             
                } catch (Exception alertEx) {
                    log.error("트랙 B ALERT_LOG 직통 인서트 실패: ", alertEx);
                    throw new IllegalStateException("Danger alert persistence failed.", alertEx);
                }
                return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK); 
            } catch (Exception e) {
                log.error("위험 객체 적재 실패: ", e);
                return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }
}

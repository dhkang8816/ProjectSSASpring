package com.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.DetectionLogVO;
import com.spring.service.AnimalCounterService;
import com.spring.service.CommonCodeService;
import com.spring.service.DetectionLogService;

import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
@RequestMapping("/api/v1/ai")
public class AiIntegrationController {

    private final AnimalCounterService animalCounterService;
    private final DetectionLogService detectionLogService;
    private final CommonCodeService commonCodeService; // 공통코드 서비스 주입

    @GetMapping("/targets")
    public ResponseEntity<Map<String, Integer>> getAiTargetCounts() {
        Map<String, Integer> targetMap = new HashMap<>();
        try {
            PageMaker pm = new PageMaker();
            pm.setPage(1);           // 첫 번째 페이지 지정
            pm.setPerPageNum(100);   // 한 번에 100개의 축종 카운터를 가져오도록 세팅 (ROWNUM 잘림 방지)
            
            List<AnimalCounterVO> counterList = animalCounterService.getAnimalCounterList(pm);
            
            if (counterList != null && !counterList.isEmpty()) {
                for (AnimalCounterVO vo : counterList) {
                    targetMap.put(String.valueOf(vo.getCounterId()), vo.getCurrentCount());
                }
            } else {
                targetMap.put("0", 0); // 개 기본값
                targetMap.put("1", 0); // 고양이 기본값
            }
            return new ResponseEntity<>(targetMap, HttpStatus.OK);
        } catch (Exception e) {
            System.err.println("❌ [AI API] PageMaker 연동 중 오라클 수량 조회 실패: " + e.getMessage());
            targetMap.put("0", 0);
            targetMap.put("1", 0);
            return new ResponseEntity<>(targetMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/report-log")
    public ResponseEntity<Map<String, Object>> createDetectionLogFromAi(@RequestBody DetectionLogVO vo) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (vo.getDroneId() == null || vo.getDroneId().isEmpty()) {
                vo.setDroneId("DRONE01"); // 실제 존재하는 드론 ID로 매핑 필요
            }
            
            detectionLogService.registerDetectionLog(vo);
            
            response.put("status", "SUCCESS");
            response.put("message", "오라클 DB에 성공적으로 탐지 로그가 적재되었습니다.");
            return new ResponseEntity<>(response, HttpStatus.CREATED);
            
        } catch (Exception e) {
            System.err.println("❌ [AI API] 오라클 DB 로그 적재 실패: " + e.getMessage());
            response.put("status", "FAIL");
            response.put("error", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping("/code-map")
    public ResponseEntity<Map<String, String>> getAnimalCodeMap() {
        Map<String, String> codeMap = new HashMap<>();
        try {
            PageMaker pm = new PageMaker();
            pm.setSearchGrpCode("ANIMAL_TYPE");
            pm.setSearchUseYn("Y");
            
            List<CommonCodeVO> typeList = commonCodeService.getCommonCodeList(pm);
            
            if (typeList != null && !typeList.isEmpty()) {
                for (CommonCodeVO vo : typeList) {
                    codeMap.put(vo.getCode(), vo.getCodeName()); 
                }
            } else {
                codeMap.put("0", "개");
                codeMap.put("1", "고양이");
            }
            return new ResponseEntity<>(codeMap, HttpStatus.OK);
        } catch (Exception e) {
            System.err.println("❌ [AI API] 오라클 공통코드 매핑 실패: " + e.getMessage());
            codeMap.put("0", "개");
            codeMap.put("1", "고양이");
            return new ResponseEntity<>(codeMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}

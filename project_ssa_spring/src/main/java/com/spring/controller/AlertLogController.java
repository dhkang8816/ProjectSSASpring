package com.spring.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;
import com.spring.dto.CommonCodeVO; // 기존 프로젝트의 공통코드 VO 경로로 맞추세요
import com.spring.service.AlertLogService;
import com.spring.service.CommonCodeService; // 기존 프로젝트의 공통코드 서비스 구조 매핑

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/alert")
@RequiredArgsConstructor
public class AlertLogController {

    private final AlertLogService alertLogService;
    private final CommonCodeService commonCodeService;

    @GetMapping("/list")
    public String list(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        log.info("컨트롤러 진입: list -> 파라미터 상태: {}", pageMaker);
        
        try {
            List<AlertLogVO> alertList = alertLogService.getAlertLogList(pageMaker);
            
            PageMaker searchCodeCmd = new PageMaker();
            searchCodeCmd.setSearchGrpCode("ALERT_TYPE");
            List<CommonCodeVO> commonCodeList = commonCodeService.getCommonCodeList(searchCodeCmd);
            
            Map<String, String> codeMap = commonCodeList.stream()
                .collect(Collectors.toMap(
                    CommonCodeVO::getCode, 
                    CommonCodeVO::getCodeName,
                    (existing, replacement) -> existing // 중복 키 방어
                ));
            
            for (AlertLogVO vo : alertList) {
                String korName = codeMap.get(vo.getAlertType());
                if (korName != null) {
                    vo.setAlertType(korName); 
                }
            }
            
            model.addAttribute("alertList", alertList);
            
        } catch (Exception e) {
            log.error("경보 목록 조회 및 코드 변환 중 에러 발생: ", e);
            model.addAttribute("errorMessage", "데이터를 불러오는 중 오류가 발생했습니다.");
        }
        
        return "alert/alertList";
    }

    @GetMapping("/register")
    public String registerForm(Model model) {
        log.info("컨트롤러 진입: registerForm -> ALERT_TYPE 공통 코드 로딩");
        
        try {
            PageMaker searchCodeCmd = new PageMaker();
            searchCodeCmd.setSearchGrpCode("ALERT_TYPE"); // 💡 ALERT_TYPE 그룹 코드를 지정
            
            List<CommonCodeVO> alertTypeCodeList = commonCodeService.getCommonCodeList(searchCodeCmd);
            
            model.addAttribute("alertTypeCodeList", alertTypeCodeList);
            
        } catch (Exception e) {
            log.error("ALERT_TYPE 공통 코드 조회 중 예외 발생: ", e);
            model.addAttribute("errorMessage", "경보 구분 코드를 불러오지 못했습니다.");
        }
        
        return "alert/alertRegister";
    }

    @PostMapping("/register")
    public String register(AlertLogVO vo, RedirectAttributes rttr) {
        try {
            alertLogService.registerAlertLog(vo);
            rttr.addFlashAttribute("result", "success");
        } catch (Exception e) {
            log.error("경보 등록 실패: ", e);
            rttr.addFlashAttribute("result", "fail");
        }
        return "redirect:/alert/list";
    }
    
    @GetMapping("/alertDetail")
    public String detail(@RequestParam("alertId") int alertId, Model model) {
        log.info("컨트롤러 진입: detail -> 요청 경보 ID: {}", alertId);
        try {
            AlertLogVO alert = alertLogService.getAlertLogDetail(alertId);
            
            PageMaker searchCodeCmd = new PageMaker();
            searchCodeCmd.setSearchGrpCode("ALERT_TYPE");
            List<CommonCodeVO> commonCodeList = commonCodeService.getCommonCodeList(searchCodeCmd);
            
            Map<String, String> codeMap = commonCodeList.stream()
                .collect(Collectors.toMap(
                    CommonCodeVO::getCode, 
                    CommonCodeVO::getCodeName,
                    (existing, replacement) -> existing
                ));
                
            String korName = codeMap.get(alert.getAlertType());
            if (korName != null) {
                alert.setAlertType(korName); // 한글 이름으로 덮어쓰기
            }

            model.addAttribute("alert", alert);
        } catch (Exception e) {
            log.error("경보 상세 조회 중 에러 발생: ", e);
            model.addAttribute("errorMessage", "존재하지 않거나 불러올 수 없는 경보 이력입니다.");
        }
        return "alert/alertDetail";
    }


}

package com.spring.controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.dto.AlertMessageTemplateVO;
import com.spring.service.AlertPolicyService;
import com.spring.service.AlertMessageTemplateService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/admin/alert-templates")
@RequiredArgsConstructor
public class AlertMessageTemplateController {

    private final AlertMessageTemplateService alertMessageTemplateService;
    private final AlertPolicyService alertPolicyService;

    @GetMapping
    public String settings(Model model) {
        Map<String, AlertMessageTemplateVO> templatesByKey = new LinkedHashMap<>();
        for (AlertMessageTemplateVO template : alertMessageTemplateService.getTemplates()) {
            templatesByKey.put(template.getTemplateKey(), template);
        }
        model.addAttribute("templatesByKey", templatesByKey);
        model.addAttribute("animalShortagePolicy", alertPolicyService.getAnimalShortagePolicy());
        return "admin/alertTemplateSettings";
    }

    @PostMapping
    public String save(@RequestParam("animalShortageTemplate") String animalShortageTemplate,
            @RequestParam("dangerObjectTemplate") String dangerObjectTemplate,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup,
            RedirectAttributes redirectAttributes) {
        try {
            alertMessageTemplateService.saveTemplates(animalShortageTemplate, dangerObjectTemplate,
                    currentMemberId());
            redirectAttributes.addFlashAttribute("templateSuccess", "경보 문구 설정을 저장했습니다. 이후 생성되는 경보부터 적용됩니다.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("templateError", ex.getMessage());
        } catch (DataAccessException ex) {
            log.error("Alert message template persistence failed.", ex);
            redirectAttributes.addFlashAttribute("templateError", "문구 설정 저장에 실패했습니다. 데이터베이스 설정을 확인해 주세요.");
        }
        return popup ? "redirect:/admin/alert-templates?popup=true"
                : "redirect:/admin/alert-templates";
    }

    private String currentMemberId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication == null ? "SYSTEM" : authentication.getName();
    }
}

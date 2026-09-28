package com.spring.controller;

import org.springframework.dao.DataAccessException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.service.AlertPolicyService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/admin/alert-policy")
@RequiredArgsConstructor
public class AlertPolicyController {

    private final AlertPolicyService alertPolicyService;

    @PostMapping
    public String save(@RequestParam("underTargetSeconds") String underTargetSeconds,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup,
            RedirectAttributes redirectAttributes) {
        try {
            alertPolicyService.saveAnimalShortagePolicy(underTargetSeconds, currentMemberId());
            redirectAttributes.addFlashAttribute("policySuccess",
                    "미달 경보 지속 시간이 저장되었습니다. 다음 탐지 판정부터 적용됩니다.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("policyError", ex.getMessage());
        } catch (DataAccessException ex) {
            log.error("Alert policy persistence failed.", ex);
            redirectAttributes.addFlashAttribute("policyError",
                    "경보 시간 설정 저장에 실패했습니다. 데이터베이스 설정을 확인해 주세요.");
        } catch (RuntimeException ex) {
            log.error("Unexpected alert policy persistence failure.", ex);
            redirectAttributes.addFlashAttribute("policyError",
                    "경보 시간 설정 저장에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        }
        return popup ? "redirect:/admin/alert-templates?popup=true"
                : "redirect:/admin/alert-templates";
    }

    private String currentMemberId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication == null ? "SYSTEM" : authentication.getName();
    }
}

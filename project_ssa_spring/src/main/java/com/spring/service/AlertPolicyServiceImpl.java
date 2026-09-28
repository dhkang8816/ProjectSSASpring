package com.spring.service;

import java.math.BigDecimal;

import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.AlertPolicyDAO;
import com.spring.dto.AlertPolicyVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@RequiredArgsConstructor
public class AlertPolicyServiceImpl implements AlertPolicyService {

    private final AlertPolicyDAO alertPolicyDAO;

    /*
     * The in-memory copy lets the AI policy endpoint keep returning the last
     * valid setting during a temporary database problem. The default is also
     * what Flask uses before the migration has been applied.
     */
    private volatile AlertPolicyVO cachedPolicy = defaultPolicy();
    private volatile boolean availabilityWarningLogged;

    @Override
    public AlertPolicyVO getAnimalShortagePolicy() {
        try {
            AlertPolicyVO policy = alertPolicyDAO.selectAnimalShortagePolicy();
            if (policy != null && isValidDuration(policy.getUnderTargetSeconds())) {
                cachedPolicy = copyOf(policy);
            }
            availabilityWarningLogged = false;
        } catch (RuntimeException ex) {
            if (!availabilityWarningLogged) {
                availabilityWarningLogged = true;
                log.warn("Alert policy table is unavailable; using the last known policy.");
            }
        }
        return copyOf(cachedPolicy);
    }

    @Override
    @Transactional
    public void saveAnimalShortagePolicy(String rawSeconds, String updatedBy) {
        double seconds = parseAndValidateDuration(rawSeconds);
        AlertPolicyVO policy = AlertPolicyVO.builder()
                .policyKey(ANIMAL_SHORTAGE)
                .underTargetSeconds(seconds)
                .updatedBy(normalizeUpdatedBy(updatedBy))
                .build();

        alertPolicyDAO.mergeAnimalShortagePolicy(policy);
        cachedPolicy = copyOf(policy);
    }

    private static double parseAndValidateDuration(String rawSeconds) {
        if (rawSeconds == null || rawSeconds.trim().isEmpty()) {
            throw new IllegalArgumentException("미달 경보 지속 시간을 입력해 주세요.");
        }

        final double seconds;
        try {
            seconds = new BigDecimal(rawSeconds.trim()).doubleValue();
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("미달 경보 지속 시간은 숫자로 입력해 주세요.");
        }

        if (!isValidDuration(seconds)) {
            throw new IllegalArgumentException("미달 경보 지속 시간은 1초 이상 3600초 이하로 설정해 주세요.");
        }
        return seconds;
    }

    private static boolean isValidDuration(double seconds) {
        return Double.isFinite(seconds)
                && seconds >= MIN_UNDER_TARGET_SECONDS
                && seconds <= MAX_UNDER_TARGET_SECONDS;
    }

    private static AlertPolicyVO defaultPolicy() {
        return AlertPolicyVO.builder()
                .policyKey(ANIMAL_SHORTAGE)
                .underTargetSeconds(DEFAULT_UNDER_TARGET_SECONDS)
                .updatedBy("SYSTEM")
                .build();
    }

    private static AlertPolicyVO copyOf(AlertPolicyVO source) {
        return AlertPolicyVO.builder()
                .policyKey(source.getPolicyKey())
                .underTargetSeconds(source.getUnderTargetSeconds())
                .updatedBy(source.getUpdatedBy())
                .updatedAt(source.getUpdatedAt())
                .build();
    }

    private static String normalizeUpdatedBy(String updatedBy) {
        return updatedBy == null || updatedBy.trim().isEmpty() ? "SYSTEM" : updatedBy.trim();
    }
}

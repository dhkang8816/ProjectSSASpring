package com.spring.service;

import com.spring.dto.AlertPolicyVO;

public interface AlertPolicyService {

    String ANIMAL_SHORTAGE = "ANIMAL_SHORTAGE";
    double DEFAULT_UNDER_TARGET_SECONDS = 10.0D;
    double MIN_UNDER_TARGET_SECONDS = 1.0D;
    double MAX_UNDER_TARGET_SECONDS = 3600.0D;

    AlertPolicyVO getAnimalShortagePolicy();

    void saveAnimalShortagePolicy(String rawSeconds, String updatedBy);
}

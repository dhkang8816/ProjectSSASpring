package com.spring.dao;

import com.spring.dto.AlertPolicyVO;

public interface AlertPolicyDAO {

    AlertPolicyVO selectAnimalShortagePolicy();

    int mergeAnimalShortagePolicy(AlertPolicyVO policy);
}

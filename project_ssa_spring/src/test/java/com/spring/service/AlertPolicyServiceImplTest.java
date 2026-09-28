package com.spring.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;

import com.spring.dao.AlertPolicyDAO;
import com.spring.dto.AlertPolicyVO;

class AlertPolicyServiceImplTest {

    @Test
    void returnsDefaultPolicyWhenMigrationTableIsNotAvailableYet() {
        AlertPolicyDAO dao = mock(AlertPolicyDAO.class);
        when(dao.selectAnimalShortagePolicy()).thenThrow(new RuntimeException("table missing"));
        AlertPolicyServiceImpl service = new AlertPolicyServiceImpl(dao);

        AlertPolicyVO policy = service.getAnimalShortagePolicy();

        assertEquals(AlertPolicyService.ANIMAL_SHORTAGE, policy.getPolicyKey());
        assertEquals(10.0D, policy.getUnderTargetSeconds());
    }

    @Test
    void savesAValidatedAnimalShortageDuration() {
        AlertPolicyDAO dao = mock(AlertPolicyDAO.class);
        AlertPolicyServiceImpl service = new AlertPolicyServiceImpl(dao);

        service.saveAnimalShortagePolicy("15", "admin");

        verify(dao).mergeAnimalShortagePolicy(argThat(policy ->
                AlertPolicyService.ANIMAL_SHORTAGE.equals(policy.getPolicyKey())
                        && policy.getUnderTargetSeconds() == 15.0D
                        && "admin".equals(policy.getUpdatedBy())));
    }

    @Test
    void rejectsDurationOutsideTheSafeRange() {
        AlertPolicyDAO dao = mock(AlertPolicyDAO.class);
        AlertPolicyServiceImpl service = new AlertPolicyServiceImpl(dao);

        assertThrows(IllegalArgumentException.class,
                () -> service.saveAnimalShortagePolicy("0", "admin"));
        assertThrows(IllegalArgumentException.class,
                () -> service.saveAnimalShortagePolicy("3601", "admin"));
    }
}

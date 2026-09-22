package com.spring.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;

import com.spring.dao.DetectionLogDAO;
import com.spring.dto.DetectionLogVO;
import com.spring.exception.DetectionNotFoundException;
import com.spring.exception.InvalidRequestException;

class DetectionLogServiceImplTest {

    @Test
    void getRequiredDetectionLogByIdReturnsExistingLog() {
        DetectionLogDAO dao = mock(DetectionLogDAO.class);
        DetectionLogVO expected = DetectionLogVO.builder().dlogId(11).build();
        when(dao.selectDetectionLogById(11)).thenReturn(expected);

        DetectionLogVO actual = new DetectionLogServiceImpl(dao).getRequiredDetectionLogById(11);

        assertEquals(expected, actual);
    }

    @Test
    void getRequiredDetectionLogByIdThrowsNotFoundForMissingLog() {
        DetectionLogDAO dao = mock(DetectionLogDAO.class);
        when(dao.selectDetectionLogById(11)).thenReturn(null);

        assertThrows(DetectionNotFoundException.class,
                () -> new DetectionLogServiceImpl(dao).getRequiredDetectionLogById(11));
    }

    @Test
    void getRequiredDetectionLogByIdRejectsNonPositiveId() {
        DetectionLogDAO dao = mock(DetectionLogDAO.class);

        assertThrows(InvalidRequestException.class,
                () -> new DetectionLogServiceImpl(dao).getRequiredDetectionLogById(0));
    }
}

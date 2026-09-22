package com.spring.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;

import com.spring.dao.DroneDAO;
import com.spring.dto.DroneVO;
import com.spring.exception.DroneNotFoundException;
import com.spring.exception.InvalidRequestException;

class DroneServiceImplTest {

    @Test
    void getRequiredDroneByIdReturnsExistingDrone() {
        DroneDAO dao = mock(DroneDAO.class);
        DroneVO expected = DroneVO.builder().droneId("DRONE01").build();
        when(dao.selectDroneById("DRONE01")).thenReturn(expected);

        DroneVO actual = new DroneServiceImpl(dao).getRequiredDroneById("DRONE01");

        assertEquals(expected, actual);
        verify(dao).selectDroneById("DRONE01");
    }

    @Test
    void getRequiredDroneByIdThrowsNotFoundForMissingDrone() {
        DroneDAO dao = mock(DroneDAO.class);
        when(dao.selectDroneById("UNKNOWN")).thenReturn(null);

        assertThrows(DroneNotFoundException.class,
                () -> new DroneServiceImpl(dao).getRequiredDroneById("UNKNOWN"));
    }

    @Test
    void getRequiredDroneByIdRejectsBlankIdBeforeDaoCall() {
        DroneDAO dao = mock(DroneDAO.class);

        assertThrows(InvalidRequestException.class,
                () -> new DroneServiceImpl(dao).getRequiredDroneById("  "));
    }
}

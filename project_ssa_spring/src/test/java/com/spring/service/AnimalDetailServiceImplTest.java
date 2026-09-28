package com.spring.service;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.Test;

import com.spring.cmd.PageMaker;
import com.spring.dao.AnimalCounterDAO;
import com.spring.dao.AnimalDetailDAO;
import com.spring.dto.AnimalDetailVO;

class AnimalDetailServiceImplTest {

    @Test
    void registeringAdoptedAnimalDoesNotIncreaseProtectedCounter() {
        AnimalDetailDAO animalDetailDAO = mock(AnimalDetailDAO.class);
        AnimalCounterDAO animalCounterDAO = mock(AnimalCounterDAO.class);
        AnimalDetailServiceImpl service = new AnimalDetailServiceImpl(animalDetailDAO, animalCounterDAO);
        AnimalDetailVO adoptedAnimal = AnimalDetailVO.builder()
                .animalType("0")
                .animalStatus("1")
                .build();

        service.registerAnimal(adoptedAnimal);

        verify(animalDetailDAO).insertAnimal(adoptedAnimal);
        verifyNoInteractions(animalCounterDAO);
    }

    @Test
    void changingProtectedAnimalToDepartedDecreasesItsCounter() {
        AnimalDetailDAO animalDetailDAO = mock(AnimalDetailDAO.class);
        AnimalCounterDAO animalCounterDAO = mock(AnimalCounterDAO.class);
        AnimalDetailServiceImpl service = new AnimalDetailServiceImpl(animalDetailDAO, animalCounterDAO);
        AnimalDetailVO previous = AnimalDetailVO.builder()
                .animalId(7)
                .animalType("0")
                .animalStatus("0")
                .build();
        AnimalDetailVO departed = AnimalDetailVO.builder()
                .animalId(7)
                .animalType("0")
                .animalStatus("2")
                .build();
        when(animalDetailDAO.selectAnimalById(7)).thenReturn(previous);
        when(animalDetailDAO.updateAnimal(departed)).thenReturn(1);

        service.modifyAnimal(departed);

        verify(animalCounterDAO).updateAnimalCount(0, -1);
    }

    @Test
    void changingAdoptedAnimalToProtectedIncreasesCounter() {
        AnimalDetailDAO animalDetailDAO = mock(AnimalDetailDAO.class);
        AnimalCounterDAO animalCounterDAO = mock(AnimalCounterDAO.class);
        AnimalDetailServiceImpl service = new AnimalDetailServiceImpl(animalDetailDAO, animalCounterDAO);
        AnimalDetailVO previous = AnimalDetailVO.builder()
                .animalId(8)
                .animalType("1")
                .animalStatus("1")
                .build();
        AnimalDetailVO protectedAnimal = AnimalDetailVO.builder()
                .animalId(8)
                .animalType("1")
                .animalStatus("0")
                .build();
        when(animalDetailDAO.selectAnimalById(8)).thenReturn(previous);
        when(animalDetailDAO.updateAnimal(protectedAnimal)).thenReturn(1);
        when(animalCounterDAO.selectAnimalCounterCount(any(PageMaker.class))).thenReturn(1);

        service.modifyAnimal(protectedAnimal);

        verify(animalCounterDAO).updateAnimalCount(1, 1);
    }

    @Test
    void removingAdoptedAnimalDoesNotDecreaseProtectedCounter() {
        AnimalDetailDAO animalDetailDAO = mock(AnimalDetailDAO.class);
        AnimalCounterDAO animalCounterDAO = mock(AnimalCounterDAO.class);
        AnimalDetailServiceImpl service = new AnimalDetailServiceImpl(animalDetailDAO, animalCounterDAO);
        AnimalDetailVO adoptedAnimal = AnimalDetailVO.builder()
                .animalId(9)
                .animalType("0")
                .animalStatus("1")
                .build();
        when(animalDetailDAO.selectAnimalById(9)).thenReturn(adoptedAnimal);
        when(animalDetailDAO.deleteAnimal(9)).thenReturn(1);

        service.removeAnimal(9);

        verify(animalDetailDAO).deleteAnimal(9);
        verify(animalCounterDAO, never()).updateAnimalCount(0, -1);
    }
}

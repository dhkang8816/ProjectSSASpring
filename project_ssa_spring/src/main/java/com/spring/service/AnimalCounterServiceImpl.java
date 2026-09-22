package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.AnimalCounterDAO;
import com.spring.dto.AnimalCounterVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class AnimalCounterServiceImpl implements AnimalCounterService {

    private final AnimalCounterDAO animalCounterDAO;

    @Override
    public List<AnimalCounterVO> getAnimalCounterList(PageMaker pageMaker) {
        int totalCount = animalCounterDAO.selectAnimalCounterCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return animalCounterDAO.selectAnimalCounterList(pageMaker);
    }

    @Override
    @Transactional
    public void modifyAnimalCount(int counterId, int countDiff) {
        animalCounterDAO.updateAnimalCount(counterId, countDiff);
    }

    @Override
    @Transactional
    public void registerNewCounter(AnimalCounterVO acv) {
        animalCounterDAO.insertNewCounter(acv);
    }
}

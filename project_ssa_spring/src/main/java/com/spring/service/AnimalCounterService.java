package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;

public interface AnimalCounterService {
    public List<AnimalCounterVO> getAnimalCounterList(PageMaker pageMaker);
    public void modifyAnimalCount(int counterId, int countDiff);
    public void registerNewCounter(AnimalCounterVO acv);
}

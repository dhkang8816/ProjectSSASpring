package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalDetailVO;

public interface AnimalDetailService {
    public void registerAnimal(AnimalDetailVO adv);
    public List<AnimalDetailVO> getAnimalList(PageMaker pageMaker);
    public AnimalDetailVO getAnimalById(int animalId);
    public void modifyAnimal(AnimalDetailVO adv);
    public void removeAnimal(int animalId);
}

package com.spring.dao;

import java.util.List;
import java.util.Map;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalDetailVO;

public interface AnimalDetailDAO {
    public int insertAnimal(AnimalDetailVO vo);
    public List<AnimalDetailVO> selectAnimalList(PageMaker pageMaker);
    public int selectAnimalCount(PageMaker pageMaker);
    public AnimalDetailVO selectAnimalById(int animalId);
    public int updateAnimal(AnimalDetailVO adv);
    public int deleteAnimal(int animalId);
    public Map<String, Object> selectAnimalStatusStats();
}

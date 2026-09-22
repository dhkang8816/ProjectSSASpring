package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;

public interface AnimalCounterDAO {
    public List<AnimalCounterVO> selectAnimalCounterList(PageMaker pageMaker);
    public int selectAnimalCounterCount(PageMaker pageMaker);
    public int updateAnimalCount(int counterId, int countDiff);
    public int insertNewCounter(AnimalCounterVO acv);
}

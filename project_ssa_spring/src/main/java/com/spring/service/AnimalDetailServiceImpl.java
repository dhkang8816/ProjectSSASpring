package com.spring.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.spring.cmd.PageMaker;
import com.spring.dao.AnimalCounterDAO;
import com.spring.dao.AnimalDetailDAO;
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.AnimalDetailVO;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class AnimalDetailServiceImpl implements AnimalDetailService {

    private final AnimalDetailDAO animalDetailDAO;
    private final AnimalCounterDAO animalCounterDAO; 

    @Override
    @Transactional
    public void registerAnimal(AnimalDetailVO adv) {
        animalDetailDAO.insertAnimal(adv);
        int counterId = Integer.parseInt(adv.getAnimalType());
        PageMaker pm = new PageMaker();
        pm.setSearchType("c");
        pm.setKeyword(String.valueOf(counterId));
        int existCount = animalCounterDAO.selectAnimalCounterCount(pm);
        
        if (existCount > 0) {
            animalCounterDAO.updateAnimalCount(counterId, 1);
        } else {
            AnimalCounterVO acv = AnimalCounterVO.builder()
                    .counterId(counterId)
                    .currentCount(1) // 처음이니까 1마리로 시작
                    .build();
            animalCounterDAO.insertNewCounter(acv);
        }
    }

    @Override
    public List<AnimalDetailVO> getAnimalList(PageMaker pageMaker) {
        int totalCount = animalDetailDAO.selectAnimalCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return animalDetailDAO.selectAnimalList(pageMaker);
    }

    @Override
    public AnimalDetailVO getAnimalById(int animalId) {
        return animalDetailDAO.selectAnimalById(animalId);
    }

    @Override
    @Transactional
    public void modifyAnimal(AnimalDetailVO adv) {
        animalDetailDAO.updateAnimal(adv);
    }

    @Override
    @Transactional
    public void removeAnimal(int animalId) {
        AnimalDetailVO adv = animalDetailDAO.selectAnimalById(animalId);
        if (adv != null) {
            animalDetailDAO.deleteAnimal(animalId);
            int counterId = Integer.parseInt(adv.getAnimalType());
            animalCounterDAO.updateAnimalCount(counterId, -1);
        }
    }
}

package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
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

    private static final String PROTECTED_STATUS = "0";

    private final AnimalDetailDAO animalDetailDAO;
    private final AnimalCounterDAO animalCounterDAO; 

    @Override
    @Transactional
    public void registerAnimal(AnimalDetailVO adv) {
        animalDetailDAO.insertAnimal(adv);
        if (!isProtected(adv)) {
            return;
        }
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
        AnimalDetailVO previousAnimal = animalDetailDAO.selectAnimalById(adv.getAnimalId());
        if (previousAnimal == null || animalDetailDAO.updateAnimal(adv) == 0) {
            return;
        }

        boolean wasProtected = isProtected(previousAnimal);
        boolean isNowProtected = isProtected(adv);
        if (wasProtected && isNowProtected
                && !Objects.equals(previousAnimal.getAnimalType(), adv.getAnimalType())) {
            animalCounterDAO.updateAnimalCount(Integer.parseInt(previousAnimal.getAnimalType()), -1);
            increaseProtectedAnimalCounter(adv.getAnimalType());
        } else if (wasProtected && !isNowProtected) {
            animalCounterDAO.updateAnimalCount(Integer.parseInt(previousAnimal.getAnimalType()), -1);
        } else if (!wasProtected && isNowProtected) {
            increaseProtectedAnimalCounter(adv.getAnimalType());
        }
    }

    @Override
    @Transactional
    public void removeAnimal(int animalId) {
        AnimalDetailVO adv = animalDetailDAO.selectAnimalById(animalId);
        if (adv != null) {
            if (animalDetailDAO.deleteAnimal(animalId) > 0 && isProtected(adv)) {
                int counterId = Integer.parseInt(adv.getAnimalType());
                animalCounterDAO.updateAnimalCount(counterId, -1);
            }
        }
    }

    @Override
    public Map<String, Object> getAnimalStatusStats() {
        return animalDetailDAO.selectAnimalStatusStats();
    }

    private boolean isProtected(AnimalDetailVO animal) {
        return animal != null && PROTECTED_STATUS.equals(animal.getAnimalStatus());
    }

    private void increaseProtectedAnimalCounter(String animalType) {
        int counterId = Integer.parseInt(animalType);
        PageMaker pm = new PageMaker();
        pm.setSearchType("c");
        pm.setKeyword(String.valueOf(counterId));

        if (animalCounterDAO.selectAnimalCounterCount(pm) > 0) {
            animalCounterDAO.updateAnimalCount(counterId, 1);
        } else {
            AnimalCounterVO counter = AnimalCounterVO.builder()
                    .counterId(counterId)
                    .currentCount(1)
                    .build();
            animalCounterDAO.insertNewCounter(counter);
        }
    }
}

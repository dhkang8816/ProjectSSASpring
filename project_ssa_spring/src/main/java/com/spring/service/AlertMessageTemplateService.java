package com.spring.service;

import java.util.List;

import com.spring.dto.AlertMessageTemplateVO;

public interface AlertMessageTemplateService {

    String ANIMAL_SHORTAGE = "ANIMAL_SHORTAGE";
    String DANGER_OBJECT = "DANGER_OBJECT";

    List<AlertMessageTemplateVO> getTemplates();

    void saveTemplates(String animalShortageTemplate, String dangerObjectTemplate, String updatedBy);

    String formatAnimalShortage(String animalName);

    String formatDangerObject(String dangerName);

    void reloadFromDatabase();
}

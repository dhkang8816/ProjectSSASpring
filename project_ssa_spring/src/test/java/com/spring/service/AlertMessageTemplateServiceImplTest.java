package com.spring.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.Test;

import com.spring.dao.AlertMessageTemplateDAO;
import com.spring.dto.AlertMessageTemplateVO;

class AlertMessageTemplateServiceImplTest {

    @Test
    void formatsConfiguredTemplateWithRuntimeAnimalName() {
        AlertMessageTemplateDAO dao = mock(AlertMessageTemplateDAO.class);
        when(dao.selectAlertMessageTemplates()).thenReturn(List.of(
                AlertMessageTemplateVO.builder()
                        .templateKey(AlertMessageTemplateService.ANIMAL_SHORTAGE)
                        .templateText("[경보] {animalName} 수량을 확인하세요.")
                        .build()));
        AlertMessageTemplateServiceImpl service = new AlertMessageTemplateServiceImpl(dao);

        service.reloadFromDatabase();

        assertEquals("[경보] 고양이(cat) 수량을 확인하세요.", service.formatAnimalShortage("고양이(cat)"));
    }

    @Test
    void rejectsTemplateThatRemovesRequiredPlaceholder() {
        AlertMessageTemplateDAO dao = mock(AlertMessageTemplateDAO.class);
        AlertMessageTemplateServiceImpl service = new AlertMessageTemplateServiceImpl(dao);

        assertThrows(IllegalArgumentException.class,
                () -> service.saveTemplates("동물 수량을 확인하세요.", "위험 객체 {dangerName} 확인", "admin"));
    }

    @Test
    void savesBothTemplatesAndUsesSavedDangerTemplateImmediately() {
        AlertMessageTemplateDAO dao = mock(AlertMessageTemplateDAO.class);
        AlertMessageTemplateServiceImpl service = new AlertMessageTemplateServiceImpl(dao);

        service.saveTemplates("{animalName} 부족", "[긴급] {dangerName} 발견", "admin");

        verify(dao, times(2)).mergeAlertMessageTemplate(argThat(template ->
                "admin".equals(template.getUpdatedBy()) && template.getTemplateText() != null));
        assertEquals("[긴급] 유해 비행체(용) 발견", service.formatDangerObject("유해 비행체(용)"));
    }
}

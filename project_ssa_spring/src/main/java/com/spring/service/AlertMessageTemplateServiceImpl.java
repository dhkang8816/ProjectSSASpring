package com.spring.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.dao.DataAccessException;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.AlertMessageTemplateDAO;
import com.spring.dto.AlertMessageTemplateVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@RequiredArgsConstructor
public class AlertMessageTemplateServiceImpl implements AlertMessageTemplateService {

    private static final int MAX_TEMPLATE_LENGTH = 1000;

    private static final Map<String, TemplateDefinition> DEFINITIONS = createDefinitions();

    private final AlertMessageTemplateDAO alertMessageTemplateDAO;
    private final Map<String, AlertMessageTemplateVO> templates = new ConcurrentHashMap<>();

    @Override
    public synchronized void reloadFromDatabase() {
        templates.clear();
        addDefaults();

        try {
            for (AlertMessageTemplateVO template : alertMessageTemplateDAO.selectAlertMessageTemplates()) {
                if (isKnownTemplate(template.getTemplateKey()) && isValidTemplateText(template.getTemplateText())) {
                    templates.put(template.getTemplateKey(), template);
                }
            }
        } catch (DataAccessException ex) {
            // The application remains operational with safe defaults until the migration is applied.
            log.warn("Alert message template table is unavailable; default templates are being used.");
        }
    }

    @Override
    public List<AlertMessageTemplateVO> getTemplates() {
        List<AlertMessageTemplateVO> result = new ArrayList<>();
        for (TemplateDefinition definition : DEFINITIONS.values()) {
            result.add(copyOf(templates.getOrDefault(definition.key(), defaultTemplate(definition))));
        }
        return result;
    }

    @Override
    @Transactional
    public synchronized void saveTemplates(String animalShortageTemplate, String dangerObjectTemplate, String updatedBy) {
        Map<String, String> requestedTemplates = new LinkedHashMap<>();
        requestedTemplates.put(ANIMAL_SHORTAGE, animalShortageTemplate);
        requestedTemplates.put(DANGER_OBJECT, dangerObjectTemplate);

        for (Map.Entry<String, String> entry : requestedTemplates.entrySet()) {
            validateTemplate(entry.getKey(), entry.getValue());
        }

        for (TemplateDefinition definition : DEFINITIONS.values()) {
            AlertMessageTemplateVO template = AlertMessageTemplateVO.builder()
                    .templateKey(definition.key())
                    .templateName(definition.name())
                    .templateText(requestedTemplates.get(definition.key()).trim())
                    .updatedBy(normalizeUpdatedBy(updatedBy))
                    .build();
            alertMessageTemplateDAO.mergeAlertMessageTemplate(template);
            templates.put(template.getTemplateKey(), template);
        }
    }

    @Override
    public String formatAnimalShortage(String animalName) {
        return resolve(ANIMAL_SHORTAGE).replace("{animalName}", displayValue(animalName, "동물"));
    }

    @Override
    public String formatDangerObject(String dangerName) {
        return resolve(DANGER_OBJECT).replace("{dangerName}", displayValue(dangerName, "이상객체"));
    }

    private String resolve(String templateKey) {
        TemplateDefinition definition = DEFINITIONS.get(templateKey);
        AlertMessageTemplateVO template = templates.get(templateKey);
        return template == null ? definition.defaultText() : template.getTemplateText();
    }

    private void addDefaults() {
        for (TemplateDefinition definition : DEFINITIONS.values()) {
            templates.put(definition.key(), defaultTemplate(definition));
        }
    }

    private static AlertMessageTemplateVO defaultTemplate(TemplateDefinition definition) {
        return AlertMessageTemplateVO.builder()
                .templateKey(definition.key())
                .templateName(definition.name())
                .templateText(definition.defaultText())
                .build();
    }

    private static AlertMessageTemplateVO copyOf(AlertMessageTemplateVO source) {
        return AlertMessageTemplateVO.builder()
                .templateKey(source.getTemplateKey())
                .templateName(source.getTemplateName())
                .templateText(source.getTemplateText())
                .updatedBy(source.getUpdatedBy())
                .updatedAt(source.getUpdatedAt())
                .build();
    }

    private static Map<String, TemplateDefinition> createDefinitions() {
        Map<String, TemplateDefinition> definitions = new LinkedHashMap<>();
        definitions.put(ANIMAL_SHORTAGE, new TemplateDefinition(
                ANIMAL_SHORTAGE,
                "개체 미달 경보",
                "{animalName}",
                "관제 구역 내 {animalName} 보유 마리수 기준치 미달 현상 지속 감지!"));
        definitions.put(DANGER_OBJECT, new TemplateDefinition(
                DANGER_OBJECT,
                "위험 이상객체 경보",
                "{dangerName}",
                "관제 구역 내 위험 이상객체 [{dangerName}] 실시간 출현! 즉시 대피 요망."));
        return definitions;
    }

    private static boolean isKnownTemplate(String templateKey) {
        return DEFINITIONS.containsKey(templateKey);
    }

    private static boolean isValidTemplateText(String text) {
        return text != null && !text.trim().isEmpty() && text.trim().length() <= MAX_TEMPLATE_LENGTH;
    }

    private static void validateTemplate(String templateKey, String text) {
        TemplateDefinition definition = DEFINITIONS.get(templateKey);
        if (!isValidTemplateText(text)) {
            throw new IllegalArgumentException(definition.name() + " 문구는 1자 이상 " + MAX_TEMPLATE_LENGTH + "자 이하여야 합니다.");
        }
        if (!text.contains(definition.requiredPlaceholder())) {
            throw new IllegalArgumentException(definition.name() + "에는 " + definition.requiredPlaceholder() + " 변수가 반드시 포함되어야 합니다.");
        }
    }

    private static String displayValue(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }

    private static String normalizeUpdatedBy(String updatedBy) {
        return updatedBy == null || updatedBy.trim().isEmpty() ? "SYSTEM" : updatedBy.trim();
    }

    private record TemplateDefinition(String key, String name, String requiredPlaceholder, String defaultText) {
    }
}

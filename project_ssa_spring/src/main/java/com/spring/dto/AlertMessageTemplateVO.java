package com.spring.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AlertMessageTemplateVO {

    private String templateKey;
    private String templateName;
    private String templateText;
    private String updatedBy;
    private Timestamp updatedAt;
}

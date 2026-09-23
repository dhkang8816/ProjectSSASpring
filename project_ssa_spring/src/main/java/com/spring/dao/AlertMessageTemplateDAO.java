package com.spring.dao;

import java.util.List;

import com.spring.dto.AlertMessageTemplateVO;

public interface AlertMessageTemplateDAO {

    List<AlertMessageTemplateVO> selectAlertMessageTemplates();

    int mergeAlertMessageTemplate(AlertMessageTemplateVO template);
}

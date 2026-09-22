package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;

public interface AlertLogService {
    public List<AlertLogVO> getAlertLogList(PageMaker pageMaker) throws Exception;
    public AlertLogVO getAlertLogDetail(int alertId) throws Exception;
    public void registerAlertLog(AlertLogVO vo) throws Exception;
}

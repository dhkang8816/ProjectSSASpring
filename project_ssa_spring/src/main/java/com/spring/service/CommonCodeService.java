package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;

public interface CommonCodeService {
    List<CommonCodeVO> getCommonCodeList(PageMaker pageMaker) throws Exception;
    int getCommonCodeCount(PageMaker pageMaker) throws Exception;
    
    List<CommonCodeVO> getCodeListByGroup(String grpCode) throws Exception;
    CommonCodeVO getCommonCodeDetail(String grpCode, String code) throws Exception;
    void registerCommonCode(CommonCodeVO ccVo) throws Exception;
    void modifyCommonCode(CommonCodeVO ccVo) throws Exception;
    void removeCommonCode(String grpCode, String code) throws Exception;
}
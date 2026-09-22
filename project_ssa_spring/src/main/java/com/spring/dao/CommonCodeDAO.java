package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;

public interface CommonCodeDAO {
    List<CommonCodeVO> selectCommonCodeList(PageMaker pageMaker) throws Exception;
    
    List<CommonCodeVO> getCodeListByGroup(String grpCode) throws Exception;
    int selectCommonCodeCount(PageMaker pageMaker) throws Exception;
    CommonCodeVO selectCommonCodeDetail(String grpCode, String code) throws Exception;
    int insertCommonCode(CommonCodeVO ccVo) throws Exception;
    int updateCommonCode(CommonCodeVO ccVo) throws Exception;
    int deleteCommonCode(String grpCode, String code) throws Exception;
}

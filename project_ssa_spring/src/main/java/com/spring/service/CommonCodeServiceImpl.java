package com.spring.service;

import java.util.List;

import com.spring.cmd.PageMaker; // 💡 PageMaker 임포트 추가
import com.spring.dao.CommonCodeDAO;
import com.spring.dto.CommonCodeVO;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class CommonCodeServiceImpl implements CommonCodeService {

    private CommonCodeDAO commonCodeDAO;

    public void setCommonCodeDAO(CommonCodeDAO commonCodeDAO) {
        this.commonCodeDAO = commonCodeDAO;
    }

    @Override
    public List<CommonCodeVO> getCommonCodeList(PageMaker pageMaker) throws Exception {
        return commonCodeDAO.selectCommonCodeList(pageMaker);
    }

    @Override
    public List<CommonCodeVO> getCodeListByGroup(String grpCode) throws Exception{
        return commonCodeDAO.getCodeListByGroup(grpCode);
    }
    
    @Override
    public int getCommonCodeCount(PageMaker pageMaker) throws Exception {
        return commonCodeDAO.selectCommonCodeCount(pageMaker);
    }

    @Override
    public CommonCodeVO getCommonCodeDetail(String grpCode, String code) throws Exception {
        return commonCodeDAO.selectCommonCodeDetail(grpCode, code);
    }

    @Override
    public void registerCommonCode(CommonCodeVO ccVO) throws Exception {
        commonCodeDAO.insertCommonCode(ccVO);
    }

    @Override
    public void modifyCommonCode(CommonCodeVO ccVO) throws Exception {
        commonCodeDAO.updateCommonCode(ccVO);
    }

    @Override
    public void removeCommonCode(String grpCode, String code) throws Exception {
        commonCodeDAO.deleteCommonCode(grpCode, code);
    }

}
package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DangerDetailDAO;
import com.spring.dto.DangerDetailVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DangerDetailServiceImpl implements DangerDetailService {

    private final DangerDetailDAO dangerDetailDAO;

    @Override
    @Transactional
    public void registerDanger(DangerDetailVO ddv) {
        dangerDetailDAO.insertDanger(ddv);
    }

    @Override
    public List<DangerDetailVO> getDangerList(PageMaker pageMaker) {
        int totalCount = dangerDetailDAO.selectDangerCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return dangerDetailDAO.selectDangerList(pageMaker);
    }

    @Override
    public DangerDetailVO getDangerById(int dangerId) {
        return dangerDetailDAO.selectDangerById(dangerId);
    }

    @Override
    @Transactional
    public void modifyDanger(DangerDetailVO ddv) {
        dangerDetailDAO.updateDanger(ddv);
    }

    @Override
    @Transactional
    public void removeDanger(int dangerId) {
        dangerDetailDAO.deleteDanger(dangerId);
    }
}

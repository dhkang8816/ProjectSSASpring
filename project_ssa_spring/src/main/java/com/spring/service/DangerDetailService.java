package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;

public interface DangerDetailService {
    public void registerDanger(DangerDetailVO ddv);
    public List<DangerDetailVO> getDangerList(PageMaker pageMaker);
    public DangerDetailVO getDangerById(int dangerId);
    public void modifyDanger(DangerDetailVO ddv);
    public void removeDanger(int dangerId);
}

package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;

public interface DangerDetailDAO {
    public int insertDanger(DangerDetailVO ddv);
    public List<DangerDetailVO> selectDangerList(PageMaker pageMaker);
    public int selectDangerCount(PageMaker pageMaker);
    public DangerDetailVO selectDangerById(int dangerId);
    public int updateDanger(DangerDetailVO ddv);
    public int deleteDanger(int dangerId);
}

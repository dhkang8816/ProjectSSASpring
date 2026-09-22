package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.LoginLogVO;

public interface LoginLogDAO {
    List<LoginLogVO> selectLoginLogList(PageMaker pageMaker) throws Exception;
    int selectLoginLogListCount(PageMaker pageMaker) throws Exception;
}

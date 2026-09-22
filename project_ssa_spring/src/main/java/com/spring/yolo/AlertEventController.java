package com.spring.yolo;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;

@RestController
@RequestMapping("/api/event")
public class AlertEventController {

    @Autowired
    private SqlSession sqlSession; // 🛠️ 안전하게 마이바티스 세션을 직접 활용

    
    @GetMapping("/latest")
    public AlertLogVO getLatestAlert() {
        try {
            PageMaker safeCmd = new PageMaker();
            safeCmd.setPage(1);
            safeCmd.setPerPageNum(1); // 최신 1건
            safeCmd.setSearchType("");
            safeCmd.setKeyword("");
            
            List<AlertLogVO> list = sqlSession.selectList("AlertLog-Mapper.getAlertLogListWithPaging", safeCmd);
            if (list != null && !list.isEmpty()) {
                return list.get(0); // 가장 최신 데이터 리턴
            }
        } catch (Exception e) {
            System.err.println("❌ 최신 알림 중계 실패: " + e.getMessage());
        }
        return null;
    }
}

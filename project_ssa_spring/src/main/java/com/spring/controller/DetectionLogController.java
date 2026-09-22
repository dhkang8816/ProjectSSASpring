package com.spring.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.IOUtils; // 💡 아파치 commons 라이브러리 연동
import org.springframework.beans.factory.annotation.Autowired; // 💡 Member 쪽과 스타일 동기화
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.DetectionLogVO;
import com.spring.service.CommonCodeService;
import com.spring.service.DetectionLogService;
import com.spring.util.RuntimeSettings;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest; // 💡 Tomcat 10 사양 완벽 준수
import lombok.extern.log4j.Log4j2; // 💡 로그 어노테이션 추가

@Log4j2
@Controller
@RequestMapping("/detection")
public class DetectionLogController {

    private static final String SNAPSHOT_UPLOAD_ROOT = RuntimeSettings.text("SSA_UPLOAD_ROOT", "C:" + File.separator + "upload");

    @Autowired
    private CommonCodeService commonCodeService;

    @Autowired
    private DetectionLogService detectionLogService; // 💡 깔끔하게 의존성 주입 구조 변경
    private String getUploadPath(HttpServletRequest request) {
        String path = new File(SNAPSHOT_UPLOAD_ROOT, "detection").getPath();
        File uploadDir = new File(path);
        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                log.info("🚨 [시스템 알림] 관제 탐지 스냅샷 저장 물리 폴더가 자동으로 생성되었습니다: {}", path);
            }
        }
        
        File noImageFile = new File(uploadDir, "noImage.jpg");
        if (!noImageFile.exists()) {
            ServletContext context = request.getServletContext();
            String resourcePath = context.getRealPath("/resources/images/member/noImage.jpg");
            File originFile = new File(resourcePath);
            if (originFile.exists()) {
                try (InputStream in = new FileInputStream(originFile);
                     FileOutputStream out = new FileOutputStream(noImageFile)) {
                    IOUtils.copy(in, out);
                    log.info("🎯 [자가치유 완료] C:\\upload\\detection\\noImage.jpg 파일이 자동 배포되었습니다.");
                } catch (Exception e) { log.error("이미지 복사 실패: ", e); }
            }
        }
        return path;
    }
    @GetMapping("/list")
    public String detectionList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        List<DetectionLogVO> detectionList = detectionLogService.getDetectionLogList(pageMaker);
        PageMaker animalTypePageMaker = new PageMaker();
        animalTypePageMaker.setSearchGrpCode("ANIMAL_TYPE");
        animalTypePageMaker.setSearchUseYn("Y");
        animalTypePageMaker.setPerPageNum(1000);

        Map<String, String> animalTypeNames = new HashMap<>();
        for (CommonCodeVO code : commonCodeService.getCommonCodeList(animalTypePageMaker)) {
            animalTypeNames.put(code.getCode(), code.getCodeName());
        }

        PageMaker actionStatusPageMaker = new PageMaker();
        actionStatusPageMaker.setSearchGrpCode("ACTION_STATUS");
        actionStatusPageMaker.setSearchUseYn("Y");
        actionStatusPageMaker.setPerPageNum(1000);
        Map<String, String> actionStatusNames = new HashMap<>();
        for (CommonCodeVO code : commonCodeService.getCommonCodeList(actionStatusPageMaker)) {
            actionStatusNames.put(code.getCode(), code.getCodeName());
        }
        
        model.addAttribute("detectionList", detectionList);
        model.addAttribute("animalTypeNames", animalTypeNames);
        model.addAttribute("actionStatusNames", actionStatusNames);
        return "detection/detectionList"; 
    }
    @GetMapping("/detail")
    public String detectionDetail(@RequestParam("dlogId") int dlogId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        DetectionLogVO vo = detectionLogService.getRequiredDetectionLogById(dlogId);

        PageMaker animalTypePageMaker = new PageMaker();
        animalTypePageMaker.setSearchGrpCode("ANIMAL_TYPE");
        animalTypePageMaker.setSearchUseYn("Y");
        animalTypePageMaker.setPerPageNum(1000);

        Map<String, String> animalTypeNames = new HashMap<>();
        for (CommonCodeVO code : commonCodeService.getCommonCodeList(animalTypePageMaker)) {
            animalTypeNames.put(code.getCode(), code.getCodeName());
        }
        
        model.addAttribute("detection", vo);
        model.addAttribute("animalTypeNames", animalTypeNames);
        model.addAttribute("actionStatusList", commonCodeService.getCodeListByGroup("ACTION_STATUS"));
        return "detection/detectionDetail"; 
    }
    @PostMapping("/modify")
    public String modifyActionStatus(DetectionLogVO dlv, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        detectionLogService.modifyActionStatus(dlv);
        
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return popup ? "redirect:/detection/list?popupSaved=true" : "redirect:/detection/list";
    }

    
    @GetMapping("/getSnapshot")
    @ResponseBody
    public ResponseEntity<byte[]> getSnapshot(@RequestParam("dlogId") int dlogId, HttpServletRequest request) throws IOException {
        InputStream in = null;
        try {
            DetectionLogVO vo = detectionLogService.getDetectionLogById(dlogId);
            String fileName = (vo == null || vo.getSnapshotPath() == null || vo.getSnapshotPath().isEmpty()) 
                              ? "noImage.jpg" : vo.getSnapshotPath();
            String uploadPath = getUploadPath(request);
            File file = new File(uploadPath, fileName);
            if (!file.exists()) {
                file = new File(uploadPath, "noImage.jpg");
            }
            
            in = new FileInputStream(file);
            return new ResponseEntity<byte[]>(IOUtils.toByteArray(in), HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("스냅샷 이미지 스트림 전송 중 예외 발생: ", e);
            return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
        } finally {
            if (in != null) in.close();
        }
    }
}

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
import org.springframework.beans.factory.annotation.Autowired; // 💡 프로젝트 스타일 동기화
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
import com.spring.dto.DangerDetailVO;
import com.spring.dto.DangerLogVO;
import com.spring.service.CommonCodeService;
import com.spring.service.DangerDetailService;
import com.spring.service.DangerLogService;
import com.spring.util.RuntimeSettings;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest; // 💡 Tomcat 10 사양 완벽 준수
import lombok.extern.log4j.Log4j2; // 💡 로그 어노테이션 통합 완료

@Log4j2
@Controller
@RequestMapping("/dangerlog")
public class DangerLogController {

    private static final String SNAPSHOT_UPLOAD_ROOT = RuntimeSettings.text("SSA_UPLOAD_ROOT", "C:" + File.separator + "upload");

    @Autowired
    private DangerLogService dangerLogService;
    
    @Autowired
    private DangerDetailService dangerDetailService;

    @Autowired
    private CommonCodeService commonCodeService;
    private String getUploadPath(HttpServletRequest request) {
        String path = new File(SNAPSHOT_UPLOAD_ROOT, "dangerlog").getPath();
        
        File uploadDir = new File(path);
        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                log.info("🚨 [시스템 알림] 이상객체 스냅샷 저장 물리 폴더가 자동으로 생성되었습니다: {}", path);
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
                    log.info("🎯 [자가치유 완료] C:\\upload\\dangerlog\\noImage.jpg 파일이 자동 배포되었습니다.");
                    
                } catch (Exception e) {
                    log.error("기본 이미지 복사 중 시스템 예외 발생: ", e);
                }
            } else {
                log.warn("⚠️ [주의] 프로젝트 내부에 원본 noImage.jpg 파일이 존재하지 않습니다.");
            }
        }
        
        return path;
    }
    @GetMapping("/list")
    public String dangerLogList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        List<DangerLogVO> dangerLogList = dangerLogService.getDangerLogList(pageMaker);
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<DangerDetailVO> dangerMasterList = dangerDetailService.getDangerList(pm);
        Map<Integer, String> dangerCodeMap = new HashMap<>();
        for (DangerDetailVO master : dangerMasterList) {
            dangerCodeMap.put(master.getDangerId(), master.getDangerName());
        }
        for (DangerLogVO log : dangerLogList) {
            String matchedName = dangerCodeMap.get(log.getDangerType());
            
            if (matchedName == null) {
                log.setDangerName("미등록객체(" +  log.getDangerType() + ")");
            } else {
                log.setDangerName(matchedName);
            }
        }

        PageMaker actionStatusPageMaker = new PageMaker();
        actionStatusPageMaker.setSearchGrpCode("ACTION_STATUS");
        actionStatusPageMaker.setSearchUseYn("Y");
        actionStatusPageMaker.setPerPageNum(1000);
        Map<String, String> actionStatusNames = new HashMap<>();
        for (CommonCodeVO code : commonCodeService.getCommonCodeList(actionStatusPageMaker)) {
            actionStatusNames.put(code.getCode(), code.getCodeName());
        }
        
        model.addAttribute("dangerLogList", dangerLogList);
        model.addAttribute("actionStatusNames", actionStatusNames);
        return "dangerlog/dangerLogList"; 
    }
    @GetMapping("/detail")
    public String dangerLogDetail(@RequestParam("danlogId") int danlogId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        DangerLogVO log = dangerLogService.getDangerLogById(danlogId);
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<DangerDetailVO> dangerMasterList = dangerDetailService.getDangerList(pm);
        
        Map<Integer, String> dangerCodeMap = new HashMap<>();
        for (DangerDetailVO master : dangerMasterList) {
            dangerCodeMap.put(master.getDangerId(), master.getDangerName());
        }
        String matchedName = dangerCodeMap.get(log.getDangerType());
        if (matchedName == null) {
            log.setDangerName("미등록객체(" + log.getDangerType() + ")");
        } else {
            log.setDangerName(matchedName);
        }
        
        model.addAttribute("dangerLog", log);
        model.addAttribute("actionStatusList", commonCodeService.getCodeListByGroup("ACTION_STATUS"));
        return "dangerlog/dangerLogDetail";
    }
    @PostMapping("/modify")
    public String modifyDactionStatus(DangerLogVO dlv, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        dangerLogService.modifyDactionStatus(dlv);
        
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return popup ? "redirect:/dangerlog/list?popupSaved=true" : "redirect:/dangerlog/list";
    }

    
    @GetMapping("/getDangerSnapshot")
    @ResponseBody
    public ResponseEntity<byte[]> getDangerSnapshot(@RequestParam("danlogId") int danlogId, HttpServletRequest request) throws IOException {
        InputStream in = null;
        try {
            DangerLogVO vo = dangerLogService.getDangerLogById(danlogId);
            String fileName = (vo == null || vo.getDsnapshotPath() == null || vo.getDsnapshotPath().isEmpty()) 
                              ? "noImage.jpg" : vo.getDsnapshotPath();
            String uploadPath = getUploadPath(request);
            File file = new File(uploadPath, fileName);
            if (!file.exists()) {
                file = new File(uploadPath, "noImage.jpg");
            }
            
            in = new FileInputStream(file);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_JPEG);
            
            return new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("이상객체 스냅샷 이미지 스트림 전송 중 예외 발생: ", e);
            return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
        } finally {
            if (in != null) in.close();
        }
    }

}

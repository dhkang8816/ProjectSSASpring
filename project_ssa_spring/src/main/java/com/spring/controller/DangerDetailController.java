package com.spring.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;
import com.spring.service.DangerDetailService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/danger")
@AllArgsConstructor
public class DangerDetailController {

    private final DangerDetailService dangerDetailService;
    @GetMapping("/list")
    public String dangerList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<DangerDetailVO> dangerList = dangerDetailService.getDangerList(pageMaker);
        
        model.addAttribute("dangerList", dangerList);
        return "danger/dangerList"; // WEB-INF/views/danger/dangerList.jsp 매핑
    }
    @GetMapping("/register")
    public String registerForm() {
        return "danger/dangerRegister"; // WEB-INF/views/danger/dangerRegister.jsp 매핑
    }
    @PostMapping("/register")
    public String register(DangerDetailVO ddv, Model model,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        PageMaker pm = new PageMaker();
        pm.setSearchType("n"); // 이름 검색 조건 바인딩
        pm.setKeyword(ddv.getDangerName()); // 사용자가 화면에 입력한 이름
        int existCount = dangerDetailService.getDangerList(pm).size(); 
        
        if (existCount > 0) {
            model.addAttribute("message", "⚠️ '" + ddv.getDangerName() + "'은(는) 이미 마스터에 등록된 이상 객체입니다.");
            return "common/message"; 
        }
        dangerDetailService.registerDanger(ddv);
        return popup ? "redirect:/danger/list?popupSaved=true" : "redirect:/danger/list";
    }
    @GetMapping("/detail")
    public String dangerDetail(@RequestParam("dangerId") int dangerId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        DangerDetailVO vo = dangerDetailService.getDangerById(dangerId);
        
        model.addAttribute("danger", vo);
        return "danger/dangerDetail"; // WEB-INF/views/danger/dangerDetail.jsp 매핑
    }
    @PostMapping("/modify")
    public String modify(DangerDetailVO ddv, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        dangerDetailService.modifyDanger(ddv);
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return popup ? "redirect:/danger/list?popupSaved=true" : "redirect:/danger/list";
    }
    @PostMapping("/remove")
    public String remove(@RequestParam("dangerId") int dangerId, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        dangerDetailService.removeDanger(dangerId);
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return popup ? "redirect:/danger/list?popupSaved=true" : "redirect:/danger/list";
    }
}

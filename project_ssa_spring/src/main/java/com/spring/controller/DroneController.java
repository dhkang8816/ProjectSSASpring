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
import com.spring.dto.DroneVO;
import com.spring.dto.MemberVO;
import com.spring.service.DroneService;
import com.spring.service.MemberService;

import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
@RequestMapping("/drone")
public class DroneController {

    private final DroneService droneService;
    private final MemberService memberService;
    @GetMapping("/list")
    public String droneList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<DroneVO> droneList = droneService.getDroneList(pageMaker);
        
        model.addAttribute("droneList", droneList);
        return "drone/droneList"; // WEB-INF/views/drone/droneList.jsp 매핑
    }

    @GetMapping("/register")
    public String registerForm(Model model) throws Exception {
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000); 
        List<MemberVO> memberList = memberService.getMemberList(pm);
        
        model.addAttribute("memberList", memberList);
        return "drone/droneRegister";
    }
    @PostMapping("/register")
    public String register(DroneVO dvo, Model model,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {
        DroneVO existDrone = droneService.getDroneById(dvo.getDroneId());
        if (existDrone != null) {
            model.addAttribute("message", "⚠️ 이미 등록된 드론 기체 ID입니다. 다시 확인해 주세요.");
            return "common/message"; 
        }
        if (dvo.getMemberId() != null && !dvo.getMemberId().trim().equals("")) {
            MemberVO member = memberService.getMemberById(dvo.getMemberId());
            
            if (member == null) {
                model.addAttribute("message", "❌ 존재하지 않는 관제원 사번입니다. 올바른 사번을 입력해 주세요.");
                return "common/message";
            }
        }
        droneService.registerDrone(dvo);
        return popup ? "redirect:/drone/list?popupSaved=true" : "redirect:/drone/list";
    }
    @GetMapping("/detail")
    public String droneDetail(@RequestParam("droneId") String droneId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        DroneVO vo = droneService.getRequiredDroneById(droneId);
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<MemberVO> memberList = memberService.getMemberList(pm);
        
        model.addAttribute("drone", vo);
        model.addAttribute("memberList", memberList);
        return "drone/droneDetail";
    }
    @GetMapping("/modify")
    public String modifyForm(
            @RequestParam("droneId") String droneId,
            @ModelAttribute("pageMaker") PageMaker pageMaker,
            Model model) throws Exception {

        // 수정할 드론 조회
        DroneVO drone = droneService.getRequiredDroneById(droneId);

        // 담당 관제원 목록 조회
        PageMaker pm = new PageMaker();
        pm.setPerPageNum(1000);
        List<MemberVO> memberList = memberService.getMemberList(pm);

        model.addAttribute("drone", drone);
        model.addAttribute("memberList", memberList);

        return "drone/droneModify";
    }
    @PostMapping("/modify")
    public String modify(DroneVO dvo, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        droneService.modifyDrone(dvo);
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return popup ? "redirect:/drone/list?popupSaved=true" : "redirect:/drone/list";
    }
    @PostMapping("/remove")
    public String remove(@RequestParam("droneId") String droneId, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        droneService.removeDrone(droneId);
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return popup ? "redirect:/drone/list?popupSaved=true" : "redirect:/drone/list";
    }
}

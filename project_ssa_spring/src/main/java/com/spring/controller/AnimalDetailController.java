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
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.AnimalDetailVO;
import com.spring.dto.CommonCodeVO;
import com.spring.service.AnimalCounterService;
import com.spring.service.AnimalDetailService;
import com.spring.service.CommonCodeService;

import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/animal")
@AllArgsConstructor
public class AnimalDetailController {

    private final AnimalDetailService animalDetailService;
    private final AnimalCounterService animalCounterService;
    private final CommonCodeService commonCodeService;
    @GetMapping("/list")
    public String animalList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        List<AnimalDetailVO> animalList = animalDetailService.getAnimalList(pageMaker);
        PageMaker animalTypePageMaker = new PageMaker();
        animalTypePageMaker.setSearchGrpCode("ANIMAL_TYPE");
        animalTypePageMaker.setSearchUseYn("Y");
        animalTypePageMaker.setPerPageNum(1000);
        List<CommonCodeVO> animalTypeList = commonCodeService.getCommonCodeList(animalTypePageMaker);
        
        model.addAttribute("animalList", animalList);
        model.addAttribute("animalTypeList", animalTypeList);
        model.addAttribute("animalStatusList", getActiveCodes("ANIMAL_STATUS"));
        return "animal/animalList"; // WEB-INF/views/animal/list.jsp 매핑
    }
    @GetMapping("/register")
    public String registerForm(Model model) throws Exception {
        PageMaker pm = new PageMaker();
        pm.setSearchGrpCode("ANIMAL_TYPE");
        pm.setSearchUseYn("Y");
        List<CommonCodeVO> animalTypeList = commonCodeService.getCommonCodeList(pm);
        
        model.addAttribute("animalTypeList", animalTypeList);
        model.addAttribute("animalStatusList", getActiveCodes("ANIMAL_STATUS"));
        return "animal/animalRegister";
    }
    @PostMapping("/register")
    public String register(AnimalDetailVO vo, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        animalDetailService.registerAnimal(vo);
        rttr.addFlashAttribute("msg", "REGISTER_SUCCESS");
        return popup ? "redirect:/animal/list?popupSaved=true" : "redirect:/animal/list";
    }
    @GetMapping("/detail")
    public String animalDetail(@RequestParam("animalId") int animalId, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
        AnimalDetailVO vo = animalDetailService.getAnimalById(animalId);
        PageMaker pm = new PageMaker();
        pm.setSearchGrpCode("ANIMAL_TYPE");
        pm.setSearchUseYn("Y");
        List<CommonCodeVO> animalTypeList = commonCodeService.getCommonCodeList(pm);
        
        model.addAttribute("animal", vo);
        model.addAttribute("animalTypeList", animalTypeList);
        model.addAttribute("animalStatusList", getActiveCodes("ANIMAL_STATUS"));
        return "animal/animalDetail";
    }
    @PostMapping("/modify")
    public String modify(AnimalDetailVO vo, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        animalDetailService.modifyAnimal(vo);
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "MODIFY_SUCCESS");
        
        return popup ? "redirect:/animal/list?popupSaved=true" : "redirect:/animal/list";
    }
    @PostMapping("/remove")
    public String remove(@RequestParam("animalId") int animalId, PageMaker pageMaker, RedirectAttributes rttr,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) {
        animalDetailService.removeAnimal(animalId);
        rttr.addAttribute("page", pageMaker.getPage());
        rttr.addAttribute("searchType", pageMaker.getSearchType());
        rttr.addAttribute("keyword", pageMaker.getKeyword());
        rttr.addFlashAttribute("msg", "REMOVE_SUCCESS");
        
        return popup ? "redirect:/animal/list?popupSaved=true" : "redirect:/animal/list";
    }
    @GetMapping("/counterList")
    public String animalCounterList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) {
        List<AnimalCounterVO> counterList = animalCounterService.getAnimalCounterList(pageMaker);
        
        model.addAttribute("counterList", counterList);
        return "animal/animalCounterList"; // WEB-INF/views/animal/animalCounterList.jsp 매핑
    }

    private List<CommonCodeVO> getActiveCodes(String groupCode) throws Exception {
        return commonCodeService.getCodeListByGroup(groupCode);
    }

}

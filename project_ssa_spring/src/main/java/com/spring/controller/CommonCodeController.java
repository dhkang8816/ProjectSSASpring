package com.spring.controller;

import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.service.CommonCodeService;

@Controller
@RequestMapping("/commoncode") // 💡 웹 브라우저 접근 주소를 폴더명과 통일합니다.
public class CommonCodeController {

	@Autowired
	private CommonCodeService commonCodeService;

	
	@RequestMapping(value = "/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String getCommonCodeList(PageMaker pageMaker, Model model) throws Exception {
		int totalCount = commonCodeService.getCommonCodeCount(pageMaker);
		pageMaker.setTotalCount(totalCount);
		List<CommonCodeVO> codeList = commonCodeService.getCommonCodeList(pageMaker);
		PageMaker groupCodePageMaker = new PageMaker();
		groupCodePageMaker.setPerPageNum(1000);
		Set<String> groupCodes = new TreeSet<>();
		for (CommonCodeVO code : commonCodeService.getCommonCodeList(groupCodePageMaker)) {
			if (code.getGrpCode() != null && !code.getGrpCode().isEmpty()) {
				groupCodes.add(code.getGrpCode());
			}
		}

		model.addAttribute("codeList", codeList);
		model.addAttribute("groupCodes", groupCodes);
		model.addAttribute("pageMaker", pageMaker); // JSP에서 버튼과 검색 조건을 유지하기 위해 전달
		return "commoncode/codeList";
	}
	
	
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
	public String getCommonCodeDetail(@RequestParam("grpCode") String grpCode, @RequestParam("code") String code,
			Model model) throws Exception {

		CommonCodeVO ccVO = commonCodeService.getCommonCodeDetail(grpCode, code);
		model.addAttribute("ccVO", ccVO);
		return "commoncode/codeDetail";
	}

	
	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String registerCommonCode(@ModelAttribute("ccVO") CommonCodeVO ccVO,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {

		commonCodeService.registerCommonCode(ccVO);
		return popup ? "redirect:/commoncode/list?popupSaved=true" : "redirect:/commoncode/list";
	}

	
	@RequestMapping(value = "/modify", method = RequestMethod.POST)
	public String modifyCommonCode(@ModelAttribute("ccVO") CommonCodeVO ccVO,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {

		commonCodeService.modifyCommonCode(ccVO);

		return popup ? "redirect:/commoncode/list?popupSaved=true"
				: "redirect:/commoncode/detail?grpCode=" + ccVO.getGrpCode() + "&code=" + ccVO.getCode();
	}

	
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String removeCommonCode(@RequestParam("grpCode") String grpCode, @RequestParam("code") String code,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup)
			throws Exception {

		commonCodeService.removeCommonCode(grpCode, code);

		return popup ? "redirect:/commoncode/list?popupSaved=true" : "redirect:/commoncode/list";
	}
	@RequestMapping(value = "/registerForm", method = RequestMethod.GET)
	public String registerForm() {
		return "commoncode/codeRegister";
	}
}

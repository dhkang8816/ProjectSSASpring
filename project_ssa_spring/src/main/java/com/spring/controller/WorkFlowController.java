package com.spring.controller;

import java.util.List;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.spring.cmd.PageMaker;
import com.spring.dto.WorkFlowVO;
import com.spring.security.CustomUser;
import com.spring.service.WorkFlowService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/workflow")
@RequiredArgsConstructor
public class WorkFlowController {
	private final WorkFlowService workFlowService;

	@GetMapping("/list")
	public String list(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		String currentMemberId = getCurrentMemberId();
		List<WorkFlowVO> workflowList = workFlowService.getWorkFlowList(pageMaker, currentMemberId);
		model.addAttribute("workflowList", workflowList);
		return "workflow/workFlowList";
	}

	@GetMapping("/detail/{approvalId}")
	public String detail(@PathVariable("approvalId") Long approvalId, Model model) throws Exception {
		model.addAttribute("workflow", getAssignedWorkflow(approvalId));
		return "workflow/workFlowDetail";
	}

	@PostMapping("/approve")
	public String approve(@RequestParam("approvalId") Long approvalId,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup, RedirectAttributes rttr) {
		boolean completed = false;
		try {
			workFlowService.approve(approvalId, getCurrentMemberId());
			completed = true;
			rttr.addFlashAttribute("message", "결재를 완료했습니다.");
		} catch (Exception e) {
			rttr.addFlashAttribute("error", "결재 처리에 실패했습니다.");
		}
		return completed && popup ? "redirect:/workflow/list?popupSaved=true"
				: "redirect:/workflow/detail/" + approvalId + (popup ? "?popup=true" : "");
	}

	@PostMapping("/reject")
	public String reject(@RequestParam("approvalId") Long approvalId, @RequestParam("rejectReason") String rejectReason,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup, RedirectAttributes rttr) {
		boolean completed = false;
		try {
			workFlowService.reject(approvalId, getCurrentMemberId(), rejectReason);
			completed = true;
			rttr.addFlashAttribute("message", "반려 처리했습니다.");
		} catch (Exception e) {
			rttr.addFlashAttribute("error", "반려 사유를 확인하거나 결재 상태를 다시 확인해 주세요.");
		}
		return completed && popup ? "redirect:/workflow/list?popupSaved=true"
				: "redirect:/workflow/detail/" + approvalId + (popup ? "?popup=true" : "");
	}

	private WorkFlowVO getAssignedWorkflow(Long approvalId) throws Exception {
		WorkFlowVO workflow = workFlowService.getWorkFlowById(approvalId);
		if (workflow == null || !getCurrentMemberId().equals(workflow.getApproverId()))
			throw new AccessDeniedException("Approval is not assigned to the current administrator.");
		return workflow;
	}

	private String getCurrentMemberId() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication == null || !authentication.isAuthenticated())
			throw new AccessDeniedException("Authentication is required.");
		Object principal = authentication.getPrincipal();
		if (principal instanceof CustomUser)
			return ((CustomUser) principal).getMember().getMemberId();
		return authentication.getName();
	}
}

package com.spring.controller;

import java.nio.file.Path;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.dto.FlightHistoryVO;
import com.spring.dto.MemberVO;
import com.spring.dto.PatrolReportVO;
import com.spring.dto.WorkFlowVO;
import com.spring.security.CustomUser;
import com.spring.service.DangerLogService;
import com.spring.service.CommonCodeService;
import com.spring.service.DetectionLogService;
import com.spring.service.FlightHistoryService;
import com.spring.service.MemberService;
import com.spring.service.PdfCacheService;
import com.spring.service.PatrolReportService;
import com.spring.service.WorkFlowService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("/patrolreport")
@RequiredArgsConstructor
public class PatrolReportController {

	private final PatrolReportService reportService;
	private final PdfCacheService pdfCacheService;
	private final DangerLogService dangerLogService;
	private final DetectionLogService detectionLogService;
	private final FlightHistoryService flightHistoryService;
	private final MemberService memberService;
	private final WorkFlowService workFlowService;
	private final CommonCodeService commonCodeService;
	@GetMapping("/list")
	public String list(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		List<PatrolReportVO> reportList = reportService.getReportListWithPaging(pageMaker);
		model.addAttribute("reportList", reportList);
		model.addAttribute("confirmStatusList", commonCodeService.getCodeListByGroup("CONFIRM_STATUS"));
		return "patrolreport/patrolReportList";
	}

	@GetMapping("/approval/list")
	public String approvalList(@ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		List<PatrolReportVO> reportList = reportService.getPendingReportListWithPaging(pageMaker);
		model.addAttribute("reportList", reportList);
		return "patrolreport/patrolReportApprovalList";
	}
	@PostMapping("/legacy/updateStatus")
	@ResponseBody
	public String updateStatus(@RequestParam("reportId") int reportId,
			@RequestParam("confirmStatus") String confirmStatus) {
		try {
			PatrolReportVO reportVO = reportService.getReportById(reportId);
			if (reportVO != null) {
				reportVO.setConfirmStatus(confirmStatus);
				reportService.updateReport(reportVO); // 공통코드 규격(0, 1, 2)에 맞춰 오라클 DB 적재
				return "SUCCESS";
			}
			return "FAIL";
		} catch (Exception e) {
			log.error("❌ 결재 상태 실시간 적재 중 서버 에러 발생: ", e);
			return "ERROR";
		}
	}
    @GetMapping("/register")
    public String registerForm(Model model) throws Exception {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String currentMemberId = auth != null && auth.isAuthenticated() ? auth.getName() : null;
        
        if (auth != null && auth.getPrincipal() instanceof CustomUser) {
            CustomUser customUser = (CustomUser) auth.getPrincipal();
            if (customUser.getMember() != null) {
                currentMemberId = customUser.getMember().getMemberId();
            }
        }
        MemberVO writerVO = memberService.getMemberById(currentMemberId);
        
        model.addAttribute("currentMemberId", currentMemberId);
        model.addAttribute("currentMemberName", writerVO != null ? writerVO.getName() : "관리자");
        model.addAttribute("currentDept", writerVO != null ? writerVO.getDepartment() : "관제운영팀");
        model.addAttribute("reportVO", new PatrolReportVO());
        model.addAttribute("approverList", memberService.getAdminMembers());
        
        return "patrolreport/patrolReportRegister";
    }
	@PostMapping("/recalculate")
	@ResponseBody
	public String recalculate(@RequestParam("reportId") Long reportId, @RequestParam("flightTime") Double flightTime,
			@RequestParam("detectCount") Long detectCount, @RequestParam("completeRate") Double completeRate) {
		try {
			log.info("🔄 [수동 강제 재실행 격발] 타격 요청된 보고서 번호 (ID): {}", reportId);
			PatrolReportVO reportVO = reportService.getReportById(reportId.intValue());

			if (reportVO != null) {
				Date now = new java.util.Date(); // 오라클 DB에 적재할 실시간 현재 시간(SYSDATE)
				reportVO.setTotalFlightTime(flightTime);
				reportVO.setTotalDetectCount(detectCount);
				reportVO.setCompletionRate(completeRate);
				reportVO.setModDate(now); // 수정일자 필드에 실시간 현재 시간 주입

				reportService.updateReport(reportVO);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				return sdf.format(now);
			}
			return "FAIL";
		} catch (Exception e) {
			log.error("💥 수동 강제 재실행 수치 덮어쓰기 연동 중 치명적 서버 오류 발생: ", e);
			return "FAIL";
		}
	}
	@PostMapping("/register")
    public String register(@ModelAttribute("reportVO") PatrolReportVO reportVO,
            @RequestParam("approverId") String approverId,
            @RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String currentMemberId = auth != null && auth.isAuthenticated() ? auth.getName() : null;
        if (auth != null && auth.getPrincipal() instanceof CustomUser) {
            CustomUser customUser = (CustomUser) auth.getPrincipal();
            currentMemberId = customUser.getMember().getMemberId();
        }

        if (currentMemberId == null || currentMemberId.trim().isEmpty()) {
            throw new org.springframework.security.access.AccessDeniedException("Authentication is required.");
        }
        double todayTotalFlightHours = 0.0;
        int totalTodayDetectCount = 0;
        double actionCompleteRate = 0.0;

        PageMaker dbPageMaker = new PageMaker();
        dbPageMaker.setPage(1);
        dbPageMaker.setPerPageNum(1000);

        List<FlightHistoryVO> flightList = flightHistoryService.getFlightHistoryList(dbPageMaker);
        if (flightList != null) {
            for (FlightHistoryVO fvo : flightList) {
                todayTotalFlightHours += fvo.getFlightDuration();
            }
        }

        Map<String, Object> dangerStats = dangerLogService.getTodayDangerStats();
        Map<String, Object> detectStats = detectionLogService.getTodayDetectionStats();

        long dangerTotal = dangerStats != null && dangerStats.get("TOTAL_COUNT") != null ? ((Number) dangerStats.get("TOTAL_COUNT")).longValue() : 0;
        long dangerComplete = dangerStats != null && dangerStats.get("COMPLETE_COUNT") != null ? ((Number) dangerStats.get("COMPLETE_COUNT")).longValue() : 0;
        long detectTotal = detectStats != null && detectStats.get("TOTAL_COUNT") != null ? ((Number) detectStats.get("TOTAL_COUNT")).longValue() : 0;
        long detectComplete = detectStats != null && detectStats.get("COMPLETE_COUNT") != null ? ((Number) detectStats.get("COMPLETE_COUNT")).longValue() : 0;

        totalTodayDetectCount = (int) (dangerTotal + detectTotal);
        long totalCompleteCount = dangerComplete + detectComplete;
        if (totalTodayDetectCount > 0) {
            actionCompleteRate = ((double) totalCompleteCount / totalTodayDetectCount) * 100;
        }
        reportVO.setMemberId(currentMemberId);
        reportVO.setReportDate(new java.util.Date());
        reportVO.setPatrolDate(new java.util.Date());
        reportVO.setConfirmStatus("0"); // 초기 상태: 승인 대기
        
        reportVO.setTotalFlightTime(todayTotalFlightHours);
        reportVO.setTotalDetectCount((long) totalTodayDetectCount);
        reportVO.setCompletionRate(Math.round(actionCompleteRate * 100) / 100.0);

        reportService.insertReportWithWorkflow(reportVO, approverId);
        return popup ? "redirect:/patrolreport/list?popupSaved=true" : "redirect:/patrolreport/list";
    }
	@PostMapping("/createInstantReport")
	@ResponseBody
	public String createInstantReport() {
		try {
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())
					|| "anonymousUser".equals(auth.getName())) {
				log.warn("⚠ [관제 보안 경고] 미인증 세션이 일일 업무 보고서 생성 API 요청 차단 처리됨");
				return "NOT_LOGGED_IN";
			}
			String currentMemberId = null;
			if (auth.getPrincipal() instanceof CustomUser) {
				CustomUser customUser = (CustomUser) auth.getPrincipal();
				if (customUser.getMember() != null) {
					currentMemberId = customUser.getMember().getMemberId();
				}
			}
			if (currentMemberId == null || currentMemberId.isEmpty()) {
				currentMemberId = auth.getName();
			}
			double todayTotalFlightHours = 0.0;
			int totalTodayDetectCount = 0;
			double actionCompleteRate = 0.0;

			PageMaker dbPageMaker = new PageMaker();
			dbPageMaker.setPage(1);
			dbPageMaker.setPerPageNum(1000);

			List<FlightHistoryVO> flightList = flightHistoryService.getFlightHistoryList(dbPageMaker);
			if (flightList != null) {
				for (FlightHistoryVO fvo : flightList) {
					todayTotalFlightHours += fvo.getFlightDuration();
				}
			}

			Map<String, Object> dangerStats = dangerLogService.getTodayDangerStats();
			Map<String, Object> detectStats = detectionLogService.getTodayDetectionStats();

			long dangerTotal = 0;
			long dangerComplete = 0;
			if (dangerStats != null) {
				dangerTotal = dangerStats.get("TOTAL_COUNT") != null
						? ((Number) dangerStats.get("TOTAL_COUNT")).longValue()
						: 0;
				dangerComplete = dangerStats.get("COMPLETE_COUNT") != null
						? ((Number) dangerStats.get("COMPLETE_COUNT")).longValue()
						: 0;
			}

			long detectTotal = 0;
			long detectComplete = 0;
			if (detectStats != null) {
				detectTotal = detectStats.get("TOTAL_COUNT") != null
						? ((Number) detectStats.get("TOTAL_COUNT")).longValue()
						: 0;
				detectComplete = detectStats.get("COMPLETE_COUNT") != null
						? ((Number) detectStats.get("COMPLETE_COUNT")).longValue()
						: 0;
			}

			totalTodayDetectCount = (int) (dangerTotal + detectTotal);
			long totalCompleteCount = dangerComplete + detectComplete;
			if (totalTodayDetectCount > 0) {
				actionCompleteRate = ((double) totalCompleteCount / totalTodayDetectCount) * 100;
			}

			String defaultActionTaken = "당일 관제 구역 정밀 순찰 완수. 탐지된 객체에 대한 현장 상황 전파 및 관제 조치 절차 정상 이행 완료.";
			String defaultRemark = "종합 위험도 평가 지표 안정 상태 유지 중. 드론 기체 하드웨어 및 시스템 특이 결함 없음.";
			PatrolReportVO reportVO = PatrolReportVO.builder().reportDate(new java.util.Date())
					.totalFlightTime(todayTotalFlightHours).totalDetectCount((long) totalTodayDetectCount)
					.completionRate(Math.round(actionCompleteRate * 100) / 100.0).confirmStatus("0")
					.patrolDate(new java.util.Date()).memberId(currentMemberId).actionTaken(defaultActionTaken)
					.remark(defaultRemark).build();

			reportService.insertReport(reportVO);
			return "SUCCESS";
		} catch (Exception e) {
			log.error("❌ [시스템 중단 예외] 1-클릭 자동 보고서 적재 실패: ", e);
			return "FAIL";
		}
	}

	@PostMapping("/delete")
	public String delete(@RequestParam("reportId") int reportId,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup,
			RedirectAttributes rttr) {
		try {
			reportService.deleteReport(reportId);
			rttr.addFlashAttribute("msg", "DELETE_SUCCESS");
			return popup ? "redirect:/patrolreport/list?popupSaved=true" : "redirect:/patrolreport/list";
		} catch (Exception e) {
			log.error("업무 보고서 삭제 실패. reportId={}", reportId, e);
			rttr.addFlashAttribute("msg", "DELETE_FAIL");
			return "redirect:/patrolreport/detail/" + reportId;
		}
	}
	@GetMapping("/modify/{reportId}")
	public String modifyForm(@PathVariable("reportId") Long reportId, Model model) throws Exception {
		PatrolReportVO reportVO = reportService.getReportById(reportId.intValue());
		validateRejectedReportOwner(reportVO);

		WorkFlowVO workflow = workFlowService.getWorkFlowByReportId(reportId);
		model.addAttribute("report", reportVO);
		model.addAttribute("rejectReason", workflow == null ? null : workflow.getRejectReason());
		return "patrolreport/patrolReportModify";
	}

	@PostMapping("/modify")
	public String modifyRejectedReport(@ModelAttribute("report") PatrolReportVO reportVO,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup, RedirectAttributes rttr) {
		Long reportId = reportVO == null ? null : reportVO.getReportId();
		try {
			reportService.reviseRejectedReport(reportVO, getCurrentMemberId());
			rttr.addFlashAttribute("msg", "REVISE_SUCCESS");
			return popup ? "redirect:/patrolreport/list?popupSaved=true" : "redirect:/patrolreport/list";
		} catch (Exception e) {
			log.warn("반려 보고서 수정 실패. reportId={}", reportId, e);
			rttr.addFlashAttribute("msg", "REVISE_FAIL");
			String detailPath = reportId == null ? "/patrolreport/list" : "/patrolreport/detail/" + reportId;
			return "redirect:" + detailPath + (popup && reportId != null ? "?popup=true" : "");
		}
	}

	@GetMapping("/detail/{reportId}")
	public String detail(@PathVariable("reportId") Long reportId, Model model) {
		try {
			log.info("🔍 [스프링 엔드포인트 타격 성공] 요청된 보고서 일련번호 (ID): {}", reportId);
			PatrolReportVO reportVO = reportService.getReportById(reportId.intValue());

			if (reportVO == null) {
				log.warn("⚠ [데이터 공백] 오라클 DB에 {}번 업무 보고서가 존재하지 않습니다.", reportId);
				model.addAttribute("msg", "조회된 보고서가 존재하지 않습니다.");
				return "patrolreport/patrolReportList";
			}

			if (reportVO.getMemberId() != null && !reportVO.getMemberId().isEmpty()) {
				MemberVO memberVO = memberService.getMemberById(reportVO.getMemberId());
				if (memberVO != null) {
					model.addAttribute("memberName", memberVO.getName());
					model.addAttribute("memberDept", memberVO.getDepartment());
				} else {
					model.addAttribute("memberName", "기본 관리자");
					model.addAttribute("memberDept", "관제운영팀");
				}
			} else {
				model.addAttribute("memberName", "확인 불가");
				model.addAttribute("memberDept", "관제팀");
			}

			WorkFlowVO workflow = workFlowService.getWorkFlowByReportId(reportId);
			String rejectionReason = workflow == null ? null : workflow.getRejectReason();
			model.addAttribute("rejectReason", rejectionReason);
			String currentMemberId = getOptionalCurrentMemberId();
			model.addAttribute("canModifyRejectedReport",
					"2".equals(reportVO.getConfirmStatus()) && currentMemberId != null
							&& currentMemberId.equals(reportVO.getMemberId()));
			model.addAttribute("report", reportVO);
			return "patrolreport/patrolReportDetail";

		} catch (Exception e) {
			log.error("💥 업무 보고서 상세 조회 프로세스 중 치명적 서버 오류 발생: ", e);
			model.addAttribute("msg", "상세 조회 중 시스템 에러가 발생했습니다.");
			return "patrolreport/patrolReportList";
		}
	}

	@GetMapping(value = "/pdf/{reportId}", produces = MediaType.APPLICATION_PDF_VALUE)
	public ResponseEntity<Resource> downloadPdf(@PathVariable("reportId") Long reportId, HttpServletRequest request) throws Exception {
		String localOrigin = "http://127.0.0.1:" + request.getServerPort() + request.getContextPath();
		Path pdfPath = pdfCacheService.getOrCreatePatrolReportPdf(reportId, localOrigin);
		Resource resource = new UrlResource(pdfPath.toUri());
		String filename = "patrol_report_" + reportId + ".pdf";
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filename + "\"")
				.header(HttpHeaders.CACHE_CONTROL, "no-store")
				.contentType(MediaType.APPLICATION_PDF)
				.body(resource);
	}

	@GetMapping("/internal/pdf/{reportId}")
	public String internalPdfView(@PathVariable("reportId") Long reportId, @RequestParam("token") String token,
			Model model, HttpServletRequest request) {
		if (!isLoopbackRequest(request) || !pdfCacheService.isValidInternalRenderToken(reportId, token)) {
			throw new AccessDeniedException("PDF rendering endpoint is internal only.");
		}
		model.addAttribute("pdfRender", true);
		return detail(reportId, model);
	}

	private boolean isLoopbackRequest(HttpServletRequest request) {
		try {
			return InetAddress.getByName(request.getRemoteAddr()).isLoopbackAddress();
		} catch (Exception ex) {
			return false;
		}
	}

	private void validateRejectedReportOwner(PatrolReportVO reportVO) throws Exception {
		if (reportVO == null) {
			throw new IllegalArgumentException("The patrol report does not exist.");
		}
		if (!"2".equals(reportVO.getConfirmStatus()) || !getCurrentMemberId().equals(reportVO.getMemberId())) {
			throw new AccessDeniedException("Only the drafter can revise a rejected patrol report.");
		}
	}

	private String getCurrentMemberId() {
		String memberId = getOptionalCurrentMemberId();
		if (memberId == null) {
			throw new AccessDeniedException("Authentication is required.");
		}
		return memberId;
	}

	private String getOptionalCurrentMemberId() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getName())) {
			return null;
		}
		Object principal = authentication.getPrincipal();
		if (principal instanceof CustomUser && ((CustomUser) principal).getMember() != null) {
			return ((CustomUser) principal).getMember().getMemberId();
		}
		return authentication.getName();
	}
}

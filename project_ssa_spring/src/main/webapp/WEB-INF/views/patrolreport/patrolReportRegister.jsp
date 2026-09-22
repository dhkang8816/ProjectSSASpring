<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<title>일일 업무 보고서 작성</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #161920;
	color: #ffffff;
	font-family: 'Pretendard', sans-serif;
	padding: 30px;
}

.reg-container {
	background: #222733;
	border: 1px solid #2c313d;
	border-radius: 12px;
	padding: 35px;
	max-width: 650px;
	margin: 30px auto;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
}

.badge-info-tag {
	background: #1a1e29;
	padding: 12px 18px;
	border-radius: 6px;
	border: 1px solid #3d4354;
	font-size: 13px;
	margin-bottom: 25px;
}

.input-box {
	width: 100%;
	background-color: #161920;
	border: 1px solid #48485e;
	color: white;
	border-radius: 6px;
	padding: 12px;
	font-family: inherit;
	font-size: 14px;
}

.input-box:focus {
	border-color: #5ddcff;
	outline: none;
	box-shadow: 0 0 8px rgba(93, 220, 255, 0.2);
}

.style-label {
	font-size: 14px;
	margin-bottom: 8px;
	display: block;
}
</style>
</head>
<body class="popup-page">
	<div class="reg-container">
		<h3
			style="color: #5ddcff; margin-bottom: 20px; font-weight: bold; border-bottom: 1px solid #3d4354; padding-bottom: 12px;">
			일일 관제 업무 보고서 작성</h3>

		<form:form
			action="${pageContext.request.contextPath}/patrolreport/register"
			method="post" modelAttribute="reportVO">
			<c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true" /></c:if>

			
			<div class="badge-info-tag d-flex justify-content-between">
				<div>
					📅 업무일자: <strong class="text-info">당일 시스템 자동 입력 (오늘)</strong>
				</div>
				<div>
					👤 작성자: <strong>${currentMemberName} (${currentDept})</strong>
				</div>
			</div>

			
			<div class="mb-4">
				<label class="style-label"
					style="color: #ffae19; font-weight: bold;">■ 당일 현장 조치 내용</label>
				<form:textarea path="actionTaken" rows="5" class="input-box"
					placeholder="오늘 발생한 관제 구역 정밀 순찰 이력 및 이상 객체 상황 전파 완료 사양을 상세히 입력해 주세요."
					required="required" />
			</div>

			<div class="mb-4">
				<label class="style-label"
					style="color: #ffae19; font-weight: bold;">■ 특이사항 및 비고</label>
				<form:textarea path="remark" rows="3" class="input-box"
					placeholder="드론 배터리/기체 하드웨어 결함 동향 및 정비 사항 등 비고 입력" />
			</div>

			<div
				style="background: #1a1e29; padding: 12px; border-radius: 6px; border-left: 4px solid #2ecc71; margin-bottom: 25px;">
				<p
					style="font-size: 12px; color: #aaa; margin: 0; line-height: 1.5;">
					💡 <strong>안내사항</strong>: 당일 드론 총 비행시간, 탐지 총 건수, 종합 조치율 통계 수치 및
					시간대별 그래프 레코드는 저장 시 백엔드가 자동으로 추출하여 하단 FOOTER 영역에 영구 보존 처리합니다.
				</p>
			</div>

			<div class="mb-4">
				<label class="style-label"
					style="color: #ffae19; font-weight: bold;">결재자 선택</label> <select
					name="approverId" class="input-box" required="required">
					<option value="">결재할 관리자를 선택하세요</option>
					<c:forEach var="approver" items="${approverList}">
						<option value="${approver.memberId}">${approver.name}
							(${approver.memberId})</option>
					</c:forEach>
				</select>
			</div>

			<div class="text-end"
				style="border-top: 1px solid #3d4354; padding-top: 15px;">
				<button type="submit" class="btn btn-success px-4 fw-bold shadow-sm">보고서
					최종 제출</button>
				<button type="button" class="btn btn-secondary px-4 ms-2 shadow-sm"
					onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/patrolreport/list');">작성
					취소</button>
			</div>
		</form:form>
	</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

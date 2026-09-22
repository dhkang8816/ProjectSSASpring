<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>결재 관리</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<style>
body {
	background-color: #0b0f19;
	margin: 0;
	padding: 0;
	overflow-x: hidden;
}

#patrolReportApprovalListPage {
	color: #e2e8f0;
	font-family: 'Segoe UI', Roboto, sans-serif;
}

#patrolReportApprovalListPage.control-page-content {
	position: absolute;
	top: 80px;
	padding: 30px 40px;
	box-sizing: border-box;
	z-index: 50;
}

@media (max-width: 760px) {
	#patrolReportApprovalListPage.control-page-content {
		padding: 20px 16px;
	}
}

#patrolReportApprovalListPage .main-panel {
	overflow-x: auto;
	background: rgba(20, 26, 42, 0.85);
	border: 1px solid #1e293b;
	border-radius: 16px;
	padding: 28px;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	box-sizing: border-box;
}

#patrolReportApprovalListPage .table-zone {
	min-width: 850px;
	width: 100%;
	border-collapse: separate;
	border-spacing: 0;
	margin-top: 20px;
	border: 1px solid #1e293b;
	border-radius: 8px;
	overflow: hidden;
}

#patrolReportApprovalListPage .table-zone th {
	white-space: nowrap;
	background-color: #111827;
	color: #38bdf8;
	padding: 14px 16px;
	border: 0;
	border-bottom: 2px solid #1e293b;
	font-size: 13px;
}

#patrolReportApprovalListPage .table-zone td {
	white-space: nowrap;
	padding: 14px 16px;
	border: 0;
	border-bottom: 1px solid #1e293b;
	text-align: center;
	color: #cbd5e1;
	font-size: 13.5px;
}

#patrolReportApprovalListPage .table-zone tbody tr:hover {
	background-color: rgba(56, 189, 248, 0.08);
}

#patrolReportApprovalListPage .approval-select {
	background: #161920;
	color: #ffffff;
	border: 1px solid #f1c40f;
	border-radius: 4px;
	padding: 5px 8px;
}

#patrolReportApprovalListPage .pagination a {
	color: #5ddcff;
}

#patrolReportApprovalListPage .approval-pagination-wrap {
	text-align: center;
}


</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div id="patrolReportApprovalListPage" class="control-page-content">
		<div class="main-panel">
			<div style="border-bottom: 1px solid #2c313d; padding-bottom: 15px;">
				<h2 style="color: #f1c40f; margin: 0; font-weight: bold;">결재 관리</h2>
				<p style="color: #aaa; margin: 8px 0 0;">승인 대기 업무일지만 표시합니다.</p>
			</div>

			<table class="table-zone" data-csv-export data-csv-filename="patrol-report-approval-list">
				<thead>
					<tr>
						<th>보고서 번호</th>
						<th>업무 일자</th>
						<th>작성자</th>
						<th>비행시간</th>
						<th>탐지 건수</th>
						<th>조치완료율</th>
						<th>결재 처리</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty reportList}">
							<tr>
								<td colspan="7" style="color: #aaa; padding: 50px;">승인 대기 업무일지가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="report" items="${reportList}">
								<tr>
									<td><a data-detail-popup data-popup-name="patrolReportDetail" style="color: #5ddcff;"
										href="${pageContext.request.contextPath}/patrolreport/detail/${report.reportId}">${report.reportId}</a></td>
									<td><fmt:formatDate value="${report.reportDate}"
											pattern="yyyy-MM-dd" /></td>
									<td style="color: #ffae19; font-weight: bold;">${report.memberId}</td>
									<td>${report.totalFlightTime}시간</td>
									<td>${report.totalDetectCount}건</td>
									<td>${report.completionRate}%</td>
									<td><select class="approval-select"
										onchange="fn_changeApprovalStatus(this, ${report.reportId});">
											<option value="">처리 선택</option>
											<option value="1">승인</option>
											<option value="2">반려</option>
									</select></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>

			<c:if test="${pageMaker.totalCount gt 0}">
				<div class="approval-pagination-wrap" style="margin-top: 20px;">
					<ul class="pagination"
						style="display: flex; justify-content: center; gap: 10px; list-style: none; padding: 0;">
						<c:if test="${pageMaker.prev}">
							<li><a
								href="${pageContext.request.contextPath}/patrolreport/approval/list?page=${pageMaker.startPage - 1}">&laquo;
									이전</a></li>
						</c:if>
						<c:forEach var="pageNum" begin="${pageMaker.startPage}"
							end="${pageMaker.endPage}">
							<li><c:choose>
									<c:when test="${pageMaker.page eq pageNum}">
										<strong>${pageNum}</strong>
									</c:when>
									<c:otherwise>
										<a
											href="${pageContext.request.contextPath}/patrolreport/approval/list?page=${pageNum}">${pageNum}</a>
									</c:otherwise>
								</c:choose></li>
						</c:forEach>
						<c:if test="${pageMaker.next}">
							<li><a
								href="${pageContext.request.contextPath}/patrolreport/approval/list?page=${pageMaker.endPage + 1}">?ㅼ쓬
									&raquo;</a></li>
						</c:if>
					</ul>
				</div>
			</c:if>
		</div>
	</div>

	<script>
        function fn_changeApprovalStatus(selectElement, reportId) {
            var confirmStatus = selectElement.value;
            if (!confirmStatus) {
                return;
            }

            if (!window.confirm("선택한 결재 상태로 처리하시겠습니까?")) {
                selectElement.value = "";
                return;
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/patrolreport/updateStatus",
                type: "POST",
                data: { reportId: reportId, confirmStatus: confirmStatus },
                success: function(response) {
                    if (response === "SUCCESS") {
                        window.location.reload();
                    } else {
                        alert("결재 상태 변경에 실패했습니다.");
                        selectElement.value = "";
                    }
                },
                error: function() {
                    alert("결재 상태 변경 중 통신 오류가 발생했습니다.");
                    selectElement.value = "";
                }
            });
        }
    </script>
</body>
</html>

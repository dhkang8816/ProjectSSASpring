<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>보고서 결재 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>

body {
	background-color: #0b0f19 !important; 
	color: #e2e8f0 !important;
	font-family: 'Segoe UI', Roboto, sans-serif;
	margin: 0;
	padding: 0;
	overflow-x: hidden;
}


.control-page-content {
	position: absolute !important;
	top: 80px !important; 
	left: 150px !important; 
	width: calc(100% - 150px) !important; 
	padding: 30px 40px;
	box-sizing: border-box;
	z-index: 50 !important;
}

@media ( max-width : 760px) {
	.control-page-content {
		left: 0 !important;
		width: 100% !important;
		padding: 20px 16px;
	}
}


.panel {
	background: rgba(20, 26, 42, 0.85) !important;
	border: 1px solid #1e293b !important;
	border-radius: 16px !important;
	padding: 28px !important;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4) !important;
	backdrop-filter: blur(4px);
	width: 100%;
	box-sizing: border-box;
}

.panel h2 {
	color: #ffffff !important;
	margin: 0 0 6px 0 !important;
	font-size: 20px !important;
	font-weight: 700 !important;
	letter-spacing: -0.02em;
}

.panel p {
	color: #94a3b8 !important;
	font-size: 13.5px;
	margin: 0 0 24px 0;
}


table {
	width: 100%;
	border-collapse: separate !important;
	border-spacing: 0 !important;
	margin-top: 16px;
	background-color: transparent !important;
	box-shadow: none !important;
	border: 1px solid #1e293b !important;
	border-radius: 8px;
	overflow: hidden;
}

th {
	background-color: #111827 !important; 
	color: #38bdf8 !important; 
	padding: 14px 16px !important;
	border: 0 !important;
	border-bottom: 2px solid #1e293b !important;
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; 
}

td {
	padding: 14px 16px !important;
	background-color: transparent !important;
	color: #cbd5e1 !important;
	border: 0 !important;
	border-bottom: 1px solid #1e293b !important;
	text-align: center !important;
	font-size: 13.5px;
}


tr {
	transition: background-color 0.15s ease;
}

tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}


a {
	color: #38bdf8 !important;
	text-decoration: none !important;
	font-weight: 600;
}

a:hover {
	color: #7dd3fc !important;
	text-decoration: underline !important;
}


.btn-action-link {
	display: inline-block;
	padding: 5px 12px;
	background-color: #1e293b;
	color: #cbd5e1 !important;
	border: 1px solid #334155;
	border-radius: 6px;
	font-size: 12px;
	font-weight: 600;
	transition: all 0.15s;
}

.btn-action-link:hover {
	background-color: #0ea5e9;
	color: #ffffff !important;
	border-color: #38bdf8;
	text-decoration: none !important;
}


.badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important; 
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}

.pending {
	background-color: rgba(245, 158, 11, 0.15) !important;
	color: #f59e0b !important;
	border: 1px solid rgba(245, 158, 11, 0.3) !important;
}

.approved {
	background-color: rgba(16, 185, 129, 0.15) !important;
	color: #10b981 !important;
	border: 1px solid rgba(16, 185, 129, 0.3) !important;
}

.rejected {
	background-color: rgba(239, 68, 68, 0.15) !important;
	color: #ef4444 !important;
	border: 1px solid rgba(239, 68, 68, 0.3) !important;
}


.pagination {
	display: flex;
	justify-content: center;
	gap: 6px;
	list-style: none;
	padding: 0;
	margin: 25px 0 0 0 !important;
}

.pagination a, .pagination strong {
	display: block;
	padding: 6px 12px;
	background: #111827 !important;
	color: #94a3b8 !important;
	border: 1px solid #1e293b;
	border-radius: 6px;
	text-decoration: none;
	font-size: 13px;
	font-weight: 600;
	transition: all 0.15s;
}

.pagination a:hover {
	color: #ffffff !important;
	background: #1f2937 !important;
	border-color: #334155;
}

.pagination strong {
	color: #38bdf8 !important; 
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9;
}


.panel {
	display: grid !important;
	grid-template-columns: 1fr;
	grid-template-areas: "title" "summary" "table" "pager";
	gap: 20px;
	padding: 0 !important;
	background: transparent !important;
	border: 0 !important;
	box-shadow: none !important;
	overflow-x: auto;
}

.panel>h2 {
	grid-area: title;
	margin: 0 !important;
	padding: 0 0 16px;
	border-bottom: 1px solid #1e293b;
	color: #fff !important;
	font-size: 22px !important;
}

.panel > .staff-list-summary {
    grid-area: summary;
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    color: #94a3b8;
    font-size: 14px;
    font-weight: 500;
}

.panel>.staff-list-summary strong {
	color: #38bdf8;
	background: rgba(56, 189, 248, .1);
	border-radius: 4px;
	padding: 2px 6px;
}

.panel>table {
	grid-area: table;
	min-width: 850px;
	margin: 0 !important;
}

.panel>table th, .panel>table td {
	white-space: nowrap;
}

.panel>.pager {
	grid-area: pager;
	justify-self: center;
}


</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div id="workFlowListPage" class="control-page-content">
		<div class="panel">
			<h2>보고서 결재 관리</h2>
			<div class="staff-list-summary">
			    <div>총 <strong>${pageMaker.totalCount}</strong>건</div>
			    
			    <button class="csv-download-btn neon-theme" onclick="downloadTableAsCsv('#workflowTable', 'workflow-list')">
			        <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i>
			        CSV
			    </button>
			</div>
			<table id="workflowTable" data-csv-export data-csv-filename="workflow-list">
				<thead>
					<tr>
						<th>결재 번호</th>
						<th>기안자</th>
						<th>요청일</th>
						<th>보고서</th>
						<th>작업</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty workflowList}">
							<tr>
								<td colspan="6"
									style="color: #64748b; padding: 60px; font-size: 14px;">배정된
									결재 문서가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="workflow" items="${workflowList}">
								<tr>
									
									<td>${workflow.approvalId}</td>

									
									<td>${workflow.drafterName}(${workflow.drafterId})</td>

									
									<td><fmt:formatDate value="${workflow.requestDate}"
											pattern="yyyy-MM-dd HH:mm" /></td>

									
									<td><a class="btn-action-link"
										style="background-color: #242b35 !important; border-color: #3e4b5b !important; color: #38bdf8 !important; transition: all 0.15s ease;"
										onmouseover="this.style.backgroundColor='#0ea5e9'; this.style.borderColor='#38bdf8'; this.style.color='#ffffff';"
										onmouseout="this.style.backgroundColor='#242b35'; this.style.borderColor='#3e4b5b'; this.style.color='#38bdf8';"
										data-detail-popup data-popup-name="patrolReportDetail"
										href="${pageContext.request.contextPath}/patrolreport/detail/${workflow.reportId}">
											📄 #${workflow.reportId} 보고서 </a></td>

									
									<td><a class="btn-action-link"
										style="background-color: #1e293b !important; border-color: #334155 !important; color: #cbd5e1 !important; transition: all 0.15s ease;"
										onmouseover="this.style.backgroundColor='#0ea5e9'; this.style.borderColor='#38bdf8'; this.style.color='#ffffff';"
										onmouseout="this.style.backgroundColor='#1e293b'; this.style.borderColor='#334155'; this.style.color='#cbd5e1';"
										data-detail-popup data-popup-name="workFlowDetail"
										href="${pageContext.request.contextPath}/workflow/detail/${workflow.approvalId}">
											상세/처리 </a></td>

									
									<td><c:choose>
											<c:when test="${workflow.appStatus eq '0'}">
												<span class="badge-status pending">승인 대기</span>
											</c:when>
											<c:when test="${workflow.appStatus eq '1'}">
												<span class="badge-status approved">승인 완료</span>
											</c:when>
											<c:otherwise>
												<span class="badge-status rejected">반려</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>

			
			<c:if test="${pageMaker.totalCount gt 0}">
				<div class="pager">
					<ul class="pagination">
						<c:if test="${pageMaker.prev}">
							<li><a
								href="${pageContext.request.contextPath}/workflow/list?page=${pageMaker.startPage - 1}">이전</a>
							</li>
						</c:if>
						<c:forEach begin="${pageMaker.startPage}"
							end="${pageMaker.endPage}" var="num">
							<li><c:choose>
									<c:when test="${pageMaker.page eq num}">
										<strong>${num}</strong>
									</c:when>
									<c:otherwise>
										<a
											href="${pageContext.request.contextPath}/workflow/list?page=${num}">${num}</a>
									</c:otherwise>
								</c:choose></li>
						</c:forEach>
						<c:if test="${pageMaker.next}">
							<li><a
								href="${pageContext.request.contextPath}/workflow/list?page=${pageMaker.endPage + 1}">다음</a>
							</li>
						</c:if>
					</ul>
				</div>
			</c:if>

		</div>
	</div>

</body>
</html>

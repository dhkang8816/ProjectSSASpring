<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>보고서 결재 관리</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>

#workFlowListPage.control-page-content {
	position: absolute !important;
	top: 80px !important; 
	padding: 30px 40px;
	box-sizing: border-box;
	z-index: 50 !important;
}

@media ( max-width : 760px) {
	#workFlowListPage.control-page-content {
		padding: 20px 16px;
	}
}


#workFlowListPage .panel {
	background: rgba(20, 26, 42, 0.85) !important;
	border: 1px solid #1e293b !important;
	border-radius: 16px !important;
	padding: 28px !important;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4) !important;
	backdrop-filter: blur(4px);
	width: 100%;
	box-sizing: border-box;
}

#workFlowListPage .panel h2 {
	color: #ffffff !important;
	margin: 0 0 6px 0 !important;
	font-size: 20px !important;
	font-weight: 700 !important;
	letter-spacing: -0.02em;
}

#workFlowListPage .panel p {
	color: #94a3b8 !important;
	font-size: 13.5px;
	margin: 0 0 24px 0;
}


#workFlowListPage table {
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

#workFlowListPage th {
	background-color: #111827 !important; 
	color: #38bdf8 !important; 
	padding: 14px 16px !important;
	border: 0 !important;
	border-bottom: 2px solid #1e293b !important;
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; 
}

#workFlowListPage td {
	padding: 14px 16px !important;
	background-color: transparent !important;
	color: #cbd5e1 !important;
	border: 0 !important;
	border-bottom: 1px solid #1e293b !important;
	text-align: center !important;
	font-size: 13.5px;
}


#workFlowListPage tr {
	transition: background-color 0.15s ease;
}

#workFlowListPage tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}


#workFlowListPage a {
	color: #38bdf8 !important;
	text-decoration: none !important;
	font-weight: 600;
}

#workFlowListPage a:hover {
	color: #7dd3fc !important;
	text-decoration: underline !important;
}


#workFlowListPage .btn-action-link {
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

#workFlowListPage .btn-action-link:hover {
	background-color: #0ea5e9;
	color: #ffffff !important;
	border-color: #38bdf8;
	text-decoration: none !important;
}


#workFlowListPage .badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important; 
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}

#workFlowListPage .status-0 {
	background-color: rgba(245, 158, 11, 0.15) !important;
	color: #f59e0b !important;
	border: 1px solid rgba(245, 158, 11, 0.3) !important;
}

#workFlowListPage .status-1 {
	background-color: rgba(16, 185, 129, 0.15) !important;
	color: #10b981 !important;
	border: 1px solid rgba(16, 185, 129, 0.3) !important;
}

#workFlowListPage .status-2 {
	background-color: rgba(239, 68, 68, 0.15) !important;
	color: #ef4444 !important;
	border: 1px solid rgba(239, 68, 68, 0.3) !important;
}


#workFlowListPage .pagination {
	display: flex;
	justify-content: center;
	gap: 6px;
	list-style: none;
	padding: 0;
	margin: 25px 0 0 0 !important;
}

#workFlowListPage .pagination a, #workFlowListPage .pagination strong {
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

#workFlowListPage .pagination a:hover {
	color: #ffffff !important;
	background: #1f2937 !important;
	border-color: #334155;
}

#workFlowListPage .pagination strong {
	color: #38bdf8 !important; 
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9;
}


#workFlowListPage .panel {
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

#workFlowListPage .panel>h2 {
	grid-area: title;
	margin: 0 !important;
	padding: 0 0 16px;
	border-bottom: 1px solid #1e293b;
	color: #fff !important;
	font-size: 22px !important;
}

#workFlowListPage .panel > .staff-list-summary {
    grid-area: summary;
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    color: #94a3b8;
    font-size: 14px;
    font-weight: 500;
}

#workFlowListPage .workflow-list-actions {
	display: inline-flex;
	align-items: center;
	justify-content: flex-end;
	gap: 8px;
}

#workFlowListPage .workflow-search-form {
	display: inline-flex;
	align-items: center;
	gap: 6px;
}

#workFlowListPage .workflow-search-form select,
#workFlowListPage .workflow-search-form input {
	height: 38px;
	border: 1px solid #334155;
	border-radius: 7px;
	background: #111827;
	color: #e2e8f0;
	font-size: 13px;
}

#workFlowListPage .workflow-search-form select {
	min-width: 100px;
	padding: 0 9px;
}

#workFlowListPage .workflow-search-form input {
	width: 180px;
	padding: 0 10px;
}

#workFlowListPage .workflow-search-button {
	height: 38px;
	padding: 0 13px;
	border: 1px solid #38bdf8;
	border-radius: 7px;
	background: #0ea5e9;
	color: #ffffff;
	font-size: 13px;
	font-weight: 700;
	cursor: pointer;
}

#workFlowListPage .workflow-search-button:hover {
	background: #0284c7;
}

#workFlowListPage .panel>.staff-list-summary strong {
	color: #38bdf8;
	background: rgba(56, 189, 248, .1);
	border-radius: 4px;
	padding: 2px 6px;
}

#workFlowListPage .panel>table {
	grid-area: table;
	min-width: 900px;
	margin: 0 !important;
}

#workFlowListPage .panel>table th, #workFlowListPage .panel>table td {
	white-space: nowrap;
}

#workFlowListPage .panel>.pager {
	grid-area: pager;
	justify-self: center;
}

#workFlowListPage .confirmation-filter-header {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 7px;
}

#workFlowListPage .confirm-filter-toggle {
	padding: 4px 8px;
	border: 1px solid #475569;
	border-radius: 6px;
	background: #172033;
	color: #cbd5e1;
	font-size: 11px;
	font-weight: 700;
	cursor: pointer;
}

#workFlowListPage .confirm-filter-toggle:hover,
#workFlowListPage .confirm-filter-toggle[aria-expanded="true"] {
	border-color: #38bdf8;
	background: #0f3146;
	color: #7dd3fc;
}

#workflowConfirmFilterMenu[hidden] {
	display: none;
}

#workflowConfirmFilterMenu {
	position: fixed;
	min-width: 174px;
	padding: 8px;
	border: 1px solid #334155;
	border-radius: 8px;
	background: #111827;
	box-shadow: 0 12px 28px rgba(0, 0, 0, .42);
	z-index: 10050;
}

#workflowConfirmFilterMenu .filter-menu-caption {
	display: block;
	padding: 5px 7px 8px;
	color: #94a3b8;
	font-size: 11px;
}

#workflowConfirmFilterMenu button {
	display: block;
	width: 100%;
	padding: 8px 9px;
	border: 0;
	border-radius: 5px;
	background: transparent;
	color: #cbd5e1;
	font-size: 12px;
	font-weight: 700;
	text-align: left;
	cursor: pointer;
}

#workflowConfirmFilterMenu button:hover,
#workflowConfirmFilterMenu button.is-active {
	background: #0f3146;
	color: #7dd3fc;
}

@media (max-width: 760px) {
	#workFlowListPage .staff-list-summary,
	#workFlowListPage .workflow-list-actions,
	#workFlowListPage .workflow-search-form {
		width: 100%;
		flex-wrap: wrap;
	}
	#workFlowListPage .workflow-search-form input {
		flex: 1;
		width: auto;
	}
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
			    <div class="workflow-list-actions">
			        <form class="workflow-search-form" method="get" action="${pageContext.request.contextPath}/workflow/list">
			            <input type="hidden" name="confirmStatus" value="<c:out value='${pageMaker.confirmStatus}'/>" />
			            <select name="searchType" aria-label="검색 기준">
			                <option value="a" ${pageMaker.searchType eq 'a' ? 'selected' : ''}>결재 번호</option>
			                <option value="d" ${pageMaker.searchType eq 'd' ? 'selected' : ''}>기안자</option>
			                <option value="r" ${pageMaker.searchType eq 'r' ? 'selected' : ''}>보고서 번호</option>
			            </select>
			            <input type="search" name="keyword" value="<c:out value='${pageMaker.keyword}'/>" placeholder="검색어 입력" aria-label="검색어" />
			            <button type="submit" class="workflow-search-button">검색</button>
			        </form>
			        <button class="csv-download-btn neon-theme" onclick="downloadTableAsCsv('#workflowTable', 'workflow-list')">
			            <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i>
			            CSV
			        </button>
			    </div>
			</div>
			<table id="workflowTable" data-csv-export data-csv-filename="workflow-list">
				<thead>
					<tr>
						<th>결재 번호</th>
						<th>기안자</th>
						<th>요청일</th>
						<th>보고서</th>
						<th>작업</th>
						<th>
							<div class="confirmation-filter-header">
								<span>승인 여부</span>
								<button type="button" id="workflowConfirmFilterButton" class="confirm-filter-toggle"
									aria-expanded="false" aria-controls="workflowConfirmFilterMenu">승인 필터</button>
							</div>
						</th>
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

									
									<td>
										<c:forEach var="confirmStatus" items="${confirmStatusList}">
											<c:if test="${workflow.appStatus eq confirmStatus.code}">
												<span class="badge-status status-${confirmStatus.code}">${confirmStatus.codeName}</span>
											</c:if>
										</c:forEach>
									</td>
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
								href="${pageContext.request.contextPath}/workflow/list?page=${pageMaker.startPage - 1}&amp;searchType=${pageMaker.searchType}&amp;keyword=<c:out value='${pageMaker.keyword}'/>&amp;confirmStatus=<c:out value='${pageMaker.confirmStatus}'/>">이전</a>
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
										href="${pageContext.request.contextPath}/workflow/list?page=${num}&amp;searchType=${pageMaker.searchType}&amp;keyword=<c:out value='${pageMaker.keyword}'/>&amp;confirmStatus=<c:out value='${pageMaker.confirmStatus}'/>">${num}</a>
									</c:otherwise>
								</c:choose></li>
						</c:forEach>
						<c:if test="${pageMaker.next}">
							<li><a
								href="${pageContext.request.contextPath}/workflow/list?page=${pageMaker.endPage + 1}&amp;searchType=${pageMaker.searchType}&amp;keyword=<c:out value='${pageMaker.keyword}'/>&amp;confirmStatus=<c:out value='${pageMaker.confirmStatus}'/>">다음</a>
							</li>
						</c:if>
					</ul>
				</div>
			</c:if>

		</div>
	</div>

	<div id="workflowConfirmFilterMenu" hidden="hidden" role="menu" aria-label="승인 상태 필터">
		<span class="filter-menu-caption">승인 상태</span>
		<button type="button" role="menuitem" class="${empty pageMaker.confirmStatus ? 'is-active' : ''}" data-confirm-status="">전체</button>
		<c:forEach var="confirmStatus" items="${confirmStatusList}">
			<button type="button" role="menuitem" class="${pageMaker.confirmStatus eq confirmStatus.code ? 'is-active' : ''}" data-confirm-status="${confirmStatus.code}">${confirmStatus.codeName}</button>
		</c:forEach>
	</div>

<script>
(function () {
	var filterButton = document.getElementById('workflowConfirmFilterButton');
	var filterMenu = document.getElementById('workflowConfirmFilterMenu');

	function closeFilterMenu() {
		filterMenu.hidden = true;
		filterButton.setAttribute('aria-expanded', 'false');
	}

	function openFilterMenu() {
		filterMenu.hidden = false;
		var buttonRect = filterButton.getBoundingClientRect();
		var left = Math.min(buttonRect.left, window.innerWidth - filterMenu.offsetWidth - 12);
		filterMenu.style.top = (buttonRect.bottom + 6) + 'px';
		filterMenu.style.left = Math.max(12, left) + 'px';
		filterButton.setAttribute('aria-expanded', 'true');
	}

	filterButton.addEventListener('click', function () {
		if (filterMenu.hidden) {
			openFilterMenu();
		} else {
			closeFilterMenu();
		}
	});

	filterMenu.addEventListener('click', function (event) {
		var option = event.target.closest('button[data-confirm-status]');
		if (!option) {
			return;
		}
		var url = new URL(window.location.href);
		url.searchParams.set('page', '1');
		if (option.dataset.confirmStatus) {
			url.searchParams.set('confirmStatus', option.dataset.confirmStatus);
		} else {
			url.searchParams.delete('confirmStatus');
		}
		window.location.assign(url.toString());
	});

	document.addEventListener('click', function (event) {
		if (!filterMenu.hidden && !filterMenu.contains(event.target) && !filterButton.contains(event.target)) {
			closeFilterMenu();
		}
	});

	document.addEventListener('keydown', function (event) {
		if (event.key === 'Escape' && !filterMenu.hidden) {
			closeFilterMenu();
			filterButton.focus();
		}
	});
}());
</script>
</body>
</html>

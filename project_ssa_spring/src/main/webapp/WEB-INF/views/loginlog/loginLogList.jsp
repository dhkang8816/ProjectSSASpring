<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 이력</title>

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


.main-container {
	display: block !important; 
	margin-top: 0 !important;
}

#menu-placeholder {
	display: none !important;
	width: 0 !important;
}


.content-area {
    position: absolute !important;
    top: 80px !important; 
    left: 200px !important; 
    width: calc(100% - 200px) !important;
    padding: 30px 40px !important;
    background: transparent !important;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media ( max-width : 760px) {
	.content-area {
		left: 0 !important;
		width: 100% !important;
		padding: 20px 16px !important;
	}
}


.staff-top-bar, .staff-summary-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	gap: 16px;
	width: 100%;
}

.staff-top-bar .page-title {
	margin: 0;
	color: #ffffff !important;
	font-size: 22px;
	font-weight: 700;
	letter-spacing: -0.02em;
}


.staff-count {
	color: #94a3b8 !important;
	font-size: 14px;
	font-weight: 500;
}

.staff-count .count-num {
	color: #38bdf8 !important; 
	font-weight: 700;
	background: rgba(56, 189, 248, 0.1);
	padding: 2px 6px;
	border-radius: 4px;
}


.staff-table-wrapper {
	overflow-x: auto;
	overflow-y: hidden;
	width: 100%;
}

.staff-table {
	width: 100%;
	min-width: 850px;
	border-collapse: separate !important;
	border-spacing: 0 !important;
	background-color: transparent !important;
	box-shadow: none !important;
	border: 1px solid #1e293b !important;
	border-radius: 8px;
	overflow: hidden;
}

.staff-table th {
	white-space: nowrap;
	padding: 14px 16px !important;
	background: #111827 !important; 
	border: 0 !important;
	border-bottom: 2px solid #1e293b !important;
	color: #38bdf8 !important; 
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; 
}

.staff-table td {
	white-space: nowrap;
	padding: 12px 16px !important;
	/* Keep the list rows flush with the page, like flightHistoryList. */
	background-color: #0b0f19 !important;
	border: 0 !important;
	border-bottom: 1px solid #1e293b !important;
	color: #cbd5e1 !important;
	font-size: 13.5px;
	text-align: center !important; 
}


.staff-table tbody tr {
	transition: background-color 0s ease;
}

.staff-table tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}


.badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important; 
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}

.status-success {
	background-color: rgba(16, 185, 129, 0.15) !important;
	color: #10b981 !important;
	border: 1px solid rgba(16, 185, 129, 0.3) !important;
} 
.status-fail {
	background-color: rgba(239, 68, 68, 0.15) !important;
	color: #ef4444 !important;
	border: 1px solid rgba(239, 68, 68, 0.3) !important;
} 


.loginlog-pagination {
	display: flex;
	justify-content: center;
	margin-top: 25px;
	width: 100%;
}

.pagination {
	display: flex;
	list-style: none;
	padding-left: 0;
	gap: 6px;
	margin: 0;
}

.pagination li a, .pagination li strong {
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

.pagination li a:hover {
	color: #ffffff !important;
	background: #1f2937 !important;
	border-color: #334155;
}

.pagination li.active strong {
	color: #38bdf8 !important;
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9 !important;
}


.staff-top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    gap: 16px;
    width: 100%;
}

.search-group form {
    display: flex;
    gap: 6px;
    align-items: center;
}

.search-group select {
    padding: 9px 12px !important;
    background-color: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    font-size: 13.5px;
    outline: none;
}

.search-group .search-input {
    width: 200px !important;
    padding: 9px 16px !important;
    background: #111827 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    color: #ffffff !important;
    font-size: 13.5px;
    outline: none;
}

.search-group .search-input:focus, .search-group select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}

.btn-search-submit {
    padding: 9px 18px !important;
    border: 0 !important;
    border-radius: 8px !important;
    background: #0ea5e9 !important;
    color: #ffffff !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

.btn-search-submit:hover {
    background: #0284c7 !important;
    transform: translateY(-1px);
}


</style>
</head>
<body class="login-page">

	
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<jsp:include page="/WEB-INF/views/menu.jsp" />

	<div id="loginLogListPage" class="main-container">
		
<main class="content-area">

			<!-- ⭐ 상단 영역 (타이틀 + 검색창을 한 줄에 배치) -->
			<div class="staff-top-bar">
				<h2 class="page-title">로그인 이력</h2>
				
				<div class="search-group">
					<form:form action="list" method="get">
						<select name="searchType">
							<option value="m" ${pageMaker.searchType == 'm' ? 'selected' : ''}>사번</option>
							<option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>결과 상태</option>
						</select>
						<input type="text" name="keyword" value="${pageMaker.keyword}" class="search-input" placeholder="검색어 입력">
						<button type="submit" class="btn-search-submit">검색</button>
					</form:form>
				</div>
			</div>

			<!-- 요약 바 (전체 이력 수 + CSV 버튼) -->
			<div class="staff-summary-bar">
				<div class="staff-count">
					전체 이력 수: <span class="count-num">${pageMaker.totalCount}</span> 건
				</div>
				<button class="csv-download-btn neon-theme"
					onclick="downloadTableAsCsv('#loginLogTable', 'login-log-list')">
					<i class="fa-solid fa-file-csv" style="font-size: 14px;"></i> CSV
				</button>
			</div>

			
			<div class="staff-table-wrapper">
				<table id="loginLogTable" class="staff-table" data-csv-export
					data-csv-filename="login-log-list">
					<thead>
						<tr>
							<th style="width: 120px;">로그 번호</th>
							<th style="width: 180px;">사번(아이디)</th>
							<th>요청 IP 주소</th>
							<th>로그인 시도 일시</th>
							<th style="width: 150px;">인증 결과</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${empty loginLogList}">
								<tr>
									<td colspan="5"
										style="color: #64748b; padding: 60px; font-size: 14px;">기록된
										로그인 인증 이력이 존재하지 않습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach var="log" items="${loginLogList}">
									<tr>
										<td><strong>${log.logId}</strong></td>
										<td style="color: #38bdf8; font-weight: 600;"><c:out
												value="${log.memberId}" /></td>
										<td><code>${log.loginIp}</code></td>
										<td><fmt:formatDate value="${log.loginDate}"
												pattern="yyyy-MM-dd HH:mm:ss" /></td>
										<td>
											 <c:choose>
												<c:when test="${log.loginStatus eq 'SUCCESS'}">
													<span class="badge-status status-success">성공</span>
												</c:when>
												<c:otherwise>
													<span class="badge-status status-fail">실패</span>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			

			
			<div class="loginlog-pagination">
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li><a
							href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo;
								이전</a></li>
					</c:if>
					<c:forEach var="pageNum" begin="${pageMaker.startPage}"
						end="${pageMaker.endPage}">
						<li class="${pageMaker.page == pageNum ? 'active' : ''}"><c:choose>
								<c:when test="${pageMaker.page == pageNum}">
									<strong>${pageNum}</strong>
								</c:when>
								<c:otherwise>
									<a
										href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
								</c:otherwise>
							</c:choose></li>
					</c:forEach>
					<c:if test="${pageMaker.next}">
						<li><a
							href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음
								&raquo;</a></li>
					</c:if>
				</ul>
			</div>

		</main>
	</div>

	
	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>

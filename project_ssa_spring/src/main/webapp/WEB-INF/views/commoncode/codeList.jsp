<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>공통코드 목록</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>

body {
	background-color: #0b0f19 !important; 
	color: #e2e8f0 !important;
	font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
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
	border-radius: 16px;
	padding: 28px !important;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	backdrop-filter: blur(4px);
	width: 100%;
	box-sizing: border-box;
}

.panel h2 {
	color: #ffffff;
	margin: 0 0 6px 0 !important;
	font-size: 20px;
	font-weight: 700;
	letter-spacing: -0.02em;
	text-align: left;
}

.panel p {
	color: #94a3b8 !important;
	font-size: 13.5px;
	margin: 0 0 24px 0;
}


.search-box {
	margin: 20px 0;
	padding: 20px;
	background: rgba(17, 24, 39, 0.6) !important;
	border: 1px solid #1e293b !important;
	border-radius: 12px;
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
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; 
	border: 0 !important;
	border-bottom: 2px solid #1e293b !important;
}

td {
	padding: 12px 16px !important;
	background-color: transparent !important;
	color: #cbd5e1 !important;
	font-size: 13.5px;
	text-align: center !important; 
	border: 0 !important;
	border-bottom: 1px solid #1e293b !important;
}


tr {
	transition: background-color 0s ease;
}

tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}

.no-data {
	padding: 60px !important;
	color: #64748b !important;
	font-size: 14px;
}


form {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	align-items: center;
	color: #cbd5e1;
	font-size: 13.5px;
}

input[type="text"], select {
	padding: 8px 12px;
	background: #111827 !important;
	color: #ffffff !important;
	border: 1px solid #334155 !important;
	border-radius: 6px;
	outline: none;
	font-size: 13.5px;
	transition: all 0.15s ease;
}

input[type="text"]:focus, select:focus {
	border-color: #0ea5e9 !important;
	box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}


a.main-link {
	color: #38bdf8 !important;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
	margin-top: 20px;
	transition: color 0.15s ease;
}

a.main-link:hover {
	color: #7dd3fc !important;
	text-decoration: underline !important;
}


button {
	padding: 9px 16px;
	border: 0;
	border-radius: 8px !important;
	font-weight: 700;
	font-size: 13.5px;
	cursor: pointer;
	transition: all 0.15s ease;
}


button.btn-register {
	background-color: #10b981 !important;
	color: #ffffff !important;
}

button.btn-register:hover {
	background-color: #059669 !important;
}


button.btn-search {
	background-color: #0ea5e9 !important;
	color: #ffffff !important;
}

button.btn-search:hover {
	background-color: #0284c7 !important;
}


.badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important;
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}


.badge-status.active-y {
	background-color: rgba(16, 185, 129, 0.15) !important;
	color: #10b981 !important;
	border: 1px solid rgba(16, 185, 129, 0.3) !important;
}


.badge-status.active-n {
	background-color: rgba(239, 68, 68, 0.15) !important;
	color: #ef4444 !important;
	border: 1px solid rgba(239, 68, 68, 0.3) !important;
}


.pagination {
	display: flex;
	list-style: none;
	gap: 6px;
	justify-content: center;
	padding: 0;
	margin: 25px 0 0 0 !important;
}

.pagination li {
	margin: 0 !important;
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


.pagination li.active strong, .pagination strong {
	color: #38bdf8 !important;
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9 !important;
}

@media ( max-width : 760px) {
	table {
		display: block;
		overflow-x: auto;
		white-space: nowrap;
	}
}

.panel {
	display: grid !important;
	grid-template-columns: minmax(180px, 1fr) auto;
	grid-template-areas: "title search" "summary action" "table table"
		"pager pager";
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

.panel>br, .panel>p:not(.staff-list-summary) {
	display: none;
}

.panel>.staff-list-summary {
	grid-area: summary;
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

.panel>.search-box, .panel>form {
	grid-area: search;
	justify-self: end;
	margin: 0 !important;
}

.panel>.btn-register {
	grid-area: action;
	justify-self: end;
	margin: 0 !important;
}

.panel>table {
	grid-area: table;
	min-width: 850px;
	margin: 0 !important;
}

.panel>table th, .panel>table td {
	white-space: nowrap;
}

.panel>div[style*="margin-top"], .panel>.pagination {
	grid-area: pager;
	justify-self: center;
	margin: 0 !important;
}

@media ( max-width : 760px) {
	.panel {
		grid-template-columns: 1fr;
		grid-template-areas: "title" "search" "summary" "action" "table" "pager";
	}
	.panel>.search-box, .panel>form, .panel>.btn-register {
		justify-self: stretch;
	}
}


</style>
</head>
<body>
	
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	
	<div id="codeListPage" class="control-page-content">
		<div class="panel">
			<h2>시스템 코드</h2>

			
			<div class="staff-summary-bar"
			     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important;">
			     
			    
			    <div class="staff-count" style="display: inline-block !important; color: #94a3b8 !important;">
			        총 <strong>${pageMaker.totalCount}</strong>건
			    </div>
			    
			    
			    <div class="summary-action-group" style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important;">
			        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#codeTable', 'code-list')"
			                style="float: none !important; margin: 0 !important; display: inline-flex !important; white-space: nowrap !important;">
			            <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i> CSV
			        </button>
			        <button type="button" class="btn-register"
			                onclick="return openFormPopup('${pageContext.request.contextPath}/commoncode/registerForm', 'codeRegister');"
			                style="float: none !important; margin: 0 !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; white-space: nowrap !important; height: auto !important; padding: 9px 16px !important;">
			            신규 코드 등록
			        </button>
			    </div>
			</div>


			
			<p>
				현재 페이지: <strong>${pageMaker.page}</strong> | 검색된 총 데이터 개수: <strong>${pageMaker.totalCount}개</strong>
			</p>

			
			<table id="codeTable" data-csv-export data-csv-filename="code-list">
				<thead>
					<tr>
						<th>번호</th>
						<th>그룹코드</th>
						<th>상세코드</th>
						<th>코드명칭</th>
						<th>정렬순서</th>
						<th>사용여부</th>
						<th>등록일자</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty codeList}">
							<c:forEach var="cc" items="${codeList}" varStatus="status">
								
								<tr style="cursor: pointer;"
									onclick="return openDetailPopup('${pageContext.request.contextPath}/commoncode/detail?grpCode=${cc.grpCode}&code=${cc.code}', 'codeDetail');">
									<td>${status.count}</td>
									<td>${cc.grpCode}</td>
									<td>${cc.code}</td>
									
									<td style="text-align: left; padding-left: 15px;">${cc.codeName}</td>
									<td>${cc.sortSeq}</td>
									
									<td><c:choose>
											<c:when test="${cc.useYn eq 'Y'}">
												<span class="badge-status active-y">Y</span>
											</c:when>
											<c:otherwise>
												<span class="badge-status active-n">N</span>
											</c:otherwise>
										</c:choose></td>
									<td><fmt:formatDate value="${cc.codeDate}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="7" class="no-data">조회된 데이터가 없습니다. DB에 값이 들어있는지
									확인하세요.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			
			<div class="search-box">
				<form action="${pageContext.request.contextPath}/commoncode/list"
					method="get">
					그룹코드: <select name="searchGrpCode">
						<option value="">전체</option>
						<c:forEach var="groupCode" items="${groupCodes}">
							<option value="${groupCode}"
								${pageMaker.searchGrpCode == groupCode ? 'selected' : ''}>${groupCode}</option>
						</c:forEach>
					</select> 코드이름: <input type="text" name="searchKeyword"
						value="${pageMaker.searchKeyword}"> 사용여부: <select
						name="searchUseYn">
						<option value="">전체</option>
						<option value="Y"
							${pageMaker.searchUseYn == 'Y' ? 'selected' : ''}>Y</option>
						<option value="N"
							${pageMaker.searchUseYn == 'N' ? 'selected' : ''}>N</option>
					</select>
					<button type="submit" class="btn-search">검색</button>
				</form>
			</div>
			
			<ul class="pagination">
				<c:if test="${pageMaker.prev}">
					<li><a
						href="list?page=${pageMaker.startPage - 1}&searchGrpCode=${pageMaker.searchGrpCode}&searchKeyword=${pageMaker.searchKeyword}&searchUseYn=${pageMaker.searchUseYn}">&laquo;
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
									href="list?page=${pageNum}&searchGrpCode=${pageMaker.searchGrpCode}&searchKeyword=${pageMaker.searchKeyword}&searchUseYn=${pageMaker.searchUseYn}">${pageNum}</a>
							</c:otherwise>
						</c:choose></li>
				</c:forEach>
				<c:if test="${pageMaker.next}">
					<li><a
						href="list?page=${pageMaker.endPage + 1}&searchGrpCode=${pageMaker.searchGrpCode}&searchKeyword=${pageMaker.searchKeyword}&searchUseYn=${pageMaker.searchUseYn}">다음
							&raquo;</a></li>
				</c:if>
			</ul>
		</div>
	</div>
</body>
</html>

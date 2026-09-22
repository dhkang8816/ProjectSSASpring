<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>드론 비행 이력 목록</title>
<style>

body {
	background-color: #0b0f19 !important; 
	margin: 0;
	padding: 0;
	overflow-x: hidden;
}

#flightHistoryListPage {
	color: #e2e8f0;
	font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
}

#flightHistoryListPage.control-page-content {
	position: absolute !important;
	top: 80px !important;
	padding: 30px 40px;
	box-sizing: border-box;
	z-index: 50 !important;
}

@media ( max-width : 760px) {
	#flightHistoryListPage.control-page-content {
		padding: 20px 16px;
	}
}


#flightHistoryListPage .panel {
	background: rgba(20, 26, 42, 0.85) !important;
	border: 1px solid #1e293b !important;
	border-radius: 16px;
	padding: 28px !important;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	backdrop-filter: blur(4px);
	width: 100%;
	box-sizing: border-box;
}

#flightHistoryListPage .panel h2 {
	color: #ffffff;
	margin: 0 0 24px 0 !important;
	font-size: 20px;
	font-weight: 700;
	letter-spacing: -0.02em;
	text-align: left;
}


#flightHistoryListPage .search-box {
	margin: 20px 0;
	padding: 20px;
	background: rgba(17, 24, 39, 0.6) !important;
	border: 1px solid #1e293b !important;
	border-radius: 12px;
}


#flightHistoryListPage table {
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

#flightHistoryListPage th {
	background-color: #111827 !important; 
	color: #38bdf8 !important; 
	padding: 14px 16px !important;
	font-size: 13px;
	font-weight: 700;
	text-align: center !important; 
	border: 0 !important;
	border-bottom: 2px solid #1e293b !important;
}

#flightHistoryListPage td {
	padding: 12px 16px !important;
	background-color: transparent !important;
	color: #cbd5e1 !important;
	font-size: 13.5px;
	text-align: center !important; 
	border: 0 !important;
	border-bottom: 1px solid #1e293b !important;
}


#flightHistoryListPage tr {
	transition: background-color 0s ease;
}

#flightHistoryListPage tbody tr:hover td {
	background-color: rgba(30, 41, 59, 0.6) !important;
	color: #ffffff !important;
}

#flightHistoryListPage .no-data {
	padding: 60px !important;
	color: #64748b !important;
	font-size: 14px;
}


#flightHistoryListPage form {
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
	align-items: center;
	color: #cbd5e1;
	font-size: 13.5px;
}

#flightHistoryListPage input[type="text"], #flightHistoryListPage select {
	padding: 8px 12px;
	background: #111827 !important;
	color: #ffffff !important;
	border: 1px solid #334155 !important;
	border-radius: 6px;
	outline: none;
	font-size: 13.5px;
	transition: all 0.15s ease;
}

#flightHistoryListPage input[type="text"]:focus, #flightHistoryListPage select:focus {
	border-color: #0ea5e9 !important;
	box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}


#flightHistoryListPage a.main-link {
	color: #38bdf8 !important;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
	margin-top: 20px;
	transition: color 0.15s ease;
}

#flightHistoryListPage a.main-link:hover {
	color: #7dd3fc !important;
	text-decoration: underline !important;
}


#flightHistoryListPage button {
	padding: 9px 16px;
	background-color: #0ea5e9 !important;
	color: #ffffff !important;
	border: 0;
	border-radius: 8px !important;
	font-weight: 700;
	font-size: 13.5px;
	cursor: pointer;
	transition: all 0.15s ease;
}

#flightHistoryListPage button:hover {
	background-color: #0284c7 !important;
}


#flightHistoryListPage .badge-status {
	padding: 4px 12px !important;
	border-radius: 20px !important;
	font-size: 11.5px !important;
	font-weight: 700 !important;
	display: inline-block;
}


#flightHistoryListPage .badge-status.pending {
	background-color: rgba(245, 158, 11, 0.15) !important;
	color: #f59e0b !important;
	border: 1px solid rgba(245, 158, 11, 0.3) !important;
}


#flightHistoryListPage .pagination {
	display: flex;
	list-style: none;
	gap: 6px;
	justify-content: center;
	padding: 0;
	margin: 0 !important;
}

#flightHistoryListPage .pagination li {
	margin: 0 !important;
}

#flightHistoryListPage .pagination a, #flightHistoryListPage .pagination strong {
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

#flightHistoryListPage .pagination a:hover {
	color: #ffffff !important;
	background: #1f2937 !important;
	border-color: #334155;
}


#flightHistoryListPage .pagination li.active strong, #flightHistoryListPage .pagination strong {
	color: #38bdf8 !important;
	background: rgba(14, 165, 233, 0.15) !important;
	border-color: #0ea5e9 !important;
}

@media ( max-width : 760px) {
	#flightHistoryListPage table {
		display: block;
		overflow-x: auto;
		white-space: nowrap;
	}
}

#flightHistoryListPage .panel { display:grid !important; grid-template-columns:minmax(180px,1fr) auto; grid-template-areas:"title search" "summary action" "table table" "pager pager"; gap:20px; padding:0 !important; background:transparent !important; border:0 !important; box-shadow:none !important; overflow-x:auto; }
#flightHistoryListPage .panel > h2 { grid-area:title; margin:0 !important; padding:0 0 16px; border-bottom:1px solid #1e293b; color:#fff !important; font-size:22px !important; }
#flightHistoryListPage .panel > br { display:none; }
#flightHistoryListPage .panel > .staff-list-summary { grid-area:summary; color:#94a3b8; font-size:14px; font-weight:500; }
#flightHistoryListPage .panel > .staff-list-summary strong { color:#38bdf8; background:rgba(56,189,248,.1); border-radius:4px; padding:2px 6px; }
#flightHistoryListPage .panel > form { grid-area:search; justify-self:end; margin:0 !important; }
#flightHistoryListPage .panel > table { grid-area:table; min-width:850px; margin:0 !important; }
#flightHistoryListPage .panel > table th,#flightHistoryListPage .panel > table td { white-space:nowrap; }
#flightHistoryListPage .panel > div[style*="margin-top"] { grid-area:pager; justify-self:center; margin:0 !important; }
@media(max-width:760px){#flightHistoryListPage .panel{grid-template-columns:1fr;grid-template-areas:"title" "search" "summary" "table" "pager"}#flightHistoryListPage .panel > form{justify-self:stretch}}


</style>
</head>
<body>
	
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	
	<div id="flightHistoryListPage" class="control-page-content">
		<div class="panel">
			<h2>드론 비행 이력 목록</h2>
			
			
			<div class="staff-summary-bar"
			     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important;">
			     
			    
	            <div class="staff-count">
	              <div class="staff-list-summary">총 <strong>${pageMaker.totalCount}</strong>건</div>
	            </div>
			    
			    
			    <div class="summary-action-group" style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important;">
			        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#flightHistoryTable', 'flight-history-list')"
			                style="float: none !important; margin: 0 !important; display: inline-flex !important; white-space: nowrap !important;">
			            <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i> CSV
			        </button>
			    </div>
			</div>
			

			
			<table id="flightHistoryTable" data-csv-export data-csv-filename="flight-history-list">
				<thead>
					<tr>
						<th>이력번호</th>
						<th>드론 기체 ID</th>
						<th>비행 시작 일시</th>
						<th>비행 종료 일시</th>
						<th>총 비행 시간</th>
						<th>데이터 등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty flightHistoryList}">
							<tr>
								<td colspan="6" class="no-data">기록된 드론 비행 이력이 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="history" items="${flightHistoryList}">
								
								<tr style="cursor: pointer;"
									onclick="return openDetailPopup('${pageContext.request.contextPath}/flighthistory/detail?flightId=${history.flightId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'flightHistoryDetail');">
									<td>${history.flightId}</td>
									<td style="font-weight: bold;"><c:choose>
											<c:when test="${empty history.droneId}">
												
												<span class="badge-status pending">알수없음</span>
											</c:when>
											<c:otherwise>${history.droneId}</c:otherwise>
										</c:choose></td>
									<td><fmt:formatDate value="${history.startTime}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
									<td><fmt:formatDate value="${history.endTime}"
											pattern="yyyy-MM-dd HH:mm:ss" /></td>
									
									<td style="text-align: right; padding-right: 20px !important;">${history.flightDuration}
										시간&nbsp;</td>
									<td><fmt:formatDate value="${history.flightDate}"
											pattern="yyyy-MM-dd" /></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			
			<form:form action="list" method="get">
				<select name="searchType">
					<option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론
						기체 ID</option>
				</select>
				<select name="keyword">
					<option value="">전체 드론</option>
					<c:forEach var="drone" items="${droneList}">
						<option value="${drone.droneId}" ${pageMaker.keyword == drone.droneId ? 'selected' : ''}>${drone.droneId}</option>
					</c:forEach>
				</select>
				<button type="submit">검색</button>
			</form:form>
			
			<div style="margin-top: 25px;">
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
		</div>
	</div>
</body>
<script>
	var msg = "${msg}";
	if (msg === "REMOVE_SUCCESS")
		alert("선택하신 비행 이력 로그가 안전하게 삭제되었습니다.");
</script>
</html>

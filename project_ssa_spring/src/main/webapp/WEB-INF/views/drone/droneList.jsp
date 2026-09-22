<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>드론 관리 목록</title>
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
	padding: 14px 16px !important;
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

.badge-status.pending {
	background-color: rgba(245, 158, 11, 0.15) !important;
	color: #f59e0b !important;
	border: 1px solid rgba(245, 158, 11, 0.3) !important;
}

.pagination {
	display: flex;
	list-style: none;
	gap: 6px;
	justify-content: center;
	padding: 0;
	margin: 0 !important;
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

.panel>br {
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
	min-width: 1100px;
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
	.panel>form, .panel>.btn-register {
		justify-self: stretch;
	}
}

.drone-id {
	color: #38bdf8;
	font-weight: 700;
	letter-spacing: 0.02em;
}


</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />


	<div id="droneListPage" class="control-page-content">
		<div class="panel">

			<h2>드론 관리 목록</h2>
			<div class="staff-list-summary">
				총 <strong>${pageMaker.totalCount}</strong>건
			</div>


			<div style="margin-bottom: 15px; text-align: right;">
				<button type="button" class="btn-register"
					onclick="return openFormPopup('${pageContext.request.contextPath}/drone/register', 'droneRegister');">
					신규 드론 등록</button>
			</div>


			<table data-csv-export data-csv-filename="drone-list">
				<thead>
					<tr>
						<th>드론 기체 ID</th>
						<th>담당 관제원</th>
						<th>브랜드</th>
						<th>카메라</th>
						<th>배터리 용량</th>
						<th>전장</th>
						<th>전폭</th>
						<th>정비횟수</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>
						<c:when test="${empty droneList}">
							<tr>
								<td colspan="8" class="no-data">등록된 드론 기체가 없습니다.</td>
							</tr>
						</c:when>

						<c:otherwise>
							<c:forEach var="drone" items="${droneList}">
								<tr style="cursor: pointer;"
									onclick="return openDetailPopup(
										'${pageContext.request.contextPath}/drone/detail?droneId=${drone.droneId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}',
										'droneDetail'
									);">

									<!-- 드론 ID -->
									<td><strong class="drone-id"> ${drone.droneId} </strong></td>

									<!-- 담당 관제원 -->
									<td><c:choose>
											<c:when test="${empty drone.memberId}">
												<span class="badge-status pending"> 미배정 </span>
											</c:when>
											<c:otherwise>
												${drone.memberId}
											</c:otherwise>
										</c:choose></td>

									<!-- 브랜드 -->
									<td><c:choose>
											<c:when test="${empty drone.brand}">
												-
											</c:when>
											<c:otherwise>
												${drone.brand}
											</c:otherwise>
										</c:choose></td>

									<!-- 카메라 -->
									<td><c:choose>
											<c:when test="${empty drone.camera}">
												-
											</c:when>
											<c:otherwise>
												${drone.camera}
											</c:otherwise>
										</c:choose></td>

									<!-- 배터리 -->
									<td><c:choose>
											<c:when test="${empty drone.batteryCapacity}">
												-
											</c:when>
											<c:otherwise>
												${drone.batteryCapacity} mAh
											</c:otherwise>
										</c:choose></td>

									<!-- 전장 -->
									<td><c:choose>
											<c:when test="${empty drone.droneLength}">
												-
											</c:when>
											<c:otherwise>
												${drone.droneLength} mm
											</c:otherwise>
										</c:choose></td>

									<!-- 전폭 -->
									<td><c:choose>
											<c:when test="${empty drone.droneWidth}">
												-
											</c:when>
											<c:otherwise>
												${drone.droneWidth} mm
											</c:otherwise>
										</c:choose></td>

									<!-- 정비횟수 -->
									<td><c:choose>
											<c:when test="${empty drone.maintenanceCount}">
												0회
											</c:when>
											<c:otherwise>
												${drone.maintenanceCount}회
											</c:otherwise>
										</c:choose></td>

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
					<option value="m" ${pageMaker.searchType == 'm' ? 'selected' : ''}>담당
						사번</option>
				</select>
				<input type="text" name="keyword" value="${pageMaker.keyword}"
					placeholder="검색어 입력">
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
	if (msg === "REGISTER_SUCCESS")
		alert("신규 드론 기체가 등록되었습니다.");
	if (msg === "MODIFY_SUCCESS")
		alert("드론 배정 정보가 수정되었습니다.");
	if (msg === "REMOVE_SUCCESS")
		alert("드론 기체 정보가 삭제되었습니다.");
</script>
</html>

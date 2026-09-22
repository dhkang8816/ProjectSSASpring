<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<title>드론 상세 정보</title>
</head>
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
    padding: 32px !important;
    margin: 0;
}


.panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(4px);
    max-width: 500px; 
    margin: 0 auto;
}

h2 {
    color: #ffffff !important;
    margin: 0 0 24px 0 !important;
    font-size: 20px !important;
    font-weight: 700 !important;
    letter-spacing: -0.02em;
    text-align: left;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 12px;
}


.form-group {
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

label {
    display: inline-block;
    color: #38bdf8 !important; 
    font-size: 13.5px;
    font-weight: 700;
}


input[type="text"], select {
    padding: 10px 12px !important;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 14px;
    width: 100% !important; 
    box-sizing: border-box;
    transition: all 0.15s ease;
}

input[type="text"]:focus, select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}


input[readonly] {
    background-color: rgba(30, 41, 59, 0.5) !important;
    color: #64748b !important;
    border: 1px solid #1e293b !important;
    cursor: not-allowed !important;
}


.btn-group {
    margin-top: 28px;
    display: flex;
    gap: 8px;
    justify-content: flex-end;
}

button {
    padding: 10px 18px;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}


button.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-modify:hover {
    background-color: #0284c7 !important;
}


button.btn-delete {
    background-color: #ef4444 !important;
    color: #ffffff !important;
}
button.btn-delete:hover {
    background-color: #dc2626 !important;
}


button.btn-list {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}


a.main-link {
    color: #38bdf8 !important;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
    font-size: 13.5px;
    transition: color 0.15s ease;
}
a.main-link:hover {
    color: #7dd3fc !important;
    text-decoration: underline !important;
}

.detail-grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	column-gap: 50px;
	row-gap: 22px;
}

.detail-grid .info-group:first-child .info-value {
	font-weight: 700;
	color: #ffffff;
}

.info-group {
	display: flex;
	flex-direction: column;
	gap: 5px;
	min-width: 0;
}

.info-group label {
	color: #38bdf8;
	font-size: 13px;
	font-weight: 700;
}

.info-value {
	color: #e5e7eb;
	font-size: 15px;
	font-weight: 500;
	line-height: 1.4;
}

/* 작은 팝업 대응 */
@media (max-width: 520px) {
	.detail-grid {
		grid-template-columns: 1fr;
		row-gap: 16px;
	}
}
</style>
</head>
<body class="popup-page">
<div class="panel">
    <h2>드론 상세</h2>
    
    <form:form id="droneForm" method="post">
        <input type="hidden" name="popup" value="true" />
        
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        
		        
		<div class="detail-grid">
		
			<div class="info-group">
				<label>드론 기체 ID</label>
				<div class="info-value">${drone.droneId}</div>
			</div>
		
			<div class="info-group">
				<label>담당 관제원</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.memberId}">
							<span class="badge-status pending">미배정</span>
						</c:when>
						<c:otherwise>
							${drone.memberId}
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		
			<div class="info-group">
				<label>브랜드</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.brand}">-</c:when>
						<c:otherwise>${drone.brand}</c:otherwise>
					</c:choose>
				</div>
			</div>
		
			<div class="info-group">
				<label>카메라</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.camera}">-</c:when>
						<c:otherwise>${drone.camera}</c:otherwise>
					</c:choose>
				</div>
			</div>
		
			<div class="info-group">
				<label>배터리 용량</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.batteryCapacity}">-</c:when>
						<c:otherwise>${drone.batteryCapacity} mAh</c:otherwise>
					</c:choose>
				</div>
			</div>
		
			<div class="info-group">
				<label>정비횟수</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.maintenanceCount}">0회</c:when>
						<c:otherwise>${drone.maintenanceCount}회</c:otherwise>
					</c:choose>
				</div>
			</div>
		
			<div class="info-group">
				<label>전장</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.droneLength}">-</c:when>
						<c:otherwise>${drone.droneLength} mm</c:otherwise>
					</c:choose>
				</div>
			</div>
		
			<div class="info-group">
				<label>전폭</label>
				<div class="info-value">
					<c:choose>
						<c:when test="${empty drone.droneWidth}">-</c:when>
						<c:otherwise>${drone.droneWidth} mm</c:otherwise>
					</c:choose>
				</div>
			</div>
		
		</div>
        
        <div class="btn-group">
            <button type="button"
				onclick="location.href='${pageContext.request.contextPath}/drone/modify?droneId=${drone.droneId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}&popup=true'">
				기체 정보 수정
			</button>
            <button type="button" class="btn-delete" onclick="fn_submit('remove')">기체 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
    
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>

function fn_submit(mode) {
    var form = document.getElementById("droneForm");
    if (mode === 'modify') {
        if (!confirm("드론 배정 정보를 수정하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/drone/modify";
    } else if (mode === 'remove') {
        if (!confirm("정말로 이 드론 기체를 삭제하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/drone/remove";
    }
    form.submit();
}

function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/drone/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>

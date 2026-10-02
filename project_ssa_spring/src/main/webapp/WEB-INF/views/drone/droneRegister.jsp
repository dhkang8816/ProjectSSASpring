<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/images/KakaoTalk_20260923_120441893.png?v=1">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>신규 드론 등록</title>
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


input[type="text"],
input[type="number"],
select {
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


input[type="text"]:focus,
input[type="number"]:focus,
select:focus {
	border-color: #0ea5e9 !important;
	box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}


.btn-group {
	margin-top: 28px;
	display: flex;
	gap: 8px;
	justify-content: flex-end;
}

button {
	padding: 10px 20px;
	border: 0;
	border-radius: 8px !important;
	font-weight: 700;
	font-size: 13.5px;
	cursor: pointer;
	transition: all 0.15s ease;
}


button[type="submit"] {
	background-color: #0ea5e9 !important;
	color: #ffffff !important;
}

button[type="submit"]:hover {
	background-color: #0284c7 !important;
}


button.btn-cancel {
	background-color: #1e293b !important;
	color: #cbd5e1 !important;
	border: 1px solid #334155 !important;
}

button.btn-cancel:hover {
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
</style>
</head>
<body class="popup-page">
	<div class="panel">
		<h2>신규 드론 등록</h2>

		<form:form action="${pageContext.request.contextPath}/drone/register"
			method="post">
		
			<c:if test="${param.popup eq 'true'}">
				<input type="hidden" name="popup" value="true" />
			</c:if>
		
			<!-- 신규 등록 시 정비횟수는 0 -->
			<input type="hidden" name="maintenanceCount" value="0" />
		
		
			<!-- 드론 ID -->
			<div class="form-group">
				<label>드론 기체 ID</label>
				<input type="text"
					   name="droneId"
					   placeholder="예: DRONE06"
					   required="required" />
			</div>
		
		
			<!-- 담당 관제원 -->
			<div class="form-group">
				<label>담당 관제원 배정</label>
		
				<select name="memberId">
					<option value="">-- 담당 관제원 선택 (미배정) --</option>
		
					<c:forEach var="member" items="${memberList}">
						<option value="${member.memberId}">
							${member.name} (${member.memberId})
						</option>
					</c:forEach>
				</select>
			</div>
		
		
			<!-- 브랜드 -->
			<div class="form-group">
				<label>브랜드</label>
				<input type="text"
					   name="brand"
					   placeholder="예: DJI, Autel, Parrot"
					   required="required" />
			</div>
		
		
			<!-- 카메라 -->
			<div class="form-group">
				<label>카메라</label>
				<input type="text"
					   name="camera"
					   value="ESP32"
					   placeholder="예: ESP32"
					   required="required" />
			</div>
		
		
			<!-- 배터리 용량 -->
			<div class="form-group">
				<label>배터리 용량 (mAh)</label>
				<input type="number"
					   name="batteryCapacity"
					   min="0"
					   step="1"
					   placeholder="예: 5000"
					   required="required" />
			</div>
		
		
			<!-- 전장 -->
			<div class="form-group">
				<label>전장 (mm)</label>
				<input type="number"
					   name="droneLength"
					   min="0"
					   step="0.01"
					   placeholder="예: 350.00"
					   required="required" />
			</div>
		
		
			<!-- 전폭 -->
			<div class="form-group">
				<label>전폭 (mm)</label>
				<input type="number"
					   name="droneWidth"
					   min="0"
					   step="0.01"
					   placeholder="예: 300.00"
					   required="required" />
			</div>
		
		
			<div class="btn-group">
				<button type="submit">등록 완료</button>
		
				<button type="button"
						class="btn-cancel"
						onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/drone/list');">
					취소
				</button>
			</div>
		
		</form:form>
	</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

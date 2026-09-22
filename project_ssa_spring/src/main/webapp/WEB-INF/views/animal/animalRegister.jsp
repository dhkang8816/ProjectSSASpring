<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<title>신규 동물 등록</title>
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


.btn-group {
    margin-top: 28px;
    display: flex;
    gap: 8px;
    justify-content: flex-end;
}

button {
    padding: 10px 22px;
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
</style>

<body class="popup-page">
<div class="panel">
    <h2>신규 동물 등록</h2>
    
    
    <form:form action="${pageContext.request.contextPath}/animal/register" method="post">
        <c:if test="${param.popup eq 'true'}">
            <input type="hidden" name="popup" value="true" />
        </c:if>
        
        
        <div class="form-group">
            <label>축종 구분</label>
            
            <select name="animalType">
                <c:forEach var="code" items="${animalTypeList}">
                    <option value="${code.code}">${code.codeName} (${code.code})</option>
                </c:forEach>
            </select>
        </div>
        
        <div class="form-group">
            <label>품종</label>
            <input type="text" name="animalBreed" placeholder="예: 말티즈, 진돗개" required="required" />
        </div>
        
        <div class="form-group">
            <label>동물 이름</label>
            <input type="text" name="animalName" placeholder="동물 이름을 입력하세요" required="required" />
        </div>
        
        <div class="form-group">
            <label>보호 상태</label>
            
            <select name="animalStatus">
                <c:forEach var="animalStatus" items="${animalStatusList}">
                    <option value="${animalStatus.code}">${animalStatus.codeName}</option>
                </c:forEach>
            </select>
        </div>
        
        
        <div class="btn-group">
            <button type="submit">등록</button>
            <button type="button" class="btn-cancel" 
                    onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/animal/list');">취소</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

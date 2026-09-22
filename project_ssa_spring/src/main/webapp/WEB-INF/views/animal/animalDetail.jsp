<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<title>보호 동물 상세 정보</title>
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
</style>

</head>
<body class="popup-page">
<div class="panel">
    <h2>보호 동물 상세</h2>
    
    
    <form:form id="detailForm" method="post">
        <input type="hidden" name="popup" value="true" />
        
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        
        
        <div class="form-group">
            <label>동물 식별 번호</label>
            <input type="text" name="animalId" value="${animal.animalId}" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>축종 구분</label>
            
            <select name="animalType">
                <c:forEach var="code" items="${animalTypeList}">
                    <option value="${code.code}" ${animal.animalType == code.code ? 'selected="selected"' : ''}>
                        ${code.codeName} (${code.code})
                    </option>
                </c:forEach>
            </select>
        </div>
        
        <div class="form-group">
            <label>품종</label>
            <input type="text" name="animalBreed" value="${animal.animalBreed}" required="required" />
        </div>
        
        <div class="form-group">
            <label>동물 이름</label>
            <input type="text" name="animalName" value="${animal.animalName}" required="required" />
        </div>
        
        <div class="form-group">
            <label>입소 날짜</label>
            <input type="text" value="<fmt:formatDate value="${animal.entranceDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>보호 상태</label>
            
            <select name="animalStatus">
                <c:forEach var="animalStatus" items="${animalStatusList}">
                    <option value="${animalStatus.code}" ${animal.animalStatus == animalStatus.code ? 'selected="selected"' : ''}>${animalStatus.codeName}</option>
                </c:forEach>
            </select>
        </div>
        
        
        <div class="btn-group">
            <button type="button" class="btn-modify" onclick="fn_submit('modify')">수정 완료</button>
            <button type="button" class="btn-delete" onclick="fn_submit('remove')">동물 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
function fn_submit(mode) {
    var form = document.getElementById("detailForm");
    if (mode === 'modify') {
        if (!confirm("동물 정보를 수정하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/animal/modify";
    } else if (mode === 'remove') {
        if (!confirm("정말로 이 동물 데이터를 삭제하시겠습니까?\n(삭제 시 개체수 대시보드에서 1마리가 자동 감소합니다.)"))
            return;
        form.action = "${pageContext.request.contextPath}/animal/remove";
    }
    form.submit();
}
function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/animal/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>

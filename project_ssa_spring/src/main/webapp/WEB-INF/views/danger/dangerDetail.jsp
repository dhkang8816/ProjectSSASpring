<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이상 객체 상세 정보</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
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


input[type="text"] {
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

input[type="text"]:focus {
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
</style>

</head>
<body class="popup-page">
<div class="panel">
    <h2>이상 객체 상세</h2>
    
    
    <form:form id="dangerForm" method="post">
        <input type="hidden" name="popup" value="true" />
        
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        
        
        <div class="form-group">
            <label>마스터 식별 번호</label>
            <input type="text" name="dangerId" value="${danger.dangerId}" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>이상 객체 명칭</label>
            <input type="text" name="dangerName" value="${danger.dangerName}" required="required" />
        </div>
        
        <div class="form-group">
            <label>마스터 등록 일자</label>
            <input type="text" value="<fmt:formatDate value="${danger.dangerDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly="readonly" />
        </div>
        
        
        <div class="btn-group">
            <button type="button" class="btn-modify" onclick="fn_submit('modify')">수정 완료</button>
            <button type="button" class="btn-delete" onclick="fn_submit('remove')">객체 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
function fn_submit(mode) {
    var form = document.getElementById("dangerForm");
    if (mode === 'modify') {
        if (!confirm("이상 객체 명칭을 수정하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/danger/modify";
    } else if (mode === 'remove') {
        if (!confirm("정말로 이 객체를 마스터에서 영구 삭제하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/danger/remove";
    }
    form.submit();
}
function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/danger/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>

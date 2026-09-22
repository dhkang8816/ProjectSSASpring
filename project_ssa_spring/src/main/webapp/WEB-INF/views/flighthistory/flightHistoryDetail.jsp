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
<title>비행 이력 상세 정보</title>
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
    max-width: 600px; 
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
    font-size: 13.5px;
    font-weight: 700;
    text-align: left !important; 
    width: 160px;
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    border-right: 1px solid #1e293b !important; 
}

td {
    padding: 14px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 14px;
    text-align: left !important; 
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
}


tr:last-child th, tr:last-child td {
    border-bottom: 0 !important;
}


tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.4) !important;
    color: #ffffff !important;
}
tbody tr:hover th {
    background-color: rgba(17, 24, 39, 0.8) !important;
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


.badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important;
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}


.badge-status.rejected {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
}
</style>
</head>
<body class="popup-page">
<div class="panel">
    <h2>드론 상세 비행 세부 내역</h2>
    
    <form:form id="historyForm" method="post">
        <input type="hidden" name="popup" value="true" />
        
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        <input type="hidden" name="flightId" value="${flightHistory.flightId}" />
        
        
        <table>
            <tbody>
                <tr>
                    <th>비행 이력 번호</th>
                    <td>${flightHistory.flightId}</td>
                </tr>
                <tr>
                    <th>드론 기체 고유 ID</th>
                    <td style="font-weight: bold; color: #ffffff;">${flightHistory.droneId}</td>
                </tr>
                <tr>
                    <th>비행 시작 시각</th>
                    <td><fmt:formatDate value="${flightHistory.startTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                    <th>비행 종료 시각</th>
                    <td><fmt:formatDate value="${flightHistory.endTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                    <th>총 누적 비행 시간</th>
                    <td>${flightHistory.flightDuration} 시간</td>
                </tr>
                <tr>
                    <th>배터리 총 소모량</th>
                    <td>
                        <c:choose>
                            <c:when test="${empty flightHistory.batteryConsumption}">
                                
                                <span class="badge-status rejected">집계불가</span>
                            </c:when>
                            <c:otherwise>${flightHistory.batteryConsumption} %</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>관제 데이터 등록일</th>
                    <td><fmt:formatDate value="${flightHistory.flightDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
            </tbody>
        </table>
        
        
        <div class="btn-group">
            <button type="button" class="btn-delete" onclick="fn_delete()">이력 로그 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>

function fn_delete() {
    if (!confirm("정말로 이 드론의 비행 이력 데이터를 시스템에서 영구 삭제하시겠습니까?")) {
        return;
    }
    var form = document.getElementById("historyForm");
    form.action = "${pageContext.request.contextPath}/flighthistory/remove";
    form.submit();
}

function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/flighthistory/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/images/KakaoTalk_20260923_120441893.png?v=1">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>이상 개체 탐지 상세</title>
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
    max-width: 750px; 
    margin: 0 auto;
}

.panel h2 {
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
    vertical-align: middle !important;
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


.detail-snapshot {
    max-width: 600px;
    width: 100%;
    height: auto;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5) !important;
    background-color: #111827;
}


select, textarea {
    padding: 10px 12px !important;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 14px;
    box-sizing: border-box;
    transition: all 0.15s ease;
}

select {
    width: 220px !important;
}

textarea {
    width: 100% !important; 
    resize: vertical;
}

select:focus, textarea:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}

.status-choice {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

button.status-choice-button {
    min-width: 94px;
    padding: 9px 14px;
    color: #94a3b8;
    background: #111827;
    border: 1px solid #334155;
    border-radius: 7px !important;
}

button.status-choice-button:hover {
    color: #e2e8f0;
    background: #1e293b;
}

button.status-choice-button.is-selected.status-unverified {
    color: #fecaca;
    background: #3b1d2a;
    border-color: #ef4444;
}

button.status-choice-button.is-selected.status-progress {
    color: #fde68a;
    background: #3b2a16;
    border-color: #f59e0b;
}

button.status-choice-button.is-selected.status-complete {
    color: #bbf7d0;
    background: #153526;
    border-color: #22c55e;
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
    <h2>이상 개체 탐지 상세</h2>
    
    <form:form action="${pageContext.request.contextPath}/dangerlog/modify" method="post">
        
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />
        <input type="hidden" name="popup" value="true" />
        <input type="hidden" name="danlogId" value="${dangerLog.danlogId}" />
        
        
        <table>
            <tbody>
                <tr>
                    <th>로그 번호</th>
                    <td>${dangerLog.danlogId}</td>
                </tr>
                <tr>
                    <th>드론 기체 ID</th>
                    <td style="font-weight: bold; color: #ffffff;">${dangerLog.droneId}</td>
                </tr>
                <tr>
                    <th>포착 객체</th>
                    <td style="font-weight: bold; color: #ffffff;">${dangerLog.dangerName}</td>
                </tr>
                <tr>
                    <th>최초 감지 시각</th>
                    <td><fmt:formatDate value="${dangerLog.dangerTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <tr>
                    <th>드론 스냅샷 영상</th>
                    <td>
                        
                        <img src="${pageContext.request.contextPath}/dangerlog/getDangerSnapshot?danlogId=${dangerLog.danlogId}" 
                             alt="드론 포착 스냅샷" 
                             class="detail-snapshot"
                             onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
                    </td>
                </tr>
                <tr>
                    <th>관제원 현장 조치</th>
                    <td>
                        <input type="hidden" id="dactionStatus" name="dactionStatus"
                            value="${empty dangerLog.dactionStatus ? '0' : dangerLog.dactionStatus}" />
                        <div class="status-choice" role="group" aria-label="현장 조치 상태">
                            <button type="button" class="status-choice-button status-unverified ${empty dangerLog.dactionStatus or dangerLog.dactionStatus eq '0' ? 'is-selected' : ''}" data-status="0">미확인</button>
                            <button type="button" class="status-choice-button status-progress ${dangerLog.dactionStatus eq '1' ? 'is-selected' : ''}" data-status="1">조치중</button>
                            <button type="button" class="status-choice-button status-complete ${dangerLog.dactionStatus eq '2' ? 'is-selected' : ''}" data-status="2">조치완료</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>현장 조치 사유/내용</th>
                    <td>
                        
                        <textarea name="dactionReason" rows="5" placeholder="출동 요청, 상황 전파 등 구체적인 조치 이력을 기록하세요." required="required"><c:out value="${dangerLog.dactionReason}" /></textarea>
                    </td>
                </tr>
            </tbody>
        </table>
        
        
        <div class="btn-group">
            <button type="submit">조치 내용 저장</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>

(function () {
    const statusInput = document.getElementById('dactionStatus');
    const statusButtons = document.querySelectorAll('.status-choice-button');

    statusButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            statusInput.value = button.dataset.status;
            statusButtons.forEach(function (candidate) {
                candidate.classList.toggle('is-selected', candidate === button);
            });
        });
    });
}());

function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/dangerlog/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}
</script>
</html>

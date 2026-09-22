<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<title>경보 이력 상세조회</title>
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
    max-width: 650px; 
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
    width: 180px; 
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


button.btn-control {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-control:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}
</style>
</head>
<body class="popup-page">
<div class="panel">
    <h2>시스템 경보 이력</h2>
    
    
    <table>
        <tbody>
            <tr>
                <th>경보번호</th>
                <td>${alert.alertId}</td>
            </tr>
            <tr>
                <th>경보대상구분</th>
                <td>${alert.alertType}</td>
            </tr>
            <tr>
                <th>경보알림메세지내용</th>
                
                <td style="white-space: pre-wrap !important;"><c:out value="${alert.alertMsg}" /></td>
            </tr>
            <tr>
                <th>전송성공여부</th>
                <td>${alert.sendStatus}</td>
            </tr>
            <tr>
                <th>탐지이력시퀀스</th>
                <td>${empty alert.dlogId ? '-' : alert.dlogId}</td>
            </tr>
            <tr>
                <th>이상객체탐지시퀀스</th>
                <td>${empty alert.danlogId ? '-' : alert.danlogId}</td>
            </tr>
            <tr>
                <th>최초경보시각</th>
                <td><fmt:formatDate value="${alert.firstSendTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
            </tr>
            <tr>
                <th>경보전송일시</th>
                <td><fmt:formatDate value="${alert.sendDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
            </tr>
        </tbody>
    </table>
    
    
    <div class="btn-group">
        
        <button type="button" class="btn-control" onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/alert/list');">목록으로</button>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

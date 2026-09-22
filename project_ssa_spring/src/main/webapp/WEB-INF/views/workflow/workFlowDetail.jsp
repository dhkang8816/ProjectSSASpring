<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>전자결재</title>
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 20px;
    box-sizing: border-box;
}


.panel {
    width: 100%;
    max-width: 850px;
    margin: 0 auto;
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 14px !important;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    box-sizing: border-box;
}

.panel h2 {
    color: #ffffff !important;
    font-size: 20px;
    font-weight: 700;
    margin-top: 0;
    margin-bottom: 24px;
    letter-spacing: -0.02em;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 16px;
}


.message {
    background-color: rgba(16, 185, 129, 0.15);
    border: 1px solid rgba(16, 185, 129, 0.3);
    border-radius: 8px;
    padding: 12px 16px;
    margin-bottom: 20px;
    color: #10b981;
    font-size: 13.5px;
    font-weight: 500;
}

.error {
    background-color: rgba(239, 68, 68, 0.15);
    border: 1px solid rgba(239, 68, 68, 0.3);
    border-radius: 8px;
    padding: 12px 16px;
    margin-bottom: 20px;
    color: #ef4444;
    font-size: 13.5px;
    font-weight: 500;
}


.row {
    display: flex;
    align-items: flex-start;
    margin: 14px 0;
    font-size: 14px;
    line-height: 1.6;
    width: 100%;
}

.label {
    display: inline-block;
    width: 140px;
    color: #94a3b8 !important; 
    font-weight: 600;
    flex-shrink: 0;
}


.badge-status {
    padding: 3px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    display: inline-block;
}

.status-0 { 
    background: rgba(245, 158, 11, 0.15); 
    color: #f59e0b; 
    border: 1px solid rgba(245, 158, 11, 0.3); 
} 

.status-1 { 
    background: rgba(16, 185, 129, 0.15); 
    color: #10b981; 
    border: 1px solid rgba(16, 185, 129, 0.3); 
} 

.status-2 { 
    background: rgba(239, 68, 68, 0.15); 
    color: #ef4444; 
    border: 1px solid rgba(239, 68, 68, 0.3); 
} 


.content {
    flex: 1;
    white-space: pre-wrap;
    background: #111827 !important; 
    border: 1px solid #1e293b !important;
    border-radius: 8px;
    padding: 14px 16px;
    color: #cbd5e1;
    font-size: 13.5px;
}


.actions {
    margin-top: 28px;
    border-top: 1px solid #1e293b;
    padding-top: 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
}


button {
    padding: 10px 18px;
    font-size: 13.5px;
    font-weight: 700;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.15s ease;
    border: none;
}


.btn-approve {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
}

.btn-approve:hover {
    background-color: #0284c7 !important;
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px);
}


.btn-reject {
    background-color: #ef4444 !important;
    color: #ffffff !important;
    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
}

.btn-reject:hover {
    background-color: #dc2626 !important;
    box-shadow: 0 4px 16px rgba(239, 68, 68, 0.35);
    transform: translateY(-1px);
}


button.btn-list {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}

button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
    border-color: #0ea5e9 !important;
}

button:active { 
    transform: translateY(0); 
}


.reject-form-box {
    background: rgba(30, 41, 59, 0.2);
    border: 1px solid #1e293b;
    border-radius: 10px;
    padding: 20px;
    margin-top: 10px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}


textarea {
    width: 100%;
    min-height: 90px;
    background: #111827 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    padding: 12px 16px;
    color: #ffffff;
    font-size: 13.5px;
    outline: none;
    resize: vertical;
    box-sizing: border-box;
    transition: border-color 0.15s ease;
}

textarea:focus {
    border-color: #ef4444 !important;
    box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2) !important;
}


.btn-back-container {
    margin-top: 24px;
    border-top: 1px solid #1e293b;
    padding-top: 20px;
    display: flex;
    justify-content: flex-end; 
}
</style>

</head>
<body class="popup-page">
<div class="panel">
    <h2>전자결재 상세</h2>
    
    
    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    
    
    <div class="row">
        <span class="label">결재 번호</span>
        <strong style="color: #ffffff;">${workflow.approvalId}</strong>
    </div>
    <div class="row">
        <span class="label">보고서 번호</span>
        <strong style="color: #38bdf8;">#${workflow.reportId}</strong>
    </div>
    <div class="row">
        <span class="label">기안자</span>
        <span>${workflow.drafterName} (${workflow.drafterId})</span>
    </div>
    <div class="row">
        <span class="label">결재자</span>
        <span>${workflow.approverName} (${workflow.approverId})</span>
    </div>
    <div class="row">
        <span class="label">요청일</span>
        <span style="color: #94a3b8;"><fmt:formatDate value="${workflow.requestDate}" pattern="yyyy-MM-dd HH:mm" /></span>
    </div>
    <div class="row">
        <span class="label">결재 상태</span>
        <c:choose>
            <c:when test="${workflow.appStatus eq '0'}"><span class="badge-status status-0">승인 대기</span></c:when>
            <c:when test="${workflow.appStatus eq '1'}"><span class="badge-status status-1">승인 완료</span></c:when>
            <c:otherwise><span class="badge-status status-2">반려</span></c:otherwise>
        </c:choose>
    </div>
    
    
    <div class="row">
        <div class="label">현장 조치 내역</div>
        <div class="content">${workflow.actionTaken}</div>
    </div>
    <div class="row">
        <div class="label">특이사항</div>
        <div class="content">${workflow.remark}</div>
    </div>
    
    
    <c:if test="${not empty workflow.rejectReason}">
        <div class="row">
            <div class="label" style="color: #f87171 !important;">반려 사유</div>
            <div class="content" style="border-color: rgba(239, 68, 68, 0.2) !important; color: #f87171;"><c:out value="${workflow.rejectReason}" /></div>
        </div>
    </c:if>
    
    
    <c:if test="${workflow.appStatus eq '0'}">
        <div class="actions">
            
            <form:form action="${pageContext.request.contextPath}/workflow/approve" method="post" style="display: inline; margin:0; padding:0;">
                <input type="hidden" name="approvalId" value="${workflow.approvalId}">
                <input type="hidden" name="popup" value="true">
                <button type="submit" class="btn-approve">✔ 결재 승인</button>
            </form:form>
            
            
            <form:form action="${pageContext.request.contextPath}/workflow/reject" method="post" style="margin:0; padding:0;">
                <input type="hidden" name="approvalId" value="${workflow.approvalId}">
                <input type="hidden" name="popup" value="true">
                <div class="reject-form-box">
                    <label for="rejectReason" style="font-size: 13.5px; font-weight: 600; color: #cbd5e1;">⚠ 서류 반려 사유 입력</label>
                    <textarea id="rejectReason" name="rejectReason" placeholder="반려 사유를 상세히 기술해 주세요." required="required"></textarea>
                    <div style="text-align: right; margin-top: 4px;">
                        <button type="submit" class="btn-reject">✖ 반려 실행</button>
                    </div>
                </div>
            </form:form>
        </div>
    </c:if>
    
    
    <div class="btn-back-container">
        <button type="button" class="btn-list" onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/workflow/list');">목록으로</button>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

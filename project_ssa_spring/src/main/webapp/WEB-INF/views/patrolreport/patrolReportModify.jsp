<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>반려 보고서 수정</title>
<style>
body {
    margin: 0;
    padding: 28px;
    background: #0b0f19;
    color: #e2e8f0;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
}
.report-modify-panel {
    width: 100%;
    max-width: 720px;
    margin: 0 auto;
    padding: 30px;
    box-sizing: border-box;
    background: rgba(20, 26, 42, .92);
    border: 1px solid #1e293b;
    border-radius: 14px;
}
.report-modify-panel h2 {
    margin: 0 0 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid #1e293b;
    color: #fff;
    font-size: 20px;
}
.rejection-summary {
    margin-bottom: 24px;
    padding: 16px;
    border: 1px solid rgba(239, 68, 68, .42);
    border-left: 4px solid #ef4444;
    border-radius: 8px;
    background: rgba(127, 29, 29, .18);
    color: #fecaca;
    line-height: 1.6;
    white-space: pre-wrap;
}
.rejection-summary strong {
    display: block;
    margin-bottom: 6px;
    color: #f87171;
    font-size: 13px;
}
.form-field {
    margin-bottom: 22px;
}
.form-field label {
    display: block;
    margin-bottom: 8px;
    color: #7dd3fc;
    font-size: 14px;
    font-weight: 700;
}
.form-field textarea {
    width: 100%;
    min-height: 130px;
    padding: 12px 14px;
    box-sizing: border-box;
    border: 1px solid #334155;
    border-radius: 8px;
    outline: none;
    resize: vertical;
    background: #111827;
    color: #f8fafc;
    font: inherit;
    line-height: 1.6;
}
.form-field textarea:focus {
    border-color: #38bdf8;
    box-shadow: 0 0 0 3px rgba(56, 189, 248, .18);
}
.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    padding-top: 20px;
    border-top: 1px solid #1e293b;
}
.form-actions button {
    padding: 10px 18px;
    border: 0;
    border-radius: 8px;
    color: #fff;
    font-weight: 700;
    cursor: pointer;
}
.btn-resubmit { background: #0ea5e9; }
.btn-cancel { background: #334155; }
</style>
</head>
<body class="popup-page">
<main class="report-modify-panel">
    <h2>반려 보고서 수정 · 재상신</h2>

    <div class="rejection-summary">
        <strong>반려 사유</strong>
        <c:choose>
            <c:when test="${not empty rejectReason}"><c:out value="${rejectReason}" /></c:when>
            <c:otherwise>등록된 반려 사유가 없습니다.</c:otherwise>
        </c:choose>
    </div>

    <form:form modelAttribute="report" action="${pageContext.request.contextPath}/patrolreport/modify" method="post">
        <form:hidden path="reportId" />
        <c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true"></c:if>

        <div class="form-field">
            <label for="actionTaken">당일 현장 조치 내용</label>
            <form:textarea id="actionTaken" path="actionTaken" required="required"
                placeholder="반려 사유를 반영해 현장 조치 내용을 수정해 주세요." />
        </div>
        <div class="form-field">
            <label for="remark">특이사항 및 비고</label>
            <form:textarea id="remark" path="remark"
                placeholder="보완 내용이나 추가 특이사항을 입력해 주세요." />
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-resubmit">수정 후 재상신</button>
            <button type="button" class="btn-cancel"
                onclick="location.href='${pageContext.request.contextPath}/patrolreport/detail/${report.reportId}?popup=true';">취소</button>
        </div>
    </form:form>
</main>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

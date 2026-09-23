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
<title>직원 상세 정보</title>
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 24px;
    box-sizing: border-box;
}


.detail-panel {
    width: 100%;
    max-width: 520px; 
    margin: 0 auto;
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 14px !important;
    padding: 32px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    box-sizing: border-box;
}

.detail-panel h2 {
    color: #ffffff !important;
    font-size: 20px;
    font-weight: 700;
    margin-top: 0;
    margin-bottom: 24px;
    letter-spacing: -0.02em;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 16px;
    text-align: center; 
}


.profile-top-section {
    display: flex;
    flex-direction: column;
    align-items: center; 
    width: 100%;
    margin-bottom: 30px;
}


.profile-img-box {
    padding: 6px;
    background: #111827;
    border: 2px solid #0ea5e9; 
    box-shadow: 0 0 20px rgba(14, 165, 233, 0.2);
    border-radius: 12px;
    flex-shrink: 0;
    margin-bottom: 10px; 
}
.profile-img-box img {
    width: 150px; 
    height: 185px;
    border-radius: 6px;
    object-fit: cover;
    display: block;
}


.info-grid {
    width: 100%;
    display: flex;
    flex-direction: column;
    background: rgba(17, 24, 39, 0.5); 
    border: 1px solid #1e293b;
    border-radius: 10px;
    padding: 10px 20px;
    box-sizing: border-box;
}

.info-row {
    display: flex;
    align-items: center;
    justify-content: space-between; 
    padding: 12px 0;
    font-size: 14px;
    border-bottom: 1px solid rgba(30, 41, 59, 0.5);
}
.info-row:last-child {
    border-bottom: none; 
}

.info-label {
    color: #94a3b8 !important; 
    font-weight: 600;
}

.info-value {
    color: #cbd5e1;
    font-weight: 500;
    text-align: right;
}


.badge-status {
    padding: 3px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    display: inline-block;
}
.status-0 { background: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); } 
.status-1 { background: rgba(239, 68, 68, 0.15); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); } 
.status-2 { background: rgba(148, 163, 184, 0.15); color: #94a3b8; border: 1px solid rgba(148, 163, 184, 0.3); } 


.action-bar {
    margin-top: 24px;
    display: flex;
    justify-content: center; 
    gap: 12px;
    width: 100%;
}

button {
    padding: 10px 24px;
    font-size: 13.5px;
    font-weight: 700;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.15s ease;
    border: none;
}


.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
}
.btn-modify:hover {
    background-color: #0284c7 !important;
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px);
}


.btn-back {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
.btn-back:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}
button:active { transform: translateY(0); }
</style>
</head>
<body class="popup-page">

<div class="detail-panel">
    <h2>📋 관제소 보안 직원 상세 정보</h2>
    
    
    <div class="profile-top-section">
        
        <div class="profile-img-box">
            <img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" alt="직원 사진" 
                 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
        </div>
    </div>
    
    
    <div class="info-grid">
        <div class="info-row">
            <span class="info-label">사원번호</span>
            <span class="info-value" style="color: #38bdf8; font-weight: 700;">${member.memberId}</span>
        </div>
        <div class="info-row">
            <span class="info-label">이름</span>
            <span class="info-value" style="color: #ffffff; font-weight: 600;">${member.name}</span>
        </div>
        <div class="info-row">
            <span class="info-label">소속 부서</span>
            <span class="info-value">${member.department}</span>
        </div>
        <div class="info-row">
            <span class="info-label">연락처</span>
            <span class="info-value">${member.phone}</span>
        </div>
        <div class="info-row">
            <span class="info-label">이메일</span>
            <span class="info-value">${member.email}</span>
        </div>
        <c:if test="${canManageAccount}">
            <div class="info-row">
                <span class="info-label">계정 상태</span>
                <c:choose>
                    <c:when test="${member.status == '0'}"><span class="badge-status status-0">정상</span></c:when>
                    <c:when test="${member.status == '1'}"><span class="badge-status status-1">정지</span></c:when>
                    <c:when test="${member.status == '2'}"><span class="badge-status status-2">휴면</span></c:when>
                    <c:otherwise><span class="badge-status" style="background: #334155; color: #94a3b8;">${member.status}</span></c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${canManageAccount}">
            <div class="info-row">
                <span class="info-label">비밀번호 실패</span>
                <span class="info-value" style="${member.failCount >= 5 ? 'color: #ef4444; font-weight: 700;' : ''}">${member.failCount} 회</span>
            </div>
        </c:if>
        <div class="info-row">
            <span class="info-label">인프라 등록일</span>
            <span class="info-value" style="color: #94a3b8;"><fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd" /></span>
        </div>
        <div class="info-row">
            <span class="info-label">최종 로그인</span>
            <span class="info-value" style="color: #94a3b8;"><fmt:formatDate value="${member.lastLongDate}" pattern="yyyy-MM-dd HH:mm" /></span>
        </div>
    </div>
    
    
    <div class="action-bar">
        <button type="button" class="btn-modify" onclick="return openMemberModifyPopup();">정보 수정</button>
        <button type="button" class="btn-back" onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/member/list');">목록으로</button>
    </div>
    
</div> 

<script>
function openMemberModifyPopup() {
    location.href = '${pageContext.request.contextPath}/member/modifyForm?memberId=${member.memberId}';
    return false;
}

(function resizeMemberDetailPopup() {
    if (!window.opener || window.opener.closed) {
        return;
    }

    var popupWidth = Math.max(320, Math.min(680, screen.availWidth - 40));
    var popupHeight = Math.max(420, Math.min(960, screen.availHeight - 36));
    var left = Math.max(0, Math.round((screen.availWidth - popupWidth) / 2));
    var top = Math.max(12, Math.min(24, screen.availHeight - popupHeight - 12));

    window.resizeTo(popupWidth, popupHeight);
    window.moveTo(left, top);
})();
</script>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>

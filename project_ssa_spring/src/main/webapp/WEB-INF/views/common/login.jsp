<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>로그인</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>

body.login-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background-color: #0b0f19 !important; 
    margin: 0;
    padding: 0;
    font-family: 'Segoe UI', Roboto, sans-serif;
}


.login-wrapper {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px 20px; 
    box-sizing: border-box;
}


.login-container {
    width: 100%;
    max-width: 420px;
    padding: 40px;
    background: rgba(20, 26, 42, 0.85) !important; 
    border: 1px solid #1e293b !important;
    border-radius: 16px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    box-sizing: border-box;
}


.login-container h2 {
    margin: 0 0 32px 0;
    color: #ffffff !important;
    text-align: center;
    font-size: 24px;
    font-weight: 700;
    letter-spacing: -0.03em;
}


.input-group {
    display: flex;
    flex-direction: column;
    margin-bottom: 22px;
    box-sizing: border-box;
}

.input-group label {
    margin-bottom: 8px;
    color: #94a3b8 !important; 
    font-size: 13px;
    font-weight: 600;
    letter-spacing: -0.01em;
}


.input-group input {
    width: 100%;
    background: #111827 !important; 
    padding: 12px 16px !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    outline: none;
    font-size: 14px;
    box-sizing: border-box;
    transition: all 0.15s ease-in-out;
}


.input-group input:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}


.input-group input::placeholder {
    color: #4b5563;
    font-size: 13px;
}


.login-btn {
    width: 100%;
    padding: 13px !important;
    border: 0 !important;
    border-radius: 8px !important;
    background: #0ea5e9 !important; 
    color: #ffffff !important;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
    transition: all 0.15s ease;
    box-sizing: border-box;
}

.login-btn:hover {
    background: #0284c7 !important; 
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px); 
}

.login-btn:active {
    transform: translateY(0);
}

.login-alert {
    margin: 0 0 20px;
    padding: 11px 13px;
    border: 1px solid #7f1d1d;
    border-radius: 8px;
    background: rgba(127, 29, 29, 0.2);
    color: #fecaca;
    font-size: 13px;
    line-height: 1.4;
}

.save-id-option {
    display: flex;
    align-items: center;
    gap: 7px;
    margin: -4px 0 20px;
    color: #94a3b8;
    font-size: 13px;
    cursor: pointer;
}

.save-id-option input {
    width: auto;
    margin: 0;
    accent-color: #0ea5e9;
}
</style>
</head>
<body class="login-page">


<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="login-wrapper">
    <div class="login-container">
        <h2>시스템 로그인</h2>
        <c:set var="loginMemberId" value="${sessionScope.LOGIN_MEMBER_ID}" />
        <c:choose>
            <c:when test="${not empty sessionScope.ERROR_MSG}">
                <div class="login-alert"><c:out value="${sessionScope.ERROR_MSG}" /></div>
            </c:when>
            <c:when test="${not empty msg}">
                <div class="login-alert"><c:out value="${msg}" /></div>
            </c:when>
        </c:choose>
        <c:remove var="ERROR_MSG" scope="session" />
        <c:remove var="LOGIN_MEMBER_ID" scope="session" />

        <form:form id="loginForm" action="${pageContext.request.contextPath}/login" method="post">
            
            
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            
            
            <div class="input-group">
                <label for="username">사번 (아이디)</label> 
                <input type="text" id="username" name="memberId" placeholder="사번을 입력하세요" required autocomplete="username" value="<c:out value='${loginMemberId}'/>">
            </div>
            
            
            <div class="input-group">
                <label for="password">비밀번호</label> 
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required autocomplete="current-password">
            </div>

            <label class="save-id-option" for="saveId">
                <input type="checkbox" id="saveId" name="saveId">
                아이디 저장
            </label>

            <button type="submit" class="login-btn">접속하기</button>
            
        </form:form>
    </div>
</div>
	<script>
        (function () {
            function getCookie(name) {
                const prefix = name + '=';
                return document.cookie.split(';').map(function (item) {
                    return item.trim();
                }).filter(function (item) {
                    return item.indexOf(prefix) === 0;
                }).map(function (item) {
                    return item.substring(prefix.length);
                })[0] || '';
            }

            const savedId = getCookie('saveId');
            if (!savedId) {
                return;
            }

            try {
                document.getElementById('username').value = decodeURIComponent(savedId);
                document.getElementById('saveId').checked = true;
            } catch (ignore) {
                // Ignore a malformed non-sensitive convenience cookie.
            }
        })();
    </script>
	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>

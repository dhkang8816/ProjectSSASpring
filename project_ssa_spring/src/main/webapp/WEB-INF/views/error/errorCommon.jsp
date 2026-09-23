<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/images/KakaoTalk_20260923_120441893.png?v=1">
<meta charset="UTF-8">
<title>시스템 오류 안내</title>
</head>
<body>
	<div
		style="margin: 50px; text-align: center; border: 1px solid red; padding: 30px; background-color: #fff8f8;">
		<h2 style="color: red;">⚠️ 서비스 이용에 불편을 드려 죄송합니다.</h2>
		<p style="font-size: 16px; font-weight: bold;">${errorMsg}</p>

		<button type="button" onclick="history.back();">이전 페이지로</button>
		<button type="button"
			onclick="location.href='${pageContext.request.contextPath}/'">메인으로</button>
	</div>
</body>
</html>

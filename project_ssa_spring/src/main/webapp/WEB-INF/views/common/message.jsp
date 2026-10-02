<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/images/KakaoTalk_20260923_120441893.png?v=1">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>안내 메시지</title>
</head>
<body>

</body>
<script>
	var message = "${message}";
	if (message) {
		alert(message);
	}
	var redirectUrl = "${redirectUrl}";
	if (redirectUrl) {
		location.href = "${pageContext.request.contextPath}" + redirectUrl;
	} else {
		history.back();
	}
</script>
</html>

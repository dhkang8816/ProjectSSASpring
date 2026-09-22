<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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

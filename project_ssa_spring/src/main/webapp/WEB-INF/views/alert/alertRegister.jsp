<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 경보 이력</title>

</head>
<body>
	<h2>신규 경보 이력</h2>

	<form:form action="${pageContext.request.contextPath}/alert/register"
		method="post" onsubmit="return validateForm();">
		<table border="1" style="width: 500px; border-collapse: collapse;">
			<colgroup>
				<col style="width: 30%; background-color: #f2f2f2;">
				<col style="width: 70%;">
			</colgroup>
			<tbody>
				
				<tr>
					<th style="padding: 8px; text-align: left;">경보대상구분 *</th>
					<td style="padding: 8px;"><select name="alertType"
						id="alertType" style="width: 100%;">
							<option value="">-- 선택 --</option>
							
							<c:forEach var="code" items="${alertTypeCodeList}">
								
								<option value="${code.code}"><c:out
										value="${code.codeName}" /></option>
							</c:forEach>
					</select></td>
				</tr>
				
				<tr>
					<th style="padding: 8px; text-align: left;">알림 메시지 내용 *</th>
					<td style="padding: 8px;"><textarea name="alertMsg"
							id="alertMsg" rows="5" style="width: 97%; resize: none;"
							maxlength="200" placeholder="경보 내용을 입력하세요. (최대 200자)"></textarea>
					</td>
				</tr>
				
				<tr>
					<th style="padding: 8px; text-align: left;">전송성공여부</th>
					<td style="padding: 8px;"><label><input type="radio"
							name="sendStatus" value="성공"> 성공</label> <label
						style="margin-left: 10px;"><input type="radio"
							name="sendStatus" value="실패" checked> 실패</label></td>
				</tr>
				
				<tr>
					<th style="padding: 8px; text-align: left;">탐지이력시퀀스</th>
					<td style="padding: 8px;"><input type="number" name="dlogId"
						style="width: 95%;" placeholder="부모 탐지 ID (선택사항)"></td>
				</tr>
				
				<tr>
					<th style="padding: 8px; text-align: left;">이상객체탐지시퀀스</th>
					<td style="padding: 8px;"><input type="number" name="danlogId"
						style="width: 95%;" placeholder="부모 이상객체 ID (선택사항)"></td>
				</tr>
			</tbody>
		</table>

		<br>

		<div>
			<button type="submit">등록</button>
			<button type="button" style="margin-left: 5px;"
				onclick="location.href='${pageContext.request.contextPath}/alert/list'">취소</button>
		</div>
	</form:form>

</body>
<script>
	function validateForm() {
		var alertType = document.getElementById("alertType").value;
		var alertMsg = document.getElementById("alertMsg").value;

		if (!alertType) {
			alert("경보대상구분을 선택해주세요.");
			return false;
		}
		if (!alertMsg.trim()) {
			alert("경보 알림 메시지 내용을 입력해주세요.");
			document.getElementById("alertMsg").focus();
			return false;
		}
		return true;
	}
</script>
</html>



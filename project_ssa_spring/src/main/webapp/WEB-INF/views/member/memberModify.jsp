<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/popup.css">
<meta charset="UTF-8">
<title>직원 정보 수정</title>
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 24px;
    box-sizing: border-box;
}


.form-panel {
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

.form-panel h2 {
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


.profile-upload-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
    margin-bottom: 24px;
    box-sizing: border-box;
}

.profile-upload-wrapper label {
    margin-bottom: 10px;
    color: #94a3b8 !important;
    font-size: 13.5px;
    font-weight: 600;
}


.preview-box {
    width: 150px;
    height: 185px;
    border: 2px solid #0ea5e9;
    box-shadow: 0 0 20px rgba(14, 165, 233, 0.2);
    border-radius: 12px;
    object-fit: cover;
    background-color: #111827;
    display: block;
    margin-bottom: 12px;
}


#fileInput {
    font-size: 12px;
    color: #94a3b8;
    margin-bottom: 8px;
}


.form-grid-card {
    width: 100%;
    display: flex;
    flex-direction: column;
    background: rgba(17, 24, 39, 0.5);
    border: 1px solid #1e293b;
    border-radius: 10px;
    padding: 10px 20px;
    box-sizing: border-box;
    margin-bottom: 24px;
}

.form-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 0;
    font-size: 14px;
    border-bottom: 1px solid rgba(30, 41, 59, 0.5);
}
.form-row:last-child {
    border-bottom: none;
}

.form-label {
    color: #94a3b8 !important;
    font-weight: 600;
    width: 100px;
    flex-shrink: 0;
}

.form-value-slot {
    flex: 1;
    text-align: right;
    display: flex;
    justify-content: flex-end;
}


.form-grid-card input[type="text"], 
.form-grid-card input[type="email"], 
.form-grid-card select {
    width: 220px !important; 
    background: #111827 !important;
    padding: 8px 12px !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 13.5px;
    box-sizing: border-box;
    transition: all 0.15s ease-in-out;
    text-align: left;
}

.form-grid-card input:focus, 
.form-grid-card select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}


button, input[type="submit"] {
    padding: 9px 18px;
    font-size: 13.5px;
    font-weight: 700;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.15s ease;
    border: none;
}


.btn-photo-action, .btn-back {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
    font-size: 12px;
    padding: 6px 14px;
}
.btn-photo-action:hover, .btn-back:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}


.btn-submit {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
}
.btn-submit:hover {
    background-color: #0284c7 !important;
    box-shadow: 0 4px 16px rgba(14, 165, 233, 0.35);
    transform: translateY(-1px);
}

.action-bar {
    display: flex;
    justify-content: center;
    gap: 12px;
    width: 100%;
}
button:active { transform: translateY(0); }
</style>
</head>
<body class="popup-page">

<div class="form-panel">
    <h2>⚙ 직원 정보 수정 설정</h2>
    
    
    <form:form modelAttribute="member" action="${pageContext.request.contextPath}/member/modify" method="post" enctype="multipart/form-data">
        
        
        <c:if test="${param.popup eq 'true'}"><input type="hidden" name="popup" value="true" /></c:if>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="deleteOldPicture" id="deleteFlag" value="false">
        
        
        <div class="profile-upload-wrapper">
            <label>프로필 사진 변경 레이더</label>
            <img id="imagePreview" src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" alt="현재 사진" class="preview-box"
                 onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
            
            <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
                <input type="file" name="pictureFile" id="fileInput" accept="image/*" onchange="previewImage(this);" />
                <button type="button" class="btn-photo-action" onclick="removeSelectedImage();">❌ 사진 초기화</button>
            </div>
        </div>
        
        
        <div class="form-grid-card">
            
            <div class="form-row">
                <span class="form-label">사원번호</span>
                <div class="form-value-slot">
                    <strong style="color: #38bdf8; font-size: 15px; padding-right: 6px;">${member.memberId}</strong>
                    <form:hidden path="memberId" />
                </div>
            </div>
            
            
            <div class="form-row">
                <span class="form-label">이름</span>
                <div class="form-value-slot">
                    <form:input path="name" required="required" placeholder="이름을 입력하세요" />
                </div>
            </div>
            
            
            <div class="form-row">
                <span class="form-label">소속 부서</span>
                <div class="form-value-slot">
                    <form:input path="department" placeholder="부서명 입력" />
                </div>
            </div>
            
            
            <div class="form-row">
                <span class="form-label">연락처</span>
                <div class="form-value-slot">
                    <form:input path="phone" placeholder="ex) 010-0000-0000" />
                </div>
            </div>
            
            
            <div class="form-row">
                <span class="form-label">이메일 주소</span>
                <div class="form-value-slot">
                    <form:input path="email" type="email" placeholder="example@domain.com" />
                </div>
            </div>
            
            
            <div class="form-row">
                <span class="form-label">보안 권한</span>
                <div class="form-value-slot">
                    <form:select path="role">
                        <form:options items="${roleList}" itemValue="code" itemLabel="codeName" />
                    </form:select>
                </div>
            </div>
            
            
            <div class="form-row">
                <span class="form-label">계정 상태</span>
                <div class="form-value-slot">
                    <form:select path="status">
                        <form:options items="${statusList}" itemValue="code" itemLabel="codeName" />
                    </form:select>
                </div>
            </div>
        </div> 
        
        
        <div class="action-bar">
            <button type="submit" class="btn-submit">변경사항 저장</button>
            <button type="button" class="btn-back" onclick="location.href='${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}'">취소</button>
        </div>
        
    </form:form>
</div> 
</body>
<script>
	function previewImage(input) {
		var preview = document.getElementById('imagePreview');
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function(e) {
				preview.src = e.target.result;
			}
			reader.readAsDataURL(input.files[0]);
			document.getElementById('deleteFlag').value = "false";
		}
	}
	function removeSelectedImage() {
		var preview = document.getElementById('imagePreview');
		var fileInput = document.getElementById('fileInput');

		fileInput.value = "";
		preview.src = "${pageContext.request.contextPath}/resources/images/member/noImage.jpg";
		document.getElementById('deleteFlag').value = "true";
	}

	(function resizeMemberModifyPopup() {
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
</html>

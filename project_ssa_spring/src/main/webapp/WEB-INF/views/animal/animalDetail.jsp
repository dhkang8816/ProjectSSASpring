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
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>보호 동물 상세 정보</title>
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
    max-width: 500px; 
    margin: 0 auto;
}

h2 {
    color: #ffffff !important;
    margin: 0 0 24px 0 !important;
    font-size: 20px !important;
    font-weight: 700 !important;
    letter-spacing: -0.02em;
    text-align: left;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 12px;
}


.form-group {
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

label {
    display: inline-block;
    color: #38bdf8 !important; 
    font-size: 13.5px;
    font-weight: 700;
}


input[type="text"], select {
    padding: 10px 12px !important;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px !important;
    outline: none;
    font-size: 14px;
    width: 100% !important; 
    box-sizing: border-box;
    transition: all 0.15s ease;
}

input[type="text"]:focus, select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25) !important;
}


input[readonly] {
    background-color: rgba(30, 41, 59, 0.5) !important;
    color: #64748b !important;
    border: 1px solid #1e293b !important;
    cursor: not-allowed !important;
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


button.btn-modify {
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
}
button.btn-modify:hover {
    background-color: #0284c7 !important;
}


button.btn-delete {
    background-color: #ef4444 !important;
    color: #ffffff !important;
}
button.btn-delete:hover {
    background-color: #dc2626 !important;
}


button.btn-list {
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
}
button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
}


a.main-link {
    color: #38bdf8 !important;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
    font-size: 13.5px;
    transition: color 0.15s ease;
}
a.main-link:hover {
    color: #7dd3fc !important;
    text-decoration: underline !important;
}

#animalDetailPage .animal-photo-section {
    align-items: center;
}

#animalDetailPage .animal-photo-preview {
    width: 132px;
    height: 132px;
    object-fit: cover;
    border-radius: 12px;
    border: 1px solid #334155;
    background: #111827;
}

#animalDetailPage .animal-photo-actions {
    display: flex;
    gap: 8px;
    align-items: center;
    flex-wrap: wrap;
}

#animalDetailPage .animal-photo-upload-button {
    padding: 8px 12px;
    background: #1e293b;
    color: #cbd5e1;
    border: 1px solid #334155;
}

#animalDetailPage .animal-photo-status {
    color: #94a3b8;
    font-size: 12px;
}

/* Keep this popup aligned with the member detail popup without affecting other views. */
body.popup-page {
    padding: 24px !important;
    box-sizing: border-box;
}

#animalDetailPage.panel {
    width: 100%;
    max-width: 520px;
    padding: 32px !important;
    border-radius: 14px;
    box-sizing: border-box;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5);
}

#animalDetailPage h2 {
    text-align: center;
    padding-bottom: 16px;
}

#animalDetailPage .btn-group {
    justify-content: center;
    gap: 12px;
}

#animalDetailPage .animal-photo-preview {
    width: 150px;
    height: 185px;
    padding: 6px;
    box-sizing: content-box;
    border: 2px solid #0ea5e9;
    border-radius: 6px;
    box-shadow: 0 0 20px rgba(14, 165, 233, 0.2);
}
</style>

</head>
<body class="popup-page">
<div id="animalDetailPage" class="panel">
    <h2>보호 동물 상세</h2>
    
    
    <form:form id="detailForm" method="post" enctype="multipart/form-data">
        <input type="hidden" name="popup" value="true" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" id="animalPicture" name="animalPicture" value="<c:out value='${animal.animalPicture}'/>" />
        
        <input type="hidden" name="page" value="${pageMaker.page}" />
        <input type="hidden" name="searchType" value="${pageMaker.searchType}" />
        <input type="hidden" name="keyword" value="${pageMaker.keyword}" />

        <div class="form-group animal-photo-section">
            <label for="animalPictureFile">동물 사진</label>
            <c:choose>
                <c:when test="${not empty animal.animalPicture}">
                    <img id="animalPicturePreview"
                         class="animal-photo-preview"
                         src="${pageContext.request.contextPath}/animal/image/<c:out value='${animal.animalPicture}'/>"
                         alt="현재 동물 사진"
                         onerror="this.src='${pageContext.request.contextPath}/resources/images/noImage.jpg';" />
                </c:when>
                <c:otherwise>
                    <img id="animalPicturePreview"
                         class="animal-photo-preview"
                         src="${pageContext.request.contextPath}/resources/images/noImage.jpg"
                         alt="등록된 사진 없음" />
                </c:otherwise>
            </c:choose>
            <div class="animal-photo-actions">
                <input type="file" id="animalPictureFile" accept="image/jpeg,image/png,.jpg,.jpeg,.png" />
                <button type="button" id="animalPictureUploadButton" class="animal-photo-upload-button">이미지 변경</button>
            </div>
            <span id="animalPictureStatus" class="animal-photo-status">새 사진을 등록하지 않으면 기존 사진을 유지합니다.</span>
        </div>
        
        
        <div class="form-group">
            <label>동물 식별 번호</label>
            <input type="text" name="animalId" value="${animal.animalId}" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>축종 구분</label>
            
            <select name="animalType">
                <c:forEach var="code" items="${animalTypeList}">
                    <option value="${code.code}" ${animal.animalType == code.code ? 'selected="selected"' : ''}>
                        ${code.codeName} (${code.code})
                    </option>
                </c:forEach>
            </select>
        </div>
        
        <div class="form-group">
            <label>품종</label>
            <input type="text" name="animalBreed" value="${animal.animalBreed}" required="required" />
        </div>
        
        <div class="form-group">
            <label>동물 이름</label>
            <input type="text" name="animalName" value="${animal.animalName}" required="required" />
        </div>
        
        <div class="form-group">
            <label>입소 날짜</label>
            <input type="text" value="<fmt:formatDate value="${animal.entranceDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" readonly="readonly" />
        </div>
        
        <div class="form-group">
            <label>보호 상태</label>
            
            <select name="animalStatus">
                <c:forEach var="animalStatus" items="${animalStatusList}">
                    <option value="${animalStatus.code}" ${animal.animalStatus == animalStatus.code ? 'selected="selected"' : ''}>${animalStatus.codeName}</option>
                </c:forEach>
            </select>
        </div>
        
        
        <div class="btn-group">
            <button type="button" class="btn-modify" onclick="fn_submit('modify')">수정 완료</button>
            <button type="button" class="btn-delete" onclick="fn_submit('remove')">동물 삭제</button>
            <button type="button" class="btn-list" onclick="fn_goList()">목록으로</button>
        </div>
    </form:form>
</div>
<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>

<script>
function fn_submit(mode) {
    var form = document.getElementById("detailForm");
    if (mode === 'modify') {
        if (!confirm("동물 정보를 수정하시겠습니까?"))
            return;
        form.action = "${pageContext.request.contextPath}/animal/modify";
    } else if (mode === 'remove') {
        if (!confirm("정말로 이 동물 데이터를 삭제하시겠습니까?\n(삭제 시 개체수 대시보드에서 1마리가 자동 감소합니다.)"))
            return;
        form.action = "${pageContext.request.contextPath}/animal/remove";
    }
    form.submit();
}
function fn_goList() {
    return closePopupAndRefreshParent("${pageContext.request.contextPath}/animal/list"
        + "?page=${pageMaker.page}"
        + "&searchType=${pageMaker.searchType}"
        + "&keyword=${pageMaker.keyword}");
}

(function () {
    const contextPath = '${pageContext.request.contextPath}';
    const fileInput = document.getElementById('animalPictureFile');
    const uploadButton = document.getElementById('animalPictureUploadButton');
    const pictureInput = document.getElementById('animalPicture');
    const preview = document.getElementById('animalPicturePreview');
    const status = document.getElementById('animalPictureStatus');
    let currentPicture = pictureInput.value;
    const fallbackImage = contextPath + '/resources/images/noImage.jpg';

    fileInput.addEventListener('change', function () {
        const file = this.files[0];
        if (!file) {
            preview.src = currentPicture
                ? contextPath + '/animal/image/' + encodeURIComponent(currentPicture)
                : fallbackImage;
            status.textContent = '새 사진을 등록하지 않으면 기존 사진을 유지합니다.';
            return;
        }
        preview.src = URL.createObjectURL(file);
        status.textContent = '이미지 변경 버튼을 눌러 저장하세요.';
    });

    uploadButton.addEventListener('click', function () {
        const file = fileInput.files[0];
        if (!file) {
            status.textContent = '변경할 JPG 또는 PNG 파일을 선택하세요.';
            return;
        }

        const formData = new FormData();
        formData.append('pictureFile', file);
        formData.append('${_csrf.parameterName}', '${_csrf.token}');
        uploadButton.disabled = true;
        status.textContent = '이미지를 등록하고 있습니다...';

        fetch(contextPath + '/animal/uploadPicture', {
            method: 'POST',
            headers: { 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest' },
            body: formData
        })
        .then(async function (response) {
            const body = await response.json();
            if (!response.ok || !body.success) {
                throw new Error(body.message || '이미지 등록에 실패했습니다.');
            }
            return body;
        })
        .then(function (body) {
            currentPicture = body.fileName;
            pictureInput.value = body.fileName;
            preview.src = contextPath + '/animal/image/' + encodeURIComponent(body.fileName);
            status.textContent = '새 이미지 등록이 완료되었습니다. 수정 완료를 눌러 반영하세요.';
        })
        .catch(function (error) {
            pictureInput.value = currentPicture;
            preview.src = currentPicture
                ? contextPath + '/animal/image/' + encodeURIComponent(currentPicture)
                : fallbackImage;
            status.textContent = error.message;
        })
        .finally(function () {
            uploadButton.disabled = false;
        });
    });
})();
</script>
<script>
(function resizeAnimalDetailPopup() {
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

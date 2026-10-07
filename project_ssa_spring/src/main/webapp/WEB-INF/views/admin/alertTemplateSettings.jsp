<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
<title>경보 문구 설정</title>
<style>
body {
    margin: 0;
    background: #0b0f19;
}

#alertTemplateSettingsPage {
    box-sizing: border-box;
    padding: 24px 32px;
    color: #e2e8f0;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
}

#alertTemplateSettingsPage *,
#alertTemplateSettingsPage *::before,
#alertTemplateSettingsPage *::after {
    box-sizing: border-box;
}

#alertTemplateSettingsPage .template-panel {
    width: min(900px, 100%);
    margin: 0 auto;
    padding: 24px;
    background: #111827;
    border: 1px solid #263449;
    border-radius: 12px;
}

#alertTemplateSettingsPage .template-title-row {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid #263449;
}

#alertTemplateSettingsPage h2 {
    margin: 0;
    color: #f8fafc;
    font-size: 22px;
}

#alertTemplateSettingsPage .template-description {
    margin: 8px 0 0;
    color: #94a3b8;
    font-size: 13px;
    line-height: 1.6;
}

#alertTemplateSettingsPage .template-history-note {
    margin: 14px 0;
    padding: 11px 13px;
    border-left: 3px solid #38bdf8;
    background: #0f172a;
    color: #cbd5e1;
    font-size: 13px;
    line-height: 1.55;
}

#alertTemplateSettingsPage .template-notice {
    margin: 16px 0;
    padding: 11px 13px;
    border-radius: 7px;
    font-size: 13px;
}

#alertTemplateSettingsPage .template-notice.success {
    color: #bbf7d0;
    background: #123126;
    border: 1px solid #1f6a45;
}

#alertTemplateSettingsPage .template-notice.error {
    color: #fecaca;
    background: #351a22;
    border: 1px solid #7f3140;
}

#alertTemplateSettingsPage .template-form {
    display: grid;
    gap: 12px;
}

#alertTemplateSettingsPage .policy-form {
    display: grid;
    gap: 12px;
    margin-top: 12px;
}

#alertTemplateSettingsPage .template-card {
    padding: 15px;
    background: #0f172a;
    border: 1px solid #263449;
    border-radius: 9px;
}

#alertTemplateSettingsPage .template-card-title {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 0 0 8px;
    color: #f8fafc;
    font-size: 15px;
    font-weight: 700;
}

#alertTemplateSettingsPage .template-variable {
    display: inline-block;
    padding: 2px 6px;
    border: 1px solid #265a78;
    border-radius: 4px;
    color: #7dd3fc;
    font-family: Consolas, monospace;
    font-size: 12px;
}

#alertTemplateSettingsPage .template-card-help {
    margin: 0 0 10px;
    color: #94a3b8;
    font-size: 12px;
    line-height: 1.5;
}

#alertTemplateSettingsPage .policy-input-row {
    display: flex;
    align-items: center;
    gap: 8px;
}

#alertTemplateSettingsPage .policy-input-row input {
    width: 130px;
    height: 38px;
    padding: 0 10px;
    color: #e2e8f0;
    background: #111827;
    border: 1px solid #334155;
    border-radius: 7px;
    font: inherit;
    font-weight: 700;
}

#alertTemplateSettingsPage .policy-input-row input:focus {
    outline: none;
    border-color: #38bdf8;
}

#alertTemplateSettingsPage .policy-input-unit {
    color: #cbd5e1;
    font-size: 14px;
    font-weight: 700;
}

#alertTemplateSettingsPage textarea {
    display: block;
    width: 100%;
    min-height: 82px;
    resize: vertical;
    padding: 12px;
    color: #e2e8f0;
    background: #111827;
    border: 1px solid #334155;
    border-radius: 7px;
    font: inherit;
    line-height: 1.55;
}

#alertTemplateSettingsPage textarea:focus {
    outline: none;
    border-color: #38bdf8;
}

#alertTemplateSettingsPage .template-meta {
    margin: 7px 0 0;
    color: #64748b;
    font-size: 11px;
}

#alertTemplateSettingsPage .template-actions {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 0;
}

#alertTemplateSettingsPage .template-actions button,
#alertTemplateSettingsPage .template-back-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 36px;
    padding: 0 14px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 700;
    text-decoration: none;
    cursor: pointer;
}

#alertTemplateSettingsPage .template-actions .cancel-button,
#alertTemplateSettingsPage .template-back-link {
    color: #cbd5e1;
    background: #1e293b;
    border: 1px solid #334155;
}

#alertTemplateSettingsPage .template-actions .save-button {
    color: #ffffff;
    background: #0284c7;
    border: 1px solid #38bdf8;
}

#alertTemplateSettingsPage .template-actions .save-button:hover {
    background: #0369a1;
}

@media (max-width: 760px) {
    #alertTemplateSettingsPage {
        padding: 18px 14px;
    }

    #alertTemplateSettingsPage .template-panel {
        padding: 18px;
    }

    #alertTemplateSettingsPage .template-title-row {
        align-items: stretch;
        flex-direction: column;
    }
}
</style>
</head>
<body>
    <main id="alertTemplateSettingsPage">
        <section class="template-panel">
            <div class="template-title-row">
                <div>
                    <h2>경보 문구 설정</h2>
                    <p class="template-description">개체 미달과 위험 이상객체 경보에 사용할 문구를 관리합니다.</p>
                </div>
            </div>

            <p class="template-history-note">저장 후 새로 생성되는 경보에만 적용됩니다. 기존 감지·경보 이력의 문구는 감사 기록으로 보존됩니다.</p>

            <c:if test="${not empty templateSuccess}">
                <div class="template-notice success"><c:out value="${templateSuccess}" /></div>
            </c:if>
            <c:if test="${not empty templateError}">
                <div class="template-notice error"><c:out value="${templateError}" /></div>
            </c:if>
            <c:if test="${not empty policySuccess}">
                <div class="template-notice success"><c:out value="${policySuccess}" /></div>
            </c:if>
            <c:if test="${not empty policyError}">
                <div class="template-notice error"><c:out value="${policyError}" /></div>
            </c:if>

            <c:set var="animalTemplate" value="${templatesByKey['ANIMAL_SHORTAGE']}" />
            <c:set var="dangerTemplate" value="${templatesByKey['DANGER_OBJECT']}" />
            <form:form class="template-form" method="post" action="${pageContext.request.contextPath}/admin/alert-templates?popup=true">
                <article class="template-card">
                    <h3 class="template-card-title">개체 미달 경보 <span class="template-variable">{animalName}</span></h3>
                    <p class="template-card-help">동물명 위치에 <code>{animalName}</code> 변수가 자동으로 치환됩니다. 이 변수는 삭제할 수 없습니다.</p>
                    <textarea id="animalShortageTemplate" name="animalShortageTemplate" maxlength="1000" required><c:out value="${animalTemplate.templateText}" /></textarea>
                    <p class="template-meta">마지막 저장: <c:choose><c:when test="${not empty animalTemplate.updatedAt}"><fmt:formatDate value="${animalTemplate.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" /> · <c:out value="${animalTemplate.updatedBy}" /></c:when><c:otherwise>기본 문구 사용 중</c:otherwise></c:choose></p>
                </article>

                <article class="template-card">
                    <h3 class="template-card-title">위험 이상객체 경보 <span class="template-variable">{dangerName}</span></h3>
                    <p class="template-card-help">탐지된 위험 객체명 위치에 <code>{dangerName}</code> 변수가 자동으로 치환됩니다. 이 변수는 삭제할 수 없습니다.</p>
                    <textarea id="dangerObjectTemplate" name="dangerObjectTemplate" maxlength="1000" required><c:out value="${dangerTemplate.templateText}" /></textarea>
                    <p class="template-meta">마지막 저장: <c:choose><c:when test="${not empty dangerTemplate.updatedAt}"><fmt:formatDate value="${dangerTemplate.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" /> · <c:out value="${dangerTemplate.updatedBy}" /></c:when><c:otherwise>기본 문구 사용 중</c:otherwise></c:choose></p>
                </article>

                <div class="template-actions">
                    <button type="reset" class="cancel-button">입력 취소</button>
                    <button type="submit" class="save-button">문구 저장</button>
                </div>
            </form:form>

            <form:form class="policy-form" method="post" action="${pageContext.request.contextPath}/admin/alert-policy?popup=true">
                <article class="template-card">
                    <h3 class="template-card-title">미달 경보 지속 시간</h3>
                    <p class="template-card-help">동물 탐지 결과에서 보호중 개체수가 기준보다 적은 상태가 이 시간 이상 연속될 때 경보를 생성합니다. 설정 변경 후 진행 중이던 미달 시간은 새 기준으로 다시 계산됩니다.</p>
                    <div class="policy-input-row">
                        <input id="underTargetSeconds" name="underTargetSeconds" type="number"
                               min="1" max="3600" step="1" required
                               value="${animalShortagePolicy.underTargetSeconds}" />
                        <span class="policy-input-unit">초</span>
                    </div>
                    <p class="template-meta">현재 설정: <c:out value="${animalShortagePolicy.underTargetSeconds}" />초<c:if test="${not empty animalShortagePolicy.updatedAt}"> · 마지막 저장: <fmt:formatDate value="${animalShortagePolicy.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" /> · <c:out value="${animalShortagePolicy.updatedBy}" /></c:if></p>
                </article>

                <div class="template-actions">
                    <button type="button" class="template-back-link" onclick="closeAlertTemplateSettings();">닫기</button>
                    <button type="submit" class="save-button">시간 저장</button>
                </div>
            </form:form>
        </section>
    </main>
    <script>
function closeAlertTemplateSettings() {
    if (window.opener && !window.opener.closed) {
        window.close();
        return;
    }
    window.location.href = '${pageContext.request.contextPath}/alert/list';
}

function fitAlertTemplateSettingsPopup() {
    if (!window.opener || window.opener.closed) {
        return;
    }

    var chromeHeight = Math.max(0, window.outerHeight - window.innerHeight);
    var popupWidth = Math.max(640, Math.min(860, screen.availWidth - 40));
    var contentHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
    var popupHeight = Math.max(600, Math.min(contentHeight + chromeHeight + 4, screen.availHeight - 36));
    var left = Math.max(0, Math.round((screen.availWidth - popupWidth) / 2));
    var top = Math.max(12, Math.min(24, screen.availHeight - popupHeight - 12));

    window.resizeTo(popupWidth, popupHeight);
    window.moveTo(left, top);
}

window.addEventListener('load', function() {
    window.setTimeout(fitAlertTemplateSettingsPopup, 0);
});
</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>시스템 진단</title>
<style>
#systemDiagnosticsPage.control-page-content {
    position: absolute !important;
    top: 80px !important;
    left: 200px !important;
    width: calc(100% - 200px) !important;
    min-height: calc(100vh - 80px);
    box-sizing: border-box;
    padding: 30px 40px;
    color: #e2e8f0;
    z-index: 50 !important;
}

#systemDiagnosticsPage .diagnostics-panel {
    max-width: 1180px;
    margin: 0 auto;
    padding: 26px;
    border: 1px solid #24344d;
    border-radius: 14px;
    background: #111827;
    box-shadow: 0 12px 30px rgba(0, 0, 0, .22);
}

#systemDiagnosticsPage .diagnostics-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 10px;
}

#systemDiagnosticsPage h2 {
    margin: 0;
    color: #f8fafc;
    font-size: 22px;
}

#systemDiagnosticsPage .diagnostics-description {
    margin: 0 0 22px;
    color: #94a3b8;
    font-size: 13px;
    line-height: 1.6;
}

#systemDiagnosticsPage .diagnostics-refresh {
    border: 1px solid #38bdf8;
    border-radius: 7px;
    padding: 8px 13px;
    background: #0ea5e9;
    color: #fff;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
}

#systemDiagnosticsPage .diagnostics-refresh:disabled {
    cursor: wait;
    opacity: .65;
}

#systemDiagnosticsPage .diagnostics-summary {
    margin-bottom: 14px;
    color: #94a3b8;
    font-size: 12px;
}

#systemDiagnosticsPage .diagnostics-table-wrap {
    overflow-x: auto;
    border: 1px solid #27364d;
    border-radius: 9px;
}

#systemDiagnosticsPage .diagnostics-table {
    width: 100%;
    min-width: 760px;
    border-collapse: collapse;
    font-size: 13px;
}

#systemDiagnosticsPage .diagnostics-table th,
#systemDiagnosticsPage .diagnostics-table td {
    padding: 13px 14px;
    border-bottom: 1px solid #243044;
    text-align: left;
}

#systemDiagnosticsPage .diagnostics-table th {
    background: #0f172a;
    color: #7dd3fc;
    font-size: 12px;
}

#systemDiagnosticsPage .diagnostics-table tbody tr:last-child td {
    border-bottom: 0;
}

#systemDiagnosticsPage .diagnostics-table td:nth-child(3),
#systemDiagnosticsPage .diagnostics-table td:nth-child(4),
#systemDiagnosticsPage .diagnostics-table td:nth-child(5) {
    white-space: nowrap;
}

#systemDiagnosticsPage .diagnostics-badge {
    display: inline-block;
    min-width: 44px;
    padding: 4px 7px;
    border-radius: 999px;
    text-align: center;
    font-size: 11px;
    font-weight: 800;
}

#systemDiagnosticsPage .diagnostics-badge.pass {
    color: #86efac;
    background: rgba(34, 197, 94, .14);
}

#systemDiagnosticsPage .diagnostics-badge.warn {
    color: #fcd34d;
    background: rgba(245, 158, 11, .14);
}

#systemDiagnosticsPage .diagnostics-badge.fail {
    color: #fca5a5;
    background: rgba(239, 68, 68, .14);
}

#systemDiagnosticsPage .diagnostics-empty {
    color: #94a3b8;
    text-align: center !important;
}

@media (max-width: 760px) {
    #systemDiagnosticsPage.control-page-content {
        top: 64px !important;
        left: 0 !important;
        width: 100% !important;
        min-height: calc(100vh - 64px);
        padding: 20px 16px;
    }
    #systemDiagnosticsPage .diagnostics-panel {
        padding: 18px;
    }
}
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/menu.jsp" />
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main id="systemDiagnosticsPage" class="control-page-content">
        <section class="diagnostics-panel" aria-labelledby="diagnosticsTitle">
            <div class="diagnostics-heading">
                <h2 id="diagnosticsTitle">시스템 진단</h2>
                <button id="diagnosticsRefresh" type="button" class="diagnostics-refresh">전체 진단 실행</button>
            </div>
            <p class="diagnostics-description">
                이 화면은 읽기 전용입니다. DB 조회, 서비스 상태 API 및 공개 API 연결만 확인하며,
                카메라·YOLO·ESP32 부저·Discord 전송을 새로 실행하지 않습니다.
            </p>
            <div id="diagnosticsSummary" class="diagnostics-summary" aria-live="polite">진단 준비 중</div>
            <div class="diagnostics-table-wrap">
                <table class="diagnostics-table">
                    <thead>
                        <tr>
                            <th scope="col">항목</th>
                            <th scope="col">상태</th>
                            <th scope="col">응답 시간</th>
                            <th scope="col">점검 시각</th>
                            <th scope="col">결과</th>
                        </tr>
                    </thead>
                    <tbody id="diagnosticsRows">
                        <tr><td colspan="5" class="diagnostics-empty">진단을 실행하는 중입니다.</td></tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

<script>
(function () {
    var contextPath = '${pageContext.request.contextPath}';
    var refreshButton = document.getElementById('diagnosticsRefresh');
    var summary = document.getElementById('diagnosticsSummary');
    var rows = document.getElementById('diagnosticsRows');

    function escapeHtml(value) {
        return String(value == null ? '' : value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function formatCheckedAt(value) {
        var date = new Date(value);
        return isNaN(date.getTime()) ? '-' : date.toLocaleString('ko-KR');
    }

    function render(results) {
        if (!Array.isArray(results) || results.length === 0) {
            rows.innerHTML = '<tr><td colspan="5" class="diagnostics-empty">표시할 진단 결과가 없습니다.</td></tr>';
            summary.textContent = '진단 결과 없음';
            return;
        }
        var counts = { PASS: 0, WARN: 0, FAIL: 0 };
        rows.innerHTML = results.map(function (item) {
            var status = item.status || 'FAIL';
            counts[status] = (counts[status] || 0) + 1;
            return '<tr>'
                + '<td>' + escapeHtml(item.name) + '</td>'
                + '<td><span class="diagnostics-badge ' + status.toLowerCase() + '">' + escapeHtml(status) + '</span></td>'
                + '<td>' + escapeHtml(item.responseTimeMs) + ' ms</td>'
                + '<td>' + escapeHtml(formatCheckedAt(item.checkedAt)) + '</td>'
                + '<td>' + escapeHtml(item.message) + '</td>'
                + '</tr>';
        }).join('');
        summary.textContent = 'PASS ' + counts.PASS + ' · WARN ' + counts.WARN + ' · FAIL ' + counts.FAIL;
    }

    function runDiagnostics() {
        refreshButton.disabled = true;
        summary.textContent = '진단 실행 중';
        fetch(contextPath + '/admin/diagnostics/all', { headers: { 'Accept': 'application/json' } })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status);
                }
                return response.json();
            })
            .then(render)
            .catch(function () {
                rows.innerHTML = '<tr><td colspan="5" class="diagnostics-empty">진단 결과를 불러오지 못했습니다.</td></tr>';
                summary.textContent = '진단 요청 실패';
            })
            .finally(function () {
                refreshButton.disabled = false;
            });
    }

    refreshButton.addEventListener('click', runDiagnostics);
    runDiagnostics();
}());
</script>
</body>
</html>

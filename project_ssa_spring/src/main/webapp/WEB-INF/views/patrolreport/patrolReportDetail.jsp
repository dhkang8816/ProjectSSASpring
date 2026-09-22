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
<title>일일 관제 업무 보고서</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #161920;
	color: #ffffff;
	font-family: 'Pretendard', sans-serif;
	padding: 20px;
}

.report-frame {
	background: #222733;
	border: 1px solid #2c313d;
	border-radius: 12px;
	padding: 30px;
	max-width: 850px;
	margin: 20px auto;
}

.layout-segment {
	border: 1px solid #3d4354;
	border-radius: 8px;
	padding: 18px;
	margin-bottom: 20px;
	background-color: #1a1e29;
}

.segment-title {
	font-weight: bold;
	font-size: 14px;
	margin-bottom: 12px;
	padding-bottom: 6px;
	border-bottom: 2px solid #5ddcff;
}


.status-select {
	padding: 6px 16px;
	border-radius: 6px;
	font-size: 14px;
	font-weight: bold;
	background-color: #161920;
	outline: none;
	transition: 0.2s;
	cursor: default;
}

.sel-0 {
	color: #f1c40f;
	border: 1px solid #f1c40f;
} 
.sel-1 {
	color: #2ecc71;
	border: 1px solid #2ecc71;
} 
.sel-2 {
	color: #e74c3c;
	border: 1px solid #e74c3c;
}

.rejection-status-wrapper {
	position: relative;
	display: inline-block;
}

.rejection-reason-popup {
	position: absolute;
	top: calc(100% + 9px);
	right: 0;
	z-index: 20;
	width: min(360px, calc(100vw - 56px));
	padding: 14px 16px;
	box-sizing: border-box;
	border: 1px solid rgba(231, 76, 60, .7);
	border-radius: 8px;
	background: #2a1720;
	box-shadow: 0 12px 28px rgba(0, 0, 0, .42);
	color: #fecaca;
	font-size: 13px;
	font-weight: normal;
	line-height: 1.55;
	text-align: left;
}

.rejection-reason-popup::before {
	content: '';
	position: absolute;
	top: -6px;
	right: 18px;
	width: 10px;
	height: 10px;
	border-top: 1px solid rgba(231, 76, 60, .7);
	border-left: 1px solid rgba(231, 76, 60, .7);
	background: #2a1720;
	transform: rotate(45deg);
}

.rejection-reason-popup strong {
	display: block;
	margin-bottom: 5px;
	color: #f87171;
	font-size: 12px;
}

.rejection-reason-text {
	display: block;
	white-space: pre-wrap;
	word-break: break-word;
}
.grid-metrics {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 15px;
	text-align: center;
	margin-bottom: 15px;
}

.chart-box {
	background: #161920;
	border-radius: 6px;
	padding: 15px;
	border: 1px solid #2c313d;
}

.chart-title {
	font-size: 12px;
	color: #5ddcff;
	font-weight: bold;
	margin-bottom: 8px;
	display: flex;
	align-items: center;
	gap: 5px;
}

@page {
	size: A4;
	margin: 12mm;
}

@media print {
	body {
		background: #ffffff !important;
		color: #000000 !important;
		padding: 0;
	}
	.no-print {
		display: none !important;
	}
	.report-frame, .layout-segment, .chart-box, .grid-metrics>div {
		background: #ffffff !important;
		color: #000000 !important;
		box-shadow: none !important;
	}
	.report-frame {
		max-width: none;
		margin: 0;
		padding: 0;
		border: 0;
	}
	.report-frame * {
		color: #000000 !important;
	}
	.layout-segment {
		break-inside: avoid;
	}
	canvas {
		max-width: 100% !important;
	}
}
</style>
</head>
<body class="popup-page">
	<div class="report-frame">
		<div
			class="d-flex justify-content-between align-items-center mb-3 pb-2"
			style="border-bottom: 1px solid #3d4354;">
			<h2 style="color: #ffffff; margin: 0; font-weight: bold;">일일
				관제 업무 보고서</h2>

			
			<div class="d-flex gap-2 align-items-center no-print">
				<button type="button" class="btn btn-outline-light"
					onclick="window.print();">인쇄</button>
				<c:choose>
					<c:when test="${report.confirmStatus eq '2'}">
						<div class="rejection-status-wrapper">
							<span class="status-select sel-2">반려</span>
							<div class="rejection-reason-popup" role="alert">
								<strong>반려 사유</strong>
								<span class="rejection-reason-text"><c:choose><c:when test="${not empty rejectReason}"><c:out value="${rejectReason}" /></c:when><c:otherwise>등록된 반려 사유가 없습니다.</c:otherwise></c:choose></span>
							</div>
						</div>
					</c:when>
					<c:when test="${report.confirmStatus eq '1'}">
						<span class="status-select sel-1">승인 완료</span>
					</c:when>
					<c:otherwise>
						<span class="status-select sel-0">승인 대기</span>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		
		<div class="layout-segment">
			<div class="segment-title text-info">☝️ 관제 책임자 식별 레코드</div>
			<div class="row" style="font-size: 14px; row-gap: 8px;">
				<div class="col-6">
					<span class="text-muted">📅 업무 일자:</span> <strong
						class="text-white"><fmt:formatDate
							value="${report.reportDate}" pattern="yyyy-MM-dd" /></strong>
				</div>
				<div class="col-6">
					<span class="text-muted">🔑 담당자 사번:</span> <strong
						class="text-white">${report.memberId}</strong>
				</div>
				<div class="col-6">
					<span class="text-muted">👤 관제원 성명:</span> <strong
						style="color: #ffae19;">${memberName}</strong>
				</div>
				<div class="col-6">
					<span class="text-muted">🏢 소속(부서):</span> <strong
						class="text-white">${memberDept}</strong>
				</div>
			</div>
		</div>

		
		<div class="layout-segment">
			<div class="segment-title" style="color: #ffae19;">📝 현장 조치 내역
				및 종합 비고 이력</div>
			<div style="font-size: 14px;">
				<span
					style="font-size: 12px; color: #888; display: block; margin-bottom: 4px;">■
					당일 현장 조치내용 (ACTION_TAKEN)</span>
				<p
					style="background: #161920; padding: 12px; border-radius: 6px; margin-bottom: 15px; line-height: 1.6;">
					<c:out value="${report.actionTaken}" />
				</p>

				<span
					style="font-size: 12px; color: #888; display: block; margin-bottom: 4px;">■
					특이사항 및 비고 (REMARK)</span>
				<p
					style="background: #161920; padding: 12px; border-radius: 6px; margin: 0; line-height: 1.6; color: #ffae19;">
					<c:out value="${report.remark}" />
				</p>
			</div>
		</div>

		
		<div class="layout-segment">
			<div class="segment-title text-success">📊 라이브 관제 통계 수치 및 트렌드
				분석 차트</div>

			<div class="grid-metrics">
				<div
					style="background: #161920; padding: 12px; border-radius: 6px; border-top: 4px solid #3498db;">
					<div style="font-size: 11px; color: #aaa;">당일 드론 총 비행시간</div>
					<div
						style="font-size: 20px; font-weight: bold; color: white; margin-top: 3px;">${report.totalFlightTime}
						<span style="font-size: 12px;">시간</span>
					</div>
				</div>
				<div
					style="background: #161920; padding: 12px; border-radius: 6px; border-top: 4px solid #e74c3c;">
					<div style="font-size: 11px; color: #aaa;">당일 탐지 총 건수</div>
					<div
						style="font-size: 20px; font-weight: bold; color: #ff6b6b; margin-top: 3px;">${report.totalDetectCount}
						<span style="font-size: 12px;">건</span>
					</div>
				</div>
				<div
					style="background: #161920; padding: 12px; border-radius: 6px; border-top: 4px solid #2ecc71;">
					<div style="font-size: 11px; color: #aaa;">당일 조치 완료율</div>
					<div
						style="font-size: 20px; font-weight: bold; color: #2ecc71; margin-top: 3px;">${report.completionRate}
						<span style="font-size: 12px;">%</span>
					</div>
				</div>
			</div>

			
			<div class="row g-3 mb-3">
				<div class="col-6">
					<div class="chart-box">
						<div class="chart-title">📈 최근 5일간 누적 이상객체 검출 추이 (건)</div>
						<div style="height: 180px;">
							<canvas id="miniTrendChart"></canvas>
						</div>
					</div>
				</div>
				<div class="col-6">
					<div class="chart-box">
						<div class="chart-title">📊 당일 시간대별 관제 경보 발생 분포 (건)</div>
						<div style="height: 180px;">
							<canvas id="miniHourChart"></canvas>
						</div>
					</div>
				</div>
			</div>

			<div
				style="padding-top: 10px; border-top: 1px dashed #2c313d; font-size: 12px; color: #888; display: flex; justify-content: space-between;">
				<div>
					🕒 최초 데이터 집계시각:
					<fmt:formatDate value="${report.patrolDate}"
						pattern="yyyy-MM-dd HH:mm:ss" />
				</div>
				<div id="modDateZone">
					🔄 수동 강제 재실행 시각:
					<c:choose>
						<c:when test="${empty report.modDate}">
							<span style="color: #555;">이력 없음</span>
						</c:when>
						<c:otherwise>
							<fmt:formatDate value="${report.modDate}"
								pattern="yyyy-MM-dd HH:mm:ss" />
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		
		<div class="d-flex justify-content-between no-print">
			<button type="button" class="btn btn-primary fw-bold"
				onclick="fn_triggerForceUpdate();">🔄 대시보드 수동 강제 재실행</button>
			<div class="d-flex gap-2">
				<c:if test="${canModifyRejectedReport}">
					<button type="button" class="btn btn-warning fw-bold"
						onclick="location.href='${pageContext.request.contextPath}/patrolreport/modify/${report.reportId}?popup=true';">반려 사유 반영 후 수정</button>
				</c:if>
				<form:form
					action="${pageContext.request.contextPath}/patrolreport/delete"
					method="post"
					onsubmit="return confirm('이 업무 보고서를 완전히 영구 삭제하시겠습니까?');">
					<input type="hidden" name="reportId" value="${report.reportId}">
					<input type="hidden" name="popup" value="true">
					<button type="submit" class="btn btn-danger fw-bold">보고서
						삭제</button>
				</form:form>
				<button type="button" class="btn btn-secondary"
					onclick="return closePopupAndRefreshParent('${pageContext.request.contextPath}/patrolreport/list');">목록으로</button>
			</div>
		</div>
	</div>

	<script>

$(document).ready(function() {
    new Chart(document.getElementById('miniTrendChart'), {
        type: 'line',
        data: {
            labels: ['9/7', '9/8', '9/9', '9/10', '오늘'],
            datasets: [{
                label: '탐지수 (건)',
                data: [15, 24, 8, 12, ${report.totalDetectCount}],
                borderColor: '#5ddcff', 
                backgroundColor: 'rgba(93, 220, 255, 0.05)', 
                borderWidth: 2, 
                tension: 0.2, 
                fill: true
            }]
        },
        options: { 
            responsive: true, 
            maintainAspectRatio: false, 
            plugins: { legend: { display: false } } 
        }
    });
    new Chart(document.getElementById('miniHourChart'), {
        type: 'bar',
        data: {
            labels: ['오전(06~12)', '오후(12~18)', '야간(18~06)'],
            datasets: [{
                label: '발생수 (건)',
                data: [
                    Math.round(${report.totalDetectCount} * 0.2), 
                    Math.round(${report.totalDetectCount} * 0.5), 
                    Math.round(${report.totalDetectCount} * 0.3)
                ],
                backgroundColor: ['#3498db', '#ffae19', '#e74c3c']
            }]
        },
        options: { 
            responsive: true, 
            maintainAspectRatio: false, 
            plugins: { legend: { display: false } } 
        }
    });
}); // 💡 유실되었던 도큐먼트 레디 닫는 괄호선 완벽 수리 완료!


function fn_triggerForceUpdate() {
    if (!confirm("라이브 관제 대시보드 코어 엔진에서 최신 데이터를 긁어와 수동 강제 재실행을 격발하시겠습니까?")) {
        return;
    }
    $.ajax({
        url: "${pageContext.request.contextPath}/dashboard/api/ai-briefing",
        type: "GET",
        success: function(res) {
            $.ajax({
                url: "${pageContext.request.contextPath}/patrolreport/recalculate",
                type: "POST",
                data: {
                    reportId: "${report.reportId}",
                    flightTime: res.flightHours,
                    detectCount: res.todayDetectCount,
                    completeRate: res.actionCompleteRate
                },
                success: function(response) {
                    if (response !== "FAIL") {
                        alert("🔄 수동 강제 재실행 및 대시보드 실시간 연동이 정상 완수되었습니다!");
                        $("#modDateZone").html("🔄 수동 강제 재실행 시각: " + response);
                    } else {
                        alert("❌ 데이터 재계산에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("❌ 리포트 재계산 중 통신 오류가 발생했습니다.");
                }
            });
        },
        error: function() {
            alert("❌ AI 브리핑 데이터를 가져오는 데 실패했습니다.");
        }
    });
}
</script>

<script src="${pageContext.request.contextPath}/resources/js/popup-support.js"></script>
</body>
</html>


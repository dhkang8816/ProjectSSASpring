<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>관제 대시보드</title>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<link rel="stylesheet" href="https://cloudflare.com">
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Pretendard', -apple-system, 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
    display: flex;
    flex-direction: row; /* 좌우로 배치 */
}


.dashboard-container {
    position: relative !important;
    top: 0 !important;
    left: 0 !important;
    flex: 1 !important; /* 남은 화면 공간을 가득 채우도록 설정 */
    margin-left: 180px !important; /* 사이드바 너비만큼 여백 주기 (사이드바 실제 너비에 맞춰 조절 가능) */
    margin-top: 70px !important; /* 상단 헤더 높이만큼 여백 */
    padding: 30px 40px !important;
    box-sizing: border-box !important;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    .dashboard-container {
        margin-left: 0 !important;
        width: 100% !important;
        padding: 20px 16px !important;
        top: 0 !important;
    }
}
.header-title {
	font-size: 24px;
	font-weight: 700;
	margin-bottom: 24px;
	color: #38bdf8; 
	display: flex;
	align-items: center;
	gap: 10px;
	letter-spacing: -0.02em;
}


.ai-briefing-panel {
	background: #141a2a !important;
	border: 1px solid #1e293b !important;
	border-radius: 16px !important;
	padding: 28px !important;
	box-shadow: none !important;
	margin-bottom: 30px;
	position: relative;
	overflow: hidden;
	box-sizing: border-box;
}

.panel-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	border-bottom: 1px solid #1e293b;
	padding-bottom: 14px;
	position: relative;
}

.panel-title {
	font-size: 16px;
	font-weight: 700;
	color: #ffffff;
	display: flex;
	align-items: center;
	gap: 8px;
	letter-spacing: -0.01em;
}


.btn-refresh-ai {
	background-color: #1e293b !important; 
	color: #cbd5e1 !important;
	border: 1px solid #334155 !important;
	padding: 8px 16px !important;
	border-radius: 8px !important;
	cursor: pointer;
	font-size: 13px;
	font-weight: 700;
	display: flex;
	align-items: center;
	gap: 6px;
	transition: all 0.15s ease;
}

.btn-refresh-ai:hover {
	background-color: #334155 !important;
	color: #ffffff !important;
	border-color: #0ea5e9 !important;
}

.ai-content-box {
	width: 100%;
	font-size: 14px;
	line-height: 1.7;
	color: #cbd5e1;
	min-height: 80px;
}


.ai-loading {
	color: #64748b;
	display: flex;
	align-items: center;
	gap: 10px;
	font-size: 14px;
	width: 100%;
	justify-content: center;
	padding: 30px 0;
}

.ai-loading i {
	font-size: 20px;
	animation: spin 1s infinite linear;
}


#dashboardPage .print-chart-card {
	background: #111827 !important;
	border: 1px solid #1e293b !important;
	border-radius: 12px !important;
	padding: 24px !important;
	box-sizing: border-box;
	box-shadow: none;
}

.chart-title {
	font-size: 14px;
	color: #ffffff;
	font-weight: 700;
	margin-bottom: 18px;
	letter-spacing: -0.01em;
}


#dashboardPage .dashboard-stat-card {
	position: relative;
	overflow: hidden;
	padding: 20px;
	border: 1px solid #263449;
	border-top: 2px solid var(--stat-accent, #38bdf8);
	border-radius: 10px;
	background: #111827;
	box-shadow: none;
}

.dashboard-date-region {
	position: absolute;
	left: 50%;
	transform: translateX(-50%);
	display: inline-flex;
	align-items: center;
	gap: 10px;
	white-space: nowrap;
}

.dashboard-date-control {
	display: inline-flex;
	align-items: center;
	gap: 7px;
	color: #94a3b8;
	font-size: 12px;
	font-weight: 700;
}

.dashboard-date-control input[type="date"] {
	min-height: 32px;
	padding: 5px 8px;
	border: 1px solid #334155;
	border-radius: 7px;
	background: #0f172a;
	color: #e2e8f0;
	font: inherit;
	color-scheme: dark;
}

.dashboard-date-control input[type="date"]:focus {
	outline: none;
	border-color: #38bdf8;
}

.dashboard-date-control .btn-today {
	min-height: 32px;
	padding: 5px 9px;
	border: 1px solid #334155;
	border-radius: 7px;
	background: #172033;
	color: #cbd5e1;
	font: inherit;
	font-size: 12px;
	font-weight: 700;
	cursor: pointer;
}

.dashboard-date-control .btn-today:hover {
	border-color: #38bdf8;
	color: #ffffff;
}

.dashboard-report-date {
	margin: 0;
	color: #94a3b8;
	font-size: 12px;
	font-variant-numeric: tabular-nums;
	white-space: nowrap;
}

@media (max-width: 1100px) {
	.panel-header {
		flex-wrap: wrap !important;
	}
	.dashboard-date-region {
		position: static;
		order: 3;
		width: 100%;
		justify-content: center;
		transform: none;
		margin-top: 10px;
	}
}

#dashboardPage .dashboard-stat-card::before {
	display: none;
}

#dashboardPage #aiBriefingContent>div {
	grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)) !important;
}

#dashboardGraphZone>div, .chart-row-zone {
	grid-template-columns: repeat(auto-fit, minmax(380px, 1fr)) !important;
}

.chart-item-wrapper {
	min-width: 0 !important;
	position: relative;
	width: 100%;
}

#dashboardPage canvas {
	width: 100% !important;
	height: 100% !important;
}

@
keyframes spin { 0% {
	transform: rotate(0deg);
}

100


%
{
transform


:


rotate
(


360deg


)
;


}
}
}

@page {
	size: A4 portrait;
	margin: 8mm;
}

@media print {
	html, body {
		width: 100%;
		height: auto;
		margin: 0 !important;
		padding: 0 !important;
		background: #fff !important;
	}
	body>:not(.dashboard-container), .no-print {
		display: none !important;
	}
	.dashboard-container {
		position: static !important;
		width: 100% !important;
		max-width: none !important;
		margin: 0 !important;
		padding: 0 !important;
		left: auto !important;
		top: auto !important;
		box-sizing: border-box !important;
		background: none !important;
	}
	.ai-briefing-panel {
		width: 100% !important;
		padding: 10px !important;
		margin: 0 !important;
		background: rgba(20, 26, 42, 0.85) !important;
		border-color: #1e293b !important;
		border-radius: 8px !important;
		box-shadow: none !important;
		backdrop-filter: none !important;
		-webkit-print-color-adjust: exact !important;
		print-color-adjust: exact !important;
		box-sizing: border-box !important;
	}
	.panel-header {
		margin-bottom: 8px !important;
		padding-bottom: 6px !important;
	}
	.dashboard-report-date {
		margin-left: auto !important;
		font-size: 10px !important;
		color: #64748b !important;
	}

	
	#aiBriefingContent>div {
		grid-template-columns: repeat(4, 1fr) !important;
		gap: 6px !important;
		padding: 3px 0 !important;
	}
	#aiBriefingContent>div>div {
		padding: 7px !important;
	}
	#dashboardPage .dashboard-stat-card {
		background: #222733 !important;
		border: 1px solid #2c313d !important;
		border-top: 4px solid var(--stat-accent, #38bdf8) !important;
		border-radius: 8px !important;
		box-shadow: none !important;
		-webkit-print-color-adjust: exact !important;
		print-color-adjust: exact !important;
	}
	#dashboardPage .dashboard-stat-card::before {
		display: none !important;
	}

	
	#dashboardGraphZone>div, .chart-row-zone {
		width: 100% !important;
		grid-template-columns: 1fr 1fr !important;
		gap: 7px !important;
		box-sizing: border-box !important;
	}
	#dashboardGraphZone, .chart-row-zone {
		margin-top: 8px !important;
	}
	#dashboardPage .print-chart-card {
		padding: 8px !important;
		box-sizing: border-box !important;
		break-inside: avoid !important;
		page-break-inside: avoid !important;
		background: #222733 !important;
		border: 1px solid #2c313d !important;
		box-shadow: none !important;
		backdrop-filter: none !important;
		-webkit-print-color-adjust: exact !important;
		print-color-adjust: exact !important;
	}

	
	.print-chart-card>div[style*="height: 250px"] {
		height: 145px !important;
	}
	canvas {
		width: 100% !important;
		height: 100% !important;
		max-width: 100% !important;
	}
}
</style>

</head>
<body>
	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div id="dashboardPage" class="dashboard-container">
		
		<div class="ai-briefing-panel">
			<div class="panel-header"
				style="display: flex; justify-content: space-between; align-items: center; flex-wrap: nowrap; gap: 10px;">
				<div class="panel-title"
					style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
					관제 통계 수치 지표
				</div>
				<div class="dashboard-date-region">
					<div id="dashboardReportDate" class="dashboard-report-date">기준일: 집계 중</div>
					<div class="dashboard-date-control no-print">
						<input type="date" id="dashboardDate" aria-label="대시보드 기준일">
						<button type="button" class="btn-today" onclick="fn_selectTodayDashboardDate()">오늘</button>
					</div>
				</div>
				<div class="d-flex gap-2 no-print"
					style="display: flex; gap: 6px; flex-shrink: 0;">
					<button type="button" class="btn-refresh-ai"
						onclick="window.print()"
						style="padding: 4px 10px; font-size: 12px; white-space: nowrap;">
						인쇄</button>
					<button type="button" class="btn-refresh-ai"
						onclick="fn_fetchAiBriefing()"
						style="padding: 4px 10px; font-size: 12px; white-space: nowrap;">
						<i class="fa-solid fa-arrows-rotate"></i> 분석 동기화
					</button>
				</div>
			</div>

			
			<div id="aiBriefingContent" class="ai-content-box">
				<div class="ai-loading">
					<i class="fa-solid fa-gear"></i> 오라클 통합 로그 데이터 집계 엔진 가동 중...
				</div>
			</div>

			
			<div id="dashboardGraphZone"
				style="width: 100%; margin-top: 25px; display: none;">
				<div
					style="width: 100%; display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
					
					<div class="print-chart-card">
						<div
							style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
							<i class="fa-solid fa-calendar-days"
								style="color: #5ddcff; margin-right: 6px;"></i><span id="trendChartTitle">최근 7일간 일별 트렌드</span>
						</div>
						<div style="position: relative; width: 100%; height: 250px;">
							<canvas id="trendChart"></canvas>
						</div>
					</div>
					
					<div class="print-chart-card">
						<div
							style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
							<i class="fa-solid fa-clock"
								style="color: #ffae19; margin-right: 6px;"></i><span id="timeChartTitle">당일 시간대별 통계</span>
						</div>
						<div style="position: relative; width: 100%; height: 250px;">
							<canvas id="timeChart"></canvas>
						</div>
					</div>
				</div>
			</div>

			
			<div class="chart-row-zone"
				style="width: 100%; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 25px;">
				
				<div class="print-chart-card">
					<div
						style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
						<i class="fa-solid fa-dog"
							style="color: #2ecc71; margin-right: 6px;"></i><span id="animalChartTitle">축종별 경보 발생 분포</span>
					</div>
					<div style="position: relative; width: 100%; height: 250px;">
						<canvas id="animalChart"></canvas>
					</div>
				</div>

				
				<div class="print-chart-card">
					<div
						style="font-size: 14px; color: #ffffff; font-weight: 600; margin-bottom: 15px;">
						<i class="fa-solid fa-skull-crossbones"
							style="color: #e74c3c; margin-right: 6px;"></i><span id="dangerTypeChartTitle">이상객체 유형별 포착 통계</span>
					</div>
					<div style="position: relative; width: 100%; height: 250px;">
						<canvas id="dangerTypeChart"></canvas>
					</div>
				</div>

			</div>
		</div>


	</div>

</body>

<script>
	$(document).ready(function() {
		var today = getLocalIsoDate();
		$("#dashboardDate").attr("max", today).val(today).on("change", fn_fetchAiBriefing);
		fn_fetchAiBriefing();
	});

	function getLocalIsoDate() {
		var now = new Date();
		var offsetDate = new Date(now.getTime() - now.getTimezoneOffset() * 60000);
		return offsetDate.toISOString().slice(0, 10);
	}

	function fn_selectTodayDashboardDate() {
		$("#dashboardDate").val(getLocalIsoDate());
		fn_fetchAiBriefing();
	}

	function formatFlightDuration(seconds) {
		var totalSeconds = Math.max(0, Math.round(Number(seconds) || 0));
		var minutes = Math.floor(totalSeconds / 60);
		var remainingSeconds = totalSeconds % 60;
		return minutes + '분 ' + String(remainingSeconds).padStart(2, '0') + '초';
	}

	function dashboardCardHtml(title, value, accentColor, valueFontSize) {
		return '  <div class="dashboard-stat-card" style="--stat-accent:' + accentColor + ';">'
				+ '    <div style="font-size:12px; color:#aaa; margin-bottom:8px;">' + title + '</div>'
				+ '    <div style="font-size:' + (valueFontSize || '24px')
				+ '; font-weight:bold; color:' + accentColor + ';">' + value + '</div>'
				+ '  </div>';
	}

	function createDashboardChartGradient(context, startColor, endColor, horizontal) {
		var chart = context.chart;
		var chartArea = chart.chartArea;
		if (!chartArea) {
			return startColor;
		}

		var gradient = horizontal ? chart.ctx.createLinearGradient(chartArea.left, chartArea.top,
				chartArea.right, chartArea.top) : chart.ctx.createLinearGradient(chartArea.left,
				chartArea.top, chartArea.left, chartArea.bottom);
		gradient.addColorStop(0, startColor);
		gradient.addColorStop(1, endColor);
		return gradient;
	}

	function fn_fetchAiBriefing() {
		var $contentBox = $("#aiBriefingContent");
		var selectedDate = $("#dashboardDate").val() || getLocalIsoDate();
		$contentBox
				.html('<div class="ai-loading">'
						+ '    <i class="fa-solid fa-gear"></i> 오라클 통합 수치 집계 및 상황 분석 분석 중...'
						+ '</div>');
		$
				.ajax({
					url : "${pageContext.request.contextPath}/dashboard/api/ai-briefing",
					type : "GET",
					data : { date : selectedDate },
					dataType : "json",
					success : function(res) {
						console.log("✈ [오라클 관제 데이터 수신 완료]:", res);
						try {
							var danger = (res.dangerCount !== undefined && res.dangerCount !== null) ? res.dangerCount
									: 0;
							var detect = (res.detectionCount !== undefined && res.detectionCount !== null) ? res.detectionCount
									: 0;
							var flightDurationSeconds = (res.flightDurationSeconds !== undefined
									&& res.flightDurationSeconds !== null) ? res.flightDurationSeconds
											: Number(res.flightHours || 0) * 3600;
							var todayDetect = (res.todayDetectCount !== undefined && res.todayDetectCount !== null) ? res.todayDetectCount
									: 0;
							var completeRate = (res.actionCompleteRate !== undefined && res.actionCompleteRate !== null) ? res.actionCompleteRate
									: 0.0;
							var score = (res.safetyScore !== undefined && res.safetyScore !== null) ? res.safetyScore
									: 0;
							var cumulativeCompleteRate = (res.cumulativeActionCompleteRate !== undefined
									&& res.cumulativeActionCompleteRate !== null) ? res.cumulativeActionCompleteRate : 0.0;
							var cumulativeFlightDurationSeconds = (res.cumulativeFlightDurationSeconds !== undefined
									&& res.cumulativeFlightDurationSeconds !== null) ? res.cumulativeFlightDurationSeconds : 0;
							var animalAdoptionRate = (res.animalAdoptionRate !== undefined && res.animalAdoptionRate !== null)
									? res.animalAdoptionRate : 0.0;
							var pendingAlertCount = (res.pendingAlertCount !== undefined && res.pendingAlertCount !== null)
									? res.pendingAlertCount : 0;
							var topAlertDroneId = res.topAlertDroneId || '집계 없음';
							var topAlertDroneCount = (res.topAlertDroneCount !== undefined && res.topAlertDroneCount !== null)
									? res.topAlertDroneCount : 0;
							var topFlightDroneId = res.topFlightDroneId || '집계 없음';
							var topFlightDurationSeconds = (res.topFlightDurationSeconds !== undefined
									&& res.topFlightDurationSeconds !== null) ? res.topFlightDurationSeconds : 0;
							var topAlertSummary = topAlertDroneId === '집계 없음' ? topAlertDroneId
									: topAlertDroneId + '<br>' + '[' + topAlertDroneCount + ' 건' + ']';
							var topFlightSummary = topFlightDroneId === '집계 없음' ? topFlightDroneId
									: topFlightDroneId + '<br>' + '[' + formatFlightDuration(topFlightDurationSeconds) + ']';
							var selectedDateLabel = res.selectedDateLabel || selectedDate;

							$("#dashboardReportDate").text("기준일: " + selectedDateLabel);
							$("#trendChartTitle").text(selectedDateLabel + " 기준 최근 7일간 일별 트렌드");
							$("#timeChartTitle").text(selectedDateLabel + " 시간대별 통계");
							$("#animalChartTitle").text(selectedDateLabel + " 축종별 경보 발생 분포");
							$("#dangerTypeChartTitle").text(selectedDateLabel + " 이상객체 유형별 포착 통계");

							var statusText = "안전";
							var statusColor = "#2ecc71";

							if (score >= 70) {
								statusText = "심각 (출동)";
								statusColor = "#e74c3c";
							} else if (score >= 40) {
								statusText = "주의 (감시)";
								statusColor = "#f1c40f";
							} else {
								statusText = "안전";
								statusColor = "#2ecc71";
							}
							var cardHtml = '<div style="width:100%; display:grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap:15px; text-align:center; padding:10px 0;">'
									+ dashboardCardHtml('관제구역 종합 위험도', score + '점<br>[' + statusText + ']', statusColor, '18px')
									+ dashboardCardHtml('탐지 총 건수', todayDetect + ' 건', '#5ddcff')
									+ dashboardCardHtml('현장조치 완료율', completeRate + ' %', '#2ecc71')
									+ dashboardCardHtml('드론 총 비행시간', formatFlightDuration(flightDurationSeconds), '#3498db', '20px')
									+ dashboardCardHtml('누적 위험객체 포착', danger + ' 회', '#e74c3c')
									+ dashboardCardHtml('누적 미달경보 발생', detect + ' 건', '#f1c40f')
									+ dashboardCardHtml('누적 조치 완료율', cumulativeCompleteRate + ' %', '#a78bfa')
									+ dashboardCardHtml('누적 드론 총 비행시간', formatFlightDuration(cumulativeFlightDurationSeconds), '#60a5fa', '20px')
									+ dashboardCardHtml('현재 보호동물 입양율', animalAdoptionRate + ' %', '#fbbf24')
									+ dashboardCardHtml('미조치 경보', pendingAlertCount + ' 건', '#f97316')
									+ dashboardCardHtml('경보 최다 드론', topAlertSummary, '#fb7185', '18px')
									+ dashboardCardHtml('최장 비행 드론', topFlightSummary, '#60a5fa', '18px')
									+ '</div>';
							$("#aiBriefingContent").html(cardHtml);
							$("#dashboardGraphZone").show();
							var ctxTrend = document
									.getElementById('trendChart').getContext(
											'2d');
							if (window.myTrendChart)
								window.myTrendChart.destroy(); // 기존 차트 객체 제거로 버그 방지
							window.myTrendChart = new Chart(
									ctxTrend,
									{
										type : 'line',
										data : {
											labels : res.dateLabels,
											datasets : [
													{
														label : '위험객체 (회)',
														data : res.dangerWeeklyData,
														borderColor : '#fb7185',
														backgroundColor : function(context) {
															return createDashboardChartGradient(context, 'rgba(251, 113, 133, 0.34)', 'rgba(251, 113, 133, 0.01)');
														},
														pointBackgroundColor : '#fb7185',
														borderWidth : 2,
														tension : 0.3,
														fill : true
													},
													{
														label : '미달경보 (건)',
														data : res.detectWeeklyData,
														borderColor : '#facc15',
														backgroundColor : function(context) {
															return createDashboardChartGradient(context, 'rgba(250, 204, 21, 0.30)', 'rgba(250, 204, 21, 0.01)');
														},
														pointBackgroundColor : '#facc15',
														borderWidth : 2,
														tension : 0.3,
														fill : true
													} ]
										},
										options : {
											responsive : true,
											maintainAspectRatio : false,
											resizeDelay : 50, // 👈 렌더링 엇박자 방지 방어선 추가
											plugins : {
												legend : {
													labels : {
														color : '#fff',
														font : {
															size : 10
														}
													}
												}
											},
											scales : {
												x : {
													grid : {
														color : '#2c313d'
													},
													ticks : {
														color : '#aaa',
														font : {
															size : 10
														}
													}
												},
												y : {
													grid : {
														color : '#2c313d'
													},
													ticks : {
														color : '#aaa',
														font : {
															size : 10
														}
													},
													beginAtZero : true
												}
											}
										}

									});
							var ctxTime = document.getElementById('timeChart')
									.getContext('2d');
							if (window.myTimeChart)
								window.myTimeChart.destroy();
							window.myTimeChart = new Chart(ctxTime, {
								type : 'bar',
								data : {
									labels : res.timeLabels,
									datasets : [ {
										label : '위험객체 (회)',
										data : res.dangerTimeData,
										backgroundColor : function(context) {
											return createDashboardChartGradient(context, '#fb7185', 'rgba(251, 113, 133, 0.38)');
										},
										borderRadius : 4
									}, {
										label : '미달경보 (건)',
										data : res.detectTimeData,
										backgroundColor : function(context) {
											return createDashboardChartGradient(context, '#fde047', 'rgba(250, 204, 21, 0.36)');
										},
										borderRadius : 4
									} ]
								},
								options : {
									responsive : true,
									maintainAspectRatio : false,
									resizeDelay : 50,
									plugins : {
										legend : {
											display : false
										}
									},
									scales : {
										x : {
											grid : {
												color : '#2c313d'
											},
											ticks : {
												color : '#aaa',
												font : {
													size : 10
												}
											}
										},
										y : {
											grid : {
												color : '#2c313d'
											},
											ticks : {
												color : '#aaa',
												font : {
													size : 10
												}
											},
											beginAtZero : true
										}
									}
								}

							});
							var ctxAnimal = document.getElementById(
									'animalChart').getContext('2d');
							if (window.myAnimalChart)
								window.myAnimalChart.destroy();
							window.myAnimalChart = new Chart(ctxAnimal, {
								type : 'doughnut',
								data : {
									labels : res.animalLabels,
									datasets : [ {
										data : res.animalData,
										backgroundColor : function(context) {
											var colors = [ [ '#38bdf8', '#2563eb' ], [ '#e2e8f0', '#94a3b8' ], [ '#a78bfa', '#6366f1' ], [ '#34d399', '#0f766e' ] ];
											var palette = colors[context.dataIndex % colors.length];
											return createDashboardChartGradient(context, palette[0], palette[1], true);
										},
										borderColor : 'rgba(226, 232, 240, 0.16)',
										borderWidth : 1
									} ]
								},
								options : {
									responsive : true,
									maintainAspectRatio : false,
									resizeDelay : 50,
									plugins : {
										legend : {
											position : 'right',
											labels : {
												color : '#ffffff'
											}
										}
									}
								}
							});
							var ctxDangerType = document.getElementById(
									'dangerTypeChart').getContext('2d');
							if (window.myDangerTypeChart)
								window.myDangerTypeChart.destroy();
							window.myDangerTypeChart = new Chart(ctxDangerType,
									{
										type : 'bar',
										data : {
											labels : res.dangerTypeLabels,
											datasets : [ {
												label : '포착 횟수',
												data : res.dangerTypeData,
												backgroundColor : function(context) {
													var colors = [ [ '#38bdf8', 'rgba(37, 99, 235, 0.34)' ], [ '#fb923c', 'rgba(249, 115, 22, 0.34)' ], [ '#c084fc', 'rgba(139, 92, 246, 0.34)' ], [ '#fb7185', 'rgba(244, 63, 94, 0.34)' ] ];
													var palette = colors[context.dataIndex % colors.length];
													return createDashboardChartGradient(context, palette[0], palette[1], true);
												},
												borderRadius : 4
											} ]
										},
										options : {
											indexAxis : 'y',
											responsive : true,
											maintainAspectRatio : false,
											resizeDelay : 50,
											plugins : {
												legend : {
													display : false
												}
											},
											scales : {
												x : {
													grid : {
														color : '#2c313d'
													},
													ticks : {
														color : '#aaa'
													},
													beginAtZero : true
												},
												y : {
													grid : {
														display : false
													},
													ticks : {
														color : '#ffffff'
													}
												}
											}
										}
									});

						} catch (parseError) {
							console.error("화면 시각화 매핑 에러:", parseError);
							$("#aiBriefingContent")
									.html(
											'<div style="color:#ff6b6b;">❌ 데이터 멀티 시각화 블록 분리 연동 중 오류가 발생했습니다.</div>');
						}
					},
					error : function(xhr) {
						var message = xhr.responseJSON && xhr.responseJSON.message
								? xhr.responseJSON.message : '선택한 날짜의 대시보드 데이터를 불러오지 못했습니다.';
						$("#aiBriefingContent").html('<div style="color:#ff6b6b;">❌ ' + message + '</div>');
					}

				});
	}
</script>
</html>

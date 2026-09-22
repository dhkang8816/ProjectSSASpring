<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관제</title>
<link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">

<style>
body {
	margin: 0;
	padding: 0;
	background-color: #0b0f19;
	color: #e2e8f0;
	font-family: 'Segoe UI', Roboto, sans-serif;
	overflow-x: hidden;
}

header, .top-header {
	position: fixed !important;
	top: 0 !important;
	left: 0 !important;
	width: 100% !important;
	height: 80px !important;
	z-index: 1000 !important;
}

.control-content-wrapper {
	position: absolute !important;
	top: 80px !important;
	left: 250px !important;
	width: calc(100% - 250px) !important;
	padding: 25px 35px;
	box-sizing: border-box;
	min-height: calc(100vh - 80px);
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	margin: 0 !important;
	z-index: 50 !important;
}

/* 대시보드 레이아웃: 화면 전체 너비를 채우고 왼쪽/오른쪽 높이를 맞춤 */
.yolo-detail-layout {
	display: flex;
	gap: 20px;
	width: 100%;
	/* max-width 제한을 제거하여 우측 공간까지 꽉 채우도록 변경 */
}

.yolo-main-section {
	flex: 1;
	min-width: 0;
	display: flex;
	flex-direction: column;
}

.c2-main-card {
	background: rgba(20, 26, 42, 0.85);
	border: 1px solid #1e293b;
	border-radius: 16px;
	padding: 24px;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	width: 100%;
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	box-sizing: border-box;
	height: 100%; /* 왼쪽 카드 높이를 꽉 채우도록 설정 */
}

/* 오른쪽 환경 대시보드 스타일 (왼쪽과 높이 일치 및 내부 스크롤 처리) */
.env-dashboard-panel {
	width: 360px; /* 공간에 맞춰 너비 소폭 확장 */
	flex-shrink: 0;
	background: rgba(20, 26, 42, 0.85);
	border: 1px solid #1e293b;
	border-radius: 16px;
	padding: 20px;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	box-sizing: border-box;
	display: flex;
	flex-direction: column;
	gap: 16px;
	height: 100%; /* 왼쪽 메인 카드와 높이를 똑같이 맞춤 */
	max-height: calc(100vh - 130px);
	overflow-y: auto;
}

.env-dashboard-panel::-webkit-scrollbar {
	width: 4px;
}
.env-dashboard-panel::-webkit-scrollbar-thumb {
	background: #334155;
	border-radius: 2px;
}

.env-section-title {
	font-size: 11px;
	font-weight: 700;
	color: #94a3b8;
	letter-spacing: 0.05em;
	margin-bottom: 8px;
	text-transform: uppercase;
}

.env-location-box {
	background: #0f172a;
	border: 1px solid #1e293b;
	border-radius: 10px;
	padding: 12px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.env-location-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.env-location-name {
	font-size: 14px;
	font-weight: 700;
	color: #38bdf8;
}

.btn-env-setting {
	background-color: #1e293b;
	color: #94a3b8;
	border: 1px solid #334155;
	padding: 4px 10px;
	border-radius: 6px;
	font-size: 11px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
}

.btn-env-setting:hover {
	background-color: #334155;
	color: #ffffff;
}

.env-card {
	background: #0f172a;
	border: 1px solid #1e293b;
	border-radius: 10px;
	padding: 12px;
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.env-grid-2 {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 8px;
}

.env-metric-item {
	background: rgba(30, 41, 59, 0.4);
	border: 1px solid rgba(51, 65, 85, 0.5);
	border-radius: 6px;
	padding: 8px 10px;
	display: flex;
	flex-direction: column;
	gap: 2px;
}

.env-metric-label {
	font-size: 11px;
	color: #94a3b8;
}

.env-metric-value {
	font-size: 14px;
	font-weight: 700;
	color: #e2e8f0;
}

.env-metric-value.highlight {
	color: #38bdf8;
}

/* 상태 색상 클래스 */
.status-normal { color: #22c55e !important; }
.status-caution { color: #facc15 !important; }
.status-warning { color: #f97316 !important; }
.status-danger { color: #ef4444 !important; }
.status-offline { color: #64748b !important; }

/* 지역설정 팝업 모달 스타일 */
.env-modal-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
	background: rgba(0, 0, 0, 0.6);
	backdrop-filter: blur(2px);
	z-index: 2000;
	display: none;
	align-items: center;
	justify-content: center;
}

.env-modal-overlay.open {
	display: flex;
}

.env-modal-box {
	background: #0f172a;
	border: 1px solid #334155;
	border-radius: 14px;
	width: 400px;
	padding: 24px;
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.6);
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.env-modal-title {
	font-size: 16px;
	font-weight: 700;
	color: #ffffff;
}

.env-search-group {
	display: flex;
	gap: 8px;
}

.env-search-input {
	flex: 1;
	background: #1e293b;
	border: 1px solid #334155;
	border-radius: 6px;
	padding: 8px 12px;
	color: #ffffff;
	font-size: 13px;
	outline: none;
}

.env-search-input:focus {
	border-color: #0ea5e9;
}

.btn-search-action {
	background-color: #0ea5e9;
	color: #ffffff;
	border: none;
	padding: 0 14px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
}

.env-search-results {
	background: #1e293b;
	border: 1px solid #334155;
	border-radius: 6px;
	max-height: 150px;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
}

.env-result-item {
	padding: 10px 12px;
	font-size: 13px;
	color: #cbd5e1;
	cursor: pointer;
	border-bottom: 1px solid rgba(51, 65, 85, 0.4);
}

.env-result-item:last-child {
	border-bottom: none;
}

.env-result-item:hover {
	background: #334155;
	color: #ffffff;
}

.env-result-item.selected {
	background: #334155;
	color: #ffffff;
	box-shadow: inset 3px 0 0 #38bdf8;
}

.env-result-meta {
	margin-top: 4px;
	color: #94a3b8;
	font-size: 11px;
}

.env-result-message, .env-modal-message {
	padding: 10px 12px;
	color: #94a3b8;
	font-size: 13px;
}

.env-modal-message {
	display: none;
	padding: 0;
}

.env-modal-message.is-visible {
	display: block;
}

.env-modal-message.is-error {
	color: #fca5a5;
}

.env-modal-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 8px;
	margin-top: 4px;
}

.btn-modal-cancel {
	background: #1e293b;
	color: #94a3b8;
	border: 1px solid #334155;
	padding: 6px 14px;
	border-radius: 6px;
	font-size: 13px;
	cursor: pointer;
}

.btn-modal-save {
	background: #0ea5e9;
	color: #ffffff;
	border: none;
	padding: 6px 14px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
}

/* 상단 네비게이션 및 드론 전환 버튼 바 */
.detail-top-bar {
	width: 100%;
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.btn-back {
	background-color: #1e293b;
	color: #94a3b8;
	border: 1px solid #334155;
	padding: 6px 14px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	text-decoration: none;
	transition: all 0.2s ease;
}

.btn-back:hover {
	background-color: #334155;
	color: #ffffff;
}

.drone-switch-buttons {
	display: flex;
	gap: 8px;
}

.btn-drone-tab {
	background-color: #1e293b;
	color: #94a3b8;
	border: 1px solid #334155;
	padding: 6px 14px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
	text-decoration: none;
	transition: all 0.2s ease;
}

.btn-drone-tab:hover {
	background-color: #334155;
	color: #ffffff;
}

.btn-drone-tab.active {
	background-color: #0ea5e9;
	color: #ffffff;
	border-color: #38bdf8;
	box-shadow: 0 0 12px rgba(14, 165, 233, 0.4);
}

.drone-spec-overlay {
	position: absolute;
	top: 18px;
	right: 18px;
	z-index: 20;
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	justify-content: flex-end;
	max-width: 650px;
	pointer-events: none;
}

.spec-badge {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    background: rgba(15, 23, 42, 0.85);
    border: 1px solid rgba(56, 189, 248, 0.25);
    border-radius: 8px;
    color: #e2e8f0;
    font-size: 12px;
    backdrop-filter: blur(4px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.spec-badge span.label {
    color: #94a3b8;
    font-weight: 500;
}

.spec-badge span.value {
    color: #38bdf8;
    font-weight: 700;
    letter-spacing: 0.02em;
}

.spec-badge.battery .value {
    color: #22c55e; 
}

.spec-badge.env span.value {
    color: #facc15;
}

.spec-badge.collision-alert {
    background: rgba(239, 68, 68, 0.2);
    border-color: rgba(239, 68, 68, 0.6);
    display: none;
}

.spec-badge.collision-alert.active {
    display: flex;
    animation: alertBlink 1s infinite alternate;
}

.spec-badge.collision-alert.caution {
    background: rgba(250, 204, 21, 0.2);
    border-color: rgba(250, 204, 21, 0.7);
}

.spec-badge.collision-alert.warning {
    background: rgba(249, 115, 22, 0.24);
    border-color: rgba(249, 115, 22, 0.8);
}

.spec-badge.collision-alert.danger {
    background: rgba(239, 68, 68, 0.3);
    border-color: rgba(239, 68, 68, 0.95);
}

.spec-badge.collision-alert.offline {
    background: rgba(100, 116, 139, 0.25);
    border-color: rgba(148, 163, 184, 0.7);
    animation: none;
}

.spec-badge.collision-alert span.value {
    color: #f87171;
    font-weight: 800;
}

@keyframes alertBlink {
    0% { background: rgba(239, 68, 68, 0.2); border-color: rgba(239, 68, 68, 0.4); }
    100% { background: rgba(239, 68, 68, 0.5); border-color: rgba(239, 68, 68, 0.9); }
}

.single-video-display-box {
	background-color: #000000;
	padding: 12px;
	border-radius: 14px;
	border: 2px solid #1e293b;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
	width: 100%;
	box-sizing: border-box;
	position: relative;
	transition: all 0.2s ease;
}

.single-video-display-box.active-border {
	border-color: #0ea5e9;
	box-shadow: 0 0 30px rgba(14, 165, 233, 0.3);
}

.flight-timer-overlay {
	position: absolute;
	top: 18px;
	left: 18px;
	z-index: 20;
	display: flex;
	align-items: center;
	gap: 7px;
	padding: 6px 9px;
	background: rgba(15, 23, 42, 0.82);
	border: 1px solid rgba(148, 163, 184, 0.28);
	border-radius: 6px;
	color: #e2e8f0;
	font-size: 12px;
	font-variant-numeric: tabular-nums;
	pointer-events: none;
	backdrop-filter: blur(2px);
}

.flight-timer-dot {
	width: 7px;
	height: 7px;
	border-radius: 50%;
	background: #64748b;
}

.flight-timer-overlay.is-running .flight-timer-dot {
	background: #22c55e;
	box-shadow: 0 0 8px rgba(34, 197, 94, 0.8);
}

.flight-timer-value {
	color: #f8fafc;
	font-weight: 700;
	letter-spacing: 0.04em;
}

.streaming-frame-large {
	width: 100%;
	aspect-ratio: 16/9;
	max-height: 600px;
	object-fit: cover;
	display: block;
	border-radius: 8px;
	background-color: #000000;
}

.single-video-display-box.stream-off .streaming-frame-large,
.single-video-display-box.stream-error .streaming-frame-large {
	visibility: hidden;
}

.single-video-display-box.stream-off::after {
	content: "탐지 중지됨";
	position: absolute;
	top: 12px;
	left: 12px;
	right: 12px;
	aspect-ratio: 16/9;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #94a3b8;
	font-size: 16px;
	font-weight: 700;
	pointer-events: none;
}

.single-video-display-box.stream-error::after {
	content: "영상 서버 연결 오류";
	position: absolute;
	top: 12px;
	left: 12px;
	right: 12px;
	aspect-ratio: 16/9;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #f87171;
	font-size: 16px;
	font-weight: 700;
	pointer-events: none;
}

.video-card-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 12px;
	padding: 0 6px;
}

.channel-title {
	font-size: 15px;
	font-weight: 700;
	color: #38bdf8;
}

.switch-item {
	display: flex;
	align-items: center;
	gap: 8px;
	cursor: pointer;
}

.switch-item input {
	display: none;
}

.slider {
	position: relative;
	width: 48px;
	height: 24px;
	background-color: #475569;
	border-radius: 24px;
	transition: background-color 0.2s ease;
}

.slider::before {
	content: "";
	position: absolute;
	top: 2px;
	left: 2px;
	width: 20px;
	height: 20px;
	background-color: #ffffff;
	border-radius: 50%;
	transition: transform 0.2s ease;
}

.switch-item input:checked+.slider {
	background-color: #06b6d4;
}

.switch-item input:checked+.slider::before {
	transform: translateX(24px);
}

.switch-label {
	font-size: 12px;
	font-weight: 700;
	color: #94a3b8;
	width: 26px;
	text-align: left;
}

.switch-item input:checked ~ .switch-label {
	color: #06b6d4;
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div id="yoloDetailPage" class="control-content-wrapper">
		
		<!-- 전체 좌우 배치 래퍼 추가 -->
		<div class="yolo-detail-layout">
			
			<!-- 왼쪽 메인 영상 영역 -->
			<div class="yolo-main-section">
				<div class="c2-main-card">

					<div class="detail-top-bar">
						<a href="${pageContext.request.contextPath}/yolo/view"
							class="btn-back">⬅</a>

						<div class="drone-switch-buttons">
							<button type="button" class="btn-drone-tab" data-channel="video_1"
								onclick="switchChannel('video_1')">DRONE 1</button>
							<button type="button" class="btn-drone-tab" data-channel="video_2"
								onclick="switchChannel('video_2')">DRONE 2</button>
							<button type="button" class="btn-drone-tab" data-channel="video_3"
								onclick="switchChannel('video_3')">DRONE 3</button>
							<button type="button" class="btn-drone-tab" data-channel="esp32"
								onclick="switchChannel('esp32')">DRONE 4</button>
						</div>
					</div>

					<div class="single-video-display-box stream-off" id="box_single">
						<div class="flight-timer-overlay" id="flightTimer_single">
							<span class="flight-timer-dot"></span><span class="flight-timer-value">--:--:--</span>
						</div>

						<div class="drone-spec-overlay">
							<div class="spec-badge">
								<span class="label">BRAND</span>
								<span class="value" id="specBrand">-</span>
							</div>
							<div class="spec-badge">
								<span class="label">CAM</span>
								<span class="value" id="specCamera">-</span>
							</div>
							<div class="spec-badge battery">
								<span class="label">BAT</span>
								<span class="value" id="specBattery">-</span>
							</div>
							<div class="spec-badge env">
								<span class="label">온도</span>
								<span class="value" id="specTemp">0°C</span>
							</div>
							<div class="spec-badge env">
								<span class="label">습도</span>
								<span class="value" id="specHumidity">0%</span>
							</div>
							<div class="spec-badge env">
								<span class="label">조도</span>
								<span class="value" id="specIllum">0 ADC</span>
							</div>
							<div class="spec-badge collision-alert" id="collisionAlertBadge">
								<span class="label">⚠️ 경고</span>
								<span class="value" id="specCollisionMsg">장애물 근접</span>
							</div>
						</div>

						<img id="droneVideo_single" class="streaming-frame-large" alt="상세 드론 화면" />
						
						<div class="video-card-footer">
							<span class="channel-title" id="sourceButton_single">LOADING...</span>
							<label class="switch-item">
								<input id="toggle_single" type="checkbox" disabled onchange="toggleDetailChannelPower(this)">
								<span class="slider"></span>
								<span class="switch-label">OFF</span>
							</label>
						</div>
					</div>

				</div>
			</div>

			<!-- 오른쪽 환경 / 우주환경 대시보드 영역 -->
			<aside class="env-dashboard-panel">
				
				<!-- 운용 환경 / 관제지역 설정 -->
				<div>
					<div class="env-section-title">운용 환경</div>
					<div class="env-location-box">
						<div class="env-section-title" style="margin-bottom: 2px;">관제지역</div>
						<div class="env-location-header">
						<span id="envLocationName" class="env-location-name">관제지역 미설정</span>
							<button type="button" id="environmentSettingButton" class="btn-env-setting" onclick="openEnvironmentModal()">설정</button>
						</div>
					</div>
				</div>

				<!-- 현재 기상 카드 -->
				<div>
					<div class="env-section-title">Current Weather</div>
					<div class="env-card">
						<div class="env-grid-2">
							<div class="env-metric-item">
								<span class="env-metric-label">기온</span>
								<span id="weatherTemperature" class="env-metric-value highlight">--</span>
							</div>
							<div class="env-metric-item">
								<span class="env-metric-label">습도</span>
								<span id="weatherHumidity" class="env-metric-value">--</span>
							</div>
						</div>
						<div class="env-grid-2">
							<div class="env-metric-item">
								<span class="env-metric-label">풍속</span>
								<span id="weatherWindSpeed" class="env-metric-value">--</span>
							</div>
							<div class="env-metric-item">
								<span class="env-metric-label">날씨상태</span>
								<span id="weatherCondition" class="env-metric-value">--</span>
							</div>
						</div>
					</div>
				</div>

				<!-- 일사량 카드 -->
				<div>
					<div class="env-section-title">Solar Radiation</div>
					<div class="env-card">
						<div class="env-grid-2">
							<div class="env-metric-item">
								<span class="env-metric-label">GHI</span>
								<span id="solarGhi" class="env-metric-value highlight">--</span>
							</div>
							<div class="env-metric-item">
								<span class="env-metric-label">DNI</span>
								<span id="solarDni" class="env-metric-value">--</span>
							</div>
						</div>
						<div class="env-metric-item" style="margin-top: 2px;">
							<span class="env-metric-label">DHI</span>
							<span id="solarDhi" class="env-metric-value">--</span>
						</div>
					</div>
				</div>

				<!-- 우주환경 카드 -->
				<div>
					<div class="env-section-title">Space Weather</div>
					<div class="env-card">
						<div class="env-metric-item">
							<span class="env-metric-label">Solar Wind</span>
							<span id="spaceSolarWind" class="env-metric-value highlight">--</span>
						</div>
						<div class="env-grid-2" style="margin-top: 2px;">
							<div class="env-metric-item">
								<span class="env-metric-label">Kp Index</span>
								<span id="spaceKp" class="env-metric-value">--</span>
							</div>
							<div class="env-metric-item">
								<span class="env-metric-label">Bz</span>
								<span id="spaceBz" class="env-metric-value">--</span>
							</div>
						</div>
					</div>
				</div>

				<!-- 통신/전자기 영향 카드 (Space Weather Risk) -->
				<div>
					<div class="env-section-title">Space Weather Risk</div>
					<div class="env-card" style="gap: 6px;">
						<div class="env-metric-item" style="flex-direction: row; justify-content: space-between; align-items: center;">
							<span class="env-metric-label">지자기 (G Scale)</span>
							<span id="spaceGScale" class="env-metric-value status-offline">UNKNOWN</span>
						</div>
						<div class="env-metric-item" style="flex-direction: row; justify-content: space-between; align-items: center;">
							<span class="env-metric-label">복사 (R Scale)</span>
							<span id="spaceRScale" class="env-metric-value status-offline">UNKNOWN</span>
						</div>
						<div class="env-metric-item" style="flex-direction: row; justify-content: space-between; align-items: center;">
							<span class="env-metric-label">태양양성자 (S Scale)</span>
							<span id="spaceSScale" class="env-metric-value status-offline">UNKNOWN</span>
						</div>
					</div>
				</div>

			</aside>

		</div>
	</div>

	<!-- 지역설정 팝업 UI (Modal) -->
	<div id="environmentLocationModal" class="env-modal-overlay">
		<div class="env-modal-box">
			<div class="env-modal-title">관제지역 설정</div>
			<div class="env-search-group">
				<input type="text" id="environmentSearchKeyword" class="env-search-input" placeholder="검색어 입력 (예: 인천 남동구)">
				<button type="button" id="environmentSearchButton" class="btn-search-action" onclick="searchEnvironmentLocation()">검색</button>
			</div>
			<div class="env-section-title" style="margin-bottom: -8px;">검색결과</div>
			<div id="environmentSearchResult" class="env-search-results"></div>
			<div id="environmentLocationMessage" class="env-modal-message" aria-live="polite"></div>
			<div class="env-modal-buttons">
				<button type="button" id="environmentCancelButton" class="btn-modal-cancel" onclick="closeEnvironmentModal()">취소</button>
				<button type="button" id="environmentSaveButton" class="btn-modal-save" onclick="saveEnvironmentLocation()">저장</button>
			</div>
		</div>
	</div>

	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
	<script>
		const urlParams = new URLSearchParams(window.location.search);
		let currentChannelKey = urlParams.get('channel') || 'video_1';
		let selectedEnvironment = null;
		const yoloContextPath = "${pageContext.request.contextPath}";

		let detectionEnabled = false;
		let isToggling = false;
		let flightStatus = {
			running : false,
			startTime : null
		};
		let spaceWeatherLoading = false;

		/* 관제지역 설정: 기존 Spring EnvironmentController API만 사용한다. */
		function setEnvironmentLocationMessage(message, isError) {
			var $message = $('#environmentLocationMessage');
			$message.text(message || '').toggleClass('is-visible', !!message)
					.toggleClass('is-error', !!message && !!isError);
		}

		function getEnvironmentFromResponse(response) {
			if (!response) {
				return null;
			}
			if (Object.prototype.hasOwnProperty.call(response, 'environment')) {
				return response.environment;
			}
			return response.locationName || response.address ? response : null;
		}

		function environmentDisplayName(environment) {
			if (!environment) {
				return '관제지역 미설정';
			}
			return environment.locationName || environment.address || '관제지역 미설정';
		}

		function loadCurrentEnvironment(onComplete) {
			$.ajax({
				url : yoloContextPath + '/yolo/environment/location',
				type : 'GET',
				dataType : 'json',
				cache : false
			}).done(function(response) {
				$('#envLocationName').text(environmentDisplayName(
						getEnvironmentFromResponse(response)));
			}).fail(function() {
				$('#envLocationName').text('관제지역 미설정');
			}).always(function() {
				if (typeof onComplete === 'function') {
					onComplete();
				}
			});
		}

		function openEnvironmentModal() {
			selectedEnvironment = null;
			$('#environmentSearchResult').empty();
			setEnvironmentLocationMessage('');
			$('#environmentSearchKeyword').val('').focus();
			$('#environmentLocationModal').addClass('open');
		}

		function closeEnvironmentModal() {
			$('#environmentLocationModal').removeClass('open');
		}

		function showEnvironmentSearchResultMessage(message) {
			$('#environmentSearchResult').empty().append($('<div/>', {
				'class' : 'env-result-message'
			}).text(message));
		}

		function searchEnvironmentLocation() {
			var keyword = $.trim($('#environmentSearchKeyword').val());
			var $button = $('#environmentSearchButton');
			if (!keyword) {
				showEnvironmentSearchResultMessage('검색어를 입력해주세요.');
				return;
			}

			selectedEnvironment = null;
			setEnvironmentLocationMessage('');
			$button.prop('disabled', true).text('검색 중...');
			showEnvironmentSearchResultMessage('검색 중...');
			$.ajax({
				url : yoloContextPath + '/yolo/environment/location/search',
				type : 'GET',
				data : { keyword : keyword },
				dataType : 'json',
				cache : false
			}).done(function(list) {
				renderEnvironmentSearchResults($.isArray(list) ? list : []);
			}).fail(function() {
				showEnvironmentSearchResultMessage('지역 검색에 실패했습니다.');
			}).always(function() {
				$button.prop('disabled', false).text('검색');
			});
		}

		function renderEnvironmentSearchResults(list) {
			var $result = $('#environmentSearchResult').empty();
			if (!list || !list.length) {
				showEnvironmentSearchResultMessage('검색 결과가 없습니다.');
				return;
			}

			$.each(list, function(_, environment) {
				var name = environmentDisplayName(environment);
				var latitude = Number(environment.latitude);
				var longitude = Number(environment.longitude);
				var coordinateText = isFinite(latitude) && isFinite(longitude) ? latitude
						.toFixed(4) + ', ' + longitude.toFixed(4) : '';
				var $item = $('<div/>', {
					'class' : 'env-result-item',
					role : 'button',
					tabindex : 0
				});
				$item.append($('<div/>').text(name));
				if (environment.address || coordinateText) {
					$item.append($('<div/>', {
						'class' : 'env-result-meta'
					}).text([ environment.address, coordinateText ].filter(Boolean)
							.join(' · ')));
				}
				$item.on('click keydown', function(event) {
					if (event.type === 'click' || event.key === 'Enter'
							|| event.key === ' ') {
						event.preventDefault();
						selectEnvironmentLocation(environment, this);
					}
				});
				$result.append($item);
			});
		}

		function selectEnvironmentLocation(environment, element) {
			selectedEnvironment = {
				locationName : environment.locationName || environment.address,
				address : environment.address || environment.locationName,
				latitude : Number(environment.latitude),
				longitude : Number(environment.longitude),
				timezone : environment.timezone || 'Asia/Seoul'
			};
			$('#environmentSearchResult .env-result-item').removeClass('selected');
			$(element).addClass('selected');
			setEnvironmentLocationMessage('');
		}

		function saveEnvironmentLocation() {
			var $button = $('#environmentSaveButton');
			if (!selectedEnvironment) {
				setEnvironmentLocationMessage('지역을 선택해주세요.', true);
				return;
			}
			if (!isFinite(selectedEnvironment.latitude)
					|| !isFinite(selectedEnvironment.longitude)) {
				setEnvironmentLocationMessage('좌표 정보가 없는 지역입니다.', true);
				return;
			}

			setEnvironmentLocationMessage('');
			$button.prop('disabled', true).text('저장 중...');
			$.ajax({
				url : yoloContextPath + '/yolo/environment/location',
				type : 'POST',
				contentType : 'application/json; charset=UTF-8',
				dataType : 'json',
				data : JSON.stringify(selectedEnvironment)
			}).done(function(response) {
				if (!response || response.success !== true) {
					setEnvironmentLocationMessage(response && response.message
							|| '관제지역 저장에 실패했습니다.', true);
					return;
				}
				closeEnvironmentModal();
				loadCurrentEnvironment(refreshWeatherEnvironment);
			}).fail(function() {
				setEnvironmentLocationMessage('관제지역 저장에 실패했습니다.', true);
			}).always(function() {
				$button.prop('disabled', false).text('저장');
			});
		}

		function formatElapsed(ms) {
			const totalSeconds = Math.max(0, Math.floor(ms / 1000));
			const hours = Math.floor(totalSeconds / 3600);
			const minutes = Math.floor((totalSeconds % 3600) / 60);
			const seconds = totalSeconds % 60;
			return [ hours, minutes, seconds ].map(function(value) {
				return String(value).padStart(2, '0');
			}).join(':');
		}

		function renderFlightTimer() {
			const overlay = document.getElementById('flightTimer_single');
			if (!overlay)
				return;
			const value = overlay.querySelector('.flight-timer-value');
			const running = !!(flightStatus.running && flightStatus.startTime);
			overlay.classList.toggle('is-running', running);
			if (value)
				value.textContent = running ? formatElapsed(Date.now()
						- flightStatus.startTime) : '--:--:--';
		}

		function refreshFlightStatus() {
			$.ajax({
				url : yoloContextPath + '/yolo/flight/status',
				type : 'GET',
				dataType : 'json',
				cache : false
			}).done(function(response) {
				const status = response && response[currentChannelKey];
				flightStatus = {
					running : !!(status && status.running),
					startTime : status && status.startTime ? Number(status.startTime) : null
				};
				renderFlightTimer();
			});
		}

		function setWeatherEnvironmentUnavailable() {
			$('#weatherTemperature, #weatherHumidity, #weatherWindSpeed, '
					+ '#weatherCondition, #solarGhi, #solarDni, #solarDhi').text('--');
		}

		function formatWeatherNumber(value, decimals, suffix) {
			if (value === null || value === undefined || value === '') {
				return '--';
			}
			var numeric = Number(value);
			if (!isFinite(numeric)) {
				return '--';
			}
			var text = decimals > 0 && Math.round(numeric) !== numeric ? numeric
					.toFixed(decimals) : String(Math.round(numeric));
			return text + suffix;
		}

		function refreshWeatherEnvironment() {
			$.ajax({
				url : yoloContextPath + '/yolo/environment/weather',
				type : 'GET',
				dataType : 'json',
				cache : false
			}).done(function(data) {
				if (!data || data.success === false) {
					setWeatherEnvironmentUnavailable();
					return;
				}
				$('#weatherTemperature').text(formatWeatherNumber(data.temperature,
						1, '°C'));
				$('#weatherHumidity').text(formatWeatherNumber(data.humidity, 0,
						'%'));
				$('#weatherWindSpeed').text(formatWeatherNumber(data.windSpeed,
						1, 'm/s'));
				$('#weatherCondition').text(data.weatherCondition ? String(
						data.weatherCondition) : '--');
				$('#solarGhi').text(formatWeatherNumber(data.ghi, 0, ' W/m²'));
				$('#solarDni').text(formatWeatherNumber(data.dni, 0, ' W/m²'));
				$('#solarDhi').text(formatWeatherNumber(data.dhi, 0, ' W/m²'));
			}).fail(setWeatherEnvironmentUnavailable);
		}

		function formatSpaceWeatherScale(scale) {
			var normalized = String(scale || '').trim().toUpperCase();
			if (!/^[GRS][0-5]$/.test(normalized)) {
				return 'UNKNOWN';
			}
			var descriptions = [ 'NORMAL', 'MINOR', 'MODERATE', 'STRONG',
					'SEVERE', 'EXTREME' ];
			return normalized + ' ' + descriptions[Number(normalized.charAt(1))];
		}

		function getSpaceWeatherStatusClass(scale) {
			var normalized = String(scale || '').trim().toUpperCase();
			if (!/^[GRS][0-5]$/.test(normalized)) {
				return 'status-offline';
			}
			var level = Number(normalized.charAt(1));
			if (level === 0) return 'status-normal';
			if (level <= 2) return 'status-caution';
			if (level === 3) return 'status-warning';
			return 'status-danger';
		}

		function applySpaceWeatherScale(elementId, scale) {
			var $element = $('#' + elementId);
			$element.removeClass('status-normal status-caution status-warning '
					+ 'status-danger status-offline')
					.addClass(getSpaceWeatherStatusClass(scale))
					.text(formatSpaceWeatherScale(scale));
		}

		function setSpaceWeatherOffline() {
			$('#spaceSolarWind, #spaceKp, #spaceBz').text('--');
			applySpaceWeatherScale('spaceGScale', null);
			applySpaceWeatherScale('spaceRScale', null);
			applySpaceWeatherScale('spaceSScale', null);
		}

		function refreshSpaceWeather() {
			if (spaceWeatherLoading) {
				return;
			}
			spaceWeatherLoading = true;
			$.ajax({
				url : yoloContextPath + '/yolo/environment/space-weather',
				type : 'GET',
				dataType : 'json',
				cache : false
			}).done(function(data) {
				if (!data || data.success === false) {
					setSpaceWeatherOffline();
					return;
				}
				$('#spaceSolarWind').text(formatWeatherNumber(data.solarWindSpeed,
						1, ' km/s'));
				$('#spaceKp').text(formatWeatherNumber(data.kp, 1, ''));
				$('#spaceBz').text(formatWeatherNumber(data.bz, 1, ' nT'));
				applySpaceWeatherScale('spaceGScale', data.gScale);
				applySpaceWeatherScale('spaceRScale', data.rScale);
				applySpaceWeatherScale('spaceSScale', data.sScale);
			}).fail(setSpaceWeatherOffline).always(function() {
				spaceWeatherLoading = false;
			});
		}

		function setEnvironmentOffline() {
			$('#specTemp').text('0\u00b0C');
			$('#specHumidity').text('0%');
			$('#specIllum').text('0 ADC');
			$('#collisionAlertBadge').removeClass('caution warning danger').addClass('active offline');
			$('#specCollisionMsg').text('SENSOR OFFLINE');
		}

		function collisionMessage(level, distance) {
			if (level === 'UNKNOWN') return '거리 측정 불가';
			var distanceText = Number(distance).toFixed(1) + 'cm';
			if (level === 'DANGER') return '충돌 위험 (' + distanceText + ')';
			if (level === 'WARNING') return '충돌 주의 (' + distanceText + ')';
			if (level === 'CAUTION') return '장애물 접근 중 (' + distanceText + ')';
			return '충돌 위험 없음';
		}

		function refreshEnvironmentAndCollision() {
			$.ajax({
				url: yoloContextPath + '/yolo/envSensor/status',
				type: 'GET',
				dataType: 'json',
				cache: false,
				success: function(data) {
					if (!data || !data.sensorOnline) {
						setEnvironmentOffline();
						return;
					}
					$('#specTemp').text(Number(data.temperature).toFixed(1) + '\u00b0C');
					$('#specHumidity').text(Number(data.humidity).toFixed(0) + '%');
					$('#specIllum').text(Number(data.illumination).toFixed(0) + ' ADC');

					var level = String(data.collisionLevel || 'UNKNOWN').toUpperCase();
					var isWarning = level === 'CAUTION' || level === 'WARNING' || level === 'DANGER';
					var isUnknown = level === 'UNKNOWN';
					var $badge = $('#collisionAlertBadge');
					$badge.removeClass('caution warning danger offline')
						.toggleClass('active', isWarning || isUnknown)
						.toggleClass(level.toLowerCase(), isWarning)
						.toggleClass('offline', isUnknown);
					$('#specCollisionMsg').text(collisionMessage(level, data.distance));
				},
				error: setEnvironmentOffline
			});
		}

		$(document).ready(function() {
			updateActiveTabUI();
			loadCurrentEnvironment(refreshWeatherEnvironment);
			refreshSpaceWeather();
			readStatus();
			fn_loadMappingInfo();
			refreshFlightStatus();
			refreshEnvironmentAndCollision();
			$('#environmentSearchKeyword').on('keydown', function(event) {
				if (event.key === 'Enter') {
					event.preventDefault();
					searchEnvironmentLocation();
				}
			});

			setInterval(readStatus, 2000);
			setInterval(renderFlightTimer, 1000);
			setInterval(refreshEnvironmentAndCollision, 1000); 
			setInterval(refreshWeatherEnvironment, 5 * 60 * 1000);
			setInterval(refreshSpaceWeather, 5 * 60 * 1000);
		});

		function switchChannel(channelKey) {
			if (currentChannelKey === channelKey)
				return;
			currentChannelKey = channelKey;

			const newUrl = window.location.pathname + '?channel=' + channelKey;
			window.history.pushState({
				channel : channelKey
			}, '', newUrl);

			updateActiveTabUI();
			readStatus();
			fn_loadMappingInfo();
			refreshFlightStatus();
			refreshEnvironmentAndCollision();
		}

		window.addEventListener('popstate', function(event) {
			const params = new URLSearchParams(window.location.search);
			const channel = params.get('channel') || 'video_1';

			if (currentChannelKey !== channel) {
				currentChannelKey = channel;
				updateActiveTabUI();
				readStatus();
				fn_loadMappingInfo();
				refreshFlightStatus();
				refreshEnvironmentAndCollision();
			}
		});

		function updateActiveTabUI() {
			$('.btn-drone-tab').removeClass('active');
			$('.btn-drone-tab').each(function() {
				if ($(this).attr('data-channel') === currentChannelKey) {
					$(this).addClass('active');
				}
			});
		}

		function getElements() {
			return {
				image : document.getElementById('droneVideo_single'),
				box : document.getElementById('box_single'),
				checkbox : document.getElementById('toggle_single'),
				title : document.getElementById('sourceButton_single')
			};
		}

		function setStream(enabled) {
			const els = getElements();
			if (!els.image)
				return;
			els.box.classList.remove('stream-error');
			if (enabled) {
				els.image.onerror = function() {
					els.box.classList.add('stream-error');
				};
				els.image.src = yoloContextPath + '/yolo/videoFeed/'
						+ encodeURIComponent(currentChannelKey) + '?t='
						+ new Date().getTime();
			} else {
				els.image.onerror = null;
				els.image.removeAttribute('src');
			}
		}

		function renderState(enabled, disabled, statusText) {
			const els = getElements();
			if (!els.checkbox || !els.box)
				return;
			els.checkbox.checked = !!enabled;
			els.checkbox.disabled = !!disabled;
			els.box.classList.toggle('stream-off', !enabled);
			els.box.classList.toggle('active-border', !!enabled);
			const label = els.checkbox.parentElement
					.querySelector('.switch-label');
			if (label)
				label.innerText = statusText || (enabled ? 'ON' : 'OFF');
		}

		function readStatus() {
			$.ajax({
				url : yoloContextPath + '/yolo/detection/status',
				type : 'GET',
				dataType : 'json',
				cache : false,
				success : function(response) {
					const sources = response && response.sources;
					if (!sources || !sources[currentChannelKey])
						return;

					const workerStatus = sources[currentChannelKey];
					const enabled = !!workerStatus.running;
					const stopping = !!workerStatus.stopping;

					detectionEnabled = enabled;
					renderState(enabled, stopping,
							stopping ? 'STOPPING' : null);
					setStream(enabled);
				}
			});
		}

		function toggleDetailChannelPower(checkbox) {
			const previousState = detectionEnabled;
			const requestedState = checkbox.checked;
			if (isToggling) {
				checkbox.checked = previousState;
				return;
			}

			isToggling = true;
			renderState(previousState, true, '...');
			if (!requestedState)
				setStream(false);

			$.ajax({
				url : yoloContextPath + '/yolo/detection/'
						+ encodeURIComponent(currentChannelKey)
						+ '/'
						+ (requestedState ? 'start' : 'stop'),
				type : 'POST',
				dataType : 'json'
			}).done(function(response) {
				const workerStatus = response
						&& response.sources
						&& response.sources[currentChannelKey];
				const actualState = !!(workerStatus && workerStatus.running);

				detectionEnabled = actualState;
				renderState(actualState, false);
				setStream(actualState);
				refreshFlightStatus();
			}).fail(function() {
				detectionEnabled = previousState;
				renderState(previousState, false);
				setStream(previousState);
				alert('탐지 worker 상태 변경에 실패했습니다.');
			}).always(function() {
				isToggling = false;
			});
		}

		function fn_loadMappingInfo() {
			renderDroneSpec(null);
			$.ajax({
				url : yoloContextPath + '/yolo/currentMappings',
				type : 'GET',
				dataType : 'json',
				cache : false,
				success : function(res) {
					var mappings = res && res.activeMappings ? res.activeMappings : {};
					var droneDetails = res && res.dbDroneDetails ? res.dbDroneDetails : [];
					var activeDroneId = mappings[currentChannelKey] || '';

					$('.btn-drone-tab').each(function() {
						var channelKey = $(this).attr('data-channel');
						var mappedDroneId = mappings[channelKey];
						$(this).text(mappedDroneId || channelKey.toUpperCase());
					});

					$('#sourceButton_single').text(activeDroneId || currentChannelKey.toUpperCase());
					var activeDrone = null;
					for (var i = 0; i < droneDetails.length; i++) {
						if (droneDetails[i].droneId === activeDroneId) {
							activeDrone = droneDetails[i];
							break;
						}
					}
					renderDroneSpec(activeDrone);
				}
			});
		}

		function renderDroneSpec(drone) {
			$('#specBrand').text(drone && drone.brand ? drone.brand : '-');
			$('#specCamera').text(drone && drone.camera ? drone.camera : '-');
			$('#specBattery').text(drone && drone.batteryCapacity !== null
					&& drone.batteryCapacity !== undefined ? drone.batteryCapacity + 'mAh' : '-');
			$('#specMaint').text(drone && drone.maintenanceCount !== null
					&& drone.maintenanceCount !== undefined ? drone.maintenanceCount + '회' : '-');
		}
	</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>유기동물 관제 시스템</title>
<link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
	left: 200px !important;
	width: calc(100% - 200px) !important;
	padding: 15px 25px !important;
	box-sizing: border-box;
	height: calc(100vh - 80px);
	min-height: 0;
	overflow-x: hidden;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	margin: 0 !important;
	z-index: 50 !important;
}

.c2-main-card {
	background: rgba(20, 26, 42, 0.85);
	border: 1px solid #1e293b;
	border-radius: 16px;
	padding: 16px;
	box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
	width: 100%;
	max-width: none;
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	box-sizing: border-box;
}

.video-grid-container {
	position: relative;
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 12px;
	width: 100%;
	height: calc(100vh - 136px);
	grid-template-rows: repeat(2, minmax(0, 1fr));
	max-width: none;
	box-sizing: border-box;
}

.main-control-layout {
	--main-dashboard-width: 310px;
	position: relative;
	width: 100%;
	box-sizing: border-box;
	/* 우측 요약 패널 공간만큼 우측 패널딩을 주어 겹침 원천 방지 */
	padding-right: calc(var(--main-dashboard-width) + 16px);
}

.main-control-layout .c2-main-card {
	width: 100%;
	max-width: none;
	min-width: 0;
	box-sizing: border-box;
}

.main-dashboard-summary {
	position: absolute;
	top: 0;
	right: 0;
	width: var(--main-dashboard-width);
	box-sizing: border-box;
	display: flex;
	flex-direction: column;
	background: #111827;
	border: 1px solid #263449;
	border-radius: 12px;
	padding: 16px;
	min-width: 0;
	overflow: hidden;
}

.main-dashboard-heading {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 8px;
	margin-bottom: 14px;
	font-size: 15px;
	font-weight: 700;
	color: #e2e8f0;
}

.main-dashboard-link {
	color: #38bdf8;
	font-size: 13px;
	font-weight: 600;
	text-decoration: none;
}

.main-dashboard-metrics {
	display: grid;
	grid-template-columns: 1fr;
	gap: 10px;
}

.main-dashboard-metric {
	border: 1px solid #263449;
	border-left: 4px solid var(--metric-color, #38bdf8);
	border-radius: 8px;
	padding: 11px 12px;
	background: #0f172a;
}

.main-dashboard-metric-label {
	display: block;
	margin-bottom: 5px;
	font-size: 12px;
	color: #94a3b8;
}

.main-dashboard-metric-value {
	display: block;
	font-size: 21px;
	font-weight: 800;
	line-height: 1.2;
	color: var(--metric-color, #f8fafc);
	font-variant-numeric: tabular-nums;
}

.main-dashboard-charts {
	display: grid;
	grid-template-rows: repeat(3, minmax(0, 1fr));
	flex: 1 1 auto;
	gap: 10px;
	width: 100%;
	min-width: 0;
	min-height: 0;
	margin-top: 10px;
}

.main-dashboard-chart {
	display: flex;
	flex-direction: column;
	width: 100%;
	min-width: 0;
	min-height: 0;
	box-sizing: border-box;
	padding: 10px;
	background: #0f172a;
	border: 1px solid #263449;
	border-radius: 9px;
}

.main-dashboard-chart-title {
	flex: 0 0 auto;
	margin-bottom: 8px;
	font-size: 12px;
	font-weight: 700;
	color: #cbd5e1;
}

.main-dashboard-chart-canvas {
	position: relative;
	flex: 1 1 auto;
	width: 100%;
	min-width: 0;
	min-height: 0;
	overflow: hidden;
}

.main-dashboard-chart-canvas canvas {
	display: block;
	width: 100% !important;
	max-width: 100% !important;
	height: 100% !important;
}

.main-alert-log-panel {
	width: 100%;
	max-width: none;
	margin-top: 16px;
	padding: 15px 16px;
	box-sizing: border-box;
	display: flex;
	flex-direction: column;
	background: #111827;
	border: 1px solid #263449;
	border-radius: 12px;
}

.main-alert-log-heading {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	margin-bottom: 10px;
	font-size: 14px;
	font-weight: 700;
	color: #e2e8f0;
}

.main-alert-log-link {
	color: #38bdf8;
	font-size: 12px;
	font-weight: 600;
	text-decoration: none;
}

.main-alert-log-list {
	flex: 1 1 auto;
	min-height: 0;
	max-height: none;
	overflow-y: auto;
	border-top: 1px solid #263449;
}

.main-alert-log-item {
	display: grid;
	grid-template-columns: auto minmax(0, 1fr) auto;
	align-items: center;
	gap: 10px;
	padding: 11px 4px;
	border-bottom: 1px solid #1f2937;
	color: #cbd5e1;
	text-decoration: none;
}

.main-alert-log-item:hover {
	background: rgba(56, 189, 248, 0.06);
}

.main-alert-log-type {
	padding: 4px 7px;
	border-radius: 5px;
	font-size: 11px;
	font-weight: 700;
	white-space: nowrap;
}

.main-alert-log-type.danger {
	color: #fecaca;
	background: rgba(239, 68, 68, 0.16);
}

.main-alert-log-type.detection {
	color: #fed7aa;
	background: rgba(249, 115, 22, 0.15);
}

.main-alert-log-message {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	font-size: 13px;
}

.main-alert-log-time {
	color: #64748b;
	font-size: 11px;
	white-space: nowrap;
}

.main-alert-log-empty {
	padding: 36px 12px;
	color: #64748b;
	font-size: 13px;
	text-align: center;
}

@media ( max-width : 1180px) {
	.main-control-layout {
		padding-right: 0;
	}
	.main-dashboard-summary {
		display: none;
	}
	.main-control-layout .c2-main-card, .main-alert-log-panel {
		width: 100%;
	}
}

.video-display-box {
	background-color: #000000;
	padding: 8px;
	border-radius: 12px;
	border: 2px solid #1e293b;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
	width: 100%;
	height: 100%;
	min-height: 0;
	box-sizing: border-box;
	position: relative;
	display: flex;
	flex-direction: column;
	overflow: hidden;
	transition: all 0.2s ease;
}

.video-display-box.active-border {
	border-color: #0ea5e9;
	box-shadow: 0 0 25px rgba(14, 165, 233, 0.35);
}

.flight-timer-overlay {
	position: absolute;
	top: 12px;
	left: 12px;
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

.streaming-frame {
	width: 100%;
	height: 0;
	min-height: 0;
	flex: 1 1 auto;
	aspect-ratio: auto;
	object-fit: cover;
	display: block;
	border-radius: 8px;
	background-color: #000000;
}

.video-display-box.stream-off .streaming-frame, .video-display-box.stream-error .streaming-frame
	{
	visibility: hidden;
}

.video-display-box.stream-off::after {
	content: "탐지 중지";
	position: absolute;
	top: 8px;
	left: 8px;
	right: 8px;
	bottom: 36px;
	aspect-ratio: auto;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #94a3b8;
	font-size: 14px;
	font-weight: 700;
	letter-spacing: 0.04em;
	pointer-events: none;
}

.video-display-box.stream-error::after {
	content: "영상 서버 연결 오류";
	position: absolute;
	top: 8px;
	left: 8px;
	right: 8px;
	bottom: 36px;
	aspect-ratio: auto;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #f87171;
	font-size: 14px;
	font-weight: 700;
	pointer-events: none;
}

.video-card-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 8px;
	padding: 0 4px;
}

/* 4채널 관제용 최소 환경 센서 HUD: 우상단 배치로 변경 */
.video-sensor-hud {
	position: absolute;
	right: 12px;
	top: 12px; /* bottom: 42px 에서 top: 12px로 변경하여 우상단으로 이동 */
	z-index: 21;
	display: flex;
	align-items: center;
	gap: 7px;
	max-width: calc(100% - 24px);
	padding: 6px 9px; /* 타이머와 높이/패딩감을 맞추기 위해 살짝 조정 가능 */
	border: 1px solid rgba(56, 189, 248, 0.24);
	border-radius: 6px;
	background: rgba(15, 23, 42, 0.82); /* 타이머와 배경 투명도 일치 */
	color: #dbeafe;
	font-size: 11px;
	font-weight: 700;
	font-variant-numeric: tabular-nums;
	line-height: 1;
	white-space: nowrap;
	pointer-events: none;
	backdrop-filter: blur(2px);
}

.video-sensor-hud span + span {
	border-left: 1px solid rgba(148, 163, 184, 0.28);
	padding-left: 7px;
}

.video-sensor-hud .sensor-distance {
	color: #94a3b8;
}

.video-sensor-hud.is-safe .sensor-distance {
	color: #86efac;
}

.video-sensor-hud.is-caution .sensor-distance {
	color: #facc15;
}

.video-sensor-hud.is-warning .sensor-distance {
	color: #fb923c;
}

.video-sensor-hud.is-danger .sensor-distance {
	color: #f87171;
}

.video-sensor-hud.is-offline {
	border-color: rgba(100, 116, 139, 0.42);
	background: rgba(30, 41, 59, 0.78);
	color: #94a3b8;
}

@media (max-width: 760px) {
	.video-sensor-hud {
		gap: 4px;
		padding: 3px 5px;
		font-size: 10px;
	}

	.video-sensor-hud span + span {
		padding-left: 4px;
	}
}

.channel-title {
	font-size: 13px;
	font-weight: 700;
	color: #38bdf8;
}

/* 토글 스위치 스타일 */
.switch-item {
	display: flex;
	align-items: center;
	gap: 6px;
	cursor: pointer;
}

.switch-item input {
	display: none;
}

.slider {
	position: relative;
	width: 42px;
	height: 22px;
	background-color: #475569;
	border-radius: 22px;
	transition: background-color 0.2s ease;
}

.slider::before {
	content: "";
	position: absolute;
	top: 2px;
	left: 2px;
	width: 18px;
	height: 18px;
	background-color: #ffffff;
	border-radius: 50%;
	transition: transform 0.2s ease;
}

.switch-item input:checked+.slider {
	background-color: #06b6d4;
}

.switch-item input:checked+.slider::before {
	transform: translateX(20px);
}

.switch-label {
	font-size: 11px;
	font-weight: 700;
	color: #94a3b8;
	width: 22px;
	text-align: left;
}

.switch-item input:checked ~ .switch-label {
	color: #06b6d4;
}

.switch-item input:disabled+.slider {
	opacity: 0.55;
	cursor: wait;
}

.drone-center-setting-btn {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 38px;
	height: 38px;
	background-color: #1e293b;
	border: 2px solid #334155;
	color: #94a3b8;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 15px;
	cursor: pointer;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.6);
	transition: all 0.2s ease;
	z-index: 100;
}

.drone-center-setting-btn:hover {
	background-color: #334155;
	color: #ffffff;
	border-color: #0ea5e9;
	box-shadow: 0 0 15px rgba(14, 165, 233, 0.4);
	transform: translate(-50%, -50%) scale(1.08);
}

.drone-dropdown-wrapper {
	position: absolute !important;
	top: 50%;
	left: 50%;
	z-index: 1000 !important;
}

#droneSettingDropdown {
	display: none;
	position: absolute;
	top: 28px;
	left: -150px;
	width: 320px;
	background-color: #131926;
	border: 1px solid #334155;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
	border-radius: 10px;
	padding: 16px;
	box-sizing: border-box;
	z-index: 9999 !important;
}

.drone-setting-title {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 8px;
	margin: 0 0 12px;
	padding-bottom: 6px;
	border-bottom: 1px solid #334155;
	color: #38bdf8;
	font-size: 13px;
	font-weight: 600;
}

.channel-bulk-actions {
	display: flex;
	gap: 6px;
}

.channel-bulk-actions button {
	border: none;
	border-radius: 6px;
	padding: 5px 10px;
	color: #ffffff;
	font-size: 11px;
	font-weight: 700;
	cursor: pointer;
	transition: all 0.2s ease;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
}

.channel-bulk-actions button:hover:not(:disabled) {
	filter: brightness(1.15);
	transform: translateY(-1px);
}

.channel-bulk-actions button:disabled {
	cursor: wait;
	opacity: 0.55;
}

.btn-all-channel-on {
	background-color: #0284c7;
	border: 1px solid rgba(56, 189, 248, 0.3);
}

.btn-all-channel-on:hover:not(:disabled) {
	background-color: #0ea5e9;
	box-shadow: 0 0 10px rgba(14, 165, 233, 0.4);
}

.btn-all-channel-off {
	background-color: #334155;
	border: 1px solid rgba(148, 163, 184, 0.2);
	color: #cbd5e1;
}

.btn-all-channel-off:hover:not(:disabled) {
	background-color: #dc2626;
	color: #ffffff;
	border-color: rgba(248, 113, 113, 0.4);
	box-shadow: 0 0 10px rgba(220, 38, 38, 0.3);
}

.top-alarm-toggle-wrapper {
	position: absolute;
	top: 8px;
	right: 16px;
	z-index: 100;
}

.alarm-circle-btn {
	display: flex;
	align-items: center;
	gap: 8px;
	background: rgba(17, 24, 39, 0.85);
	border: 1px solid #334155;
	padding: 4px 12px;
	border-radius: 30px;
	cursor: pointer;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
	backdrop-filter: blur(4px);
	transition: all 0.2s ease;
}

.alarm-circle-btn:hover {
	border-color: #38bdf8;
	background: rgba(30, 41, 59, 0.9);
}

.alarm-icon-circle {
	width: 26px;
	height: 26px;
	background-color: #1e293b;
	border: 1px solid #475569;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 13px;
}

.alarm-switch-container {
	position: relative;
	width: 36px;
	height: 20px;
	background-color: #475569;
	border-radius: 20px;
	transition: background-color 0.2s ease;
}

.alarm-switch-container::before {
	content: "";
	position: absolute;
	top: 2px;
	left: 2px;
	width: 16px;
	height: 16px;
	background-color: #ffffff;
	border-radius: 50%;
	transition: transform 0.2s ease;
}

.alarm-checkbox {
	display: none;
}

.alarm-checkbox:checked+.alarm-switch-container {
	background-color: #06b6d4;
}

.alarm-checkbox:checked+.alarm-switch-container::before {
	transform: translateX(16px);
}
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/menu.jsp" />
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div id="yoloMainPage" class="control-content-wrapper">
		<div class="main-control-layout">
			<div class="c2-main-card">

				<div class="top-alarm-toggle-wrapper">
					<label class="alarm-circle-btn" title="알람 소리 설정">
					    <span class="alarm-icon-circle">🔔</span> 
					    <input type="checkbox" id="topAlarmToggle" class="alarm-checkbox" checked>
					    <span class="alarm-switch-container"></span>
					</label>
				</div>

				<div class="video-grid-container">

					<!-- 동영상 1번 박스 -->
					<div class="video-display-box stream-off" id="box_video_1">
						<div class="flight-timer-overlay" id="flightTimer_video_1">
							<span class="flight-timer-dot"></span><span
								class="flight-timer-value">--:--:--</span>
						</div>
						<img id="droneVideo_video_1" class="streaming-frame" alt="동영상 1번" />
						<div class="video-sensor-hud is-offline" title="SENSOR OFFLINE">
							<span class="sensor-temp" title="온도">0°C</span><span
								class="sensor-humidity" title="습도">0%</span><span
								class="sensor-light" title="조도 ADC">0</span><span
								class="sensor-distance" title="충돌 거리">0cm</span>
						</div>
						<div class="video-card-footer">
							<span class="channel-title" id="sourceButton_video_1">DRONE-01</span>
							<label class="switch-item"> <input id="toggle_video_1"
								type="checkbox" disabled
								onchange="toggleChannelPower('video_1', this)"> <span
								class="slider"></span> <span class="switch-label">OFF</span>
							</label>
						</div>
					</div>

					<!-- 동영상 2번 박스 -->
					<div class="video-display-box stream-off" id="box_video_2">
						<div class="flight-timer-overlay" id="flightTimer_video_2">
							<span class="flight-timer-dot"></span><span
								class="flight-timer-value">--:--:--</span>
						</div>
						<img id="droneVideo_video_2" class="streaming-frame" alt="동영상 2번" />
						<div class="video-sensor-hud is-offline" title="SENSOR OFFLINE">
							<span class="sensor-temp" title="온도">0°C</span><span
								class="sensor-humidity" title="습도">0%</span><span
								class="sensor-light" title="조도 ADC">0</span><span
								class="sensor-distance" title="충돌 거리">0cm</span>
						</div>
						<div class="video-card-footer">
							<span class="channel-title" id="sourceButton_video_2">DRONE-02</span>
							<label class="switch-item"> <input id="toggle_video_2"
								type="checkbox" disabled
								onchange="toggleChannelPower('video_2', this)"> <span
								class="slider"></span> <span class="switch-label">OFF</span>
							</label>
						</div>
					</div>

					<!-- 동영상 3번 박스 -->
					<div class="video-display-box stream-off" id="box_video_3">
						<div class="flight-timer-overlay" id="flightTimer_video_3">
							<span class="flight-timer-dot"></span><span
								class="flight-timer-value">--:--:--</span>
						</div>
						<img id="droneVideo_video_3" class="streaming-frame" alt="동영상 3번" />
						<div class="video-sensor-hud is-offline" title="SENSOR OFFLINE">
							<span class="sensor-temp" title="온도">0°C</span><span
								class="sensor-humidity" title="습도">0%</span><span
								class="sensor-light" title="조도 ADC">0</span><span
								class="sensor-distance" title="충돌 거리">0cm</span>
						</div>
						<div class="video-card-footer">
							<span class="channel-title" id="sourceButton_video_3">DRONE-03</span>
							<label class="switch-item"> <input id="toggle_video_3"
								type="checkbox" disabled
								onchange="toggleChannelPower('video_3', this)"> <span
								class="slider"></span> <span class="switch-label">OFF</span>
							</label>
						</div>
					</div>

					<!-- 실시간 CAM (ESP32) 박스 -->
					<div class="video-display-box stream-off" id="box_esp32">
						<div class="flight-timer-overlay" id="flightTimer_esp32">
							<span class="flight-timer-dot"></span><span
								class="flight-timer-value">--:--:--</span>
						</div>
						<img id="droneVideo_esp32" class="streaming-frame" alt="실시간 CAM" />
						<div class="video-sensor-hud is-offline" title="SENSOR OFFLINE">
							<span class="sensor-temp" title="온도">0°C</span><span
								class="sensor-humidity" title="습도">0%</span><span
								class="sensor-light" title="조도 ADC">0</span><span
								class="sensor-distance" title="충돌 거리">0cm</span>
						</div>
						<div class="video-card-footer">
							<span class="channel-title" id="sourceButton_esp32">DRONE-04
								(ESP32)</span> <label class="switch-item"> <input
								id="toggle_esp32" type="checkbox" disabled
								onchange="toggleChannelPower('esp32', this)"> <span
								class="slider"></span> <span class="switch-label">OFF</span>
							</label>
						</div>
					</div>

					<div class="drone-dropdown-wrapper">
						<button type="button" id="btnToggleDroneSetting"
							class="drone-center-setting-btn" title="드론 설정">⚙</button>

						<div id="droneSettingDropdown">
							<div class="drone-setting-title">
								<span>⚙ 채널별 드론 배정</span>
								<div class="channel-bulk-actions">
									<button type="button" id="btnAllChannelOn"
										class="btn-all-channel-on" onclick="toggleAllChannels(true)">전체
										ON</button>
									<button type="button" id="btnAllChannelOff"
										class="btn-all-channel-off" onclick="toggleAllChannels(false)">전체
										OFF</button>
								</div>
							</div>
							<div style="display: flex; flex-direction: column; gap: 10px;">
								<div
									style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
									<span style="width: 80px; color: #94a3b8;">동영상 1번</span> <select
										id="drone_select_video_1"
										class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary"
										style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
									<button type="button" onclick="fn_saveDroneMapping('video_1')"
										class="btn btn-sm btn-primary py-1 px-2"
										style="font-size: 11px;">적용</button>
								</div>
								<div
									style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
									<span style="width: 80px; color: #94a3b8;">동영상 2번</span> <select
										id="drone_select_video_2"
										class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary"
										style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
									<button type="button" onclick="fn_saveDroneMapping('video_2')"
										class="btn btn-sm btn-primary py-1 px-2"
										style="font-size: 11px;">적용</button>
								</div>
								<div
									style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
									<span style="width: 80px; color: #94a3b8;">동영상 3번</span> <select
										id="drone_select_video_3"
										class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary"
										style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
									<button type="button" onclick="fn_saveDroneMapping('video_3')"
										class="btn btn-sm btn-primary py-1 px-2"
										style="font-size: 11px;">적용</button>
								</div>
								<div
									style="display: flex; align-items: center; justify-content: space-between; color: #fff; font-size: 12px;">
									<span style="width: 80px; color: #5ddcff; font-weight: bold;">실시간
										CAM</span> <select id="drone_select_esp32"
										class="drone-map-select form-select form-select-sm bg-dark text-white border-secondary"
										style="width: 120px; padding: 4px; border-radius: 4px; font-size: 11px;"></select>
									<button type="button" onclick="fn_saveDroneMapping('esp32')"
										class="btn btn-sm btn-success py-1 px-2"
										style="font-size: 11px;">적용</button>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>

			<aside class="main-dashboard-summary" aria-label="당일 관제 요약">
				<div class="main-dashboard-heading">
					<span>당일 관제 요약</span> <a class="main-dashboard-link"
						href="${pageContext.request.contextPath}/dashboard/main">상세</a>
				</div>
				<div class="main-dashboard-metrics">
					<div class="main-dashboard-metric" style="--metric-color: #ef4444;">
						<span class="main-dashboard-metric-label">관제구역 위험도</span> <strong
							class="main-dashboard-metric-value" id="mainSafetyScore">-</strong>
					</div>
					<div class="main-dashboard-metric" style="--metric-color: #38bdf8;">
						<span class="main-dashboard-metric-label">당일 탐지 총 건수</span> <strong
							class="main-dashboard-metric-value" id="mainTodayDetectCount">-</strong>
					</div>
					<div class="main-dashboard-metric" style="--metric-color: #f97316;">
						<span class="main-dashboard-metric-label">당일 위험객체 포착</span> <strong
							class="main-dashboard-metric-value" id="mainTodayDangerCount">-</strong>
					</div>
					<div class="main-dashboard-metric" style="--metric-color: #22c55e;">
						<span class="main-dashboard-metric-label">당일 현장 조치 완료율</span> <strong
							class="main-dashboard-metric-value" id="mainActionCompleteRate">-</strong>
					</div>
					<div class="main-dashboard-metric" style="--metric-color: #a78bfa;">
						<span class="main-dashboard-metric-label">당일 드론 총 비행시간</span> <strong
							class="main-dashboard-metric-value" id="mainFlightHours">-</strong>
					</div>
				</div>
				<div class="main-dashboard-charts">
					<div class="main-dashboard-chart">
						<div class="main-dashboard-chart-title">당일 시간대별 통계</div>
						<div class="main-dashboard-chart-canvas">
							<canvas id="mainTimeChart"></canvas>
						</div>
					</div>
					<div class="main-dashboard-chart">
						<div class="main-dashboard-chart-title">당일 축종별 경보 발생 분포</div>
						<div class="main-dashboard-chart-canvas">
							<canvas id="mainAnimalChart"></canvas>
						</div>
					</div>
					<div class="main-dashboard-chart">
						<div class="main-dashboard-chart-title">당일 이상개체 유형별 포착 통계</div>
						<div class="main-dashboard-chart-canvas">
							<canvas id="mainDangerTypeChart"></canvas>
						</div>
					</div>
				</div>
			</aside>

			<section class="main-alert-log-panel" aria-label="감지 경보 이력">
				<div class="main-alert-log-heading">
					<span>감지 · 경보 이력</span><a class="main-alert-log-link"
						href="${pageContext.request.contextPath}/alert/list">전체 이력</a>
				</div>
				<div class="main-alert-log-list" id="mainAlertLogList">
					<c:choose>
						<c:when test="${empty mainAlertList}">
							<div class="main-alert-log-empty">표시할 경보 이력이 없습니다.</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="alert" items="${mainAlertList}">
								<c:choose>
									<c:when test="${not empty alert.dlogId}">
										<c:set var="mainAlertUrl"
											value="${pageContext.request.contextPath}/detection/detail?dlogId=${alert.dlogId}" />
										<c:set var="mainAlertPopup" value="detectionDetail" />
									</c:when>
									<c:when test="${not empty alert.danlogId}">
										<c:set var="mainAlertUrl"
											value="${pageContext.request.contextPath}/dangerlog/detail?danlogId=${alert.danlogId}" />
										<c:set var="mainAlertPopup" value="dangerLogDetail" />
									</c:when>
									<c:otherwise>
										<c:set var="mainAlertUrl"
											value="${pageContext.request.contextPath}/alert/alertDetail?alertId=${alert.alertId}" />
										<c:set var="mainAlertPopup" value="alertDetail" />
									</c:otherwise>
								</c:choose>
								<a class="main-alert-log-item" data-detail-popup
									data-popup-name="${mainAlertPopup}"
									data-alert-id="${alert.alertId}" href="${mainAlertUrl}"><span
									class="main-alert-log-type ${alert.alertType eq '1' ? 'danger' : 'detection'}">${alert.alertType eq '1' ? '이상객체' : '개체미달'}</span><span
									class="main-alert-log-message"><c:out
											value="${alert.alertMsg}" /></span><span
									class="main-alert-log-time"><fmt:formatDate
											value="${alert.firstSendTime}" pattern="MM-dd HH:mm" /></span></a>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>
			</section>
		</div>
	</div>

	<script
		src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
	<script>
		const yoloSourceKeys = [ 'video_1', 'video_2', 'video_3', 'esp32' ];
		const yoloContextPath = "${pageContext.request.contextPath}";
		const detectionEnabled = {};
		const isToggling = {};
		const flightStatusByChannel = {};
		let detectionStatusRefreshTimer = null;
		let isBulkToggling = false;

		function formatElapsed(ms) {
			const totalSeconds = Math.max(0, Math.floor(ms / 1000));
			const hours = Math.floor(totalSeconds / 3600);
			const minutes = Math.floor((totalSeconds % 3600) / 60);
			const seconds = totalSeconds % 60;
			return [ hours, minutes, seconds ].map(function(value) {
				return String(value).padStart(2, '0');
			}).join(':');
		}

		function renderFlightTimers() {
			yoloSourceKeys
					.forEach(function(channelKey) {
						const overlay = document.getElementById('flightTimer_'
								+ channelKey);
						if (!overlay)
							return;
						const value = overlay
								.querySelector('.flight-timer-value');
						const status = flightStatusByChannel[channelKey];
						const running = !!(status && status.running && status.startTime);
						overlay.classList.toggle('is-running', running);
						if (value)
							value.textContent = running ? formatElapsed(Date
									.now()
									- status.startTime) : '--:--:--';
					});
		}

		function refreshFlightStatus() {
			$
					.ajax({
						url : yoloContextPath + '/yolo/flight/status',
						type : 'GET',
						dataType : 'json',
						cache : false
					})
					.done(
							function(response) {
								yoloSourceKeys
										.forEach(function(channelKey) {
											const status = response
													&& response[channelKey];
											flightStatusByChannel[channelKey] = {
												running : !!(status && status.running),
												startTime : status
														&& status.startTime ? Number(status.startTime)
														: null
											};
										});
								renderFlightTimers();
							});
		}

		function getChannelElements(channelKey) {
			return {
				image : document.getElementById('droneVideo_' + channelKey),
				box : document.getElementById('box_' + channelKey),
				checkbox : document.getElementById('toggle_' + channelKey)
			};
		}

		function setChannelStream(channelKey, enabled) {
			const elements = getChannelElements(channelKey);
			if (!elements.image)
				return;
			elements.box.classList.remove('stream-error');
			if (enabled) {
				elements.image.onerror = function() {
					elements.box.classList.add('stream-error');
				};
				elements.image.src = yoloContextPath + '/yolo/videoFeed/'
						+ encodeURIComponent(channelKey) + '?t='
						+ new Date().getTime();
			} else {
				elements.image.onerror = null;
				elements.image.removeAttribute('src');
			}
		}

		function renderChannelState(channelKey, enabled, disabled, statusText) {
			const elements = getChannelElements(channelKey);
			if (!elements.checkbox || !elements.box)
				return;

			elements.checkbox.checked = !!enabled;
			elements.checkbox.disabled = !!disabled;

			elements.box.classList.toggle('stream-off', !enabled);

			elements.box.classList.toggle('active-border', !!enabled);

			const label = elements.checkbox.parentElement
					.querySelector('.switch-label');
			if (label)
				label.innerText = statusText || (enabled ? 'ON' : 'OFF');
		}

		function applyServerChannelState(channelKey, workerStatus) {
			const enabled = !!(workerStatus && workerStatus.running);
			const stopping = !!(workerStatus && workerStatus.stopping);
			detectionEnabled[channelKey] = enabled;
			renderChannelState(channelKey, enabled, stopping,
					stopping ? 'STOPPING' : null);
			setChannelStream(channelKey, enabled);
			return stopping;
		}

		function readDetectionStatus() {
			$.ajax({
				url : yoloContextPath + '/yolo/detection/status',
				type : 'GET',
				dataType : 'json',
				cache : false,
				success : function(response) {
					const sources = response && response.sources;
					if (!sources) {
						handleDetectionStatusFailure();
						return;
					}
					let hasStoppingWorker = false;
					yoloSourceKeys.forEach(function(channelKey) {
						hasStoppingWorker = applyServerChannelState(channelKey,
								sources[channelKey])
								|| hasStoppingWorker;
					});
					scheduleDetectionStatusRefresh(hasStoppingWorker ? 700
							: 2000);
				},
				error : function() {
					handleDetectionStatusFailure();
					scheduleDetectionStatusRefresh(3000);
				}
			});
		}

		function scheduleDetectionStatusRefresh(delay) {
			window.clearTimeout(detectionStatusRefreshTimer);
			detectionStatusRefreshTimer = window.setTimeout(
					readDetectionStatus, delay);
		}

		function handleDetectionStatusFailure() {
			yoloSourceKeys.forEach(function(channelKey) {
				const elements = getChannelElements(channelKey);
				if (!elements.checkbox)
					return;
				elements.checkbox.disabled = true;
				const label = elements.checkbox.parentElement
						.querySelector('.switch-label');
				if (label)
					label.innerText = 'ERR';
			});
		}

		function toggleChannelPower(channelKey, checkbox) {
			const previousState = !!detectionEnabled[channelKey];
			const requestedState = checkbox.checked;
			if (isToggling[channelKey]) {
				checkbox.checked = previousState;
				return;
			}
			if (requestedState === previousState) {
				renderChannelState(channelKey, previousState, false);
				return;
			}

			isToggling[channelKey] = true;
			renderChannelState(channelKey, previousState, true, '...');
			if (!requestedState)
				setChannelStream(channelKey, false);

			$
					.ajax(
							{
								url : yoloContextPath + '/yolo/detection/'
										+ encodeURIComponent(channelKey) + '/'
										+ (requestedState ? 'start' : 'stop'),
								type : 'POST',
								dataType : 'json'
							})
					.done(
							function(response) {
								const workerStatus = response
										&& response.sources
										&& response.sources[channelKey];
								const actualState = !!(workerStatus && workerStatus.running);
								if (response.status !== 'SUCCESS'
										|| actualState !== requestedState) {
									detectionEnabled[channelKey] = previousState;
									renderChannelState(channelKey,
											previousState, false);
									setChannelStream(channelKey, previousState);
									alert('[' + channelKey
											+ '] worker 상태가 요청과 일치하지 않습니다.');
									return;
								}
								detectionEnabled[channelKey] = actualState;
								renderChannelState(channelKey, actualState,
										false);
								setChannelStream(channelKey, actualState);
								refreshFlightStatus();
							}).fail(function() {
						detectionEnabled[channelKey] = previousState;
						renderChannelState(channelKey, previousState, false);
						setChannelStream(channelKey, previousState);
						alert('[' + channelKey + '] 탐지 worker 상태 변경에 실패했습니다.');
					}).always(function() {
						isToggling[channelKey] = false;
						const enabled = !!detectionEnabled[channelKey];
						renderChannelState(channelKey, enabled, false);
					});
		}

		function toggleAllChannels(enable) {
			if (isBulkToggling)
				return;
			isBulkToggling = true;
			$('#btnAllChannelOn, #btnAllChannelOff').prop('disabled', true);
			yoloSourceKeys.forEach(function(channelKey) {
				renderChannelState(channelKey, !!detectionEnabled[channelKey],
						true, '...');
			});

			$.ajax(
					{
						url : yoloContextPath + '/yolo/detection/'
								+ (enable ? 'start' : 'stop'),
						type : 'POST',
						dataType : 'json'
					}).done(
					function(response) {
						if (!response || response.status !== 'SUCCESS'
								|| !response.sources) {
							alert('전체 채널 상태 변경에 실패했습니다.');
							return;
						}
						yoloSourceKeys.forEach(function(channelKey) {
							applyServerChannelState(channelKey,
									response.sources[channelKey]);
						});
						refreshFlightStatus();
					}).fail(function() {
				alert('전체 채널 상태 변경 중 서버 통신 오류가 발생했습니다.');
			}).always(
					function() {
						isBulkToggling = false;
						$('#btnAllChannelOn, #btnAllChannelOff').prop(
								'disabled', false);
						readDetectionStatus();
					});
		}

		var mainTimeChart = null;
		var mainAnimalChart = null;
		var mainDangerTypeChart = null;

		function renderMainDashboardCharts(res) {
			if (typeof Chart === 'undefined')
				return;
			var tickColor = '#94a3b8';
			var gridColor = 'rgba(71, 85, 105, 0.35)';
			var timeCanvas = document.getElementById('mainTimeChart');
			var animalCanvas = document.getElementById('mainAnimalChart');
			var dangerTypeCanvas = document
					.getElementById('mainDangerTypeChart');

			if (timeCanvas) {
				if (mainTimeChart)
					mainTimeChart.destroy();
				mainTimeChart = new Chart(timeCanvas.getContext('2d'), {
					type : 'bar',
					data : {
						labels : res.timeLabels || [],
						datasets : [ {
							label : '\uC704\uD5D8\uAC1D\uCCB4',
							data : res.dangerTimeData || [],
							backgroundColor : '#f97316',
							borderRadius : 3
						}, {
							label : '\uAC1C\uCCB4\uBBF8\uB2EC',
							data : res.detectTimeData || [],
							backgroundColor : '#38bdf8',
							borderRadius : 3
						} ]
					},
					options : {
						responsive : true,
						maintainAspectRatio : false,
						plugins : {
							legend : {
								labels : {
									color : tickColor,
									boxWidth : 8,
									font : {
										size : 9
									}
								}
							}
						},
						scales : {
							x : {
								stacked : true,
								ticks : {
									color : tickColor,
									maxTicksLimit : 6,
									font : {
										size : 9
									}
								},
								grid : {
									display : false
								}
							},
							y : {
								stacked : true,
								beginAtZero : true,
								ticks : {
									color : tickColor,
									precision : 0,
									font : {
										size : 9
									}
								},
								grid : {
									color : gridColor
								}
							}
						}
					}
				});
			}

			if (animalCanvas) {
				if (mainAnimalChart)
					mainAnimalChart.destroy();
				mainAnimalChart = new Chart(animalCanvas.getContext('2d'), {
					type : 'doughnut',
					data : {
						labels : res.animalLabels || [],
						datasets : [ {
							data : res.animalData || [],
							backgroundColor : [ '#38bdf8', '#f59e0b',
									'#a78bfa', '#22c55e' ],
							borderWidth : 0
						} ]
					},
					options : {
						responsive : true,
						maintainAspectRatio : false,
						cutout : '58%',
						plugins : {
							legend : {
								position : 'bottom',
								labels : {
									color : tickColor,
									boxWidth : 8,
									font : {
										size : 9
									}
								}
							}
						}
					}
				});
			}

			if (dangerTypeCanvas) {
				if (mainDangerTypeChart)
					mainDangerTypeChart.destroy();
				mainDangerTypeChart = new Chart(dangerTypeCanvas
						.getContext('2d'),
						{
							type : 'bar',
							data : {
								labels : res.dangerTypeLabels || [],
								datasets : [ {
									label : '\uD3EC\uCC29 \uAC74\uC218',
									data : res.dangerTypeData || [],
									backgroundColor : [ '#ef4444', '#f97316',
											'#eab308', '#a855f7', '#ec4899',
											'#14b8a6' ],
									borderRadius : 3
								} ]
							},
							options : {
								indexAxis : 'y',
								responsive : true,
								maintainAspectRatio : false,
								plugins : {
									legend : {
										display : false
									}
								},
								scales : {
									x : {
										beginAtZero : true,
										ticks : {
											color : tickColor,
											precision : 0,
											font : {
												size : 9
											}
										},
										grid : {
											color : gridColor
										}
									},
									y : {
										ticks : {
											color : tickColor,
											font : {
												size : 9
											}
										},
										grid : {
											display : false
										}
									}
								}
							}
						});
			}
		}

		function syncMainDashboardHeight() {
			var dashboard = document.querySelector('.main-dashboard-summary');
			var alertPanel = document.querySelector('.main-alert-log-panel');
			var layout = document.querySelector('.main-control-layout');
			if (!dashboard || !alertPanel || !layout)
				return;

			dashboard.style.height = '';
			alertPanel.style.minHeight = '';
			layout.style.paddingBottom = '0px';
			if (window.innerWidth <= 1180)
				return;

			var dashboardBottom = dashboard.getBoundingClientRect().bottom;
			var alertBottom = alertPanel.getBoundingClientRect().bottom;
			var extraHeight = Math.max(0, Math.round(dashboardBottom
					- alertBottom));
			if (extraHeight > 0)
				alertPanel.style.minHeight = (alertPanel.offsetHeight + extraHeight)
						+ 'px';
		}

		function refreshMainDashboard() {
			$
					.ajax({
						url : yoloContextPath + '/dashboard/api/ai-briefing',
						type : 'GET',
						dataType : 'json',
						cache : false
					})
					.done(
							function(res) {
								renderMainDashboardCharts(res || {});
								syncMainDashboardHeight();
								var score = Number(res && res.safetyScore || 0);
								var scoreText = score >= 70 ? '점 · 심각'
										: score >= 40 ? '점 · 주의' : '점 · 안전';
								$('#mainSafetyScore').text(score + scoreText);
								$('#mainTodayDetectCount')
										.text(
												Number(res
														&& res.todayDetectCount
														|| 0)
														+ '건');
								$('#mainTodayDangerCount')
										.text(
												Number(res
														&& (res.todayDangerCount !== undefined ? res.todayDangerCount
																: res.dangerCount)
														|| 0)
														+ '건');
								$('#mainActionCompleteRate').text(
										Number(res && res.actionCompleteRate
												|| 0)
												+ '%');
								$('#mainFlightHours').text(
										Number(res && res.flightHours || 0)
												+ '시간');
							})
					.fail(
							function() {
								$(
										'#mainSafetyScore, #mainTodayDetectCount, #mainTodayDangerCount, #mainActionCompleteRate, #mainFlightHours')
										.text('-');
							});
		}

		function appendMainAlertLog(alertData) {
			if (!alertData || alertData.alertId === undefined)
				return;
			var $list = $('#mainAlertLogList');
			if ($list.length === 0
					|| $list
							.find('[data-alert-id="' + alertData.alertId + '"]').length > 0)
				return;
			$list.find('.main-alert-log-empty').remove();
			var isDanger = String(alertData.alertType) === '1';
			var targetUrl = yoloContextPath + '/alert/alertDetail?alertId='
					+ encodeURIComponent(alertData.alertId);
			var popupName = 'alertDetail';
			if (alertData.dlogId) {
				targetUrl = yoloContextPath + '/detection/detail?dlogId='
						+ encodeURIComponent(alertData.dlogId);
				popupName = 'detectionDetail';
			} else if (alertData.danlogId) {
				targetUrl = yoloContextPath + '/dangerlog/detail?danlogId='
						+ encodeURIComponent(alertData.danlogId);
				popupName = 'dangerLogDetail';
			}
			var now = new Date();
			var timeText = String(now.getMonth() + 1).padStart(2, '0') + '-'
					+ String(now.getDate()).padStart(2, '0') + ' '
					+ String(now.getHours()).padStart(2, '0') + ':'
					+ String(now.getMinutes()).padStart(2, '0');
			var $item = $('<a>', {
				href : targetUrl,
				'class' : 'main-alert-log-item',
				'data-detail-popup' : '',
				'data-popup-name' : popupName,
				'data-alert-id' : alertData.alertId
			});
			$item.append($('<span>', {
				'class' : 'main-alert-log-type '
						+ (isDanger ? 'danger' : 'detection'),
				text : isDanger ? '이상객체' : '개체미달'
			}));
			$item.append($('<span>', {
				'class' : 'main-alert-log-message',
				text : alertData.alertMsg || '새 경보가 발생했습니다.'
			}));
			$item.append($('<span>', {
				'class' : 'main-alert-log-time',
				text : timeText
			}));
			$list.prepend($item);
			while ($list.children('.main-alert-log-item').length > 11) {
				$list.children('.main-alert-log-item').last().remove();
			}
			syncMainDashboardHeight();
		}

		document.addEventListener('ssa:alert-received', function(event) {
			appendMainAlertLog(event.detail);
		});

		function loadTopAlarmSoundState() {
			var $toggle = $('#topAlarmToggle');
			if (!$toggle.length) {
				return;
			}
			$.ajax({
				url : yoloContextPath + '/yolo/buzzer/enabled',
				type : 'GET',
				dataType : 'json',
				cache : false
			}).done(function(response) {
				var enabled = !!(response && response.enabled);
				$toggle.prop('checked', enabled).data('lastEnabled', enabled);
			});
		}

		$('#topAlarmToggle').on('change', function() {
			var toggle = this;
			var requested = toggle.checked;
			var previous = $(toggle).data('lastEnabled');
			if (typeof previous !== 'boolean') {
				previous = !requested;
			}

			$(toggle).prop('disabled', true);
			$.ajax({
				url : yoloContextPath + '/yolo/buzzer/enabled',
				type : 'POST',
				data : { enabled : requested },
				dataType : 'json'
			}).done(function(response) {
				var enabled = !!(response && response.enabled);
				$(toggle).prop('checked', enabled).data('lastEnabled', enabled);
			}).fail(function() {
				$(toggle).prop('checked', previous).data('lastEnabled', previous);
				window.alert('알람 소리 상태 변경에 실패했습니다.');
			}).always(function() {
				$(toggle).prop('disabled', false);
			});
		});

		function toMainSensorNumber(value, fallback) {
			var parsed = Number(value);
			return isFinite(parsed) ? parsed : fallback;
		}

		function formatMainSensorNumber(value, decimals) {
			var numeric = toMainSensorNumber(value, 0);
			return decimals > 0 && Math.round(numeric) !== numeric ? numeric
					.toFixed(decimals) : String(Math.round(numeric));
		}

		function renderMainSensorStatus(status) {
			var online = !!(status && status.sensorOnline === true);
			var level = String(status && status.collisionLevel || 'UNKNOWN')
					.toUpperCase();
			var knownLevels = [ 'SAFE', 'CAUTION', 'WARNING', 'DANGER' ];
			if (!online || knownLevels.indexOf(level) === -1) {
				level = 'OFFLINE';
			}

			var temperature = online ? formatMainSensorNumber(status.temperature,
					1) : '0';
			var humidity = online ? formatMainSensorNumber(status.humidity, 0)
					: '0';
			var illumination = online ? formatMainSensorNumber(status.illumination,
					0) : '0';
			var distance = online ? formatMainSensorNumber(status.distance, 1) : '0';
			var statusTitle = online ? '충돌 상태: ' + level : 'SENSOR OFFLINE';

			$('.video-sensor-hud').each(function() {
				var $hud = $(this);
				$hud.removeClass('is-safe is-caution is-warning is-danger is-offline')
						.addClass('is-' + level.toLowerCase()).attr('title', statusTitle);
				$hud.find('.sensor-temp').text(temperature + '°C');
				$hud.find('.sensor-humidity').text(humidity + '%');
				$hud.find('.sensor-light').text(illumination);
				$hud.find('.sensor-distance').text(distance + 'cm')
						.attr('title', statusTitle);
			});
		}

		function refreshMainSensorStatus() {
			$.ajax({
				url : yoloContextPath + '/yolo/envSensor/status',
				type : 'GET',
				dataType : 'json',
				cache : false
			}).done(function(status) {
				renderMainSensorStatus(status || {});
			}).fail(function() {
				renderMainSensorStatus({ sensorOnline : false });
			});
		}

		$(document).ready(function() {
			readDetectionStatus();
			loadTopAlarmSoundState();
			refreshFlightStatus();
			refreshMainSensorStatus();
			syncMainDashboardHeight();
			refreshMainDashboard();
			window.setInterval(renderFlightTimers, 1000);
			window.setInterval(refreshMainSensorStatus, 3000);
			window.setInterval(refreshMainDashboard, 60000);
		});

		window.addEventListener('resize', syncMainDashboardHeight);
	</script>

	<script>
		$('#btnToggleDroneSetting').on('click', function(e) {
			e.stopPropagation();
			$('#droneSettingDropdown').fadeToggle(150);
		});
		$('#droneSettingDropdown').on('click', function(e) {
			e.stopPropagation();
		});
		$(document).on('click', function() {
			$('#droneSettingDropdown').fadeOut(100);
		});
		$(document).ready(function() {
			fn_loadCurrentDroneMappings();
		});

		function fn_loadCurrentDroneMappings() {
			$
					.ajax({
						url : "${pageContext.request.contextPath}/yolo/currentMappings",
						type : "GET",
						dataType : "json",
						cache : false,
						success : function(res) {
							if (res) {
								var drones = res.dbDroneList;
								var mappings = res.activeMappings;
								$(".drone-map-select")
										.each(
												function() {
													var $el = $(this);
													$el.empty();
													if (drones
															&& drones.length > 0) {
														drones
																.forEach(function(
																		droneId) {
																	$el
																			.append($(
																					'<option>',
																					{
																						value : droneId,
																						text : droneId
																					}));
																});
													} else {
														$el
																.append('<option value="">등록 드론 없음</option>');
													}
												});
								if (mappings) {
									Object
											.keys(mappings)
											.forEach(
													function(key) {
														var targetSelect = $("#drone_select_"
																+ key);
														if (targetSelect.length > 0) {
															targetSelect
																	.val(mappings[key]);
														}
													});
								}
								fn_updateSourceButtonLabels(mappings);
							}
						},
						error : function(xhr, status, error) {
							console.error("❌ 드론 맵 정보 획득 실패 사유: ", error);
						}
					});
		}

		function fn_updateSourceButtonLabels(mappings) {
			var sourceDefaults = {
				video_1 : 'DRONE-01',
				video_2 : 'DRONE-02',
				video_3 : 'DRONE-03',
				esp32 : 'DRONE-04 (ESP32)'
			};
			Object.keys(sourceDefaults).forEach(function(sourceKey) {
				var $title = $("#sourceButton_" + sourceKey);
				var droneId = mappings && mappings[sourceKey];
				var displayName = droneId || sourceDefaults[sourceKey];
				if ($title.length)
					$title.text(displayName);
			});
		}

		function fn_saveDroneMapping(sourceKey) {
			var targetSelect = $("#drone_select_" + sourceKey);
			if (targetSelect.length === 0) {
				alert("해당 채널의 설정 요소를 찾을 수 없습니다.");
				return;
			}
			var droneId = targetSelect.val();
			if (!droneId) {
				alert("배정할 드론을 선택해 주세요.");
				return;
			}
			$
					.ajax({
						url : "${pageContext.request.contextPath}/yolo/updateMapping",
						type : "POST",
						dataType : "json",
						data : {
							sourceKey : sourceKey,
							droneId : droneId
						},
						success : function(res) {
							if (res && res.status === "SUCCESS") {
								alert("✅ [" + sourceKey
										+ "] 채널에 드론 배정이 완벽하게 적용되었습니다.");
								$('#droneSettingDropdown').fadeOut(100);
								fn_loadContentDroneMappings();
							} else {
								alert("❌ 서버 처리 중 매핑 적용에 실패했습니다.");
							}
						},
						error : function(xhr, status, error) {
							console.error("❌ 드론 매핑 적용 통신 실패 사유: ", error);
							alert("서버와 통신 중 오류가 발생했습니다.");
						}
					});
		}
	</script>

	<script>
		$('.video-display-box')
				.on(
						'click',
						function(e) {
							if ($(e.target)
									.closest(
											'.switch-item, .drone-dropdown-wrapper, button, select').length > 0) {
								return;
							}
							const boxId = $(this).attr('id');
							const channelKey = boxId.replace('box_', '');
							location.href = yoloContextPath
									+ '/yolo/detail?channel='
									+ encodeURIComponent(channelKey);
						});
	</script>
</body>
</html>
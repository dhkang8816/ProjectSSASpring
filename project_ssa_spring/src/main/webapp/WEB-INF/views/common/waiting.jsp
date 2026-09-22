<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>승인 대기 중</title>
<style>

body {
    background-color: #0b0f19 !important; 
    color: #cbd5e1 !important;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
    margin: 0;
    padding: 20px;
    box-sizing: border-box;
    
    
    display: flex !important;
    justify-content: center !important;
    align-items: center !important;
    min-height: 100vh !important;
}


.panel {
    background: rgba(20, 26, 42, 0.85) !important; 
    border: 1px solid #1e293b !important;
    border-radius: 16px !important;
    padding: 32px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5) !important;
    backdrop-filter: blur(4px);
    width: 100%;
    max-width: 480px; 
    box-sizing: border-box;
    text-align: center;
}

.panel h2 {
    color: #ffffff !important;
    margin: 0 0 16px 0 !important;
    font-size: 19px !important;
    font-weight: 700 !important;
    letter-spacing: -0.02em;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.panel p {
    color: #94a3b8 !important; 
    font-size: 14px;
    line-height: 1.6;
    margin: 0 0 28px 0;
    word-break: keep-all;
}


.btn-container {
    display: flex;
    justify-content: center;
    width: 100%;
}


button.btn-list {
    padding: 10px 24px !important;
    background-color: #1e293b !important;
    color: #cbd5e1 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    font-size: 13.5px;
    font-weight: 700;
    cursor: pointer;
    transition: all 0.15s ease;
}

button.btn-list:hover {
    background-color: #334155 !important;
    color: #ffffff !important;
    border-color: #0ea5e9 !important;
}
</style>

</head>
<body>

<div class="panel">
    
    <h2>⚠ 관리자 승인 대기 중입니다.</h2>
    
    <p>
        현재 계정은 승인 대기 상태입니다.<br>
        관리자 승인 후 시스템 관제 서비스를 이용하실 수 있습니다.
    </p>
    
    
    <div class="btn-container">
        <button type="button" class="btn-list" onclick="fn_goBackHistory();">
            뒤로가기
        </button>
    </div>
    
</div>
</body>

<script>

function fn_goBackHistory() {
    if (document.referrer) {
        location.href = document.referrer;
    } else {
        history.back();
    }
}
</script>
</html>
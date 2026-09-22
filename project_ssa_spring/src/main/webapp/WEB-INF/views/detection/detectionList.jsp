<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관제 탐지 이력</title>
<style>

body {
    background-color: #0b0f19 !important; 
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}

#detectionListPage {
    color: #e2e8f0;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
}

#detectionListPage.control-page-content {
    position: absolute !important;
    top: 80px !important;
    padding: 30px 40px;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    #detectionListPage.control-page-content {
        padding: 20px 16px;
    }
}


#detectionListPage .panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(4px);
    width: 100%;
    box-sizing: border-box;
}

#detectionListPage .panel h2 {
    color: #ffffff;
    margin: 0 0 24px 0 !important;
    font-size: 20px;
    font-weight: 700;
    letter-spacing: -0.02em;
    text-align: left;
}


#detectionListPage .search-box {
    margin: 20px 0;
    padding: 20px;
    background: rgba(17, 24, 39, 0.6) !important;
    border: 1px solid #1e293b !important;
    border-radius: 12px;
}


#detectionListPage table {
    width: 100%;
    border-collapse: separate !important;
    border-spacing: 0 !important;
    margin-top: 16px;
    background-color: transparent !important;
    box-shadow: none !important;
    border: 1px solid #1e293b !important;
    border-radius: 8px;
    overflow: hidden;
}

#detectionListPage th {
    background-color: #111827 !important; 
    color: #38bdf8 !important; 
    padding: 14px 16px !important;
    font-size: 13px;
    font-weight: 700;
    text-align: center !important; 
    border: 0 !important;
    border-bottom: 2px solid #1e293b !important;
}

#detectionListPage td {
    padding: 12px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 13.5px;
    text-align: center !important; 
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    vertical-align: middle !important;
}


#detectionListPage tr {
    transition: background-color 0s ease;
}

#detectionListPage tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}

#detectionListPage .no-data {
    padding: 60px !important;
    color: #64748b !important;
    font-size: 14px;
}


.mini-snapshot {
    width: 70px;
    height: 45px;
    border-radius: 6px !important;
    border: 1px solid #334155 !important;
    object-fit: cover;
    vertical-align: middle;
    background-color: #111827;
}


#detectionListPage form {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
    color: #cbd5e1;
    font-size: 13.5px;
}

#detectionListPage input[type="text"], #detectionListPage select {
    padding: 8px 12px;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px;
    outline: none;
    font-size: 13.5px;
    transition: all 0.15s ease;
}

#detectionListPage input[type="text"]:focus, #detectionListPage select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}


#detectionListPage a.main-link {
    color: #38bdf8 !important;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
    transition: color 0.15s ease;
}

#detectionListPage a.main-link:hover {
    color: #7dd3fc !important;
    text-decoration: underline !important;
}


#detectionListPage button {
    padding: 9px 16px;
    background-color: #0ea5e9 !important;
    color: #ffffff !important;
    border: 0;
    border-radius: 8px !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    transition: all 0.15s ease;
}

#detectionListPage button:hover {
    background-color: #0284c7 !important;
}


#detectionListPage .badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important;
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}


#detectionListPage .badge-status.status-unverified {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
}


#detectionListPage .badge-status.status-progress {
    background-color: rgba(245, 158, 11, 0.15) !important;
    color: #f59e0b !important;
    border: 1px solid rgba(245, 158, 11, 0.3) !important;
}


.badge-status.status-complete {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
}


.badge-none {
    background-color: rgba(30, 41, 59, 0.5) !important;
    color: #64748b !important;
    border: 1px solid #1e293b !important;
}


#detectionListPage .pagination {
    display: flex;
    list-style: none;
    gap: 6px;
    justify-content: center;
    padding: 0;
    margin: 0 !important;
}

#detectionListPage .pagination li {
    margin: 0 !important;
}

#detectionListPage .pagination a, #detectionListPage .pagination strong {
    display: block;
    padding: 6px 12px;
    background: #111827 !important;
    color: #94a3b8 !important;
    border: 1px solid #1e293b;
    border-radius: 6px;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    transition: all 0.15s;
}

#detectionListPage .pagination a:hover {
    color: #ffffff !important;
    background: #1f2937 !important;
    border-color: #334155;
}


#detectionListPage .pagination li.active strong, #detectionListPage .pagination strong {
    color: #38bdf8 !important;
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}

@media (max-width: 760px) {
	#detectionListPage table {
        display: block;
        overflow-x: auto;
        white-space: nowrap;
    }
}

#detectionListPage .panel { display: grid !important; grid-template-columns: minmax(180px, 1fr) auto; grid-template-areas: "title search" "summary action" "table table" "pager pager"; gap: 20px; padding: 0 !important; background: transparent !important; border: 0 !important; box-shadow: none !important; overflow-x: auto; }#detectionListPage .panel > h2 { grid-area: title; margin: 0 !important; padding: 0 0 16px; border-bottom: 1px solid #1e293b; color: #fff !important; font-size: 22px !important; }#detectionListPage .panel > .staff-list-summary { grid-area: summary; color: #94a3b8; font-size: 14px; font-weight: 500; }#detectionListPage .panel > .staff-list-summary strong { color: #38bdf8; background: rgba(56,189,248,.1); border-radius: 4px; padding: 2px 6px; }#detectionListPage .panel > .search-box { grid-area: search; justify-self: end; margin: 0 !important; }#detectionListPage .panel > table { grid-area: table; min-width: 850px; margin: 0 !important; }#detectionListPage .panel > table th, #detectionListPage .panel > table td { white-space: nowrap; }#detectionListPage .panel > div[style*="margin-top"] { grid-area: pager; justify-self: center; margin: 0 !important; }@media (max-width: 760px) { #detectionListPage .panel { grid-template-columns: 1fr; grid-template-areas: "title" "search" "summary" "table" "pager"; }#detectionListPage .panel > .search-box { justify-self: stretch; } }


</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />


<div id="detectionListPage" class="control-page-content">
    <div class="panel">
        
        <h2>관제 탐지 이력 목록</h2>
    		<div class="staff-summary-bar"
			     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important; line-height: 1.2 !important; height: auto !important; margin-bottom: 5px !important;">
			     
			    
			    <div class="staff-count" style="display: inline-block !important; color: #94a3b8 !important; font-size: 14px !important; font-weight: 500 !important; margin: 0 !important; padding: 0 !important;">
			        총 <strong>${pageMaker.totalCount}</strong>건
			    </div>
			    
			    
			    <div class="summary-action-group"
			         style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important; padding: 0 !important; height: auto !important;">
			         
			        
			        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#detectionTable', 'detection-list')"
			                style="float: none !important; margin: 0 !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; white-space: nowrap !important; box-sizing: border-box !important; height: 36px !important; padding: 0 16px !important; line-height: 1 !important; border-radius: 6px !important;">
			            <i class="fa-solid fa-file-csv" style="font-size: 14px; margin: 0 !important; padding: 0 !important;"></i> CSV
			        </button>
			    </div>
			</div>
        
        <table id="detectionTable" data-csv-export data-csv-filename="detection-list">
            <thead>
                <tr>
                    <th style="width: 80px;">로그번호</th>
                    <th style="width: 90px;">스냅샷</th>
                    <th style="width: 140px;">드론 기체 ID</th>
                    <th style="width: 150px;">축종</th>
                    <th style="width: 90px;">개체수</th>
                    <th style="width: 180px;">탐지 시각</th>
                    <th style="width: 110px;">조치 상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty detectionList}">
                        <tr>
                            <td colspan="7" class="no-data">포착된 실시간 관제 탐지 이력이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="detection" items="${detectionList}">
                            
                            <tr style="cursor: pointer;"
                                onclick="return openDetailPopup('${pageContext.request.contextPath}/detection/detail?dlogId=${detection.dlogId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'detectionDetail');">
                                
                                
                                <td style="font-weight: bold;">${detection.dlogId}</td>
                                
                                
                                <td>
                                    <img src="${pageContext.request.contextPath}/detection/getSnapshot?dlogId=${detection.dlogId}" 
                                         alt="탐지 스냅샷" 
                                         class="mini-snapshot"
                                         onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
                                </td>
                                
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${empty detection.droneId}">
                                            <span class="badge-status badge-none">알수없음</span>
                                        </c:when>
                                        <c:otherwise>${detection.droneId}</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                
                                <td style="color: #ffffff; font-weight: bold;"><c:out value="${empty animalTypeNames[detection.animalType] ? detection.animalType : animalTypeNames[detection.animalType]}" /></td>
                                
                                
                                <td>${detection.detectCount}마리</td>
                                
                                
                                <td><fmt:formatDate value="${detection.detectTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                
                                
                                <td>
                <span class="badge-status badge-none"><c:out value="${empty actionStatusNames[detection.actionStatus] ? detection.actionStatus : actionStatusNames[detection.actionStatus]}" /></span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
                
        <div class="search-box">
            <form:form action="list" method="get">
                <select name="searchType">
                    <option value="a" ${pageMaker.searchType == 'a' ? 'selected' : ''}>이상 객체 이름</option>
                    <option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론 기체 ID</option>
                    <option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>조치 상태</option>
                </select>
                <select name="keyword" id="animalTypeKeyword" ${pageMaker.searchType == 'a' ? '' : 'disabled'}>
                    <option value="">전체 축종</option>
                    <c:forEach var="animalType" items="${animalTypeNames}">
                        <option value="${animalType.key}" ${pageMaker.keyword == animalType.key ? 'selected' : ''}>${animalType.value}</option>
                    </c:forEach>
                </select>
                <select name="keyword" id="actionStatusKeyword" ${pageMaker.searchType == 's' ? '' : 'disabled'}>
                    <option value="">전체 조치상태</option>
                    <c:forEach var="actionStatus" items="${actionStatusNames}">
                        <option value="${actionStatus.key}" ${pageMaker.keyword == actionStatus.key ? 'selected' : ''}>${actionStatus.value}</option>
                    </c:forEach>
                </select>
                <input type="text" name="keyword" id="detectionTextKeyword" value="${pageMaker.searchType == 'a' or pageMaker.searchType == 's' ? '' : pageMaker.keyword}" placeholder="검색어 입력" ${pageMaker.searchType == 'a' or pageMaker.searchType == 's' ? 'disabled' : ''}>
                <button type="submit">검색</button>
            </form:form>
        </div>
        
        <div style="margin-top: 25px;">
            <ul class="pagination">
                <c:if test="${pageMaker.prev}">
                    <li>
                        <a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a>
                    </li>
                </c:if>
                <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <li class="${pageMaker.page == pageNum ? 'active' : ''}">
                        <c:choose>
                            <c:when test="${pageMaker.page == pageNum}">
                                <strong>${pageNum}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="list?page=${pageNum}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">${pageNum}</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </c:forEach>
                <c:if test="${pageMaker.next}">
                    <li>
                        <a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
</body>
<script>
var msg = "${msg}";
if (msg === "MODIFY_SUCCESS") {
    alert("현장 상황 조치 내역이 성공적으로 업데이트되었습니다.");
}

document.querySelector('.search-box select[name="searchType"]').addEventListener('change', function () {
    var isAnimalType = this.value === 'a';
    var isActionStatus = this.value === 's';
    document.getElementById('animalTypeKeyword').disabled = !isAnimalType;
    document.getElementById('actionStatusKeyword').disabled = !isActionStatus;
    document.getElementById('detectionTextKeyword').disabled = isAnimalType || isActionStatus;
});
</script>
</html>

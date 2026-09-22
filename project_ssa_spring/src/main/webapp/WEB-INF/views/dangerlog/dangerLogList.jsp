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
<title>이상 객체 탐지 이력</title>
<style>

body {
    background-color: #0b0f19 !important; 
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}

#dangerLogListPage {
    color: #e2e8f0;
    font-family: 'Segoe UI', Roboto, 'Malgun Gothic', sans-serif;
}

#dangerLogListPage.control-page-content {
    position: absolute !important;
    top: 80px !important;
    padding: 30px 40px;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    #dangerLogListPage.control-page-content {
        padding: 20px 16px;
    }
}


#dangerLogListPage .panel {
    background: rgba(20, 26, 42, 0.85) !important;
    border: 1px solid #1e293b !important;
    border-radius: 16px;
    padding: 28px !important;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(4px);
    width: 100%;
    box-sizing: border-box;
}

#dangerLogListPage .panel h2 {
    color: #ffffff;
    margin: 0 0 24px 0 !important;
    font-size: 20px;
    font-weight: 700;
    letter-spacing: -0.02em;
    text-align: left;
}


#dangerLogListPage .search-box {
    margin: 20px 0;
    padding: 20px;
    background: rgba(17, 24, 39, 0.6) !important;
    border: 1px solid #1e293b !important;
    border-radius: 12px;
}


#dangerLogListPage table {
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

#dangerLogListPage th {
    background-color: #111827 !important; 
    color: #38bdf8 !important; 
    padding: 14px 16px !important;
    font-size: 13px;
    font-weight: 700;
    text-align: center !important; 
    border: 0 !important;
    border-bottom: 2px solid #1e293b !important;
}

#dangerLogListPage td {
    padding: 12px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    font-size: 13.5px;
    text-align: center !important; 
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    vertical-align: middle !important;
}


#dangerLogListPage tr {
    transition: background-color 0s ease;
}

#dangerLogListPage tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}

#dangerLogListPage .no-data {
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


#dangerLogListPage form {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    align-items: center;
    color: #cbd5e1;
    font-size: 13.5px;
}

#dangerLogListPage input[type="text"], #dangerLogListPage select {
    padding: 8px 12px;
    background: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 6px;
    outline: none;
    font-size: 13.5px;
    transition: all 0.15s ease;
}

#dangerLogListPage input[type="text"]:focus, #dangerLogListPage select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}


#dangerLogListPage a.main-link {
    color: #38bdf8 !important;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
    transition: color 0.15s ease;
}

#dangerLogListPage a.main-link:hover {
    color: #7dd3fc !important;
    text-decoration: underline !important;
}


#dangerLogListPage button {
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

#dangerLogListPage button:hover {
    background-color: #0284c7 !important;
}


#dangerLogListPage .badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important;
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}


#dangerLogListPage .badge-status.status-unverified {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
}


#dangerLogListPage .badge-status.status-progress {
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


#dangerLogListPage .pagination {
    display: flex;
    list-style: none;
    gap: 6px;
    justify-content: center;
    padding: 0;
    margin: 0 !important;
}

#dangerLogListPage .pagination li {
    margin: 0 !important;
}

#dangerLogListPage .pagination a, #dangerLogListPage .pagination strong {
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

#dangerLogListPage .pagination a:hover {
    color: #ffffff !important;
    background: #1f2937 !important;
    border-color: #334155;
}


#dangerLogListPage .pagination li.active strong, #dangerLogListPage .pagination strong {
    color: #38bdf8 !important;
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}

@media (max-width: 760px) {
	#dangerLogListPage table {
        display: block;
        overflow-x: auto;
        white-space: nowrap;
    }
}

#dangerLogListPage .panel { display:grid !important; grid-template-columns:minmax(180px,1fr) auto; grid-template-areas:"title search" "summary action" "table table" "pager pager"; gap:20px; padding:0 !important; background:transparent !important; border:0 !important; box-shadow:none !important; overflow-x:auto; }
#dangerLogListPage .panel > h2 { grid-area:title; margin:0 !important; padding:0 0 16px; border-bottom:1px solid #1e293b; color:#fff !important; font-size:22px !important; }
#dangerLogListPage .panel > br { display:none; }
#dangerLogListPage .panel > .staff-list-summary { grid-area:summary; color:#94a3b8; font-size:14px; font-weight:500; }
#dangerLogListPage .panel > .staff-list-summary strong { color:#38bdf8; background:rgba(56,189,248,.1); border-radius:4px; padding:2px 6px; }
#dangerLogListPage .panel > .search-box { grid-area:search; justify-self:end; margin:0 !important; }
#dangerLogListPage .panel > table { grid-area:table; min-width:850px; margin:0 !important; }
#dangerLogListPage .panel > table th,#dangerLogListPage .panel > table td { white-space:nowrap; }
#dangerLogListPage .panel > div[style*="margin-top"] { grid-area:pager; justify-self:center; margin:0 !important; }
@media(max-width:760px){#dangerLogListPage .panel{grid-template-columns:1fr;grid-template-areas:"title" "search" "summary" "table" "pager"}#dangerLogListPage .panel > .search-box{justify-self:stretch}}


</style>

</head>
<body>

<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />


<div id="dangerLogListPage" class="control-page-content">
    <div class="panel">
        
        <h2>이상 객체 탐지 이력 목록</h2>
        
          <div class="staff-summary-bar"
		     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important; line-height: 1.2 !important; height: auto !important; margin-bottom: 5px !important;">
		     
		    
		    <div class="staff-count" style="display: inline-block !important; color: #94a3b8 !important; font-size: 14px !important; font-weight: 500 !important; margin: 0 !important; padding: 0 !important;">
		        총 <strong>${pageMaker.totalCount}</strong>건
		    </div>
		    
		    
		    <div class="summary-action-group"
		         style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important; padding: 0 !important; height: auto !important;">
		         
		        
		        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#dangerLogTable', 'danger-log-list')"
		                style="float: none !important; margin: 0 !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; white-space: nowrap !important; box-sizing: border-box !important; height: 36px !important; padding: 0 16px !important; line-height: 1 !important; border-radius: 6px !important;">
		            <i class="fa-solid fa-file-csv" style="font-size: 14px; margin: 0 !important; padding: 0 !important;"></i> CSV
		        </button>
		    </div>
		</div>
        
        
        <table id="dangerLogTable" data-csv-export data-csv-filename="danger-log-list">
            <thead>
                <tr>
                    <th style="width: 80px;">로그번호</th>
                    <th style="width: 90px;">스냅샷</th>
                    <th style="width: 120px;">드론 기체 ID</th>
                    <th style="width: 150px;">이상 객체</th>
                    <th style="width: 180px;">탐지 시각</th>
                    <th style="width: 100px;">조치 상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty dangerLogList}">
                        <tr>
                            
                            <td colspan="6" class="no-data">포착된 실시간 이상 객체 탐지 이력이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="log" items="${dangerLogList}">
                            
                            <tr style="cursor: pointer;"
                                onclick="return openDetailPopup('${pageContext.request.contextPath}/dangerlog/detail?danlogId=${log.danlogId}&page=${pageMaker.page}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}', 'dangerLogDetail');">
                                
                                
                                <td style="font-weight: bold;">${log.danlogId}</td>
                                
                                
                                <td>
                                    <img src="${pageContext.request.contextPath}/dangerlog/getDangerSnapshot?danlogId=${log.danlogId}" 
                                         alt="탐지 스냅샷" 
                                         class="mini-snapshot"
                                         onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';" />
                                </td>
                                
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${empty log.droneId}">
                                            <span class="badge-status badge-none">미배정</span>
                                        </c:when>
                                        <c:otherwise>${log.droneId}</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                
                                <td style="color: #ffffff; font-weight: bold;"><c:out value="${log.dangerName}" /></td>
                                
                                
                                <td><fmt:formatDate value="${log.dangerTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                
                                
                                <td>
                <span class="badge-status badge-none"><c:out value="${empty actionStatusNames[log.dactionStatus] ? log.dactionStatus : actionStatusNames[log.dactionStatus]}" /></span>
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
                    <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이상 객체</option>
                    <option value="d" ${pageMaker.searchType == 'd' ? 'selected' : ''}>드론 기체 ID</option>
                    <option value="s" ${pageMaker.searchType == 's' ? 'selected' : ''}>조치 상태</option>
                </select>
                <select name="keyword" id="dangerActionStatusKeyword" ${pageMaker.searchType == 's' ? '' : 'disabled'}>
                    <option value="">전체 조치상태</option>
                    <c:forEach var="actionStatus" items="${actionStatusNames}">
                        <option value="${actionStatus.key}" ${pageMaker.keyword == actionStatus.key ? 'selected' : ''}>${actionStatus.value}</option>
                    </c:forEach>
                </select>
                <input type="text" name="keyword" id="dangerLogTextKeyword" value="${pageMaker.searchType == 's' ? '' : pageMaker.keyword}" placeholder="검색어 입력" ${pageMaker.searchType == 's' ? 'disabled' : ''}>
                <button type="submit" class="btn-search">검색</button>
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
    var isActionStatus = this.value === 's';
    document.getElementById('dangerActionStatusKeyword').disabled = !isActionStatus;
    document.getElementById('dangerLogTextKeyword').disabled = isActionStatus;
});
</script>
</html>

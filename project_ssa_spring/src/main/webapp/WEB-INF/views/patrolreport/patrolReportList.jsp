<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>일일 업무 보고서 관제 인프라</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}


.patrol-list-content {
    position: absolute !important;
    top: 80px !important; 
    left: 150px !important; 
    width: calc(100% - 150px) !important; 
    padding: 30px 40px;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    .patrol-list-content {
        left: 0 !important;
        width: 100% !important;
        padding: 20px 16px;
    }
}


.main-panel {
    background: transparent !important;
    border: 0 !important;
    border-radius: 0 !important;
    padding: 0 !important;
    box-shadow: none !important;
    width: 100%;
    box-sizing: border-box;
}


.staff-top-bar { 
    display: flex; 
    justify-content: flex-start; 
    align-items: center; 
    margin-bottom: 20px; 
    padding-bottom: 16px; 
    border-bottom: 1px solid #1e293b; 
}

.staff-top-bar h2 { 
    margin: 0 !important; 
    color: #fff !important; 
    font-size: 22px !important; 
    font-weight: 700 !important; 
    letter-spacing: -.02em; 
}


.staff-summary-bar { 
    display: flex; 
    justify-content: space-between; 
    align-items: center; 
    margin-bottom: 20px; 
}

.staff-count { 
    color: #94a3b8; 
    font-size: 14px; 
    font-weight: 500; 
}

.count-num { 
    color: #38bdf8; 
    background: rgba(56, 189, 248, .1); 
    border-radius: 4px; 
    padding: 2px 6px; 
    font-weight: 700; 
}

.staff-table-wrapper { 
    overflow-x: auto; 
    overflow-y: hidden; 
    width: 100%;
}


.table-zone {
    min-width: 850px;
    width: 100%;
    border-collapse: separate !important;
    border-spacing: 0 !important;
    margin: 0;
    background-color: transparent !important;
    box-shadow: none !important;
    border: 1px solid #1e293b !important;
    border-radius: 8px;
    overflow: hidden;
}

.table-zone th {
    white-space: nowrap;
    background-color: #111827 !important; 
    color: #38bdf8 !important; 
    padding: 14px 16px !important;
    border: 0 !important;
    border-bottom: 2px solid #1e293b !important;
    font-size: 13px;
    font-weight: 700;
    text-align: center !important; 
}

.table-zone td {
    white-space: nowrap;
    padding: 12px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    text-align: center !important;
    font-size: 13.5px;
}


.table-zone tbody tr {
    transition: background-color 0s ease;
    cursor: pointer;
}

.table-zone tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}


.btn-create {
    background-color: #10b981 !important; 
    color: white !important;
    border: none !important;
    padding: 10px 18px !important;
    border-radius: 8px !important;
    cursor: pointer;
    font-size: 13.5px;
    font-weight: 700;
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
    transition: all 0.15s ease;
}

.btn-create:hover {
    background-color: #059669 !important;
    box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
    transform: translateY(-1px);
}

.btn-create:active {
    transform: translateY(0);
}


.badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important; 
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}

.badge-0 {
    background-color: rgba(245, 158, 11, 0.15) !important;
    color: #f59e0b !important;
    border: 1px solid rgba(245, 158, 11, 0.3) !important;
} 

.badge-1 {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
} 

.badge-2 {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
} 


.pagination {
    display: flex;
    justify-content: center;
    gap: 6px;
    list-style: none;
    padding: 0;
    margin: 25px 0 0 0 !important;
}

.pagination li {
    margin: 0 !important;
}

.pagination li a, .pagination li strong {
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

.pagination li a:hover {
    color: #ffffff !important;
    background: #1f2937 !important;
    border-color: #334155;
}

.pagination li.active strong, .pagination li strong {
    color: #38bdf8 !important; 
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}

@media (max-width:760px) { 
    .staff-summary-bar { 
        align-items: stretch; 
        flex-direction: column; 
        gap: 10px;
    } 
    .btn-create { 
        align-self: flex-end; 
    } 
}


</style>

</head>
<body>

<jsp:include page="/WEB-INF/views/menu.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<div id="patrolReportListPage" class="patrol-list-content">
    <div class="main-panel">
        
        
        <div class="staff-top-bar">
            <h2>일일 관제 업무 보고서 목록</h2>
        </div>
        
		
		<div class="staff-summary-bar"
		     style="display: flex !important; justify-content: space-between !important; align-items: center !important; width: 100% !important; box-sizing: border-box !important; grid-column: 1 / -1 !important;">
		     
		    
            <div class="staff-count">
                총 보고서: <span class="count-num">${pageMaker.totalCount}</span>건
            </div>
		    
		    
		    <div class="summary-action-group" style="display: flex !important; gap: 8px !important; align-items: center !important; float: none !important; margin: 0 !important;">
		        <button class="csv-download-btn neon-theme"
		                onclick="downloadTableAsCsv('#patrolReportTable', 'patrol-report-list')"
		                style="float: none !important; margin: 0 !important; display: inline-flex !important; white-space: nowrap !important;">
		            <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i> CSV
		        </button>
                <button type="button" class="btn-create" onclick="return openFormPopup('${pageContext.request.contextPath}/patrolreport/register', 'patrolReportRegister');">
                    새 보고서 작성
                </button>
		    </div>
		</div>
        
        <div class="staff-table-wrapper">
        <table id="patrolReportTable" class="table-zone" data-csv-export data-csv-filename="patrol-report-list">
                <thead>
                    <tr>
                        <th>보고서 번호</th>
                        <th>업무 일자</th>
                        <th>작성 사번</th>
                        <th>비행시간</th>
                        <th>탐지건수</th>
                        <th>조치완료율</th>
                        <th>확정 여부</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty reportList}">
                            <tr>
                                <td colspan="7" style="color: #64748b; padding: 60px; font-size: 14px;">생성된 일일 업무 보고서 레코드가 존재하지 않습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="report" items="${reportList}">
                                
                                <tr onclick="return openDetailPopup('${pageContext.request.contextPath}/patrolreport/detail/${report.reportId}', 'patrolReportDetail');">
                                    <td><strong>${report.reportId}</strong></td>
                                    <td><fmt:formatDate value="${report.reportDate}" pattern="yyyy-MM-dd" /></td>
                                    <td><span style="color: #38bdf8; font-weight: 600;">${report.memberId}</span></td>
                                    <td>${report.totalFlightTime}시간</td>
                                    <td>${report.totalDetectCount}건</td>
                                    <td>${report.completionRate}%</td>
                                    <td>
                                        
                                        <c:choose>
                                            <c:when test="${report.confirmStatus eq '0'}">
                                                <span class="badge-status badge-0">승인 대기</span>
                                            </c:when>
                                            <c:when test="${report.confirmStatus eq '1'}">
                                                <span class="badge-status badge-1">승인 완료</span>
                                            </c:when>
                                            <c:when test="${report.confirmStatus eq '2'}">
                                                <span class="badge-status badge-2">반려</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status" style="background: #334155; color: #94a3b8;">미정</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        
        <c:if test="${pageMaker.totalCount gt 0}">
            <div class="text-center">
                <ul class="pagination">
                    <c:if test="${pageMaker.prev}">
                        <li>
                            <a href="${pageContext.request.contextPath}/patrolreport/list?page=${pageMaker.startPage - 1}">&laquo; 이전</a>
                        </li>
                    </c:if>
                    
                    <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                        <li class="${pageMaker.page eq pageNum ? 'active' : ''}">
                            <c:choose>
                                <c:when test="${pageMaker.page eq pageNum}">
                                    <strong>${pageNum}</strong>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/patrolreport/list?page=${pageNum}">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${pageMaker.next}">
                        <li>
                            <a href="${pageContext.request.contextPath}/patrolreport/list?page=${pageMaker.endPage + 1}">다음 &raquo;</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </c:if>
        
    </div>
</div>
</body>
</html>

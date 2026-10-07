<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
<title>일일 업무 보고서 관제 인프라</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>

#patrolReportListPage.patrol-list-content {
    position: absolute !important;
    top: 80px !important; 
    padding: 30px 40px;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    #patrolReportListPage.patrol-list-content {
        padding: 20px 16px;
    }
}


#patrolReportListPage .main-panel {
    background: transparent !important;
    border: 0 !important;
    border-radius: 0 !important;
    padding: 0 !important;
    box-shadow: none !important;
    width: 100%;
    box-sizing: border-box;
}


#patrolReportListPage .staff-top-bar {
    display: flex; 
    justify-content: space-between;
    align-items: center; 
    margin-bottom: 20px; 
    padding-bottom: 16px; 
    border-bottom: 1px solid #1e293b; 
}

#patrolReportListPage .staff-top-bar h2 {
    margin: 0 !important; 
    color: #fff !important; 
    font-size: 22px !important; 
    font-weight: 700 !important; 
    letter-spacing: -.02em; 
}


#patrolReportListPage .staff-summary-bar {
    display: flex; 
    justify-content: space-between; 
    align-items: center; 
    margin-bottom: 20px; 
}

#patrolReportListPage .staff-count {
    color: #94a3b8; 
    font-size: 14px; 
    font-weight: 500; 
}

#patrolReportListPage .count-num {
    color: #38bdf8; 
    background: rgba(56, 189, 248, .1); 
    border-radius: 4px; 
    padding: 2px 6px; 
    font-weight: 700; 
}

#patrolReportListPage .report-search-form {
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

#patrolReportListPage .report-search-form select,
#patrolReportListPage .report-search-form input {
    height: 38px;
    border: 1px solid #334155;
    border-radius: 7px;
    background: #111827;
    color: #e2e8f0;
    font-size: 13px;
}

#patrolReportListPage .report-search-form select {
    min-width: 104px;
    padding: 0 9px;
}

#patrolReportListPage .report-search-form input {
    width: 180px;
    padding: 0 10px;
}

#patrolReportListPage .btn-search {
    height: 38px;
    padding: 0 13px;
    border: 1px solid #38bdf8;
    border-radius: 7px;
    background: #0ea5e9;
    color: #ffffff;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
}

#patrolReportListPage .btn-search:hover {
    background: #0284c7;
}

#patrolReportListPage .staff-table-wrapper {
    overflow-x: auto; 
    overflow-y: hidden; 
    width: 100%;
}


#patrolReportListPage .table-zone {
    min-width: 900px;
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

#patrolReportListPage .table-zone th {
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

#patrolReportListPage .table-zone td {
    white-space: nowrap;
    padding: 12px 16px !important;
    background-color: transparent !important;
    color: #cbd5e1 !important;
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    text-align: center !important;
    font-size: 13.5px;
}


#patrolReportListPage .table-zone tbody tr {
    transition: background-color 0s ease;
    cursor: pointer;
}

#patrolReportListPage .table-zone tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}


#patrolReportListPage .btn-create {
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

#patrolReportListPage .btn-create:hover {
    background-color: #059669 !important;
    box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
    transform: translateY(-1px);
}

#patrolReportListPage .btn-create:active {
    transform: translateY(0);
}


#patrolReportListPage .badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important; 
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}

#patrolReportListPage .badge-0 {
    background-color: rgba(245, 158, 11, 0.15) !important;
    color: #f59e0b !important;
    border: 1px solid rgba(245, 158, 11, 0.3) !important;
} 

#patrolReportListPage .badge-1 {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
} 

#patrolReportListPage .badge-2 {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
} 

#patrolReportListPage .confirmation-filter-header {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
}

#patrolReportListPage .confirm-filter-toggle {
    padding: 4px 8px;
    border: 1px solid #475569;
    border-radius: 6px;
    background: #172033;
    color: #cbd5e1;
    font-size: 11px;
    font-weight: 700;
    cursor: pointer;
}

#patrolReportListPage .confirm-filter-toggle:hover,
#patrolReportListPage .confirm-filter-toggle[aria-expanded="true"] {
    border-color: #38bdf8;
    background: #0f3146;
    color: #7dd3fc;
}

#patrolReportConfirmFilterMenu[hidden] {
    display: none;
}

#patrolReportConfirmFilterMenu {
    position: fixed;
    min-width: 174px;
    padding: 8px;
    border: 1px solid #334155;
    border-radius: 8px;
    background: #111827;
    box-shadow: 0 12px 28px rgba(0, 0, 0, .42);
    z-index: 10050;
}

#patrolReportConfirmFilterMenu .filter-menu-caption {
    display: block;
    padding: 5px 7px 8px;
    color: #94a3b8;
    font-size: 11px;
}

#patrolReportConfirmFilterMenu button {
    display: block;
    width: 100%;
    padding: 8px 9px;
    border: 0;
    border-radius: 5px;
    background: transparent;
    color: #cbd5e1;
    font-size: 12px;
    font-weight: 700;
    text-align: left;
    cursor: pointer;
}

#patrolReportConfirmFilterMenu button:hover,
#patrolReportConfirmFilterMenu button.is-active {
    background: #0f3146;
    color: #7dd3fc;
}


#patrolReportListPage .pagination {
    display: flex;
    justify-content: center;
    gap: 6px;
    list-style: none;
    padding: 0;
    margin: 25px 0 0 0 !important;
}

#patrolReportListPage .pagination li {
    margin: 0 !important;
}

#patrolReportListPage .pagination li a, #patrolReportListPage .pagination li strong {
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

#patrolReportListPage .pagination li a:hover {
    color: #ffffff !important;
    background: #1f2937 !important;
    border-color: #334155;
}

#patrolReportListPage .pagination li.active strong, #patrolReportListPage .pagination li strong {
    color: #38bdf8 !important; 
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}

@media (max-width:760px) { 
    #patrolReportListPage .staff-top-bar {
        align-items: stretch;
        flex-direction: column;
        gap: 10px;
    }
    #patrolReportListPage .staff-summary-bar {
        align-items: stretch; 
        flex-direction: column; 
        gap: 10px;
    } 
    #patrolReportListPage .btn-create {
        align-self: flex-end; 
    } 
    #patrolReportListPage .summary-action-group {
        width: 100%;
        flex-wrap: wrap;
        justify-content: flex-end;
    }
    #patrolReportListPage .report-search-form {
        width: 100%;
    }
    #patrolReportListPage .report-search-form input {
        flex: 1;
        width: auto;
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
            <form class="report-search-form" method="get" action="${pageContext.request.contextPath}/patrolreport/list">
                <input type="hidden" name="confirmStatus" value="<c:out value='${pageMaker.confirmStatus}'/>" />
                <select name="searchType" aria-label="검색 기준">
                    <option value="r" ${pageMaker.searchType eq 'r' ? 'selected' : ''}>보고서 번호</option>
                    <option value="m" ${pageMaker.searchType eq 'm' ? 'selected' : ''}>작성 사번</option>
                    <option value="d" ${pageMaker.searchType eq 'd' ? 'selected' : ''}>업무 일자</option>
                </select>
                <input type="search" name="keyword" value="<c:out value='${pageMaker.keyword}'/>" placeholder="검색어 입력" aria-label="검색어" />
                <button type="submit" class="btn-search">검색</button>
            </form>
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
                        <th>
                            <div class="confirmation-filter-header">
                                <span>승인 여부</span>
                                <button type="button" id="patrolReportConfirmFilterButton" class="confirm-filter-toggle"
                                    aria-expanded="false" aria-controls="patrolReportConfirmFilterMenu">승인 필터</button>
                            </div>
                        </th>
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
                                        <c:forEach var="confirmStatus" items="${confirmStatusList}">
                                            <c:if test="${report.confirmStatus eq confirmStatus.code}">
                                                <span class="badge-status badge-${confirmStatus.code}">${confirmStatus.codeName}</span>
                                            </c:if>
                                        </c:forEach>
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
                            <a href="${pageContext.request.contextPath}/patrolreport/list?page=${pageMaker.startPage - 1}&amp;searchType=${pageMaker.searchType}&amp;keyword=<c:out value='${pageMaker.keyword}'/>&amp;confirmStatus=<c:out value='${pageMaker.confirmStatus}'/>">&laquo; 이전</a>
                        </li>
                    </c:if>
                    
                    <c:forEach var="pageNum" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                        <li class="${pageMaker.page eq pageNum ? 'active' : ''}">
                            <c:choose>
                                <c:when test="${pageMaker.page eq pageNum}">
                                    <strong>${pageNum}</strong>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/patrolreport/list?page=${pageNum}&amp;searchType=${pageMaker.searchType}&amp;keyword=<c:out value='${pageMaker.keyword}'/>&amp;confirmStatus=<c:out value='${pageMaker.confirmStatus}'/>">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${pageMaker.next}">
                        <li>
                            <a href="${pageContext.request.contextPath}/patrolreport/list?page=${pageMaker.endPage + 1}&amp;searchType=${pageMaker.searchType}&amp;keyword=<c:out value='${pageMaker.keyword}'/>&amp;confirmStatus=<c:out value='${pageMaker.confirmStatus}'/>">다음 &raquo;</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </c:if>
        
    </div>
</div>

<div id="patrolReportConfirmFilterMenu" hidden="hidden" role="menu" aria-label="승인 상태 필터">
    <span class="filter-menu-caption">승인 상태</span>
    <button type="button" role="menuitem" class="${empty pageMaker.confirmStatus ? 'is-active' : ''}" data-confirm-status="">전체</button>
    <c:forEach var="confirmStatus" items="${confirmStatusList}">
        <button type="button" role="menuitem" class="${pageMaker.confirmStatus eq confirmStatus.code ? 'is-active' : ''}" data-confirm-status="${confirmStatus.code}">${confirmStatus.codeName}</button>
    </c:forEach>
</div>

<script>
(function () {
    var filterButton = document.getElementById('patrolReportConfirmFilterButton');
    var filterMenu = document.getElementById('patrolReportConfirmFilterMenu');

    function closeFilterMenu() {
        filterMenu.hidden = true;
        filterButton.setAttribute('aria-expanded', 'false');
    }

    function openFilterMenu() {
        filterMenu.hidden = false;
        var buttonRect = filterButton.getBoundingClientRect();
        var left = Math.min(buttonRect.left, window.innerWidth - filterMenu.offsetWidth - 12);
        filterMenu.style.top = (buttonRect.bottom + 6) + 'px';
        filterMenu.style.left = Math.max(12, left) + 'px';
        filterButton.setAttribute('aria-expanded', 'true');
    }

    filterButton.addEventListener('click', function () {
        if (filterMenu.hidden) {
            openFilterMenu();
        } else {
            closeFilterMenu();
        }
    });

    filterMenu.addEventListener('click', function (event) {
        var option = event.target.closest('button[data-confirm-status]');
        if (!option) {
            return;
        }
        var url = new URL(window.location.href);
        url.searchParams.set('page', '1');
        if (option.dataset.confirmStatus) {
            url.searchParams.set('confirmStatus', option.dataset.confirmStatus);
        } else {
            url.searchParams.delete('confirmStatus');
        }
        window.location.assign(url.toString());
    });

    document.addEventListener('click', function (event) {
        if (!filterMenu.hidden && !filterMenu.contains(event.target) && !filterButton.contains(event.target)) {
            closeFilterMenu();
        }
    });

    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && !filterMenu.hidden) {
            closeFilterMenu();
            filterButton.focus();
        }
    });
}());
</script>
</body>
</html>

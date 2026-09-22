<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>직원관리</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/style.css">
<style>

body {
    background-color: #0b0f19 !important; 
    color: #e2e8f0 !important;
    font-family: 'Pretendard', -apple-system, 'Segoe UI', Roboto, sans-serif;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}

.main-container {
    display: block !important; 
    margin-top: 0 !important;
}

#menu-placeholder {
    display: none !important;
    width: 0 !important;
}

.content-area {
    position: absolute !important;
    top: 80px !important; 
    left: 200px !important; 
    width: calc(100% - 200px) !important; 
    padding: 30px 40px !important;
    background: transparent !important;
    box-sizing: border-box;
    z-index: 50 !important;
}

@media (max-width: 760px) {
    .content-area {
        left: 0 !important;
        width: 100% !important;
        padding: 20px 16px !important;
    }
}


.staff-top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    gap: 16px;
    width: 100%;
    border-bottom: 1px solid #1e293b;
    padding-bottom: 16px;
}

.staff-top-bar .page-title {
    margin: 0;
    color: #ffffff !important;
    font-size: 22px;
    font-weight: 700;
    letter-spacing: -0.02em;
}

.staff-summary-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    width: 100%;
}


.search-group form {
    display: flex;
    gap: 6px;
    align-items: center;
}

.search-group select {
    padding: 9px 12px !important;
    background-color: #111827 !important;
    color: #ffffff !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important;
    font-size: 13.5px;
    outline: none;
    transition: border-color 0.15s ease;
}

.search-group .search-input {
    width: 240px !important; 
    padding: 9px 16px !important;
    background: #111827 !important;
    border: 1px solid #334155 !important;
    border-radius: 8px !important; 
    color: #ffffff !important;
    font-size: 13.5px;
    outline: none;
    transition: all 0.15s ease;
}

.search-group .search-input:focus, .search-group select:focus {
    border-color: #0ea5e9 !important;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.25);
}


.staff-count {
    color: #94a3b8 !important;
    font-size: 14px;
    font-weight: 500;
}

.staff-count .count-num {
    color: #38bdf8 !important; 
    font-weight: 700;
    background: rgba(56, 189, 248, 0.1);
    padding: 2px 6px;
    border-radius: 4px;
}


.staff-register-btn {
    padding: 9px 18px !important;
    border: 0 !important;
    border-radius: 8px !important;
    background: #10b981 !important; 
    color: #ffffff !important;
    font-weight: 700;
    font-size: 13.5px;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
    transition: all 0.15s ease;
}

.staff-register-btn:hover {
    background: #059669 !important;
    box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
    transform: translateY(-1px);
}


.staff-table-wrapper {
    overflow-x: auto;
    overflow-y: hidden;
    width: 100%;
}

.staff-table {
    width: 100%;
    min-width: 850px;
    border-collapse: separate !important;
    border-spacing: 0 !important;
    background-color: transparent !important;
    box-shadow: none !important;
    border: 1px solid #1e293b !important;
    border-radius: 8px;
    overflow: hidden;
}

.staff-table th {
    white-space: nowrap;
    padding: 14px 16px !important;
    background: #111827 !important; 
    border: 0 !important;
    border-bottom: 2px solid #1e293b !important;
    color: #38bdf8 !important; 
    font-size: 13px;
    font-weight: 700;
    text-align: center !important; 
}

.staff-table td {
    padding: 12px 16px !important;
    /* Keep the list rows flush with the page, like flightHistoryList. */
    background-color: #0b0f19 !important;
    border: 0 !important;
    border-bottom: 1px solid #1e293b !important;
    color: #cbd5e1 !important;
    font-size: 13.5px;
    text-align: center !important;
    vertical-align: middle !important;
    white-space: nowrap;
}


.staff-table tbody tr {
    cursor: pointer;
    transition: background-color 0s ease;
}

.staff-table tbody tr:hover td {
    background-color: rgba(30, 41, 59, 0.6) !important;
    color: #ffffff !important;
}


.badge-status {
    padding: 4px 12px !important;
    border-radius: 20px !important; 
    font-size: 11.5px !important;
    font-weight: 700 !important;
    display: inline-block;
}

.status-online {
    background-color: rgba(16, 185, 129, 0.15) !important;
    color: #10b981 !important;
    border: 1px solid rgba(16, 185, 129, 0.3) !important;
} 

.status-stop {
    background-color: rgba(239, 68, 68, 0.15) !important;
    color: #ef4444 !important;
    border: 1px solid rgba(239, 68, 68, 0.3) !important;
} 

.status-dormant {
    background-color: rgba(148, 163, 184, 0.15) !important;
    color: #94a3b8 !important;
    border: 1px solid rgba(148, 163, 184, 0.3) !important;
} 


.pagination {
    display: flex;
    list-style: none;
    padding-left: 0;
    gap: 6px;
    margin: 0;
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


.pagination li.active strong {
    color: #38bdf8 !important;
    background: rgba(14, 165, 233, 0.15) !important;
    border-color: #0ea5e9 !important;
}


</style>

</head>
<body>


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/menu.jsp" />

<div id="memberListPage" class="main-container">
    
    <main class="content-area">
        
        
        <div class="staff-top-bar">
            <h2 class="page-title">직원관리</h2>
            
            <div class="search-group">
                <form action="list" method="get" id="searchForm">
                    <select name="searchType">
                        <option value="t" ${pageMaker.searchType == 't' ? 'selected' : ''}>이름</option>
                        <option value="c" ${pageMaker.searchType == 'c' ? 'selected' : ''}>사번</option>
                    </select> 
                    <input type="text" name="keyword" class="search-input" value="${pageMaker.keyword}" placeholder="검색어 입력 후 엔터">
                </form>
            </div>
        </div>
        
        
		
		<div class="staff-summary-bar" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
		    <div class="staff-count">
		        총 직원수: <span class="count-num">${empty memberList ? 0 : memberList.size()}</span>명
		    </div>
		    
		    <div class="summary-action-group" style="display: flex; gap: 8px; align-items: center;">
   	 		<button class="csv-download-btn neon-theme" onclick="downloadTableAsCsv('#memberTable', 'member-list')">
			        <i class="fa-solid fa-file-csv" style="font-size: 14px;"></i>
			        CSV
			    </button>
		        <button type="button" class="staff-register-btn" onclick="return openFormPopup('${pageContext.request.contextPath}/member/registForm', 'memberRegister');">계정 등록</button>
		    </div>
		</div>
        
        <div class="staff-table-wrapper">
            <table id="memberTable" class="staff-table" data-csv-export data-csv-filename="member-list">
                <thead>
                    <tr>
                        <th style="width: 80px;">사진</th>
                        <th>사원번호</th>
                        <th>이름</th>
                        <th>소속(부서)</th>
                        <th>이메일 주소</th>
                        <th>휴대전화 번호</th> 
                        <th>가입일</th>
                        <th style="width: 110px;">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty memberList}">
                            <tr>
                                <td colspan="8" style="color: #64748b; padding: 60px; font-size: 14px;">등록된 직원이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="member" items="${memberList}">
                                <tr onclick="return openDetailPopup('${pageContext.request.contextPath}/member/detail?memberId=${member.memberId}', 'memberDetail');">
                                    
                                    <td style="padding: 6px;">
                                        <img src="${pageContext.request.contextPath}/member/getPicture?id=${member.memberId}" alt="미니프로필" class="mini-profile"
                                             onerror="this.src='${pageContext.request.contextPath}/resources/images/member/noImage.jpg';"
                                             style="width: 35px; height: 35px; border-radius: 50%; border: 1px solid #1e293b; object-fit: cover; vertical-align: middle;" />
                                    </td>
                                    
                                    <td style="color: #38bdf8; font-weight: 600;">${member.memberId}</td>
                                    <td><strong>${member.name}</strong></td>
                                    <td>${member.department}</td>
                                    <td>${member.email}</td>
                                    <td>${member.phone}</td>
                                    <td><fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${member.status == '0'}">
                                                <span class="badge-status status-online">정상</span>
                                            </c:when>
                                            <c:when test="${member.status == '1'}">
                                                <span class="badge-status status-stop">정지</span>
                                            </c:when>
                                            <c:when test="${member.status == '2'}">
                                                <span class="badge-status status-dormant">휴면</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status" style="background: #334155; color: #94a3b8;">${member.status}</span>
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
        
        
        <div class="text-center" style="margin-top: 25px; display: flex; justify-content: center; width: 100%;">
            <ul class="pagination">
                <c:if test="${pageMaker.prev}">
                    <li><a href="list?page=${pageMaker.startPage - 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">&laquo; 이전</a></li>
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
                    <li><a href="list?page=${pageMaker.endPage + 1}&searchType=${pageMaker.searchType}&keyword=${pageMaker.keyword}">다음 &raquo;</a></li>
                </c:if>
            </ul>
        </div>
        
    </main>
</div>


<script>
 const contextPath = '<%=request.getContextPath()%>';
</script>
<script src="${pageContext.request.contextPath}/resources/js/jquery-1.12.3.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
</body>
</html>


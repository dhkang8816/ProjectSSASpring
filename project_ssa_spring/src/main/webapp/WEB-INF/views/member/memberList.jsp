<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="icon" type="image/png" href="<c:url value='/resources/images/KakaoTalk_20260923_120441893.png?v=1'/>">
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

#memberListPage .search-group .btn-search {
    padding: 9px 16px;
    border: 0;
    border-radius: 8px;
    background: #0ea5e9;
    color: #ffffff;
    font-size: 13.5px;
    font-weight: 700;
    cursor: pointer;
    transition: background-color 0.15s ease;
}

#memberListPage .search-group .btn-search:hover {
    background: #0284c7;
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
    min-width: 1080px;
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

#memberListPage .account-cell {
    cursor: default;
}

#memberListPage .account-select {
    min-width: 92px;
    padding: 6px 28px 6px 9px;
    color: #cbd5e1;
    background: #111827;
    border: 1px solid #334155;
    border-radius: 6px;
    font-size: 12px;
    font-weight: 700;
    outline: none;
}

#memberListPage .account-select:focus {
    border-color: #38bdf8;
    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.16);
}

#memberListPage .account-status-select[data-status="0"] { color: #34d399; }
#memberListPage .account-status-select[data-status="1"] { color: #fb7185; }
#memberListPage .account-status-select[data-status="2"] { color: #94a3b8; }

#memberListPage .account-role-control {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
}

#memberListPage .account-save-btn {
    padding: 6px 9px;
    color: #ffffff;
    background: #0ea5e9;
    border: 1px solid #38bdf8;
    border-radius: 6px;
    font-size: 11px;
    font-weight: 700;
    cursor: pointer;
}

#memberListPage .account-save-btn:hover:not(:disabled) {
    background: #0284c7;
}

#memberListPage .account-save-btn:disabled {
    color: #64748b;
    background: #1e293b;
    border-color: #334155;
    cursor: not-allowed;
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
					<input type="text" name="keyword" class="search-input" value="${pageMaker.keyword}" placeholder="검색어 입력">
					<button type="submit" class="btn-search">검색</button>
                </form>
            </div>
        </div>
        
        
		
		<div class="staff-summary-bar" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
		    <div class="staff-count">
		        총 직원수: <span class="count-num">${pageMaker.totalCount}</span>명
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
                        <th style="width: 190px;">권한</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty memberList}">
                            <tr>
                                <td colspan="9" style="color: #64748b; padding: 60px; font-size: 14px;">등록된 직원이 없습니다.</td>
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
                                    <c:set var="isMyAccount" value="${member.memberId eq currentMemberId}" />
                                    <td class="account-cell" onclick="event.stopPropagation();">
                                        <select class="account-select account-status-select"
                                            data-original="${member.status}" data-status="${member.status}"
                                            aria-label="${member.memberId} 계정 상태"
                                            <c:if test="${isMyAccount}">disabled="disabled" title="본인 계정 상태는 목록에서 변경할 수 없습니다."</c:if>>
                                            <c:forEach var="statusCode" items="${statusList}">
                                                <option value="${statusCode.code}" ${statusCode.code eq member.status ? 'selected' : ''}>${statusCode.codeName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td class="account-cell" onclick="event.stopPropagation();">
                                        <div class="account-role-control">
                                            <select class="account-select account-role-select"
                                                data-original="${member.role}" aria-label="${member.memberId} 권한"
                                                <c:if test="${isMyAccount}">disabled="disabled" title="본인 권한은 목록에서 변경할 수 없습니다."</c:if>>
                                                <c:forEach var="roleCode" items="${roleList}">
                                                    <option value="${roleCode.code}" ${roleCode.code eq member.role ? 'selected' : ''}>${roleCode.codeName}</option>
                                                </c:forEach>
                                            </select>
                                            <button type="button" class="account-save-btn" disabled="disabled"
                                                data-member-id="${member.memberId}"
                                                <c:if test="${isMyAccount}">title="본인 계정은 목록에서 변경할 수 없습니다."</c:if>>저장</button>
                                        </div>
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
<script>
(function () {
    function syncAccountSaveState(row) {
        var statusSelect = row.querySelector('.account-status-select');
        var roleSelect = row.querySelector('.account-role-select');
        var saveButton = row.querySelector('.account-save-btn');
        if (!statusSelect || !roleSelect || !saveButton) {
            return;
        }

        statusSelect.dataset.status = statusSelect.value;
        var hasChanges = statusSelect.value !== statusSelect.dataset.original
                || roleSelect.value !== roleSelect.dataset.original;
        saveButton.disabled = statusSelect.disabled || roleSelect.disabled || !hasChanges;
    }

    document.querySelectorAll('#memberListPage .account-select').forEach(function (select) {
        select.addEventListener('click', function (event) {
            event.stopPropagation();
        });
        select.addEventListener('change', function (event) {
            event.stopPropagation();
            syncAccountSaveState(select.closest('tr'));
        });
    });

    document.querySelectorAll('#memberListPage .account-save-btn').forEach(function (button) {
        button.addEventListener('click', async function (event) {
            event.stopPropagation();
            var row = button.closest('tr');
            var statusSelect = row.querySelector('.account-status-select');
            var roleSelect = row.querySelector('.account-role-select');
            var statusLabel = statusSelect.options[statusSelect.selectedIndex].text;
            var roleLabel = roleSelect.options[roleSelect.selectedIndex].text;

            if (!window.confirm('[' + button.dataset.memberId + '] 계정을 ' + statusLabel
                    + ' / ' + roleLabel + ' 권한으로 변경하시겠습니까?')) {
                return;
            }

            button.disabled = true;
            button.textContent = '저장 중';

            try {
                var response = await fetch(contextPath + '/member/admin/account', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                        'Accept': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: new URLSearchParams({
                        memberId: button.dataset.memberId,
                        status: statusSelect.value,
                        roleCode: roleSelect.value
                    }).toString()
                });
                var payload = await response.json().catch(function () { return {}; });
                if (!response.ok || !payload.success) {
                    throw new Error(payload.message || '계정 설정을 저장하지 못했습니다.');
                }

                statusSelect.dataset.original = statusSelect.value;
                roleSelect.dataset.original = roleSelect.value;
            } catch (error) {
                window.alert(error.message || '계정 설정을 저장하지 못했습니다.');
            } finally {
                button.textContent = '저장';
                syncAccountSaveState(row);
            }
        });
    });
})();
</script>
</body>
</html>


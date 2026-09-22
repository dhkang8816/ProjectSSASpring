document.addEventListener("DOMContentLoaded", function () {
    $(document).on('mouseenter', 'ul.menu>li', function(){
        $(this).find('.submenu').stop().slideDown(500);
    }).on('mouseleave', 'ul.menu>li', function(){
        $(this).find('.submenu').stop().slideUp(500);
    });
    let scrollTimer;
    $(window).on('scroll', function() {
        clearTimeout(scrollTimer);
        scrollTimer = setTimeout(function() {
            $('ul.menu>li').find('.submenu').stop().slideUp(500);
        }, 1000); 
    });
    const ul = document.querySelector("#Sothic ul");
    if (ul) { 
        setInterval(function () {
            const firstLi = ul.querySelector("li");
            if (!firstLi) return;
            
            firstLi.style.transition = "margin-left 0.5s ease";
            firstLi.style.marginLeft = "-25%";
            
            setTimeout(function () {
                firstLi.style.transition = "none";
                firstLi.style.marginLeft = "0";
                ul.appendChild(firstLi);
            }, 500);
        }, 3000);
    }
	$(document).ready(function() {
	    $('.staff-register-btn').on('click', function() {
	        $('#registerModal').css('display', 'flex').hide().fadeIn(200);
	        var today = new Date().toISOString().substring(0, 10);
	        $('#regDate').val(today);
	    });
	    $('#closeModalBtn').on('click', function() {
	        $('#registerModal').fadeOut(200);
	    });
	    $('#registerModal').on('click', function(e) {
	        if ($(e.target).is('#registerModal')) {
	            $('#registerModal').fadeOut(200);
	        }
	    });
	});
});
function downloadTableAsCsv(tableSelector, filename) {
    var table = document.querySelector(tableSelector);
    if (!table) {
        console.error("CSV로 변환할 테이블을 찾을 수 없습니다: " + tableSelector);
        return;
    }

    var rows = Array.prototype.slice.call(table.querySelectorAll('tr'));
    var csvRows = rows.map(function(row) {
        return Array.prototype.slice.call(row.querySelectorAll('th, td')).map(function(cell) {
            var value = (cell.innerText || cell.textContent || '')
                .replace(/\r?\n|\r/g, ' ')
                .replace(/\s{2,}/g, ' ')
                .trim()
                .replace(/"/g, '""');
            return '"' + value + '"';
        }).join(',');
    }).filter(function(row) { return row.length > 0; });

    if (csvRows.length < 2) {
        window.alert('다운로드할 목록 데이터가 없습니다.');
        return;
    }
    
    var finalFilename = filename || 'ssa-list';
    var blob = new Blob(['\ufeff' + csvRows.join('\r\n')], { type: 'text/csv;charset=utf-8;' });
    var link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = finalFilename + '-' + new Date().toISOString().slice(0, 10) + '.csv';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(link.href);
}
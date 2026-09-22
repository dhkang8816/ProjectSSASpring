package com.spring.cmd;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PageMaker {
	
	private String searchType = "";
	private String keyword = "";
	
	private int page = 1; // 페이지 번호
	private int perPageNum = 10; // 리스트 개수
	private int totalCount; // 전체 행의 개수
	private int displayPageNum = 10; // 한 페이지에 보여줄 페이지번호 개수
	
	private int startPage = 1; // 시작 페이지 번호
	private int endPage = 1; // 마지막 페이지 번호
	private int realEndPage; // 끝 페이지 번호
	private boolean prev; // 이전페이지 버튼 유무
	private boolean next; // 다음페이지 버튼 유무 
	
	private String searchGrpCode = "";
	private String searchKeyword = "";
	private String searchUseYn = "";
	
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
		calcData();
	}
	
	private void calcData() {
		endPage = (int) (Math.ceil(page / (double) displayPageNum) * displayPageNum);
		startPage = (endPage - displayPageNum) + 1;
		
		realEndPage = (int) (Math.ceil(totalCount / (double) perPageNum));

		if (startPage < 1) {
			startPage = 1;
		}
		if (endPage > realEndPage) {
			endPage = realEndPage;
		}

		prev = startPage == 1 ? false : true;
		next = endPage < realEndPage ? true : false;
	}
	
	public int getStartRow() {
		return (this.page - 1) * this.perPageNum+1;
	}
	
	public int getEndRow() {
	    return getStartRow() + this.perPageNum - 1;
	}
	
	
}

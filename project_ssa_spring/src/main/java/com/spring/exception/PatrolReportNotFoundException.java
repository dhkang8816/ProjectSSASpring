package com.spring.exception;

public class PatrolReportNotFoundException extends RuntimeException {

	private static final long serialVersionUID = 1L;
	
    private final Long reportId;

    public PatrolReportNotFoundException(Long reportId) {
        super("업무 보고서를 찾을 수 없습니다.");
        this.reportId = reportId;
    }

    public Long getReportId() {
        return reportId;
    }
}

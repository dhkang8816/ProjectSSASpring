package com.spring.exception;

public class DetectionNotFoundException extends RuntimeException {
	
	private static final long serialVersionUID = 1L;

    private final int detectionLogId;

    public DetectionNotFoundException(int detectionLogId) {
        super("탐지 정보를 찾을 수 없습니다.");
        this.detectionLogId = detectionLogId;
    }

    public int getDetectionLogId() {
        return detectionLogId;
    }
}

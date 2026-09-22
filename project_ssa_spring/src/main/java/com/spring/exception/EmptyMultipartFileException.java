package com.spring.exception;


public class EmptyMultipartFileException extends Exception {
    private static final long serialVersionUID = 1L;
    
    public EmptyMultipartFileException() {
        super("업로드된 멀티파트 파일 바이너리가 비어있거나 존재하지 않습니다.");
    }
}

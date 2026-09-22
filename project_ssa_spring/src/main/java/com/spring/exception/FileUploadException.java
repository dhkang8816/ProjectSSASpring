package com.spring.exception;

public class FileUploadException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    public FileUploadException(String message, Throwable cause) {
        super(message, cause);
    }
}

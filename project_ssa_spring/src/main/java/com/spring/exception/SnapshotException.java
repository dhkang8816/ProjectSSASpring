package com.spring.exception;

public class SnapshotException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    public SnapshotException(String message, Throwable cause) {
        super(message, cause);
    }
}

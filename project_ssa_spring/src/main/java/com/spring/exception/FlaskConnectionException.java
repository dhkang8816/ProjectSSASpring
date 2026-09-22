package com.spring.exception;

public class FlaskConnectionException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    public FlaskConnectionException(String message, Throwable cause) {
        super(message, cause);
    }
}

package com.spring.exception;

public class SensorUnavailableException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    public SensorUnavailableException(String message) {
        super(message);
    }
}

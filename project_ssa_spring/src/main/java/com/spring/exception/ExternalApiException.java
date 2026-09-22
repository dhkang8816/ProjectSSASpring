package com.spring.exception;

public class ExternalApiException extends RuntimeException {

	private static final long serialVersionUID = 1L;

    private final String serviceName;

    public ExternalApiException(String serviceName, String message, Throwable cause) {
        super(message, cause);
        this.serviceName = serviceName;
    }

    public String getServiceName() {
        return serviceName;
    }
}

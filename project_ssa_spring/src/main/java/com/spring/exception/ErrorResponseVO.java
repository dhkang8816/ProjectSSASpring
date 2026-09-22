package com.spring.exception;

public class ErrorResponseVO {

    private final boolean success = false;
    private final String code;
    private final String message;

    public ErrorResponseVO(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}

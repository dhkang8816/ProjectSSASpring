package com.spring.dto;

/** Immutable, non-sensitive result returned by the administrator diagnostics. */
public class DiagnosticResultVO {

    private final String id;
    private final String name;
    private final String status;
    private final String message;
    private final long responseTimeMs;
    private final String checkedAt;

    public DiagnosticResultVO(String id, String name, String status, String message,
            long responseTimeMs, String checkedAt) {
        this.id = id;
        this.name = name;
        this.status = status;
        this.message = message;
        this.responseTimeMs = responseTimeMs;
        this.checkedAt = checkedAt;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getStatus() {
        return status;
    }

    public String getMessage() {
        return message;
    }

    public long getResponseTimeMs() {
        return responseTimeMs;
    }

    public String getCheckedAt() {
        return checkedAt;
    }
}

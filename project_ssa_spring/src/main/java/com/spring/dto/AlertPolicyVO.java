package com.spring.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Persisted runtime policy used by the AI detector.
 *
 * Alert text and alert timing intentionally live in separate tables: changing
 * a message must not change the behaviour that creates the alert.
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AlertPolicyVO {

    private String policyKey;
    private double underTargetSeconds;
    private String updatedBy;
    private Timestamp updatedAt;
}

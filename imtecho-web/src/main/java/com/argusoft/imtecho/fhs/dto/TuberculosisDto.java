package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

/**
 * <p>
 * DTO for Tuberculosis Details.
 * </p>
 */
@Data
public class TuberculosisDto {

    private Integer memberId;
    private String tbSymptoms;
    private Boolean isTbCured;
}

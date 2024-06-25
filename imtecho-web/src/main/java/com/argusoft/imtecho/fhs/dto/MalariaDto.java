package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

/**
 * <p>
 * DTO for Malaria Details.
 * </p>
 */
@Data
public class MalariaDto {

    private Integer memberId;
    private String activeMalariaSymptoms;
    private String rdtTestStatus;
    private Boolean isTreatmentGiven;
    private String malariaType;

}

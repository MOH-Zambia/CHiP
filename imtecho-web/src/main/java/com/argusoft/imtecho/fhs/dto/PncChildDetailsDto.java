package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Date;

import java.util.Set;

/**
 * <p>
 * DTO for Postnatal Care (PNC) Child Details.
 * </p>
 */
@Data
public class PncChildDetailsDto {
    private Integer childId;
    private Boolean isAlive;
    private String otherDangerSign;
    private Float childWeight;
    private String memberStatus;
    private Date deathDate;
    private String deathReason;
    private String placeOfDeath;
    private Integer referralPlace;
    private String otherDeathReason;
    private Boolean isHighRiskCase;
    private String childReferralDone;
    private Set<Integer> childDangerSigns;

}

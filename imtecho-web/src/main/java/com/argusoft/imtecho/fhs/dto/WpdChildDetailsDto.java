package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Date;

/**
 * <p>
 * DTO for WPD Child Details.
 * </p>
 */
@Data
public class WpdChildDetailsDto {

    private Integer memberId;
    private Integer wpdMotherId;
    private String pregnancyOutcome;
    private Boolean kangarooCare;
    private Boolean breastCrawl;
    private Boolean wasPremature;
    private String name;
    private String typeOfDelivery;
    private String deathReason;
    private Boolean isHighRiskCase;

    private Date vitaminK1Date;
    private Boolean breastfeedingInHealthCenter;

    private Boolean babyBreatheAtBirth;
    private Boolean skinToSkin;

}

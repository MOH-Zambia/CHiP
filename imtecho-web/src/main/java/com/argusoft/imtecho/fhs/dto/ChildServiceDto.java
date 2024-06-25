package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Set;

/**
 * <p>
 * DTO for Child Service Details.
 * </p>
 */
@Data
public class ChildServiceDto {

    private Integer memberId;
    private Boolean isAlive;
    private String deathReason;
    private Float weight;
    private Boolean ifaSyrupGiven;
    private Boolean complementaryFeedingStarted;
    private String complementaryFeedingStartPeriod;
    private Set<Integer> dieseases;
    private String otherDiseases;
    private String isTreatementDone;
    private Integer height;
    private Boolean havePedalEdema;
    private Boolean exclusivelyBreastfeded;
    private Boolean anyVaccinationPending;
    private String sdScore;
    private String deliveryPlace;
    private String deliveryDoneBy;
    private Integer deliveryPerson;
    private String deliveryPersonName;

}

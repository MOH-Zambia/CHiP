package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Date;
import java.util.Set;

/**
 * <p>
 * DTO for Antenatal Care (ANC) Details.
 * </p>
 */
@Data
public class AncDto {

    private Integer memberId;
    private Date lmp;
    private String lastDeliveryOutcome;
    private Set<String> previousPregnancyComplication;
    private String otherPreviousPregnancyComplication;
    private Integer ancPlace;
    private Float weight;
    private Float haemoglobinCount;
    private Integer systolicBp;
    private Integer diastolicBp;
    private Integer memberHeight;
    private String foetalMovement;
    private Integer foetalHeight;
    private Boolean foetalHeartSound;
    private String foetalPosition;
    private Integer ifaTabletsGiven;
    private Integer faTabletsGiven;
    private Integer calciumTabletsGiven;
    private String hbsagTest;
    private String bloodSugarTest;
    private Integer sugarTestAfterFoodValue;
    private Integer sugarTestBeforeFoodValue;
    private Boolean urineTestDone;
    private String urineAlbumin;
    private String urineSugar;
    private String vdrlTest;
    private String sickleCellTest;
    private String hivTest;
    private Boolean albendazoleGiven;
    private Boolean mebendazole1Given;
    private Date mebendazole1Date;
    private Boolean mebendazole2Given;
    private Date mebendazole2Date;

}

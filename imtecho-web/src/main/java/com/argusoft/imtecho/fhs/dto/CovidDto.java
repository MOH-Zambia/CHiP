package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

/**
 * <p>
 * DTO for COVID-19 Details.
 * </p>
 */
@Data
public class CovidDto {

    private Integer memberId;
    private Boolean isDoseOneTaken;
    private String doseOneName;
    private Boolean isDoseTwoTaken;
    private String doseTwoName;
    private Boolean willingForBoosterVaccine;
    private Boolean isBoosterDoseGiven;
    private String boosterName;
    private Boolean anyReactions;

}

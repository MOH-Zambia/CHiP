package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

/**
 * <p>
 * DTO for HIV Screening Details.
 * </p>
 */
@Data
public class HivDto {

    private boolean childHivTest;
    private boolean hivTestResult;
    private boolean childMotherHivPositive;
    private boolean childHasTbSymptoms;
    private boolean childSick;
    private boolean childRashes;
    private boolean pusNearEar;
    private boolean everToldHivPositive;
    private boolean testedForHivIn12Months;
    private boolean symptoms;
    private boolean privatePartsSymptoms;
    private boolean exposedToHiv;
    private boolean unprotectedSexInLast6Months;
    private boolean pregnantOrBreastfeeding;

}

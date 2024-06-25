package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Date;

/**
 * <p>
 * DTO for WPD Mother Details.
 * </p>
 */
@Data
public class WpdMotherDetailsDto {

    private Date dateOfDelivery;
    private Boolean hasDeliveryHappened;
    private Boolean corticoSteroidGiven;
    private Boolean isPretermBirth;
    private String deliveryPlace;
    private String institutionalDeliveryPlace;
    private Integer typeOfHospital;
    private String deliveryDoneBy;
    private String typeOfDelivery;
    private Boolean motherAlive;
    private String otherDangerSigns;
    private Boolean isDischarged;
    private Date dischargeDate;
    private Boolean breastFeedingInOneHour;
    private Integer mtpDoneAt;
    private String mtpPerformedBy;
    private String deathReason;
    private Boolean isHighRiskCase;
    private Integer pregnancyRegDetId;
    private String pregnancyOutcome;
    private Boolean misoprostolGiven;
    private String freeDropDelivery;
    private Integer deliveryPerson;
    private String deliveryPersonName;
    private Boolean wasARTGiven;
    private String hivDuringDelivery;
    private Boolean isARTGivenDelivery;
    private String paymentType;

}

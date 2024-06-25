package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Date;

/**
 * <p>
 * DTO for Postnatal Care (PNC) Mother Details.
 * </p>
 */
@Data
public class PncMotherDetailsDto {
    private Integer motherId;
    private Date dateOfDelivery;
    private Date serviceDate;

    private Boolean isAlive;
    private Integer ifaTabletsGiven;
    private String otherDangerSign;
    private String deathReason;
    private Date fpInsertOperateDate;
    private String familyPlanningMethod;
    private Boolean isHighRiskCase;
    private Boolean bloodTransfusion;
    private String ironDefAnemiaInj;
    private Date ironDefAnemiaInjDueDate;
    private Boolean receivedMebendazole;

    private Date tetanus4Date;
    private Date tetanus5Date;
    private Boolean checkForBreastfeeding;
    private String paymentType;
}

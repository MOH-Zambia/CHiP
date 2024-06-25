/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.dto;

import java.util.Date;
import java.util.Set;

/**
 *
 * <p>
 *     Used for pnc mother.
 * </p>
 * @author akshar
 * @since 26/08/20 11:00 AM
 *
 */
public class PncMotherDto {

    private Integer motherId;
    private Date dateOfDelivery;
    private Date serviceDate;

    private Boolean isAlive;
    private Integer ifaTabletsGiven;
    private Integer calciumGiven;
    private String otherDangerSign;
    private Integer referralPlace;
    private String memberStatus;
    private Date deathDate;
    private String deathReason;
    private String placeOfDeath;
    private Date fpInsertOperateDate;
    private String familyPlanningMethod;
    private String otherDeathReason;
    private Boolean isHighRiskCase;
    private String motherReferralDone;
    private Set<Integer> motherDangerSigns;
    private Integer deathInfrastructureId;
    private Boolean bloodTransfusion;
    private String ironDefAnemiaInj;
    private Date ironDefAnemiaInjDueDate;
    private Integer referralInfraId;
    private Boolean receivedMebendazole;

    private Date tetanus1GivenDate;
    private Date tetanus2GivenDate;
    private Date tetanus3GivenDate;
    private Date tetanus4Date;
    private Date tetanus5Date;
    private Boolean checkForBreastfeeding;
    private String paymentType;
    private String remarks;

    public Date getTetanus1GivenDate() {
        return tetanus1GivenDate;
    }

    public void setTetanus1GivenDate(Date tetanus1GivenDate) {
        this.tetanus1GivenDate = tetanus1GivenDate;
    }

    public Date getTetanus2GivenDate() {
        return tetanus2GivenDate;
    }

    public void setTetanus2GivenDate(Date tetanus2GivenDate) {
        this.tetanus2GivenDate = tetanus2GivenDate;
    }

    public Date getTetanus3GivenDate() {
        return tetanus3GivenDate;
    }

    public void setTetanus3GivenDate(Date tetanus3GivenDate) {
        this.tetanus3GivenDate = tetanus3GivenDate;
    }



    public Integer getMotherId() {
        return motherId;
    }

    public void setMotherId(Integer motherId) {
        this.motherId = motherId;
    }

    public Date getDateOfDelivery() {
        return dateOfDelivery;
    }

    public void setDateOfDelivery(Date dateOfDelivery) {
        this.dateOfDelivery = dateOfDelivery;
    }

    public Date getServiceDate() {
        return serviceDate;
    }



    public void setServiceDate(Date serviceDate) {
        this.serviceDate = serviceDate;
    }



    public Boolean getIsAlive() {
        return isAlive;
    }

    public void setIsAlive(Boolean isAlive) {
        this.isAlive = isAlive;
    }

    public Integer getIfaTabletsGiven() {
        return ifaTabletsGiven;
    }

    public void setIfaTabletsGiven(Integer ifaTabletsGiven) {
        this.ifaTabletsGiven = ifaTabletsGiven;
    }

    public String getOtherDangerSign() {
        return otherDangerSign;
    }

    public void setOtherDangerSign(String otherDangerSign) {
        this.otherDangerSign = otherDangerSign;
    }

    public Integer getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(Integer referralPlace) {
        this.referralPlace = referralPlace;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public Date getDeathDate() {
        return deathDate;
    }

    public void setDeathDate(Date deathDate) {
        this.deathDate = deathDate;
    }

    public String getDeathReason() {
        return deathReason;
    }

    public void setDeathReason(String deathReason) {
        this.deathReason = deathReason;
    }

    public String getPlaceOfDeath() {
        return placeOfDeath;
    }

    public void setPlaceOfDeath(String placeOfDeath) {
        this.placeOfDeath = placeOfDeath;
    }

    public Date getFpInsertOperateDate() {
        return fpInsertOperateDate;
    }

    public void setFpInsertOperateDate(Date fpInsertOperateDate) {
        this.fpInsertOperateDate = fpInsertOperateDate;
    }

    public String getFamilyPlanningMethod() {
        return familyPlanningMethod;
    }

    public void setFamilyPlanningMethod(String familyPlanningMethod) {
        this.familyPlanningMethod = familyPlanningMethod;
    }

    public String getOtherDeathReason() {
        return otherDeathReason;
    }

    public void setOtherDeathReason(String otherDeathReason) {
        this.otherDeathReason = otherDeathReason;
    }

    public Boolean getIsHighRiskCase() {
        return isHighRiskCase;
    }

    public void setIsHighRiskCase(Boolean isHighRiskCase) {
        this.isHighRiskCase = isHighRiskCase;
    }

    public String getMotherReferralDone() {
        return motherReferralDone;
    }

    public void setMotherReferralDone(String motherReferralDone) {
        this.motherReferralDone = motherReferralDone;
    }

    public Set<Integer> getMotherDangerSigns() {
        return motherDangerSigns;
    }

    public void setMotherDangerSigns(Set<Integer> motherDangerSigns) {
        this.motherDangerSigns = motherDangerSigns;
    }

    public Integer getDeathInfrastructureId() {
        return deathInfrastructureId;
    }

    public void setDeathInfrastructureId(Integer deathInfrastructureId) {
        this.deathInfrastructureId = deathInfrastructureId;
    }

    public Boolean getBloodTransfusion() {
        return bloodTransfusion;
    }

    public void setBloodTransfusion(Boolean bloodTransfusion) {
        this.bloodTransfusion = bloodTransfusion;
    }

    public String getIronDefAnemiaInj() {
        return ironDefAnemiaInj;
    }

    public void setIronDefAnemiaInj(String ironDefAnemiaInj) {
        this.ironDefAnemiaInj = ironDefAnemiaInj;
    }

    public Date getIronDefAnemiaInjDueDate() {
        return ironDefAnemiaInjDueDate;
    }

    public void setIronDefAnemiaInjDueDate(Date ironDefAnemiaInjDueDate) {
        this.ironDefAnemiaInjDueDate = ironDefAnemiaInjDueDate;
    }

    public Integer getReferralInfraId() {
        return referralInfraId;
    }

    public void setReferralInfraId(Integer referralInfraId) {
        this.referralInfraId = referralInfraId;
    }

    public Integer getCalciumGiven() {
        return calciumGiven;
    }

    public void setCalciumGiven(Integer calciumGiven) {
        this.calciumGiven = calciumGiven;
    }

    public Boolean getReceivedMebendazole() {
        return receivedMebendazole;
    }

    public void setReceivedMebendazole(Boolean receivedMebendazole) {
        this.receivedMebendazole = receivedMebendazole;
    }

    public Date getTetanus4Date() {
        return tetanus4Date;
    }

    public void setTetanus4Date(Date tetanus4Date) {
        this.tetanus4Date = tetanus4Date;
    }

    public Date getTetanus5Date() {
        return tetanus5Date;
    }

    public void setTetanus5Date(Date tetanus5Date) {
        this.tetanus5Date = tetanus5Date;
    }

    public Boolean getCheckForBreastfeeding() {
        return checkForBreastfeeding;
    }

    public void setCheckForBreastfeeding(Boolean checkForBreastfeeding) {
        this.checkForBreastfeeding = checkForBreastfeeding;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }


}

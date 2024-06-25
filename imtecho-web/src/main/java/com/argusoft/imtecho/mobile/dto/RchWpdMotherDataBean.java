/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.dto;

/**
 *
 * @author prateek
 */
public class RchWpdMotherDataBean {
    
    private Integer id;
    
    private Integer memberId;
    
    private Integer familyId;
    
    private Integer locationId;
    
    private Integer serviceDate;
    
    private Long dateOfDelivery;
    
    private String typeOfDelivery;
    
    private String deliveryDoneBy;
    
    private String deliveryPlace;
    
    private Integer typeOfHospital;
    
    private String pregnancyOutcome;
    
    private Boolean isHighRiskCase;
    
    private Boolean isDischarged;
    
    private Long dischargeDate;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    public Integer getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Integer serviceDate) {
        this.serviceDate = serviceDate;
    }

    public Long getDateOfDelivery() {
        return dateOfDelivery;
    }

    public void setDateOfDelivery(Long dateOfDelivery) {
        this.dateOfDelivery = dateOfDelivery;
    }

    public String getTypeOfDelivery() {
        return typeOfDelivery;
    }

    public void setTypeOfDelivery(String typeOfDelivery) {
        this.typeOfDelivery = typeOfDelivery;
    }

    public String getDeliveryDoneBy() {
        return deliveryDoneBy;
    }

    public void setDeliveryDoneBy(String deliveryDoneBy) {
        this.deliveryDoneBy = deliveryDoneBy;
    }

    public String getDeliveryPlace() {
        return deliveryPlace;
    }

    public void setDeliveryPlace(String deliveryPlace) {
        this.deliveryPlace = deliveryPlace;
    }

    public Integer getTypeOfHospital() {
        return typeOfHospital;
    }

    public void setTypeOfHospital(Integer typeOfHospital) {
        this.typeOfHospital = typeOfHospital;
    }

    public String getPregnancyOutcome() {
        return pregnancyOutcome;
    }

    public void setPregnancyOutcome(String pregnancyOutcome) {
        this.pregnancyOutcome = pregnancyOutcome;
    }

    public Boolean getIsHighRiskCase() {
        return isHighRiskCase;
    }

    public void setIsHighRiskCase(Boolean isHighRiskCase) {
        this.isHighRiskCase = isHighRiskCase;
    }

    public Boolean getIsDischarged() {
        return isDischarged;
    }

    public void setIsDischarged(Boolean isDischarged) {
        this.isDischarged = isDischarged;
    }

    public Long getDischargeDate() {
        return dischargeDate;
    }

    public void setDischargeDate(Long dischargeDate) {
        this.dischargeDate = dischargeDate;
    }
    
}

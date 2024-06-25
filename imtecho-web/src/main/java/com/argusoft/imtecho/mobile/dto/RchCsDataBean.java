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
public class RchCsDataBean {
    
    private Integer id;
    
    private Integer memberId;
    
    private Integer familyId;
    
    private Integer locationId;
    
    private Long serviceDate;
    
    private Float weight;
    
    private Float midArmCircumference;
    
    private Integer height;
    
    private Boolean havePedalEdema;
    
    private Boolean exclusivelyBreastfeded;
    
    private Boolean anyVaccinationPending;

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

    public Long getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Long serviceDate) {
        this.serviceDate = serviceDate;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Float getMidArmCircumference() {
        return midArmCircumference;
    }

    public void setMidArmCircumference(Float midArmCircumference) {
        this.midArmCircumference = midArmCircumference;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    public Boolean getHavePedalEdema() {
        return havePedalEdema;
    }

    public void setHavePedalEdema(Boolean havePedalEdema) {
        this.havePedalEdema = havePedalEdema;
    }

    public Boolean getExclusivelyBreastfeded() {
        return exclusivelyBreastfeded;
    }

    public void setExclusivelyBreastfeded(Boolean exclusivelyBreastfeded) {
        this.exclusivelyBreastfeded = exclusivelyBreastfeded;
    }

    public Boolean getAnyVaccinationPending() {
        return anyVaccinationPending;
    }

    public void setAnyVaccinationPending(Boolean anyVaccinationPending) {
        this.anyVaccinationPending = anyVaccinationPending;
    }
}

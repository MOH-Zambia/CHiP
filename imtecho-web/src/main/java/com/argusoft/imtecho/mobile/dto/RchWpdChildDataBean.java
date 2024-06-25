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
public class RchWpdChildDataBean {
    
    private Integer id;
    
    private Integer motherId;
    
    private Integer wpdMotherId;
    
    private Long dateOfDelivery;
    
    private String gender;
    
    private Float birthWeight;
    
    private Boolean isHighRiskCase;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMotherId() {
        return motherId;
    }

    public void setMotherId(Integer motherId) {
        this.motherId = motherId;
    }

    public Integer getWpdMotherId() {
        return wpdMotherId;
    }

    public void setWpdMotherId(Integer wpdMotherId) {
        this.wpdMotherId = wpdMotherId;
    }

    public Long getDateOfDelivery() {
        return dateOfDelivery;
    }

    public void setDateOfDelivery(Long dateOfDelivery) {
        this.dateOfDelivery = dateOfDelivery;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Float getBirthWeight() {
        return birthWeight;
    }

    public void setBirthWeight(Float birthWeight) {
        this.birthWeight = birthWeight;
    }

    public Boolean getIsHighRiskCase() {
        return isHighRiskCase;
    }

    public void setIsHighRiskCase(Boolean isHighRiskCase) {
        this.isHighRiskCase = isHighRiskCase;
    }
}

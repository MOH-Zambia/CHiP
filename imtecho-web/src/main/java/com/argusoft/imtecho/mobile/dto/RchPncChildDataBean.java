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
public class RchPncChildDataBean {
    
    private Integer id;
    
    private Integer pncMasterId;
    
    private Integer childId;
    
    private Float childWeight;
    
    private Boolean isHighRiskCase;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPncMasterId() {
        return pncMasterId;
    }

    public void setPncMasterId(Integer pncMasterId) {
        this.pncMasterId = pncMasterId;
    }

    public Integer getChildId() {
        return childId;
    }

    public void setChildId(Integer childId) {
        this.childId = childId;
    }

    public Float getChildWeight() {
        return childWeight;
    }

    public void setChildWeight(Float childWeight) {
        this.childWeight = childWeight;
    }

    public Boolean getIsHighRiskCase() {
        return isHighRiskCase;
    }

    public void setIsHighRiskCase(Boolean isHighRiskCase) {
        this.isHighRiskCase = isHighRiskCase;
    }

}

package com.argusoft.imtecho.mobile.dto;

/**
 *
 * @author prateek on 17 Dec, 2018
 */
public class RchPncDataBean {

    private Integer id;
    
    private Integer memberId;
    
    private Integer familyId;
    
    private Integer locationId;
    
    private Long serviceDate;

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
    
    
}

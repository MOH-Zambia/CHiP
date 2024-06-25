package com.argusoft.sewa.android.app.databean;

import com.argusoft.sewa.android.app.model.FamilyAvailabilityBean;
/**
 * Defines methods for FamilyAvailabilityDataBean
 *
 * @author prateek
 * @since 05/06/23 3:44 pm
 */
public class FamilyAvailabilityDataBean {

    private Integer actualId;
    private Integer userId;
    private String availabilityStatus;
    private String houseNumber;
    private String address1;
    private String address2;
    private Integer locationId;
    private Integer familyId;
    private Long modifiedOn;

    public FamilyAvailabilityDataBean(FamilyAvailabilityBean bean) {
        this.actualId = bean.getActualId();
        this.userId = bean.getUserId();
        this.locationId = bean.getLocationId();
        this.availabilityStatus = bean.getAvailabilityStatus();
        this.houseNumber = bean.getHouseNumber();
        this.address1 = bean.getAddress1();
        this.address2 = bean.getAddress2();
        this.familyId = bean.getFamilyId();
        this.modifiedOn = bean.getModifiedOn().getTime();
    }

    public Integer getActualId() {
        return actualId;
    }

    public void setActualId(Integer actualId) {
        this.actualId = actualId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(String availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }


    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Long getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Long modifiedOn) {
        this.modifiedOn = modifiedOn;
    }
}

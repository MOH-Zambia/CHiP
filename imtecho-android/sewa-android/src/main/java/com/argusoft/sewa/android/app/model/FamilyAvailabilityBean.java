package com.argusoft.sewa.android.app.model;

import com.argusoft.sewa.android.app.databean.FamilyAvailabilityDataBean;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

/**
 * Defines methods for FamilyAvailabilityBean
 *
 * @author prateek
 * @since 05/06/23 3:45 pm
 */
@DatabaseTable
public class FamilyAvailabilityBean extends BaseEntity {

    @DatabaseField
    private Integer actualId;
    @DatabaseField
    private Integer userId;
    @DatabaseField
    private String availabilityStatus;
    @DatabaseField
    private String houseNumber;
    @DatabaseField
    private String address1;
    @DatabaseField
    private String address2;
    @DatabaseField
    private Integer locationId;
    @DatabaseField
    private Integer familyId;
    @DatabaseField
    private Date modifiedOn;

    public FamilyAvailabilityBean() {
    }

    public FamilyAvailabilityBean(FamilyAvailabilityDataBean databean) {
        this.actualId = databean.getActualId();
        this.userId = databean.getUserId();
        this.locationId = databean.getLocationId();
        this.availabilityStatus = databean.getAvailabilityStatus();
        this.houseNumber = databean.getHouseNumber();
        this.address1 = databean.getAddress1();
        this.address2 = databean.getAddress2();
        this.familyId = databean.getFamilyId();
        this.modifiedOn = new Date(databean.getModifiedOn());
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

    public Date getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Date modifiedOn) {
        this.modifiedOn = modifiedOn;
    }
}

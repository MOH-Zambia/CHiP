/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.dto;

/**
 *
 * @author prateek
 */
public class MigrationDetailsDataBean {

    private Integer memberId;
    private String firstName;
    private String middleName;
    private String lastName;
    private String familyId;
    private String healthId;
    private String fhwName;
    private String fhwPhoneNumber;
    private String locationDetails;
    private String otherInfo;
    private String childDetails;

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFamilyId() {
        return familyId;
    }

    public void setFamilyId(String familyId) {
        this.familyId = familyId;
    }

    public String getHealthId() {
        return healthId;
    }

    public void setHealthId(String healthId) {
        this.healthId = healthId;
    }

    public String getFhwName() {
        return fhwName;
    }

    public void setFhwName(String fhwName) {
        this.fhwName = fhwName;
    }

    public String getFhwPhoneNumber() {
        return fhwPhoneNumber;
    }

    public void setFhwPhoneNumber(String fhwPhoneNumber) {
        this.fhwPhoneNumber = fhwPhoneNumber;
    }

    public String getLocationDetails() {
        return locationDetails;
    }

    public void setLocationDetails(String locationDetails) {
        this.locationDetails = locationDetails;
    }

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }

    public String getChildDetails() {
        return childDetails;
    }

    public void setChildDetails(String childDetails) {
        this.childDetails = childDetails;
    }

    @Override
    public String toString() {
        return "MigrationDetailsDataBean{" + "memberId=" + memberId + ", firstName=" + firstName + ", middleName=" + middleName + ", lastName=" + lastName + ", familyId=" + familyId + ", healthId=" + healthId + ", fhwName=" + fhwName + ", fhwPhoneNumber=" + fhwPhoneNumber + ", locationDetails=" + locationDetails + '}';
    }
}

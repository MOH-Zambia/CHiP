/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.model;

import java.util.Objects;

public class OfflineHealthIdEntity  {

    private String aadhar;

    private String dob;

    private String gender;

    private String mobile;

    private String name;

    private Integer memberId;

    private String consentValues;

    private Boolean isAadhaarDetailMatchConsentGiven;

    public OfflineHealthIdEntity() {
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getAadhar() {
        return aadhar;
    }

    public void setAadhar(String aadhaarNo) {
        this.aadhar = aadhaarNo;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getConsentValues() {
        return consentValues;
    }

    public void setConsentValues(String consentValues) {
        this.consentValues = consentValues;
    }

    public Boolean getAadhaarDetailMatchConsentGiven() {
        return isAadhaarDetailMatchConsentGiven;
    }

    public void setAadhaarDetailMatchConsentGiven(Boolean aadhaarDetailMatchConsentGiven) {
        isAadhaarDetailMatchConsentGiven = aadhaarDetailMatchConsentGiven;
    }
    @Override
    public String toString() {
        return "OfflineHealthIdBean{" +
                "aadhaarNo='" + aadhar + '\'' +
                ", dob='" + dob + '\'' +
                ", gender='" + gender + '\'' +
                ", mobileNumber='" + mobile + '\'' +
                ", name='" + name + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OfflineHealthIdEntity that = (OfflineHealthIdEntity) o;
        return Objects.equals(aadhar, that.aadhar) && Objects.equals(dob, that.dob) && Objects.equals(gender, that.gender) && Objects.equals(mobile, that.mobile) && Objects.equals(name, that.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(aadhar, dob, gender, mobile, name);
    }
}

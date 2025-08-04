package com.argusoft.imtecho.scpro.dto;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MemberDetailsDTO  {

    private String nupn;
    private String firstName;
    private String lastName;
    private String motherName;
    private String memberReligion;
    private String nrc; // National Registration Card
    private String gender;
    private String maritalStatus;
    private Date dateOfBirth;
    private String mobileNumber;
    private String houseNumberOrLocation;
    private String landmark;
    private String mflCode;
    private String district;

    // Getters and Setters
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getMotherName() {
        return motherName;
    }

    public void setMotherName(String motherName) {
        this.motherName = motherName;
    }

    public String getMemberReligion() {
        return memberReligion;
    }

    public void setMemberReligion(String memberReligion) {
        this.memberReligion = memberReligion;
    }

    public String getNrc() {
        return nrc;
    }

    public void setNrc(String nrc) {
        this.nrc = nrc;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        if (dateOfBirth == null || dateOfBirth.trim().isEmpty()) {
            this.dateOfBirth = null;
            return;
        }

        try {
            this.dateOfBirth = new SimpleDateFormat("yyyy-MM-dd").parse(dateOfBirth);
        } catch (ParseException e) {
            throw new IllegalArgumentException("Invalid date format for dateOfBirth. Expected format: yyyy-MM-dd");
        }
    }


    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getHouseNumberOrLocation() {
        return houseNumberOrLocation;
    }

    public void setHouseNumberOrLocation(String houseNumberOrLocation) {
        this.houseNumberOrLocation = houseNumberOrLocation;
    }

    public String getLandmark() {
        return landmark;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public String getMflCode() {
        return mflCode;
    }

    public void setMflCode(String mflCode) {
        this.mflCode = mflCode;
    }

    public String getNupn() {
        return nupn;
    }

    public void setNupn(String nupn) {
        this.nupn = nupn;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }


    // toString() for easy debugging

}

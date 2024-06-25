/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.dto;

import java.util.Date;

/**
 *
 * @author kunjan
 */
public class MigrationMobileDataBean {

    private Integer memberId;

    private Integer reportedBy;

    private Date reportedOn;

    private Integer locationMigratedTo;

    private Integer locationMigratedFrom;

    private String familyMigratedTo;

    private String familyMigratedFrom;
    
    private String state;
    
    private Boolean migratedLocationNotKnown;
    
    private Integer confirmedBy;
    
    private Date confirmedOn;
    
    private String type;
    
    private String memberDetails;
    
    private String familyId;
    
    private String otherInfo;
    
    private boolean doesNotBelongToAFamily;
    
    private Integer ashaAreaId;
    
    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Integer getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(Integer reportedBy) {
        this.reportedBy = reportedBy;
    }

    public Date getReportedOn() {
        return reportedOn;
    }

    public void setReportedOn(Date reportedOn) {
        this.reportedOn = reportedOn;
    }

    public Integer getLocationMigratedTo() {
        return locationMigratedTo;
    }

    public void setLocationMigratedTo(Integer locationMigratedTo) {
        this.locationMigratedTo = locationMigratedTo;
    }

    public Integer getLocationMigratedFrom() {
        return locationMigratedFrom;
    }

    public void setLocationMigratedFrom(Integer locationMigratedFrom) {
        this.locationMigratedFrom = locationMigratedFrom;
    }

    public String getFamilyMigratedTo() {
        return familyMigratedTo;
    }

    public void setFamilyMigratedTo(String familyMigratedTo) {
        this.familyMigratedTo = familyMigratedTo;
    }

    public String getFamilyMigratedFrom() {
        return familyMigratedFrom;
    }

    public void setFamilyMigratedFrom(String familyMigratedFrom) {
        this.familyMigratedFrom = familyMigratedFrom;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public Boolean getMigratedLocationNotKnown() {
        return migratedLocationNotKnown;
    }

    public void setMigratedLocationNotKnown(Boolean migratedLocationNotKnown) {
        this.migratedLocationNotKnown = migratedLocationNotKnown;
    }

    public Integer getConfirmedBy() {
        return confirmedBy;
    }

    public void setConfirmedBy(Integer confirmedBy) {
        this.confirmedBy = confirmedBy;
    }

    public Date getConfirmedOn() {
        return confirmedOn;
    }

    public void setConfirmedOn(Date confirmedOn) {
        this.confirmedOn = confirmedOn;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getMemberDetails() {
        return memberDetails;
    }

    public void setMemberDetails(String memberDetails) {
        this.memberDetails = memberDetails;
    }

    public String getFamilyId() {
        return familyId;
    }

    public void setFamilyId(String familyId) {
        this.familyId = familyId;
    }

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }

    public boolean isDoesNotBelongToAFamily() {
        return doesNotBelongToAFamily;
    }

    public void setDoesNotBelongToAFamily(boolean doesNotBelongToAFamily) {
        this.doesNotBelongToAFamily = doesNotBelongToAFamily;
    }

    public Integer getAshaAreaId() {
        return ashaAreaId;
    }

    public void setAshaAreaId(Integer ashaAreaId) {
        this.ashaAreaId = ashaAreaId;
    }

    @Override
    public String toString() {
        return "MigrationMobileDataBean{" + "memberId=" + memberId + ", reportedBy=" + reportedBy + ", reportedOn=" + reportedOn + ", locationMigratedTo=" + locationMigratedTo + ", locationMigratedFrom=" + locationMigratedFrom + ", familyMigratedTo=" + familyMigratedTo + ", familyMigratedFrom=" + familyMigratedFrom + ", state=" + state + ", migratedLocationNotKnown=" + migratedLocationNotKnown + ", confirmedBy=" + confirmedBy + ", confirmedOn=" + confirmedOn + ", type=" + type + ", memberDetails=" + memberDetails + ", familyId=" + familyId + ", otherInfo=" + otherInfo + ", doesNotBelongToAFamily=" + doesNotBelongToAFamily + ", ashaAreaId=" + ashaAreaId + '}';
    }
}

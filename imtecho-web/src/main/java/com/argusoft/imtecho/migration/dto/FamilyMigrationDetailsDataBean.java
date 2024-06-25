package com.argusoft.imtecho.migration.dto;

import java.util.List;

/**
 *
 * @author prateek on Aug 19, 2019
 */
public class FamilyMigrationDetailsDataBean {

    private Integer migrationId;
    private Integer familyId;
    private String familyIdString;
    private List<String> memberDetails;
    private String locationDetails;
    private String areaDetails;
    private String fhwDetails;
    private String otherInfo;

    public Integer getMigrationId() {
        return migrationId;
    }

    public void setMigrationId(Integer migrationId) {
        this.migrationId = migrationId;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public String getFamilyIdString() {
        return familyIdString;
    }

    public void setFamilyIdString(String familyIdString) {
        this.familyIdString = familyIdString;
    }

    public List<String> getMemberDetails() {
        return memberDetails;
    }

    public void setMemberDetails(List<String> memberDetails) {
        this.memberDetails = memberDetails;
    }

    public String getLocationDetails() {
        return locationDetails;
    }

    public void setLocationDetails(String locationDetails) {
        this.locationDetails = locationDetails;
    }

    public String getAreaDetails() {
        return areaDetails;
    }

    public void setAreaDetails(String areaDetails) {
        this.areaDetails = areaDetails;
    }

    public String getFhwDetails() {
        return fhwDetails;
    }

    public void setFhwDetails(String fhwDetails) {
        this.fhwDetails = fhwDetails;
    }

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }
    
}

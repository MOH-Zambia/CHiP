package com.argusoft.imtecho.migration.dto;

/**
 *
 * @author prateek on 26 Feb, 2019
 */
public class MigratedMembersDataBean {

    private Integer migrationId;
    private Integer memberId;
    private String name;
    private String healthId;
    private String familyMigratedFrom;
    private String familyMigratedTo;
    private String locationMigratedFrom;
    private String locationMigratedTo;
    private Integer fromLocationId;
    private Integer toLocationId;
    private Long modifiedOn;
    private Boolean isOut;
    private Boolean isConfirmed;
    private Boolean outOfState;
    private Boolean isLfu;

    public Integer getMigrationId() {
        return migrationId;
    }

    public void setMigrationId(Integer migrationId) {
        this.migrationId = migrationId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHealthId() {
        return healthId;
    }

    public void setHealthId(String healthId) {
        this.healthId = healthId;
    }

    public String getFamilyMigratedFrom() {
        return familyMigratedFrom;
    }

    public void setFamilyMigratedFrom(String familyMigratedFrom) {
        this.familyMigratedFrom = familyMigratedFrom;
    }

    public String getFamilyMigratedTo() {
        return familyMigratedTo;
    }

    public void setFamilyMigratedTo(String familyMigratedTo) {
        this.familyMigratedTo = familyMigratedTo;
    }

    public String getLocationMigratedFrom() {
        return locationMigratedFrom;
    }

    public void setLocationMigratedFrom(String locationMigratedFrom) {
        this.locationMigratedFrom = locationMigratedFrom;
    }

    public String getLocationMigratedTo() {
        return locationMigratedTo;
    }

    public void setLocationMigratedTo(String locationMigratedTo) {
        this.locationMigratedTo = locationMigratedTo;
    }

    public Integer getFromLocationId() {
        return fromLocationId;
    }

    public void setFromLocationId(Integer fromLocationId) {
        this.fromLocationId = fromLocationId;
    }

    public Integer getToLocationId() {
        return toLocationId;
    }

    public void setToLocationId(Integer toLocationId) {
        this.toLocationId = toLocationId;
    }

    public Long getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Long modifiedOn) {
        this.modifiedOn = modifiedOn;
    }

    public Boolean getIsOut() {
        return isOut;
    }

    public void setIsOut(Boolean isOut) {
        this.isOut = isOut;
    }

    public Boolean getIsConfirmed() {
        return isConfirmed;
    }

    public void setIsConfirmed(Boolean isConfirmed) {
        this.isConfirmed = isConfirmed;
    }

    public Boolean getOutOfState() {
        return outOfState;
    }

    public void setOutOfState(Boolean outOfState) {
        this.outOfState = outOfState;
    }

    public Boolean getIsLfu() {
        return isLfu;
    }

    public void setIsLfu(Boolean isLfu) {
        this.isLfu = isLfu;
    }
}

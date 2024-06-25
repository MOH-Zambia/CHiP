package com.argusoft.imtecho.migration.dto;

import java.util.List;
import java.util.Map;

/**
 * @author prateek on Aug 19, 2019
 */
public class FamilyMigrationOutDataBean {

    private Integer familyId;
    private Boolean isSplit;
    private List<Integer> memberIds;
    private Integer newHead;
    private Boolean isCurrentLocation;
    private Boolean outOfState;
    private Boolean locationKnown;
    private Integer fromLocationId;
    private Integer toLocationId;
    private String otherInfo;
    private Long reportedOn;
    private Boolean existingHeadSelected;
    private Map<String, String> relationWithHofMap;

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Boolean getIsSplit() {
        return isSplit;
    }

    public void setIsSplit(Boolean isSplit) {
        this.isSplit = isSplit;
    }

    public List<Integer> getMemberIds() {
        return memberIds;
    }

    public void setMemberIds(List<Integer> memberIds) {
        this.memberIds = memberIds;
    }

    public Integer getNewHead() {
        return newHead;
    }

    public void setNewHead(Integer newHead) {
        this.newHead = newHead;
    }

    public Boolean getIsCurrentLocation() {
        return isCurrentLocation;
    }

    public void setIsCurrentLocation(Boolean isCurrentLocation) {
        this.isCurrentLocation = isCurrentLocation;
    }

    public Boolean getOutOfState() {
        return outOfState;
    }

    public void setOutOfState(Boolean outOfState) {
        this.outOfState = outOfState;
    }

    public Boolean getLocationKnown() {
        return locationKnown;
    }

    public void setLocationKnown(Boolean locationKnown) {
        this.locationKnown = locationKnown;
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

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }

    public Long getReportedOn() {
        return reportedOn;
    }

    public void setReportedOn(Long reportedOn) {
        this.reportedOn = reportedOn;
    }

    public Boolean getExistingHeadSelected() {
        return existingHeadSelected;
    }

    public void setExistingHeadSelected(Boolean existingHeadSelected) {
        this.existingHeadSelected = existingHeadSelected;
    }

    public Map<String, String> getRelationWithHofMap() {
        return relationWithHofMap;
    }

    public void setRelationWithHofMap(Map<String, String> relationWithHofMap) {
        this.relationWithHofMap = relationWithHofMap;
    }
}

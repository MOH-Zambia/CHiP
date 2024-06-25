package com.argusoft.imtecho.migration.dto;

import java.util.List;

/**
 *
 * @author prateek on 18 Mar, 2019
 */
public class MigrationOutDataBean {

    private Integer memberId;
    private Integer fromFamilyId;
    private Integer fromLocationId;
    private Boolean outOfState;
    private Boolean locationknown;
    private Integer toLocationId;
    private List<Integer> childrensUnder5;
    private String otherInfo;
    private Long reportedOn;
    private String migratedToStateName;

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Integer getFromFamilyId() {
        return fromFamilyId;
    }

    public void setFromFamilyId(Integer fromFamilyId) {
        this.fromFamilyId = fromFamilyId;
    }

    public Integer getFromLocationId() {
        return fromLocationId;
    }

    public void setFromLocationId(Integer fromLocationId) {
        this.fromLocationId = fromLocationId;
    }

    public Boolean getOutOfState() {
        return outOfState;
    }

    public void setOutOfState(Boolean outOfState) {
        this.outOfState = outOfState;
    }

    public Boolean getLocationknown() {
        return locationknown;
    }

    public void setLocationknown(Boolean locationknown) {
        this.locationknown = locationknown;
    }

    public Integer getToLocationId() {
        return toLocationId;
    }

    public void setToLocationId(Integer toLocationId) {
        this.toLocationId = toLocationId;
    }

    public List<Integer> getChildrensUnder5() {
        return childrensUnder5;
    }

    public void setChildrensUnder5(List<Integer> childrensUnder5) {
        this.childrensUnder5 = childrensUnder5;
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

    public String getMigratedToStateName() {
        return migratedToStateName;
    }

    public void setMigratedToStateName(String migratedToStateName) {
        this.migratedToStateName = migratedToStateName;
    }
}

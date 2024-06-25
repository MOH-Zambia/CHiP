package com.argusoft.imtecho.migration.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author prateek on Aug 19, 2019
 */
@Entity
@Table(name = "imt_family_migration_master")
public class FamilyMigrationEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "family_id")
    private Integer familyId;

    @Column(name = "is_split_family")
    private Boolean isSplitFamily;

    @Column(name = "split_family_id")
    private Integer splitFamilyId;
    
    @Column(name = "is_current_location")
    private Boolean isCurrentLocation;

    @Column(name = "member_ids")
    private String memberIds;

    @Column(name = "state")
    private String state;

    @Column(name = "type")
    private String type;

    @Column(name = "out_of_state")
    private Boolean outOfState;

    @Column(name = "migrated_location_not_known")
    private Boolean migratedLocationNotKnown;

    @Column(name = "location_migrated_to")
    private Integer locationMigratedTo;

    @Column(name = "location_migrated_from")
    private Integer locationMigratedFrom;

    @Column(name = "area_migrated_to")
    private Integer areaMigratedTo;

    @Column(name = "area_migrated_from")
    private Integer areaMigratedFrom;

    @Column(name = "reported_by")
    private Integer reportedBy;

    @Column(name = "reported_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date reportedOn;

    @Column(name = "reported_location_id")
    private Integer reportedLocationId;

    @Column(name = "confirmed_by")
    private Integer confirmedBy;

    @Column(name = "confirmed_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date confirmedOn;

    @Column(name = "mobile_data")
    private String mobileData;

    @Column(name = "other_information")
    private String otherInformation;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Boolean getIsSplitFamily() {
        return isSplitFamily;
    }

    public void setIsSplitFamily(Boolean isSplitFamily) {
        this.isSplitFamily = isSplitFamily;
    }

    public Integer getSplitFamilyId() {
        return splitFamilyId;
    }

    public void setSplitFamilyId(Integer splitFamilyId) {
        this.splitFamilyId = splitFamilyId;
    }

    public Boolean getIsCurrentLocation() {
        return isCurrentLocation;
    }

    public void setIsCurrentLocation(Boolean isCurrentLocation) {
        this.isCurrentLocation = isCurrentLocation;
    }

    public String getMemberIds() {
        return memberIds;
    }

    public void setMemberIds(String memberIds) {
        this.memberIds = memberIds;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean getOutOfState() {
        return outOfState;
    }

    public void setOutOfState(Boolean outOfState) {
        this.outOfState = outOfState;
    }

    public Boolean getMigratedLocationNotKnown() {
        return migratedLocationNotKnown;
    }

    public void setMigratedLocationNotKnown(Boolean migratedLocationNotKnown) {
        this.migratedLocationNotKnown = migratedLocationNotKnown;
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

    public Integer getAreaMigratedTo() {
        return areaMigratedTo;
    }

    public void setAreaMigratedTo(Integer areaMigratedTo) {
        this.areaMigratedTo = areaMigratedTo;
    }

    public Integer getAreaMigratedFrom() {
        return areaMigratedFrom;
    }

    public void setAreaMigratedFrom(Integer areaMigratedFrom) {
        this.areaMigratedFrom = areaMigratedFrom;
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

    public Integer getReportedLocationId() {
        return reportedLocationId;
    }

    public void setReportedLocationId(Integer reportedLocationId) {
        this.reportedLocationId = reportedLocationId;
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

    public String getMobileData() {
        return mobileData;
    }

    public void setMobileData(String mobileData) {
        this.mobileData = mobileData;
    }

    public String getOtherInformation() {
        return otherInformation;
    }

    public void setOtherInformation(String otherInformation) {
        this.otherInformation = otherInformation;
    }
}

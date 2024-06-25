/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.rch.constants.RchConstants;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;
import javax.persistence.Basic;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author kunjan
 */
@Entity
@Table(name = "migration_master")
public class MigrationEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "reported_by")
    private Integer reportedBy;

    @Column(name = "reported_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date reportedOn;

    @Column(name = "reported_location_id")
    private Integer reportedLocationId;

    @Column(name = "location_migrated_to")
    private Integer locationMigratedTo;

    @Column(name = "location_migrated_from")
    private Integer locationMigratedFrom;

    @Column(name = "family_migrated_to")
    private String familyMigratedTo;

    @Column(name = "family_migrated_from")
    private String familyMigratedFrom;

    @Column(name = "state")
    private String state;

    @Column(name = "migrated_location_not_known")
    private Boolean migratedLocationNotKnown;

    @Column(name = "confirmed_by")
    private Integer confirmedBy;

    @Column(name = "confirmed_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date confirmedOn;

    @Column(name = "type")
    private String type;

    @Column(name = "other_information")
    private String otherInfo;

    @Column(name = "no_family")
    private Boolean noFamilyFlag;

    @Column(name = "out_of_state")
    private Boolean outOfState;

    @Column(name = "area_migrated_to")
    private Integer areaMigratedTo;

    @Column(name = "area_migrated_from")
    private Integer areaMigratedFrom;

    @ElementCollection(fetch = FetchType.LAZY)
    @CollectionTable(name = "migration_child_rel", joinColumns = @JoinColumn(name = "migration_id"))
    @Column(name = "child_id")
    private Set<Integer> children;

    @Column(name = "nearest_loc_id")
    private Integer nearestLocId;

    @Column(name = "village_name")
    private String villageName;

    @Column(name = "fhw_asha_name")
    private String fhwOrAshaName;

    @Column(name = "fhw_asha_phone")
    private String fhwOrAshaPhone;

    @Column(name = "has_children")
    private Boolean hasChildren;

    @Column(name = "is_temporary")
    private Boolean isTemporary;

    @Column(name = "mobile_data")
    private String mobileData;

    @Column(name = "similar_member_verified")
    private Boolean similarMemberVerified;

    @Column(name = "status")
    private String status;
    @Column(name = "migrated_to_state_name")
    private String migratedToStateName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

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

    public Integer getReportedLocationId() {
        return reportedLocationId;
    }

    public void setReportedLocationId() {
        if (type != null) {
            if (type.equals(RchConstants.MIGRATION.MIGRATION_TYPE_IN)) {
                if (locationMigratedTo != null) {
                    reportedLocationId = locationMigratedTo;
                }
            } else if (type.equals(RchConstants.MIGRATION.MIGRATION_TYPE_OUT)) {
                if (locationMigratedFrom != null) {
                    reportedLocationId = locationMigratedFrom;
                }
            }
        }
    }

    public Integer getLocationMigratedTo() {
        return locationMigratedTo;
    }

    public void setLocationMigratedTo(Integer locationMigratedTo) {
        this.locationMigratedTo = locationMigratedTo;
        setReportedLocationId();
    }

    public Integer getLocationMigratedFrom() {
        return locationMigratedFrom;
    }

    public void setLocationMigratedFrom(Integer locationMigratedFrom) {
        this.locationMigratedFrom = locationMigratedFrom;
        setReportedLocationId();
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
        setReportedLocationId();
    }

    public String getOtherInfo() {
        return otherInfo;
    }

    public void setOtherInfo(String otherInfo) {
        this.otherInfo = otherInfo;
    }

    public Boolean getNoFamilyFlag() {
        return noFamilyFlag;
    }

    public void setNoFamilyFlag(Boolean noFamilyFlag) {
        this.noFamilyFlag = noFamilyFlag;
    }

    public Boolean getOutOfState() {
        return outOfState;
    }

    public void setOutOfState(Boolean outOfState) {
        this.outOfState = outOfState;
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

    public Set<Integer> getChildren() {
        return children;
    }

    public void setChildren(Set<Integer> children) {
        this.children = children;
    }

    public Integer getNearestLocId() {
        return nearestLocId;
    }

    public void setNearestLocId(Integer nearestLocId) {
        this.nearestLocId = nearestLocId;
    }

    public String getVillageName() {
        return villageName;
    }

    public void setVillageName(String villageName) {
        this.villageName = villageName;
    }

    public String getFhwOrAshaName() {
        return fhwOrAshaName;
    }

    public void setFhwOrAshaName(String fhwOrAshaName) {
        this.fhwOrAshaName = fhwOrAshaName;
    }

    public String getFhwOrAshaPhone() {
        return fhwOrAshaPhone;
    }

    public void setFhwOrAshaPhone(String fhwOrAshaPhone) {
        this.fhwOrAshaPhone = fhwOrAshaPhone;
    }

    public Boolean getHasChildren() {
        return hasChildren;
    }

    public void setHasChildren(Boolean hasChildren) {
        this.hasChildren = hasChildren;
    }

    public Boolean getIsTemporary() {
        return isTemporary;
    }

    public void setIsTemporary(Boolean isTemporary) {
        this.isTemporary = isTemporary;
    }

    public String getMobileData() {
        return mobileData;
    }

    public void setMobileData(String mobileData) {
        this.mobileData = mobileData;
    }

    public Boolean getSimilarMemberVerified() {
        return similarMemberVerified;
    }

    public void setSimilarMemberVerified(Boolean similarMemberVerified) {
        this.similarMemberVerified = similarMemberVerified;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMigratedToStateName() {
        return migratedToStateName;
    }

    public void setMigratedToStateName(String migratedToStateName) {
        this.migratedToStateName = migratedToStateName;
    }

    @Override
    public String toString() {
        return "MigrationEntity{" + "id=" + id + ", memberId=" + memberId + ", reportedBy=" + reportedBy + ", reportedOn=" + reportedOn + ", locationMigratedTo=" + locationMigratedTo + ", locationMigratedFrom=" + locationMigratedFrom + ", familyMigratedTo=" + familyMigratedTo + ", familyMigratedFrom=" + familyMigratedFrom + ", state=" + state + ", migratedLocationNotKnown=" + migratedLocationNotKnown + ", confirmedBy=" + confirmedBy + ", confirmedOn=" + confirmedOn + ", type=" + type + ", otherInfo=" + otherInfo + '}';
    }
}

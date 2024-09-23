/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.exception.ImtechoMobileException;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * Define rch_lmp_follow_up entity and its fields.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Entity
@Table(name = "rch_lmp_follow_up")
public class LmpFollowUpVisit extends VisitCommonFields implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "lmp")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lmp;

    @Column(name = "irregular_periods")
    private Boolean irregularPeriods;

    @Column(name = "is_pregnant", nullable = false)
    private Boolean isPregnant;

    @Column(name = "pregnancy_test_done")
    private Boolean pregnancyTestDone;

    @Column(name = "family_planning_method")
    private String familyPlanningMethod;

    @Column(name = "year")
    private Short year;

    @Column(name = "register_now_for_pregnancy")
    private Boolean registerNowForPregnancy;

    @Column(name = "member_status")
    private String memberStatus;

    @Column(name = "death_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deathDate;

    @Column(name = "place_of_death")
    private String placeOfDeath;

    @Column(name = "death_reason")
    private String deathReason;

    @Column(name = "other_death_reason")
    private String otherDeathReason;

    @Column(name = "fp_insert_operate_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fpInsertOperateDate;

    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "death_infra_id")
    private Integer deathInfrastructureId;

    @Column(name = "date_of_wedding")
    @Temporal(TemporalType.DATE)
    private Date dateOfWedding;

    @Column(name = "current_gravida")
    private Short currentGravida;

    @Column(name = "current_para")
    private Short currentPara;

    @Column(name = "fp_sub_method")
    private String fpSubMethod;

    @Column(name = "fp_alternative_main_method")
    private String fpAlternativeMainMethod;

    @Column(name = "fp_alternative_sub_method")
    private String fpAlternativeSubMethod;

    @Column(name = "other_death_place")
    private String otherDeathPlace;

    @Column(name = "abortion_count")
    private Short abortionCount;

    @Column(name = "last_pregnancy_date")
    @Temporal(TemporalType.DATE)
    private Date lastPregnancyDate;

    @Column(name = "blood_group_father")
    private String fatherBloodGroup;

    @Column(name = "sickle_cell_status_father")
    private String fatherSickleCellStatus;

    @Column(name = "received_anc_from_other")
    private Boolean receivedAncFromOtherPlace;

    @Column(name = "other_anc_service_place")
    private String otherAncServicePlace;

    @Column(name = "have_details_card")
    private Boolean haveCardForDetails;

    @Column(name = "late_reg_reason")
    private String lateRegReason;

    @Column(name = "prev_anc_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date prevAncDate;

    @Column(name = "prev_anc_infra_id")
    private Integer prevAncInfraId;

    @Column(name = "prev_anc_state")
    private String prevAncState;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getLmp() {
        return lmp;
    }

    public void setLmp(Date lmp) {
        if (lmp != null && ImtechoUtil.clearTimeFromDate(lmp).after(new Date())) {
            throw new ImtechoMobileException("LMP date cannot be future", 100);
        }
        this.lmp = ImtechoUtil.clearTimeFromDate(lmp);
    }

    public Boolean getIsPregnant() {
        return isPregnant;
    }

    public void setIsPregnant(Boolean isPregnant) {
        this.isPregnant = isPregnant;
    }

    public Boolean getPregnancyTestDone() {
        return pregnancyTestDone;
    }

    public void setPregnancyTestDone(Boolean pregnancyTestDone) {
        this.pregnancyTestDone = pregnancyTestDone;
    }

    public String getFamilyPlanningMethod() {
        return familyPlanningMethod;
    }

    public void setFamilyPlanningMethod(String familyPlanningMethod) {
        this.familyPlanningMethod = familyPlanningMethod;
    }

    public Short getYear() {
        return year;
    }

    public void setYear(Short year) {
        this.year = year;
    }

    public Boolean getRegisterNowForPregnancy() {
        return registerNowForPregnancy;
    }

    public void setRegisterNowForPregnancy(Boolean registerNowForPregnancy) {
        this.registerNowForPregnancy = registerNowForPregnancy;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public Date getDeathDate() {
        return deathDate;
    }

    public void setDeathDate(Date deathDate) {
        if (deathDate != null && ImtechoUtil.clearTimeFromDate(deathDate).after(new Date())) {
            throw new ImtechoMobileException("Death date cannot be future", 100);
        }
        this.deathDate = ImtechoUtil.clearTimeFromDate(deathDate);
    }

    public String getPlaceOfDeath() {
        return placeOfDeath;
    }

    public void setPlaceOfDeath(String placeOfDeath) {
        this.placeOfDeath = placeOfDeath;
    }

    public String getDeathReason() {
        return deathReason;
    }

    public void setDeathReason(String deathReason) {
        this.deathReason = deathReason;
    }

    public String getOtherDeathReason() {
        return otherDeathReason;
    }

    public void setOtherDeathReason(String otherDeathReason) {
        this.otherDeathReason = otherDeathReason;
    }

    public Date getFpInsertOperateDate() {
        return fpInsertOperateDate;
    }

    public void setFpInsertOperateDate(Date fpInsertOperateDate) {
        this.fpInsertOperateDate = fpInsertOperateDate;
    }

    public Date getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Date serviceDate) {
        if (serviceDate != null && ImtechoUtil.clearTimeFromDate(serviceDate).after(new Date())) {
            throw new ImtechoMobileException("Service date cannot be future", 100);
        }
        this.serviceDate = ImtechoUtil.clearTimeFromDate(serviceDate);
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Integer getDeathInfrastructureId() {
        return deathInfrastructureId;
    }

    public void setDeathInfrastructureId(Integer deathInfrastructureId) {
        this.deathInfrastructureId = deathInfrastructureId;
    }

    public Date getDateOfWedding() {
        return dateOfWedding;
    }

    public void setDateOfWedding(Date dateOfWedding) {
        this.dateOfWedding = dateOfWedding;
    }

    public Short getCurrentGravida() {
        return currentGravida;
    }

    public void setCurrentGravida(Short currentGravida) {
        this.currentGravida = currentGravida;
    }

    public Short getCurrentPara() {
        return currentPara;
    }

    public void setCurrentPara(Short currentPara) {
        this.currentPara = currentPara;
    }

    public String getFpSubMethod() {
        return fpSubMethod;
    }

    public void setFpSubMethod(String fpSubMethod) {
        this.fpSubMethod = fpSubMethod;
    }

    public String getFpAlternativeMainMethod() {
        return fpAlternativeMainMethod;
    }

    public void setFpAlternativeMainMethod(String fpAlternativeMainMethod) {
        this.fpAlternativeMainMethod = fpAlternativeMainMethod;
    }

    public String getFpAlternativeSubMethod() {
        return fpAlternativeSubMethod;
    }

    public void setFpAlternativeSubMethod(String fpAlternativeSubMethod) {
        this.fpAlternativeSubMethod = fpAlternativeSubMethod;
    }

    public String getOtherDeathPlace() {
        return otherDeathPlace;
    }

    public void setOtherDeathPlace(String otherDeathPlace) {
        this.otherDeathPlace = otherDeathPlace;
    }

    public Short getAbortionCount() {
        return abortionCount;
    }

    public void setAbortionCount(Short abortionCount) {
        this.abortionCount = abortionCount;
    }

    public Date getLastPregnancyDate() {
        return lastPregnancyDate;
    }

    public void setLastPregnancyDate(Date lastPregnancyDate) {
        this.lastPregnancyDate = lastPregnancyDate;
    }

    public String getFatherBloodGroup() {
        return fatherBloodGroup;
    }

    public void setFatherBloodGroup(String fatherBloodGroup) {
        this.fatherBloodGroup = fatherBloodGroup;
    }

    public String getFatherSickleCellStatus() {
        return fatherSickleCellStatus;
    }

    public void setFatherSickleCellStatus(String fatherSickleCellStatus) {
        this.fatherSickleCellStatus = fatherSickleCellStatus;
    }

    public Boolean getReceivedAncFromOtherPlace() {
        return receivedAncFromOtherPlace;
    }

    public void setReceivedAncFromOtherPlace(Boolean receivedAncFromOtherPlace) {
        this.receivedAncFromOtherPlace = receivedAncFromOtherPlace;
    }

    public String getOtherAncServicePlace() {
        return otherAncServicePlace;
    }

    public void setOtherAncServicePlace(String otherAncServicePlace) {
        this.otherAncServicePlace = otherAncServicePlace;
    }

    public Boolean getHaveCardForDetails() {
        return haveCardForDetails;
    }

    public void setHaveCardForDetails(Boolean haveCardForDetails) {
        this.haveCardForDetails = haveCardForDetails;
    }

    public String getLateRegReason() {
        return lateRegReason;
    }

    public void setLateRegReason(String lateRegReason) {
        this.lateRegReason = lateRegReason;
    }

    public Date getPrevAncDate() {
        return prevAncDate;
    }

    public void setPrevAncDate(Date prevAncDate) {
        this.prevAncDate = prevAncDate;
    }

    public Integer getPrevAncInfraId() {
        return prevAncInfraId;
    }

    public void setPrevAncInfraId(Integer prevAncInfraId) {
        this.prevAncInfraId = prevAncInfraId;
    }

    public String getPrevAncState() {
        return prevAncState;
    }

    public void setPrevAncState(String prevAncState) {
        this.prevAncState = prevAncState;
    }

    public Boolean getIrregularPeriods() {
        return irregularPeriods;
    }

    public void setIrregularPeriods(Boolean irregularPeriods) {
        this.irregularPeriods = irregularPeriods;
    }

    @Override
    public String toString() {
        return "LmpFollowUpVisit{" + "id=" + id + ", lmp=" + lmp + ", isPregnant=" + isPregnant + ", pregnancyTestDone=" + pregnancyTestDone + ", familyPlanningMethod=" + familyPlanningMethod + ", year=" + year + ", registerNowForPregnancy=" + registerNowForPregnancy + ", memberStatus=" + memberStatus + ", deathDate=" + deathDate + ", placeOfDeath=" + placeOfDeath + ", deathReason=" + deathReason + ", fpInsertOperateDate=" + fpInsertOperateDate + '}';
    }
}

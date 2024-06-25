/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.exception.ImtechoMobileException;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

/**
 *
 * <p>
 *     Define rch_pnc_mother_master entity and its fields.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
@Entity
@Table(name = "rch_pnc_mother_master")
public class PncMotherMaster extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "pnc_master_id")
    private Integer pncMasterId;

    @Column(name = "mother_id")
    private Integer motherId;

    @Column(name = "date_of_delivery")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateOfDelivery;

    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "member_status")
    private String memberStatus;

    @Column(name = "is_alive")
    private Boolean isAlive;

    @Column(name = "ifa_tablets_given")
    private Integer ifaTabletsGiven;

    @Column(name = "received_mebendazole")
    private Boolean receivedMebendazole;

    @Column(name = "calcium_tablets_given")
    private Integer calciumTabletsGiven;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "rch_pnc_mother_danger_signs_rel", joinColumns = @JoinColumn(name = "mother_pnc_id"))
    @Column(name = "mother_danger_signs")
    private Set<Integer> motherDangerSigns;

    @Column(name = "other_danger_sign")
    private String otherDangerSign;

    @Column(name = "mother_referral_done")
    private String motherReferralDone;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "family_planning_method")
    private String familyPlanningMethod;

    @Column(name = "fp_insert_operate_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fpInsertOperateDate;

    @Column(name = "death_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deathDate;

    @Column(name = "place_of_death")
    private String placeOfDeath;

    @Column(name = "death_reason")
    private String deathReason;

    @Column(name = "other_death_reason")
    private String otherDeathReason;

    @Column(name = "is_high_risk_case")
    private Boolean isHighRiskCase;

    @Column(name = "death_infra_id")
    private Integer deathInfrastructureId;

    @Column(name = "blood_transfusion")
    private Boolean bloodTransfusion;

    @Column(name = "iron_def_anemia_inj")
    private String ironDefAnemiaInj;

    @Column(name = "iron_def_anemia_inj_due_date")
    private Date ironDefAnemiaInjDueDate;


    @Column(name = "tetanus1_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date tetanus1Date;


    @Column(name = "tetanus2_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date tetanus2Date;


    @Column(name = "tetanus3_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date tetanus3Date;



    @Column(name = "referral_infra_id")
    private Integer referralInfraId;

    @Column(name = "fp_sub_method")
    private String fpSubMethod;

    @Column(name = "fp_alternative_main_method")
    private String fpAlternativeMainMethod;

    public Date getTetanus1Date() {
        return tetanus1Date;
    }

    public void setTetanus1Date(Date tetanus1Date) {
        if (tetanus1Date != null && tetanus1Date.after(new Date())) {
            throw new ImtechoMobileException("The selected date cannot be future", 100);
        }

        this.tetanus1Date = tetanus1Date;
    }

    public Date getTetanus2Date() {
        return tetanus2Date;
    }

    public void setTetanus2Date(Date tetanus2Date) {
        if (tetanus2Date != null && tetanus2Date.after(new Date())) {
            throw new ImtechoMobileException(" The selected date cannot be future", 100);
        }
        this.tetanus2Date = tetanus2Date;
    }

    public Date getTetanus3Date() {
        return tetanus3Date;
    }

    public void setTetanus3Date(Date tetanus3Date) {
        if (tetanus3Date != null && tetanus3Date.after(new Date())) {
            throw new ImtechoMobileException("The selected date cannot be future", 100);
        }
        this.tetanus3Date = tetanus3Date;
    }

    @Column(name = "fp_alternative_sub_method")
    private String fpAlternativeSubMethod;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "referral_for")
    private String referralFor;

    @Column(name = "other_death_place")
    private String otherDeathPlace;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    @Column(name = "tetanus4_date")
    @Temporal(TemporalType.DATE)
    private Date tetanus4Date;

    @Column(name = "tetanus5_date")
    @Temporal(TemporalType.DATE)
    private Date tetanus5Date;

    @Column(name = "check_for_breastfeeding")
    private Boolean checkForBreastfeeding;

    @Column(name = "payment_type")
    private String paymentType;

    @Column(name = "remarks")
    private String remarks;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPncMasterId() {
        return pncMasterId;
    }

    public void setPncMasterId(Integer pncMasterId) {
        this.pncMasterId = pncMasterId;
    }

    public Integer getMotherId() {
        return motherId;
    }

    public void setMotherId(Integer motherId) {
        this.motherId = motherId;
    }

    public Date getDateOfDelivery() {
        return dateOfDelivery;
    }

    public void setDateOfDelivery(Date dateOfDelivery) {
        if (dateOfDelivery != null && dateOfDelivery.after(new Date())) {
            throw new ImtechoMobileException("Delivery date cannot be future", 100);
        }
        this.dateOfDelivery = dateOfDelivery;
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

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public Boolean getIsAlive() {
        return isAlive;
    }

    public void setIsAlive(Boolean isAlive) {
        this.isAlive = isAlive;
    }

    public Integer getIfaTabletsGiven() {
        return ifaTabletsGiven;
    }

    public void setIfaTabletsGiven(Integer ifaTabletsGiven) {
        this.ifaTabletsGiven = ifaTabletsGiven;
    }

    public Integer getCalciumTabletsGiven() {
        return calciumTabletsGiven;
    }

    public void setCalciumTabletsGiven(Integer calciumTabletsGiven) {
        this.calciumTabletsGiven = calciumTabletsGiven;
    }


    public Set<Integer> getMotherDangerSigns() {
        return motherDangerSigns;
    }

    public void setMotherDangerSigns(Set<Integer> motherDangerSigns) {
        this.motherDangerSigns = motherDangerSigns;
    }

    public String getOtherDangerSign() {
        return otherDangerSign;
    }

    public void setOtherDangerSign(String otherDangerSign) {
        this.otherDangerSign = otherDangerSign;
    }

    public String getMotherReferralDone() {
        return motherReferralDone;
    }

    public void setMotherReferralDone(String motherReferralDone) {
        this.motherReferralDone = motherReferralDone;
    }

    public Integer getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(Integer referralPlace) {
        this.referralPlace = referralPlace;
    }

    public String getFamilyPlanningMethod() {
        return familyPlanningMethod;
    }

    public void setFamilyPlanningMethod(String familyPlanningMethod) {
        this.familyPlanningMethod = familyPlanningMethod;
    }

    public Date getFpInsertOperateDate() {
        return fpInsertOperateDate;
    }

    public void setFpInsertOperateDate(Date fpInsertOperateDate) {
        this.fpInsertOperateDate = fpInsertOperateDate;
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

    public Boolean getIsHighRiskCase() {
        return isHighRiskCase;
    }

    public void setIsHighRiskCase(Boolean isHighRiskCase) {
        this.isHighRiskCase = isHighRiskCase;
    }

    public Integer getDeathInfrastructureId() {
        return deathInfrastructureId;
    }

    public void setDeathInfrastructureId(Integer deathInfrastructureId) {
        this.deathInfrastructureId = deathInfrastructureId;
    }

    public Boolean getBloodTransfusion() {
        return bloodTransfusion;
    }

    public void setBloodTransfusion(Boolean bloodTransfusion) {
        this.bloodTransfusion = bloodTransfusion;
    }

    public String getIronDefAnemiaInj() {
        return ironDefAnemiaInj;
    }

    public void setIronDefAnemiaInj(String ironDefAnemiaInj) {
        this.ironDefAnemiaInj = ironDefAnemiaInj;
    }

    public Date getIronDefAnemiaInjDueDate() {
        return ironDefAnemiaInjDueDate;
    }

    public void setIronDefAnemiaInjDueDate(Date ironDefAnemiaInjDueDate) {
        this.ironDefAnemiaInjDueDate = ironDefAnemiaInjDueDate;
    }

    public Integer getReferralInfraId() {
        return referralInfraId;
    }

    public void setReferralInfraId(Integer referralInfraId) {
        this.referralInfraId = referralInfraId;
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

    public String getReferralReason() {
        return referralReason;
    }

    public void setReferralReason(String referralReason) {
        this.referralReason = referralReason;
    }

    public String getReferralFor() {
        return referralFor;
    }

    public void setReferralFor(String referralFor) {
        this.referralFor = referralFor;
    }

    public String getOtherDeathPlace() {
        return otherDeathPlace;
    }

    public void setOtherDeathPlace(String otherDeathPlace) {
        this.otherDeathPlace = otherDeathPlace;
    }

    public Date getTetanus4Date() {
        return tetanus4Date;
    }

    public void setTetanus4Date(Date tetanus4Date) {
        this.tetanus4Date = tetanus4Date;
    }

    public Date getTetanus5Date() {
        return tetanus5Date;
    }

    public void setTetanus5Date(Date tetanus5Date) {
        this.tetanus5Date = tetanus5Date;
    }

    public Boolean getCheckForBreastfeeding() {
        return checkForBreastfeeding;
    }

    public void setCheckForBreastfeeding(Boolean checkForBreastfeeding) {
        this.checkForBreastfeeding = checkForBreastfeeding;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }



    public Boolean getIecGiven() {
        return isIecGiven;
    }

    public void setIecGiven(Boolean iecGiven) {
        isIecGiven = iecGiven;
    }

    public Boolean getReceivedMebendazole() {
        return receivedMebendazole;
    }

    public void setReceivedMebendazole(Boolean receivedMebendazole) {
        this.receivedMebendazole = receivedMebendazole;
    }



    /**
     * Define fields name for rch_pnc_mother_master entity.
     */
    public static class Fields {
        private Fields(){}
        public static final String ID = "id";
        public static final String MOTHER_ID = "motherId";
        public static final String SERVICE_DATE = "serviceDate";
        public static final String REFERRAL_PLACE = "referralPlace";
        public static final String DEATH_DATE = "deathDate";
        public static final String DEATH_REASON = "deathReason";
    }


    @Override
    public String toString() {
        return "PncMotherMaster{" +
                "id=" + id +
                ", pncMasterId=" + pncMasterId +
                ", motherId=" + motherId +
                ", dateOfDelivery=" + dateOfDelivery +
                ", serviceDate=" + serviceDate +
                ", memberStatus='" + memberStatus + '\'' +
                ", isAlive=" + isAlive +
                ", ifaTabletsGiven=" + ifaTabletsGiven +
                ",receivedMebendazole="+ receivedMebendazole+
                ", calciumTabletsGiven=" + calciumTabletsGiven +
                ", motherDangerSigns=" + motherDangerSigns +
                ", otherDangerSign='" + otherDangerSign + '\'' +
                ", motherReferralDone='" + motherReferralDone + '\'' +
                ", referralPlace=" + referralPlace +
                ", familyPlanningMethod='" + familyPlanningMethod + '\'' +
                ", fpInsertOperateDate=" + fpInsertOperateDate +
                ", deathDate=" + deathDate +
                ", placeOfDeath='" + placeOfDeath + '\'' +
                ", deathReason='" + deathReason + '\'' +
                ", otherDeathReason='" + otherDeathReason + '\'' +
                ", isHighRiskCase=" + isHighRiskCase +
                ", deathInfrastructureId=" + deathInfrastructureId +
                ", bloodTransfusion=" + bloodTransfusion +
                ", ironDefAnemiaInj='" + ironDefAnemiaInj + '\'' +
                ", ironDefAnemiaInjDueDate=" + ironDefAnemiaInjDueDate +
                ", tetanus1Date=" + tetanus1Date +
                ", tetanus2Date=" + tetanus2Date +
                ", tetanus3Date=" + tetanus3Date +
                ", referralInfraId=" + referralInfraId +
                '}';
    }

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;
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
 * <p>
 *     Define rch_child_service_master entity and its fields.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
@Entity
@Table(name = "rch_child_service_master")
public class ChildServiceMaster extends VisitCommonFields implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private Integer id;

    @Column(name = "member_status")
    private String memberStatus;

    @Column(name = "is_alive")
    private Boolean isAlive;

    @Column(name = "death_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deathDate;

    @Column(name = "place_of_death")
    private String placeOfDeath;

    @Column(name = "death_reason")
    private String deathReason;

    @Column(name = "other_death_reason")
    private String otherDeathReason;

    //    @ElementCollection(fetch = FetchType.EAGER)
//    @CollectionTable(name = "rch_child_service_death_reason_rel", joinColumns = @JoinColumn(name = "child_service_id"))
//    @Column(name = "child_death_reason")
//    private Set<Integer> childDeathReason;
    @Column(name = "weight", columnDefinition = "numeric", precision = 7, scale = 3)
    private Float weight;

    @Column(name = "ifa_syrup_given")
    private Boolean ifaSyrupGiven;

    @Column(name = "complementary_feeding_started")
    private Boolean complementaryFeedingStarted;

    @Column(name = "complementary_feeding_start_period")
    private String complementaryFeedingStartPeriod;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "rch_child_service_diseases_rel", joinColumns = @JoinColumn(name = "child_service_id"))
    @Column(name = "diseases")
    private Set<Integer> dieseases;

    @Column(name = "other_diseases")
    private String otherDiseases;

    @Column(name = "is_treatement_done")
    private String isTreatementDone;

    @Column(name = "mid_arm_circumference", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float midArmCircumference;

    @Column(name = "height")
    private Integer height;

    @Column(name = "have_pedal_edema")
    private Boolean havePedalEdema;

    @Column(name = "exclusively_breastfeded")
    private Boolean exclusivelyBreastfeded;

    @Column(name = "any_vaccination_pending")
    private Boolean anyVaccinationPending;

    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "sd_score")
    private String sdScore;

    @Column(name = "is_from_web")
    private Boolean isFromWeb;

    @Column(name = "delivery_place")
    private String deliveryPlace;

    @Column(name = "type_of_hospital")
    private Integer typeOfHospital;

    @Column(name = "health_infrastructure_id")
    private Integer healthInfrastructureId;

    @Column(name = "delivery_done_by")
    private String deliveryDoneBy;

    @Column(name = "delivery_person")
    private Integer deliveryPerson;

    @Column(name = "delivery_person_name")
    private String deliveryPersonName;

    @Column(name = "is_high_risk_case")
    private Boolean isHighRiskCase;

    @Column(name = "death_infra_id")
    private Integer deathInfrastructureId;

    @Column(name = "hmis_health_infra_id")
    private Integer hmisHealthInfraId;

    @Column(name = "guardian_one_mobile_number")
    private String guardianOneMobileNumber;

    @Column(name = "guardian_two_mobile_number")
    private String guardianTwoMobileNumber;

    @Column(name = "other_death_place")
    private String otherDeathPlace;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "referral_for")
    private String referralFor;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "delay_in_developmental")
    private Boolean delayInDevelopmental;

    @Column(name = "any_disability")
    private String anyDisability;

    private transient Set<Integer> disabilitiesDetails;

    @Column(name = "other_disability")
    private String otherDisability;
    @Column(name = "delays_observed")
    private String delaysObserved;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "rch_child_service_symptoms_rel", joinColumns = @JoinColumn(name = "child_service_id"))
    @Column(name = "symptoms")
    private Set<Integer> symptoms;

    @Column(name = "other_symptoms")
    private String otherSymptoms;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Boolean getIfaSyrupGiven() {
        return ifaSyrupGiven;
    }

    public void setIfaSyrupGiven(Boolean ifaSyrupGiven) {
        this.ifaSyrupGiven = ifaSyrupGiven;
    }

    public Boolean getComplementaryFeedingStarted() {
        return complementaryFeedingStarted;
    }

    public void setComplementaryFeedingStarted(Boolean complementaryFeedingStarted) {
        this.complementaryFeedingStarted = complementaryFeedingStarted;
    }

    public String getComplementaryFeedingStartPeriod() {
        return complementaryFeedingStartPeriod;
    }

    public void setComplementaryFeedingStartPeriod(String complementaryFeedingStartPeriod) {
        this.complementaryFeedingStartPeriod = complementaryFeedingStartPeriod;
    }

    public Set<Integer> getDieseases() {
        return dieseases;
    }

    public void setDieseases(Set<Integer> dieseases) {
        this.dieseases = dieseases;
    }

    public String getOtherDiseases() {
        return otherDiseases;
    }

    public void setOtherDiseases(String otherDiseases) {
        this.otherDiseases = otherDiseases;
    }

    public String getIsTreatementDone() {
        return isTreatementDone;
    }

    public void setIsTreatementDone(String isTreatementDone) {
        this.isTreatementDone = isTreatementDone;
    }

    public Float getMidArmCircumference() {
        return midArmCircumference;
    }

    public void setMidArmCircumference(Float midArmCircumference) {
        this.midArmCircumference = midArmCircumference;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    public Boolean getHavePedalEdema() {
        return havePedalEdema;
    }

    public void setHavePedalEdema(Boolean havePedalEdema) {
        this.havePedalEdema = havePedalEdema;
    }

    public Boolean getExclusivelyBreastfeded() {
        return exclusivelyBreastfeded;
    }

    public void setExclusivelyBreastfeded(Boolean exclusivelyBreastfeded) {
        this.exclusivelyBreastfeded = exclusivelyBreastfeded;
    }

    public Boolean getAnyVaccinationPending() {
        return anyVaccinationPending;
    }

    public void setAnyVaccinationPending(Boolean anyVaccinationPending) {
        this.anyVaccinationPending = anyVaccinationPending;
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

    public String getSdScore() {
        return sdScore;
    }

    public void setSdScore(String sdScore) {
        this.sdScore = sdScore;
    }

    public Boolean getIsFromWeb() {
        return isFromWeb;
    }

    public void setIsFromWeb(Boolean isFromWeb) {
        this.isFromWeb = isFromWeb;
    }

    public String getDeliveryPlace() {
        return deliveryPlace;
    }

    public void setDeliveryPlace(String deliveryPlace) {
        this.deliveryPlace = deliveryPlace;
    }

    public Integer getTypeOfHospital() {
        return typeOfHospital;
    }

    public void setTypeOfHospital(Integer typeOfHospital) {
        this.typeOfHospital = typeOfHospital;
    }

    public Integer getHealthInfrastructureId() {
        return healthInfrastructureId;
    }

    public void setHealthInfrastructureId(Integer healthInfrastructureId) {
        this.healthInfrastructureId = healthInfrastructureId;
    }

    public String getDeliveryDoneBy() {
        return deliveryDoneBy;
    }

    public void setDeliveryDoneBy(String deliveryDoneBy) {
        this.deliveryDoneBy = deliveryDoneBy;
    }

    public Integer getDeliveryPerson() {
        return deliveryPerson;
    }

    public void setDeliveryPerson(Integer deliveryPerson) {
        this.deliveryPerson = deliveryPerson;
    }

    public String getDeliveryPersonName() {
        return deliveryPersonName;
    }

    public void setDeliveryPersonName(String deliveryPersonName) {
        this.deliveryPersonName = deliveryPersonName;
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

    public Integer getHmisHealthInfraId() {
        return hmisHealthInfraId;
    }

    public void setHmisHealthInfraId(Integer hmisHealthInfraId) {
        this.hmisHealthInfraId = hmisHealthInfraId;
    }

    public String getGuardianOneMobileNumber() {
        return guardianOneMobileNumber;
    }

    public void setGuardianOneMobileNumber(String guardianOneMobileNumber) {
        this.guardianOneMobileNumber = guardianOneMobileNumber;
    }

    public String getGuardianTwoMobileNumber() {
        return guardianTwoMobileNumber;
    }

    public void setGuardianTwoMobileNumber(String guardianTwoMobileNumber) {
        this.guardianTwoMobileNumber = guardianTwoMobileNumber;
    }

    public String getOtherDeathPlace() {
        return otherDeathPlace;
    }

    public void setOtherDeathPlace(String otherDeathPlace) {
        this.otherDeathPlace = otherDeathPlace;
    }


    public Boolean getIecGiven() {
        return isIecGiven;
    }

    public void setIecGiven(Boolean iecGiven) {
        isIecGiven = iecGiven;
    }

    public Integer getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(Integer referralPlace) {
        this.referralPlace = referralPlace;
    }

    public String getReferralFor() {
        return referralFor;
    }

    public void setReferralFor(String referralFor) {
        this.referralFor = referralFor;
    }

    public String getReferralReason() {
        return referralReason;
    }

    public void setReferralReason(String referralReason) {
        this.referralReason = referralReason;
    }

    public Boolean getDelayInDevelopmental() {
        return delayInDevelopmental;
    }

    public void setDelayInDevelopmental(Boolean delayInDevelopmental) {
        this.delayInDevelopmental = delayInDevelopmental;
    }

    public String getAnyDisability() {
        return anyDisability;
    }

    public void setAnyDisability(String anyDisability) {
        this.anyDisability = anyDisability;
    }

    public Set<Integer> getDisabilitiesDetails() {
        return disabilitiesDetails;
    }

    public void setDisabilitiesDetails(Set<Integer> disabilitiesDetails) {
        this.disabilitiesDetails = disabilitiesDetails;
        setAnyDisability(MemberDataBeanMapper.convertSetToCommaSeparatedString(this.disabilitiesDetails, ","));
    }

    public String getOtherDisability() {
        return otherDisability;
    }

    public void setOtherDisability(String otherDisability) {
        this.otherDisability = otherDisability;
    }

    public String getDelaysObserved() {
        return delaysObserved;
    }

    public void setDelaysObserved(String delaysObserved) {
        this.delaysObserved = delaysObserved;
    }

    public Set<Integer> getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(Set<Integer> symptoms) {
        this.symptoms = symptoms;
    }

    public String getOtherSymptoms() {
        return otherSymptoms;
    }

    public void setOtherSymptoms(String otherSymptoms) {
        this.otherSymptoms = otherSymptoms;
    }

    /**
     * Define fields name for rch_child_service_master entity.
     */
    public static class Fields {
        private Fields(){}
        public static final String ID = "id";
        public static final String DEATH_DATE = "deathDate";
        public static final String DEATH_REASON = "deathReason";
        public static final String SERVICE_DATE = "serviceDate";
    }

    @Override
    public String toString() {
        return "ChildServiceMaster{" + "id=" + id + ", memberStatus=" + memberStatus + ", isAlive=" + isAlive + ", deathDate=" + deathDate + ", placeOfDeath=" + placeOfDeath + ", deathReason=" + deathReason + ", otherDeathReason=" + otherDeathReason + ", weight=" + weight + ", ifaSyrupGiven=" + ifaSyrupGiven + ", complementaryFeedingStarted=" + complementaryFeedingStarted + ", complementaryFeedingStartPeriod=" + complementaryFeedingStartPeriod + ", dieseases=" + dieseases + ", otherDiseases=" + otherDiseases + ", isTreatementDone=" + isTreatementDone + ", midArmCircumference=" + midArmCircumference + ", height=" + height + ", havePedalEdema=" + havePedalEdema + ", exclusivelyBreastfeded=" + exclusivelyBreastfeded + ", anyVaccinationPending=" + anyVaccinationPending + ", serviceDate=" + serviceDate + ", sdScore=" + sdScore + ", isFromWeb=" + isFromWeb + ", deliveryPlace=" + deliveryPlace + ", typeOfHospital=" + typeOfHospital + ", healthInfrastructureId=" + healthInfrastructureId + ", deliveryDoneBy=" + deliveryDoneBy + ", deliveryPerson=" + deliveryPerson + ", deliveryPersonName=" + deliveryPersonName + '}';
    }
}

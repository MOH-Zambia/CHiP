package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "covid_screening_details")
public class CovidScreeningEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;
    @Column(name = "member_id")
    private Integer memberId;
    @Column(name = "family_id")
    private Integer familyId;
    @Column(name = "location_id")
    private Integer locationId;
    @Column(name = "is_dose_one_taken")
    private Boolean isDoseOneTaken;
    @Column(name = "dose_one_name")
    private String doseOneName;
    @Column(name = "dose_one_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseOneDate;
    @Column(name = "is_dose_two_taken")
    private Boolean isDoseTwoTaken;
    @Column(name = "dose_two_name")
    private String doseTwoName;
    @Column(name = "dose_two_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseTwoDate;
    @Column(name = "willing_for_booster_vaccine")
    private Boolean willingForBoosterVaccine;
    @Column(name = "is_booster_dose_given")
    private Boolean isBoosterDoseGiven;
    @Column(name = "booster_name")
    private String boosterName;
    @Column(name = "booster_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date boosterDate;
    @Column(name = "dose_one_schedule_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseOneScheduleDate;
    @Column(name = "dose_two_schedule_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseTwoScheduleDate;
    @Column(name = "booster_dose_schedule_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date boosterDoseScheduleDate;
    @Column(name = "any_reactions")
    private Boolean anyReactions;
    @Column(name = "referral_for")
    private String referralFor;
    @Column(name = "is_iec_given")
    private Boolean isIecGiven;
    @Column(name = "member_status")
    private String memberStatus;
    @Column(name = "reation_and_effects")
    private String reactionAndEffects;
    @Column(name = "other_effects")
    private String otherEffects;
    @Column(name = "is_referral_done")
    private String referralDone;
    @Column(name = "referral_reason")
    private String referralReason;
    @Column(name = "referral_place")
    private Integer referralPlace;
    @Column(name = "vaccination_status")
    @Getter
    @Setter
    private String vaccinationStatus;

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

    public Boolean getDoseOneTaken() {
        return isDoseOneTaken;
    }

    public void setDoseOneTaken(Boolean doseOneTaken) {
        isDoseOneTaken = doseOneTaken;
    }

    public String getDoseOneName() {
        return doseOneName;
    }

    public void setDoseOneName(String doseOneName) {
        this.doseOneName = doseOneName;
    }

    public Date getDoseOneDate() {
        return doseOneDate;
    }

    public void setDoseOneDate(Date doseOneDate) {
        this.doseOneDate = doseOneDate;
    }

    public Boolean getDoseTwoTaken() {
        return isDoseTwoTaken;
    }

    public void setDoseTwoTaken(Boolean doseTwoTaken) {
        isDoseTwoTaken = doseTwoTaken;
    }

    public String getDoseTwoName() {
        return doseTwoName;
    }

    public void setDoseTwoName(String doseTwoName) {
        this.doseTwoName = doseTwoName;
    }

    public Date getDoseTwoDate() {
        return doseTwoDate;
    }

    public void setDoseTwoDate(Date doseTwoDate) {
        this.doseTwoDate = doseTwoDate;
    }

    public Boolean getWillingForBoosterVaccine() {
        return willingForBoosterVaccine;
    }

    public void setWillingForBoosterVaccine(Boolean willingForBoosterVaccine) {
        this.willingForBoosterVaccine = willingForBoosterVaccine;
    }

    public Boolean getBoosterDoseGiven() {
        return isBoosterDoseGiven;
    }

    public void setBoosterDoseGiven(Boolean boosterDoseGiven) {
        isBoosterDoseGiven = boosterDoseGiven;
    }

    public String getBoosterName() {
        return boosterName;
    }

    public void setBoosterName(String boosterName) {
        this.boosterName = boosterName;
    }

    public Date getBoosterDate() {
        return boosterDate;
    }

    public void setBoosterDate(Date boosterDate) {
        this.boosterDate = boosterDate;
    }

    public Date getDoseOneScheduleDate() {
        return doseOneScheduleDate;
    }

    public void setDoseOneScheduleDate(Date doseOneScheduleDate) {
        this.doseOneScheduleDate = doseOneScheduleDate;
    }

    public Date getDoseTwoScheduleDate() {
        return doseTwoScheduleDate;
    }

    public void setDoseTwoScheduleDate(Date doseTwoScheduleDate) {
        this.doseTwoScheduleDate = doseTwoScheduleDate;
    }

    public Date getBoosterDoseScheduleDate() {
        return boosterDoseScheduleDate;
    }

    public void setBoosterDoseScheduleDate(Date boosterDoseScheduleDate) {
        this.boosterDoseScheduleDate = boosterDoseScheduleDate;
    }

    public Boolean getAnyReactions() {
        return anyReactions;
    }

    public void setAnyReactions(Boolean anyReactions) {
        this.anyReactions = anyReactions;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    public String getReferralFor() {
        return referralFor;
    }

    public void setReferralFor(String referralFor) {
        this.referralFor = referralFor;
    }

    public Boolean getIecGiven() {
        return isIecGiven;
    }

    public void setIecGiven(Boolean iecGiven) {
        isIecGiven = iecGiven;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public String getReactionAndEffects() {
        return reactionAndEffects;
    }

    public void setReactionAndEffects(String reactionAndEffects) {
        this.reactionAndEffects = reactionAndEffects;
    }

    public String getOtherEffects() {
        return otherEffects;
    }

    public void setOtherEffects(String otherEffects) {
        this.otherEffects = otherEffects;
    }

    public String getReferralDone() {
        return referralDone;
    }

    public void setReferralDone(String referralDone) {
        this.referralDone = referralDone;
    }

    public String getReferralReason() {
        return referralReason;
    }

    public void setReferralReason(String referralReason) {
        this.referralReason = referralReason;
    }

    public Integer getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(Integer referralPlace) {
        this.referralPlace = referralPlace;
    }
}

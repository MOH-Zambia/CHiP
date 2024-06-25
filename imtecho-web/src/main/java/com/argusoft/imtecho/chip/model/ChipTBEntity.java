package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "tuberculosis_screening_details")
public class ChipTBEntity extends EntityAuditInfo implements Serializable {

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

    @Column(name = "tuberculosis_symptoms")
    private String tuberculosisSymptoms;

    @Column(name = "is_tb_testing_done")
    private Boolean isTbTestingDone;

    @Column(name = "tb_test_type")
    private String tbTestType;

    @Column(name = "is_tb_suspected")
    private Boolean isTbSuspected;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "referral_for")
    private String referralFor;

    @Column(name = "is_tb_cured")
    private Boolean isTbCured;

    @Column(name = "is_patient_taking_medicines")
    private Boolean isPatientTakingMedicines;

    @Column(name = "any_reaction_or_side_effect")
    private Boolean anyReactionOrSideEffect;

    @Column(name = "form_type")
    private String formType;

    @Column(name = "other_tb_symptoms")
    private String otherTbSymptoms;

    @Column(name = "is_referral_done")
    private String referralDone;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "started_menstruating")
    private Boolean startedMenstruating;

    @Column(name = "lmp_date")
    @Temporal(TemporalType.DATE)
    private Date lmpDate;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    @Column(name = "member_status")
    private String memberStatus;


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

    public String getTuberculosisSymptoms() {
        return tuberculosisSymptoms;
    }

    public void setTuberculosisSymptoms(String tuberculosisSymptoms) {
        this.tuberculosisSymptoms = tuberculosisSymptoms;
    }

    public Boolean getTbTestingDone() {
        return isTbTestingDone;
    }

    public void setTbTestingDone(Boolean tbTestingDone) {
        isTbTestingDone = tbTestingDone;
    }

    public String getTbTestType() {
        return tbTestType;
    }

    public void setTbTestType(String tbTestType) {
        this.tbTestType = tbTestType;
    }

    public Boolean getTbSuspected() {
        return isTbSuspected;
    }

    public void setTbSuspected(Boolean tbSuspected) {
        isTbSuspected = tbSuspected;
    }

    public Integer getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(Integer referralPlace) {
        this.referralPlace = referralPlace;
    }

    public Boolean getTbCured() {
        return isTbCured;
    }

    public void setTbCured(Boolean tbCured) {
        isTbCured = tbCured;
    }

    public Boolean getPatientTakingMedicines() {
        return isPatientTakingMedicines;
    }

    public void setPatientTakingMedicines(Boolean patientTakingMedicines) {
        isPatientTakingMedicines = patientTakingMedicines;
    }

    public Boolean getAnyReactionOrSideEffect() {
        return anyReactionOrSideEffect;
    }

    public void setAnyReactionOrSideEffect(Boolean anyReactionOrSideEffect) {
        this.anyReactionOrSideEffect = anyReactionOrSideEffect;
    }

    public String getFormType() {
        return formType;
    }

    public void setFormType(String formType) {
        this.formType = formType;
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

    public String getOtherTbSymptoms() {
        return otherTbSymptoms;
    }

    public void setOtherTbSymptoms(String otherTbSymptoms) {
        this.otherTbSymptoms = otherTbSymptoms;
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

    public Boolean getStartedMenstruating() {
        return startedMenstruating;
    }

    public void setStartedMenstruating(Boolean startedMenstruating) {
        this.startedMenstruating = startedMenstruating;
    }

    public Date getLmpDate() {
        return lmpDate;
    }

    public void setLmpDate(Date lmpDate) {
        this.lmpDate = lmpDate;
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
}

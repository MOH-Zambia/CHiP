package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "malaria_details")
public class ChipMalariaEntity extends EntityAuditInfo implements Serializable {

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

    @Column(name = "active_malaria_symptoms")
    private String activeMalariaSymptoms;

    private transient Set<Integer> activeMalariaSDetails;

    @Column(name = "rdt_test_status")
    private String rdtTestStatus;

    @Column(name = "having_travel_history")
    private Boolean havingTravelHistory;

    @Column(name = "malaria_treatment_history")
    private Boolean malariaTreatmentHistory;

    @Column(name = "is_treatment_being_given")
    private Boolean isTreatmentBeingGiven;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "malaria_type")
    private String malariaType;

    @Column(name = "other_malaria_symptoms")
    private String otherMalariaSymtoms;

    @Column(name = "is_referral_done")
    private String referralDone;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "referral_for")
    private String referralFor;

    @Column(name = "started_menstruating")
    private Boolean startedMenstruating;

    @Column(name = "lmp_date")
    @Temporal(TemporalType.DATE)
    private Date lmpDate;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    @Column(name = "is_index_case")
    private Boolean isIndexCase;

    @Column(name = "member_status")
    private String memberStatus;

    @Column(name = "treatment_given")
    @Getter
    @Setter
    private String treatmentGiven;

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

    public String getActiveMalariaSymptoms() {
        return activeMalariaSymptoms;
    }

    public void setActiveMalariaSymptoms(String activeMalariaSymptoms) {
        this.activeMalariaSymptoms = activeMalariaSymptoms;
    }

    public String getRdtTestStatus() {
        return rdtTestStatus;
    }

    public void setRdtTestStatus(String rdtTestStatus) {
        this.rdtTestStatus = rdtTestStatus;
    }

    public Boolean getHavingTravelHistory() {
        return havingTravelHistory;
    }

    public void setHavingTravelHistory(Boolean havingTravelHistory) {
        this.havingTravelHistory = havingTravelHistory;
    }

    public Boolean getMalariaTreatmentHistory() {
        return malariaTreatmentHistory;
    }

    public void setMalariaTreatmentHistory(Boolean malariaTreatmentHistory) {
        this.malariaTreatmentHistory = malariaTreatmentHistory;
    }

    public Boolean getTreatmentBeingGiven() {
        return isTreatmentBeingGiven;
    }

    public void setTreatmentBeingGiven(Boolean treatmentBeingGiven) {
        isTreatmentBeingGiven = treatmentBeingGiven;
    }

    public Integer getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(Integer referralPlace) {
        this.referralPlace = referralPlace;
    }

    public String getMalariaType() {
        return malariaType;
    }

    public void setMalariaType(String malariaType) {
        this.malariaType = malariaType;
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

    public String getOtherMalariaSymtoms() {
        return otherMalariaSymtoms;
    }

    public void setOtherMalariaSymtoms(String otherMalariaSymtoms) {
        this.otherMalariaSymtoms = otherMalariaSymtoms;
    }

    public String getReferralDone() {
        return referralDone;
    }

    public void setReferralDone(String referralDone) {
        this.referralDone = referralDone;
    }

    public Set<Integer> getActiveMalariaSDetails() {
        return activeMalariaSDetails;
    }

    public void setActiveMalariaSDetails(Set<Integer> activeMalariaSDetails) {
        this.activeMalariaSDetails = activeMalariaSDetails;
        setActiveMalariaSymptoms(MemberDataBeanMapper.convertSetToCommaSeparatedString(this.activeMalariaSDetails, ","));
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

    public Boolean getIndexCase() {
        return isIndexCase;
    }

    public void setIndexCase(Boolean indexCase) {
        isIndexCase = indexCase;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }
}

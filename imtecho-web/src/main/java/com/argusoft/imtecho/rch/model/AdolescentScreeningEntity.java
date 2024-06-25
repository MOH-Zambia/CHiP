/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

/**
 * @author utkarsh
 */
@Entity
@Table(name = "imt_adolescent_member")
public class AdolescentScreeningEntity extends EntityAuditInfo implements Serializable {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "unique_health_id")
    private String uniqueHealthId;

    @Column(name = "school_actual_id")
    private String schoolActualId;

    @Column(name = "service_location")
    private String serviceLocation;

    private transient Set<String> counsellingDoneDetails;

    @Column(name = "counselling_done")
    private String counsellingDone;

    @Column(name = "height", columnDefinition = "numeric", precision = 7, scale = 3)
    private Float height;

    @Column(name = "weight", columnDefinition = "numeric", precision = 7, scale = 3)
    private Float weight;

    @Column(name = "is_haemoglobin_measured")
    private Boolean isHaemoglobinMeasured;

    @Column(name = "clinical_diagnosis_hb")
    private String clinicalDiagnosisHb;

    @Column(name = "health_infra_id")
    private String healthInfraId;

    @Column(name = "haemoglobin", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float haemoglobin;

    @Column(name = "ifa_tab_taken_last_month")
    private Integer ifaTabTakenLastMonth;

    @Column(name = "ifa_tab_taken_now")
    private Integer ifaTabTakenNow;

    @Column(name = "is_period_started")
    private Boolean isPeriodStarted;

    private transient Set<String> absorbentMaterialUsedDetails;

    @Column(name = "absorbent_material_used")
    private String absorbentMaterialUsed;

    @Column(name = "is_sanitary_pad_given")
    private Boolean isSanitaryPadGiven;

    @Column(name = "no_of_sanitary_pads_given")
    private Integer numberOfSanitaryPadsGiven;

    @Column(name = "lmp_date")
    @Temporal(TemporalType.DATE)
    private Date lmpDate;

    @Column(name = "is_having_menstrual_problem")
    private Boolean isHavingMenstrualProblem;

    private transient Set<String> issueWithMenstruationDetails;

    @Column(name = "issue_with_menstruation")
    private String issueWithMenstruation;

    @Column(name = "is_TD_injection_given")
    private Boolean isTDInjectionGiven;

    @Column(name = "td_injection_date")
    @Temporal(TemporalType.DATE)
    private Date tdInjectionDate;

    @Column(name = "is_albandazole_given_in_last_six_months")
    private Boolean isAlbandazoleGivenInLastSixMonths;

    private transient Set<String> addictionDetails;

    @Column(name = "addiction")
    private String addiction;

    private transient Set<String> majorIllnessDetails;

    @Column(name = "major_illness")
    private String majorIllness;

    @Column(name = "is_having_juvenile_diabetes")
    private Boolean isHavingJuvenileDiabetes;

    @Column(name = "is_interested_in_studying")
    private Boolean isInterestedInStudying;

    @Column(name = "is_behavior_diff_from_others")
    private Boolean isBehaviourDifferentFromOthers;

    @Column(name = "is_member_newly_added")
    private Boolean isMemberNewlyAdded;

    @Column(name = "adolescent_screening_date")
    @Temporal(TemporalType.DATE)
    private Date adolescentScreeningDate;

    @Column(name = "is_suffering_from_rti_sti")
    private Boolean isSufferingFromRtiSti;

    @Column(name = "is_having_skin_disease")
    private Boolean isHavingSkinDisease;

    @Column(name = "had_period_this_month")
    private Boolean hadPeriodThisMonth;

    @Column(name = "is_upt_done")
    private Boolean isUptDone;

    @Column(name = "contraceptive_methods_used")
    private String contraceptiveMethodUsed;

    private transient Set<String> contraceptiveMethodUsedDetails;

    @Column(name = "mental_health_condition")
    private String mentalHealthConditions;

    @Column(name = "current_studying_standard")
    private String currentStudyingStandard;

    @Column(name = "other_diseases")
    private String otherDiseases;

    @Column(name = "knows_about_family_planning")
    private Boolean isKnowingAboutFamilyPlanning;

    @Column(name = "location_id")
    private Integer locationId;

    private transient Set<String> mentalHealthConditionsDetails;


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

    public String getUniqueHealthId() {
        return uniqueHealthId;
    }

    public void setUniqueHealthId(String uniqueHealthId) {
        this.uniqueHealthId = uniqueHealthId;
    }

    public String getServiceLocation() {
        return serviceLocation;
    }

    public void setServiceLocation(String serviceLocation) {
        this.serviceLocation = serviceLocation;
    }

    public Set<String> getCounsellingDoneDetails() {
        return counsellingDoneDetails;
    }

    public void setCounsellingDoneDetails(Set<String> counsellingDoneDetails) {
        this.counsellingDoneDetails = counsellingDoneDetails;
        setCounsellingDone(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.counsellingDoneDetails, ","));
    }

    public String getCounsellingDone() {
        return counsellingDone;
    }

    public void setCounsellingDone(String counsellingDone) {
        this.counsellingDone = counsellingDone;
    }

    public Float getHaemoglobin() {
        return haemoglobin;
    }

    public void setHaemoglobin(Float haemoglobin) {
        this.haemoglobin = haemoglobin;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Float getHeight() {
        return height;
    }

    public void setHeight(Float height) {
        this.height = height;
    }

    public Boolean getPeriodStarted() {
        return isPeriodStarted;
    }

    public void setPeriodStarted(Boolean periodStarted) {
        isPeriodStarted = periodStarted;
    }

    public Boolean getHaemoglobinMeasured() {
        return isHaemoglobinMeasured;
    }

    public void setHaemoglobinMeasured(Boolean haemoglobinMeasured) {
        isHaemoglobinMeasured = haemoglobinMeasured;
    }

    public String getClinicalDiagnosisHb() {
        return clinicalDiagnosisHb;
    }

    public void setClinicalDiagnosisHb(String clinicalDiagnosisHb) {
        this.clinicalDiagnosisHb = clinicalDiagnosisHb;
    }

    public Integer getIfaTabTakenLastMonth() {
        return ifaTabTakenLastMonth;
    }

    public void setIfaTabTakenLastMonth(Integer ifaTabTakenLastMonth) {
        this.ifaTabTakenLastMonth = ifaTabTakenLastMonth;
    }

    public Integer getIfaTabTakenNow() {
        return ifaTabTakenNow;
    }

    public void setIfaTabTakenNow(Integer ifaTabTakenNow) {
        this.ifaTabTakenNow = ifaTabTakenNow;
    }



    public Boolean getSanitaryPadGiven() {
        return isSanitaryPadGiven;
    }

    public void setSanitaryPadGiven(Boolean sanitaryPadGiven) {
        isSanitaryPadGiven = sanitaryPadGiven;
    }

    public Integer getNumberOfSanitaryPadsGiven() {
        return numberOfSanitaryPadsGiven;
    }

    public void setNumberOfSanitaryPadsGiven(Integer numberOfSanitaryPadsGiven) {
        this.numberOfSanitaryPadsGiven = numberOfSanitaryPadsGiven;
    }

    public Boolean getHavingMenstrualProblem() {
        return isHavingMenstrualProblem;
    }

    public void setHavingMenstrualProblem(Boolean havingMenstrualProblem) {
        isHavingMenstrualProblem = havingMenstrualProblem;
    }

    public String getIssueWithMenstruation() {
        return issueWithMenstruation;
    }

    public void setIssueWithMenstruation(String issueWithMenstruation) {
        this.issueWithMenstruation = issueWithMenstruation;
    }

    public Boolean getTDInjectionGiven() {
        return isTDInjectionGiven;
    }

    public void setTDInjectionGiven(Boolean TDInjectionGiven) {
        isTDInjectionGiven = TDInjectionGiven;
    }

    public Date getTdInjectionDate() {
        return tdInjectionDate;
    }

    public void setTdInjectionDate(Date tdInjectionDate) {
        this.tdInjectionDate = tdInjectionDate;
    }

    public Boolean getAlbandazoleGivenInLastSixMonths() {
        return isAlbandazoleGivenInLastSixMonths;
    }

    public void setAlbandazoleGivenInLastSixMonths(Boolean albandazoleGivenInLastSixMonths) {
        isAlbandazoleGivenInLastSixMonths = albandazoleGivenInLastSixMonths;
    }

    public Set<String> getAbsorbentMaterialUsedDetails() {
        return absorbentMaterialUsedDetails;
    }

    public void setAbsorbentMaterialUsedDetails(Set<String> absorbentMaterialUsedDetails) {
        this.absorbentMaterialUsedDetails = absorbentMaterialUsedDetails;
        setAbsorbentMaterialUsed(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.absorbentMaterialUsedDetails, ","));
    }

    public String getAbsorbentMaterialUsed() {
        return absorbentMaterialUsed;
    }

    public void setAbsorbentMaterialUsed(String absorbentMaterialUsed) {
        this.absorbentMaterialUsed = absorbentMaterialUsed;
    }

    public Date getAdolescentScreeningDate() {
        return adolescentScreeningDate;
    }

    public void setAdolescentScreeningDate(Date adolescentScreeningDate) {
        this.adolescentScreeningDate = adolescentScreeningDate;
    }

    public Set<String> getIssueWithMenstruationDetails() {
        return issueWithMenstruationDetails;
    }

    public void setIssueWithMenstruationDetails(Set<String> issueWithMenstruationDetails) {
        this.issueWithMenstruationDetails = issueWithMenstruationDetails;
        setIssueWithMenstruation(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.issueWithMenstruationDetails, ","));
    }

    public String getHealthInfraId() {
        return healthInfraId;
    }

    public void setHealthInfraId(String healthInfraId) {
        this.healthInfraId = healthInfraId;
    }

    public String getSchoolActualId() {
        return schoolActualId;
    }

    public void setSchoolActualId(String schoolActualId) {
        this.schoolActualId = schoolActualId;
    }

    public Boolean getMemberNewlyAdded() {
        return isMemberNewlyAdded;
    }

    public void setMemberNewlyAdded(Boolean memberNewlyAdded) {
        isMemberNewlyAdded = memberNewlyAdded;
    }

    public Date getLmpDate() {
        return lmpDate;
    }

    public void setLmpDate(Date lmpDate) {
        this.lmpDate = lmpDate;
    }

    public Set<String> getAddictionDetails() {
        return addictionDetails;
    }

    public void setAddictionDetails(Set<String> addictionDetails) {
        this.addictionDetails = addictionDetails;
        setAddiction(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.addictionDetails, ","));
    }

    public String getAddiction() {
        return addiction;
    }

    public void setAddiction(String addiction) {
        this.addiction = addiction;
    }

    public Set<String> getMajorIllnessDetails() {
        return majorIllnessDetails;
    }

    public void setMajorIllnessDetails(Set<String> majorIllnessDetails) {
        this.majorIllnessDetails = majorIllnessDetails;
        setMajorIllness(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.majorIllnessDetails, ","));

    }

    public String getMajorIllness() {
        return majorIllness;
    }

    public void setMajorIllness(String majorIllness) {
        this.majorIllness = majorIllness;
    }

    public Boolean getHavingJuvenileDiabetes() {
        return isHavingJuvenileDiabetes;
    }

    public void setHavingJuvenileDiabetes(Boolean havingJuvenileDiabetes) {
        isHavingJuvenileDiabetes = havingJuvenileDiabetes;
    }

    public Boolean getInterestedInStudying() {
        return isInterestedInStudying;
    }

    public void setInterestedInStudying(Boolean interestedInStudying) {
        isInterestedInStudying = interestedInStudying;
    }

    public Boolean getBehaviourDifferentFromOthers() {
        return isBehaviourDifferentFromOthers;
    }

    public void setBehaviourDifferentFromOthers(Boolean behaviourDifferentFromOthers) {
        isBehaviourDifferentFromOthers = behaviourDifferentFromOthers;
    }

    public Boolean getSufferingFromRtiSti() {
        return isSufferingFromRtiSti;
    }

    public void setSufferingFromRtiSti(Boolean sufferingFromRtiSti) {
        isSufferingFromRtiSti = sufferingFromRtiSti;
    }

    public Boolean getHavingSkinDisease() {
        return isHavingSkinDisease;
    }

    public void setHavingSkinDisease(Boolean havingSkinDisease) {
        isHavingSkinDisease = havingSkinDisease;
    }

    public Boolean getHadPeriodThisMonth() {
        return hadPeriodThisMonth;
    }

    public void setHadPeriodThisMonth(Boolean hadPeriodThisMonth) {
        this.hadPeriodThisMonth = hadPeriodThisMonth;
    }

    public Boolean getUptDone() {
        return isUptDone;
    }

    public void setUptDone(Boolean uptDone) {
        isUptDone = uptDone;
    }

    public String getContraceptiveMethodUsed() {
        return contraceptiveMethodUsed;
    }

    public void setContraceptiveMethodUsed(String contraceptiveMethodUsed) {
        this.contraceptiveMethodUsed = contraceptiveMethodUsed;
    }

    public Set<String> getContraceptiveMethodUsedDetails() {
        return contraceptiveMethodUsedDetails;
    }

    public void setContraceptiveMethodUsedDetails(Set<String> contraceptiveMethodUsedDetails) {
        this.contraceptiveMethodUsedDetails = contraceptiveMethodUsedDetails;
        setContraceptiveMethodUsed(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.contraceptiveMethodUsedDetails, ","));
    }

    public String getMentalHealthConditions() {
        return mentalHealthConditions;
    }

    public void setMentalHealthConditions(String mentalHealthConditions) {
        this.mentalHealthConditions = mentalHealthConditions;
    }

    public Set<String> getMentalHealthConditionsDetails() {
        return mentalHealthConditionsDetails;
    }

    public void setMentalHealthConditionsDetails(Set<String> mentalHealthConditionsDetails) {
        this.mentalHealthConditionsDetails = mentalHealthConditionsDetails;
        setMentalHealthConditions(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.mentalHealthConditionsDetails, ","));
    }

    public String getCurrentStudyingStandard() {
        return currentStudyingStandard;
    }

    public void setCurrentStudyingStandard(String currentStudyingStandard) {
        this.currentStudyingStandard = currentStudyingStandard;
    }

    public String getOtherDiseases() {
        return otherDiseases;
    }

    public void setOtherDiseases(String otherDiseases) {
        this.otherDiseases = otherDiseases;
    }

    public Boolean getKnowingAboutFamilyPlanning() {
        return isKnowingAboutFamilyPlanning;
    }

    public void setKnowingAboutFamilyPlanning(Boolean knowingAboutFamilyPlanning) {
        isKnowingAboutFamilyPlanning = knowingAboutFamilyPlanning;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    @Override
    public String toString() {
        return "AdolescentScreeningEntity{" +
                "id=" + id +
                ", memberId=" + memberId +
                ", uniqueHealthId='" + uniqueHealthId + '\'' +
                ", schoolActualId='" + schoolActualId + '\'' +
                ", serviceLocation='" + serviceLocation + '\'' +
                ", counsellingDoneDetails=" + counsellingDoneDetails +
                ", counsellingDone='" + counsellingDone + '\'' +
                ", height=" + height +
                ", weight=" + weight +
                ", isHaemoglobinMeasured=" + isHaemoglobinMeasured +
                ", clinicalDiagnosisHb='" + clinicalDiagnosisHb + '\'' +
                ", healthInfraId='" + healthInfraId + '\'' +
                ", haemoglobin=" + haemoglobin +
                ", ifaTabTakenLastMonth=" + ifaTabTakenLastMonth +
                ", ifaTabTakenNow=" + ifaTabTakenNow +
                ", isPeriodStarted=" + isPeriodStarted +
                ", absorbentMaterialUsedDetails=" + absorbentMaterialUsedDetails +
                ", absorbentMaterialUsed='" + absorbentMaterialUsed + '\'' +
                ", isSanitaryPadGiven=" + isSanitaryPadGiven +
                ", numberOfSanitaryPadsGiven=" + numberOfSanitaryPadsGiven +
                ", lmpDate=" + lmpDate +
                ", isHavingMenstrualProblem=" + isHavingMenstrualProblem +
                ", issueWithMenstruationDetails=" + issueWithMenstruationDetails +
                ", issueWithMenstruation='" + issueWithMenstruation + '\'' +
                ", isTDInjectionGiven=" + isTDInjectionGiven +
                ", tdInjectionDate=" + tdInjectionDate +
                ", isAlbandazoleGivenInLastSixMonths=" + isAlbandazoleGivenInLastSixMonths +
                ", addictionDetails=" + addictionDetails +
                ", addiction='" + addiction + '\'' +
                ", majorIllnessDetails=" + majorIllnessDetails +
                ", majorIllness='" + majorIllness + '\'' +
                ", isHavingJuvenileDiabetes=" + isHavingJuvenileDiabetes +
                ", isInterestedInStudying=" + isInterestedInStudying +
                ", isBehaviourDifferentFromOthers=" + isBehaviourDifferentFromOthers +
                ", isMemberNewlyAdded=" + isMemberNewlyAdded +
                ", adolescentScreeningDate=" + adolescentScreeningDate +
                ", isSufferingFromRtiSti=" + isSufferingFromRtiSti +
                ", isHavingSkinDisease=" + isHavingSkinDisease +
                ", hadPeriodThisMonth=" + hadPeriodThisMonth +
                ", isUptDone=" + isUptDone +
                ", contraceptiveMethodUsed='" + contraceptiveMethodUsed + '\'' +
                ", contraceptiveMethodUsedDetails=" + contraceptiveMethodUsedDetails +
                ", mentalHealthConditions='" + mentalHealthConditions + '\'' +
                ", currentStudyingStandard='" + currentStudyingStandard + '\'' +
                ", otherDiseases='" + otherDiseases + '\'' +
                ", isKnowingAboutFamilyPlanning=" + isKnowingAboutFamilyPlanning +
                ", mentalHealthConditionsDetails=" + mentalHealthConditionsDetails +
                '}';
    }
}

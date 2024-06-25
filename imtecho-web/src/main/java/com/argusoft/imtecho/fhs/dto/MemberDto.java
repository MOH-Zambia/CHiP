/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dto;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import java.util.Date;
import java.util.Set;

/**
 * <p>
 * Used for member.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 11:00 AM
 */
public class MemberDto extends EntityAuditInfo {

    private Integer id;
    private Integer fid;       //Family
    private String familyId;
    private String uniqueHealthId;
    private Integer motherId;
    private String areaId;      //Family
    private Integer locationId;    //Family
    private String locationHierarchy;   //Family
    private String firstName;
    private String middleName;
    private String lastName;
    private String healthId;
    private String healthIdNumber;
    private String husbandName;
    private String grandfatherName;
    private String gender;
    private Date dob;
    private Integer age;
    private Integer maritalStatus;
    private String yearOfWedding;
    private String aadharNumber;
    private String mobileNumber;
    private String ifsc;
    private String accountNumber;
    private Boolean familyHeadFlag;
//    private Boolean bplFlag;    //Family
//    private String caste;       //Family
//    private String maaVatsalyaCardNumber;       //Family
    private Boolean isPregnantFlag;
    private Date lmpDate;
    private Date edd;
    private Short normalCycleDays;
    private String familyPlanningMethod;
    private Integer gravida;
    private String state;
    private Boolean isMobileNumberVerified;
    private Boolean isNativeFlag;
    private Integer educationStatus;
    private Integer currentState;
    private Boolean isReport;
    private Set<Integer> chronicDiseaseDetails;
    private Set<Integer> congenitalAnomalyDetails;
    private Set<Integer> currentDiseaseDetails;
    private Set<Integer> eyeIssueDetails;
    private Boolean isEarlyRegistration;
//    private Boolean isJsyBeneficiary;
//    private Boolean isKpsyBeneficiary;
//    private Boolean isIayBeneficiary;
//    private Boolean isChiranjeeviYojnaBeneficiary;
    private String wpdState;
    private String immunisationGiven;
    private String bloodGroup;
    private Float weight;
    private Float haemoglobin;
    private String ancVisitDates;
    private Integer curPregRegDetId;
    private Date curPregRegDate;
    private Date lastDeliveryDate;
    private String lastDeliveryOutcome;
    private String additionalInfo;
    private String ashaInfo;
    private String anmInfo;
    private Date eligibleCoupleDate;
    private Short currentGravida;
    private Integer familyPlanningHealthInfrastructure;
    private String basicState;
    private String lastMethodOfContraception;
    private String relationWithHof;
    private String chronicDiseases; // comma separated
    private String hofMobileNumber;
    private Boolean isHighRiskCase;
    private Boolean healthInsurance;
//    private String schemeDetail;
    private String rchId;
    private Long memberId;

    private String counsellingDone;

    private Float height;

    private Boolean isHaemoglobinMeasured;

    private Integer ifaTabTakenLastMonth;

    private Integer ifaTabTakenNow;

    private Boolean isPeriodStarted;

    private String absorbentMaterialUsed;

    private Boolean isSanitaryPadGiven;

    private Integer noOfSanitaryPadsGiven;

    private Boolean isHavingMenstrualProblem;

    private String issueWithMenstruation;

    private Boolean isTdInjectionGiven;

    private Date tdInjectionDate;

    private Boolean isAlbandazoleGivenInLastSixMonths;

    private Date adolescentScreeningDate;

    private Integer currentStudyingStandard;

    private Long currentSchool;

    private String religion;

//    private Long anganwadiId;

    private String concatWs;

    private String searchText;
    private String deliveryOutcome;

    private String deliveryPlace;

    private String deliveryType;

    private String motherComplication;

    private String address;

    public MemberDto() {
    }

    public MemberDto(Integer id, Integer fid, String familyId, String uniqueHealthId, Integer motherId, String areaId, Integer locationId, String locationHierarchy, String firstName, String middleName, String lastName, String husbandName, String grandfatherName, String gender, Date dob, Integer age, Integer maritalStatus, String yearOfWedding, String aadharNumber, String mobileNumber, String ifsc, String accountNumber, Boolean familyHeadFlag, Boolean isPregnantFlag, Date lmpDate, Date edd, Short normalCycleDays, String familyPlanningMethod, Integer gravida, String state, Boolean isMobileNumberVerified, Boolean isNativeFlag, Integer educationStatus, Integer currentState, Boolean isReport, Set<Integer> chronicDiseaseDetails, Set<Integer> congenitalAnomalyDetails, Set<Integer> currentDiseaseDetails, Set<Integer> eyeIssueDetails, Boolean isEarlyRegistration, String wpdState, String immunisationGiven, String bloodGroup, Float weight, Float haemoglobin, String ancVisitDates, Integer curPregRegDetId, Date curPregRegDate, Date lastDeliveryDate, String lastDeliveryOutcome, String additionalInfo, String ashaInfo, String anmInfo, Date eligibleCoupleDate, Short currentGravida, Integer familyPlanningHealthInfrastructure, String basicState, String lastMethodOfContraception, String relationWithHof, String chronicDiseases, String rchId, String deliveryOutcome, String deliveryPlace, String deliveryType, String motherComplication, String address) {
        this.id = id;
        this.fid = fid;
        this.familyId = familyId;
        this.uniqueHealthId = uniqueHealthId;

        this.motherId = motherId;
        this.areaId = areaId;
        this.locationId = locationId;
        this.locationHierarchy = locationHierarchy;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.husbandName = husbandName;
        this.grandfatherName = grandfatherName;
        this.gender = gender;
        this.dob = dob;
        this.age = age;
        this.maritalStatus = maritalStatus;
        this.yearOfWedding = yearOfWedding;
        this.aadharNumber = aadharNumber;
        this.mobileNumber = mobileNumber;
        this.ifsc = ifsc;
        this.accountNumber = accountNumber;
        this.familyHeadFlag = familyHeadFlag;
//        this.bplFlag = bplFlag;
//        this.caste = caste;
//        this.maaVatsalyaCardNumber = maaVatsalyaCardNumber;
        this.isPregnantFlag = isPregnantFlag;
        this.lmpDate = lmpDate;
        this.edd = edd;
        this.normalCycleDays = normalCycleDays;
        this.familyPlanningMethod = familyPlanningMethod;
        this.gravida = gravida;
        this.state = state;
        this.isMobileNumberVerified = isMobileNumberVerified;
        this.isNativeFlag = isNativeFlag;
        this.educationStatus = educationStatus;
        this.currentState = currentState;
        this.isReport = isReport;
        this.chronicDiseaseDetails = chronicDiseaseDetails;
        this.congenitalAnomalyDetails = congenitalAnomalyDetails;
        this.currentDiseaseDetails = currentDiseaseDetails;
        this.eyeIssueDetails = eyeIssueDetails;
        this.isEarlyRegistration = isEarlyRegistration;
//        this.isJsyBeneficiary = isJsyBeneficiary;
//        this.isIayBeneficiary = isIayBeneficiary;
//        this.isChiranjeeviYojnaBeneficiary = isChiranjeeviYojnaBeneficiary;
        this.wpdState = wpdState;
        this.immunisationGiven = immunisationGiven;
        this.bloodGroup = bloodGroup;
        this.weight = weight;
        this.haemoglobin = haemoglobin;
        this.ancVisitDates = ancVisitDates;
        this.curPregRegDetId = curPregRegDetId;
        this.curPregRegDate = curPregRegDate;
        this.lastDeliveryDate = lastDeliveryDate;
        this.lastDeliveryOutcome = lastDeliveryOutcome;
        this.additionalInfo = additionalInfo;
        this.ashaInfo = ashaInfo;
        this.anmInfo = anmInfo;
        this.eligibleCoupleDate = eligibleCoupleDate;
        this.currentGravida = currentGravida;
        this.familyPlanningHealthInfrastructure = familyPlanningHealthInfrastructure;
        this.basicState = basicState;
        this.lastMethodOfContraception = lastMethodOfContraception;
        this.relationWithHof = relationWithHof;
        this.chronicDiseases = chronicDiseases;
        this.rchId = rchId;
        this.deliveryOutcome=deliveryOutcome;
        this.deliveryPlace=deliveryPlace;
        this.deliveryType=deliveryType;
        this.motherComplication=motherComplication;
        this.address=address;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDeliveryPlace() {
        return deliveryPlace;
    }

    public void setDeliveryPlace(String deliveryPlace) {
        this.deliveryPlace = deliveryPlace;
    }

    public String getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(String deliveryType) {
        this.deliveryType = deliveryType;
    }

    public String getMotherComplication() {
        return motherComplication;
    }

    public void setMotherComplication(String motherComplication) {
        this.motherComplication = motherComplication;
    }

    public String getDeliveryOutcome() {
        return deliveryOutcome;
    }

    public void setDeliveryOutcome(String deliveryOutcome) {
        this.deliveryOutcome = deliveryOutcome;
    }

    public String getFamilyId() {
        return familyId;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getGender() {
        return gender;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public Boolean getFamilyHeadFlag() {
        return familyHeadFlag;
    }

    public Date getDob() {
        return dob;
    }

    public String getUniqueHealthId() {
        return uniqueHealthId;
    }

    public String getIfsc() {
        return ifsc;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

//    public String getMaaVatsalyaCardNumber() {
//        return maaVatsalyaCardNumber;
//    }

    public Boolean getIsPregnantFlag() {
        return isPregnantFlag;
    }

    public Date getLmpDate() {
        return lmpDate;
    }

    public String getFamilyPlanningMethod() {
        return familyPlanningMethod;
    }

    public String getGrandfatherName() {
        return grandfatherName;
    }

    public Boolean getIsMobileNumberVerified() {
        return isMobileNumberVerified;
    }

    public Boolean getIsNativeFlag() {
        return isNativeFlag;
    }

    public Boolean getIsReport() {
        return isReport;
    }

    public Integer getId() {
        return id;
    }

    public String getState() {
        return state;
    }

    public Integer getCurrentState() {
        return currentState;
    }

    public void setFamilyId(String familyId) {
        this.familyId = familyId;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setAadharNumber(String aadharNumber) {
        this.aadharNumber = aadharNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public void setFamilyHeadFlag(Boolean familyHeadFlag) {
        this.familyHeadFlag = familyHeadFlag;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public void setUniqueHealthId(String uniqueHealthId) {
        this.uniqueHealthId = uniqueHealthId;
    }

    public void setIfsc(String ifsc) {
        this.ifsc = ifsc;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

//    public void setMaaVatsalyaCardNumber(String maaVatsalyaCardNumber) {
//        this.maaVatsalyaCardNumber = maaVatsalyaCardNumber;
//    }

    public void setIsPregnantFlag(Boolean isPregnantFlag) {
        this.isPregnantFlag = isPregnantFlag;
    }

    public void setLmpDate(Date lmpDate) {
        this.lmpDate = lmpDate;
    }

    public void setFamilyPlanningMethod(String familyPlanningMethod) {
        this.familyPlanningMethod = familyPlanningMethod;
    }

    public void setGrandfatherName(String grandfatherName) {
        this.grandfatherName = grandfatherName;
    }

    public void setIsMobileNumberVerified(Boolean isMobileNumberVerified) {
        this.isMobileNumberVerified = isMobileNumberVerified;
    }

    public void setIsNativeFlag(Boolean isNativeFlag) {
        this.isNativeFlag = isNativeFlag;
    }

    public Integer getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(Integer maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public Short getNormalCycleDays() {
        return normalCycleDays;
    }

    public void setNormalCycleDays(Short normalCycleDays) {
        this.normalCycleDays = normalCycleDays;
    }

    public Integer getEducationStatus() {
        return educationStatus;
    }

    public void setEducationStatus(Integer educationStatus) {
        this.educationStatus = educationStatus;
    }

    public void setIsReport(Boolean isReport) {
        this.isReport = isReport;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setCurrentState(Integer currentState) {
        this.currentState = currentState;
    }

    public Set<Integer> getChronicDiseaseDetails() {
        return chronicDiseaseDetails;
    }

    public void setChronicDiseaseDetails(Set<Integer> chronicDiseaseDetails) {
        this.chronicDiseaseDetails = chronicDiseaseDetails;
    }

    public Set<Integer> getCongenitalAnomalyDetails() {
        return congenitalAnomalyDetails;
    }

    public void setCongenitalAnomalyDetails(Set<Integer> congenitalAnomalyDetails) {
        this.congenitalAnomalyDetails = congenitalAnomalyDetails;
    }

    public Set<Integer> getCurrentDiseaseDetails() {
        return currentDiseaseDetails;
    }

    public void setCurrentDiseaseDetails(Set<Integer> currentDiseaseDetails) {
        this.currentDiseaseDetails = currentDiseaseDetails;
    }

    public Set<Integer> getEyeIssueDetails() {
        return eyeIssueDetails;
    }

    public void setEyeIssueDetails(Set<Integer> eyeIssueDetails) {
        this.eyeIssueDetails = eyeIssueDetails;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getYearOfWedding() {
        return yearOfWedding;
    }

    public void setYearOfWedding(String yearOfWedding) {
        this.yearOfWedding = yearOfWedding;
    }

    public Boolean getIsEarlyRegistration() {
        return isEarlyRegistration;
    }

    public void setIsEarlyRegistration(Boolean isEarlyRegistration) {
        this.isEarlyRegistration = isEarlyRegistration;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Date getEdd() {
        return edd;
    }

    public void setEdd(Date edd) {
        this.edd = edd;
    }

//    public Boolean getIsJsyBeneficiary() {
//        return isJsyBeneficiary;
//    }
//
//    public void setIsJsyBeneficiary(Boolean isJsyBeneficiary) {
//        this.isJsyBeneficiary = isJsyBeneficiary;
//    }

    public String getImmunisationGiven() {
        return immunisationGiven;
    }

    public void setImmunisationGiven(String immunisationGiven) {
        this.immunisationGiven = immunisationGiven;
    }

//    public Boolean getIsKpsyBeneficiary() {
//        return isKpsyBeneficiary;
//    }
//
//    public void setIsKpsyBeneficiary(Boolean isKpsyBeneficiary) {
//        this.isKpsyBeneficiary = isKpsyBeneficiary;
//    }

//    public Boolean getIsIayBeneficiary() {
//        return isIayBeneficiary;
//    }
//
//    public void setIsIayBeneficiary(Boolean isIayBeneficiary) {
//        this.isIayBeneficiary = isIayBeneficiary;
//    }
//
//    public Boolean getIsChiranjeeviYojnaBeneficiary() {
//        return isChiranjeeviYojnaBeneficiary;
//    }
//
//    public void setIsChiranjeeviYojnaBeneficiary(Boolean isChiranjeeviYojnaBeneficiary) {
//        this.isChiranjeeviYojnaBeneficiary = isChiranjeeviYojnaBeneficiary;
//    }

//    public Boolean getBplFlag() {
//        return bplFlag;
//    }
//
//    public void setBplFlag(Boolean bplFlag) {
//        this.bplFlag = bplFlag;
//    }
//
//    public String getCaste() {
//        return caste;
//    }
//
//    public void setCaste(String caste) {
//        this.caste = caste;
//    }

    public String getLocationHierarchy() {
        return locationHierarchy;
    }

    public void setLocationHierarchy(String locationHierarchy) {
        this.locationHierarchy = locationHierarchy;
    }

    public Integer getFid() {
        return fid;
    }

    public void setFid(Integer fid) {
        this.fid = fid;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    public Integer getMotherId() {
        return motherId;
    }

    public void setMotherId(Integer motherId) {
        this.motherId = motherId;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getWpdState() {
        return wpdState;
    }

    public void setWpdState(String wpdState) {
        this.wpdState = wpdState;
    }

    public Float getHaemoglobin() {
        return haemoglobin;
    }

    public void setHaemoglobin(Float haemoglobin) {
        this.haemoglobin = haemoglobin;
    }

    public String getAncVisitDates() {
        return ancVisitDates;
    }

    public void setAncVisitDates(String ancVisitDates) {
        this.ancVisitDates = ancVisitDates;
    }

    public Integer getCurPregRegDetId() {
        return curPregRegDetId;
    }

    public void setCurPregRegDetId(Integer curPregRegDetId) {
        this.curPregRegDetId = curPregRegDetId;
    }

    public Date getCurPregRegDate() {
        return curPregRegDate;
    }

    public void setCurPregRegDate(Date curPregRegDate) {
        this.curPregRegDate = curPregRegDate;
    }

    public Date getLastDeliveryDate() {
        return lastDeliveryDate;
    }

    public void setLastDeliveryDate(Date lastDeliveryDate) {
        this.lastDeliveryDate = lastDeliveryDate;
    }

    public String getLastDeliveryOutcome() {
        return lastDeliveryOutcome;
    }

    public void setLastDeliveryOutcome(String lastDeliveryOutcome) {
        this.lastDeliveryOutcome = lastDeliveryOutcome;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }

    public String getAshaInfo() {
        return ashaInfo;
    }

    public void setAshaInfo(String ashaInfo) {
        this.ashaInfo = ashaInfo;
    }

    public String getAnmInfo() {
        return anmInfo;
    }

    public void setAnmInfo(String anmInfo) {
        this.anmInfo = anmInfo;
    }

    public Integer getGravida() {
        return gravida;
    }

    public void setGravida(Integer gravida) {
        this.gravida = gravida;
    }

    public Date getEligibleCoupleDate() {
        return eligibleCoupleDate;
    }

    public void setEligibleCoupleDate(Date eligibleCoupleDate) {
        this.eligibleCoupleDate = eligibleCoupleDate;
    }

    public String getHusbandName() {
        return husbandName;
    }

    public void setHusbandName(String husbandName) {
        this.husbandName = husbandName;
    }

    public Short getCurrentGravida() {
        return currentGravida;
    }

    public void setCurrentGravida(Short currentGravida) {
        this.currentGravida = currentGravida;
    }

    public Integer getFamilyPlanningHealthInfrastructure() {
        return familyPlanningHealthInfrastructure;
    }

    public void setFamilyPlanningHealthInfrastructure(Integer familyPlanningHealthInfrastructure) {
        this.familyPlanningHealthInfrastructure = familyPlanningHealthInfrastructure;
    }

    public String getBasicState() {
        return basicState;
    }

    public void setBasicState(String basicState) {
        this.basicState = basicState;
    }

    public String getLastMethodOfContraception() {
        return lastMethodOfContraception;
    }

    public void setLastMethodOfContraception(String lastMethodOfContraception) {
        this.lastMethodOfContraception = lastMethodOfContraception;
    }

    public String getRelationWithHof() {
        return relationWithHof;
    }

    public void setRelationWithHof(String relationWithHof) {
        this.relationWithHof = relationWithHof;
    }

    public String getChronicDiseases() {
        return chronicDiseases;
    }

    public void setChronicDiseases(String chronicDiseases) {
        this.chronicDiseases = chronicDiseases;
    }

    public String getHofMobileNumber() {
        return hofMobileNumber;
    }

    public void setHofMobileNumber(String hofMobileNumber) {
        this.hofMobileNumber = hofMobileNumber;
    }

    public Boolean getIsHighRiskCase() {
        return isHighRiskCase;
    }

    public void setIsHighRiskCase(Boolean isHighRiskCase) {
        this.isHighRiskCase = isHighRiskCase;
    }

    public String getHealthId() {
        return healthId;
    }

    public void setHealthId(String healthId) {
        this.healthId = healthId;
    }

    public String getHealthIdNumber() {
        return healthIdNumber;
    }

    public void setHealthIdNumber(String healthIdNumber) {
        this.healthIdNumber = healthIdNumber;
    }

    public Boolean getHealthInsurance() {
        return healthInsurance;
    }

    public void setHealthInsurance(Boolean healthInsurance) {
        this.healthInsurance = healthInsurance;
    }

//    public String getSchemeDetail() {
//        return schemeDetail;
//    }
//
//    public void setSchemeDetail(String schemeDetail) {
//        this.schemeDetail = schemeDetail;
//    }

    public String getRchId() {
        return rchId;
    }

    public void setRchId(String rchId) {
        this.rchId = rchId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getCounsellingDone() {
        return counsellingDone;
    }

    public void setCounsellingDone(String counsellingDone) {
        this.counsellingDone = counsellingDone;
    }

    public Float getHeight() {
        return height;
    }

    public void setHeight(Float height) {
        this.height = height;
    }

    public Boolean getHaemoglobinMeasured() {
        return isHaemoglobinMeasured;
    }

    public void setHaemoglobinMeasured(Boolean haemoglobinMeasured) {
        isHaemoglobinMeasured = haemoglobinMeasured;
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

    public Boolean getPeriodStarted() {
        return isPeriodStarted;
    }

    public void setPeriodStarted(Boolean periodStarted) {
        isPeriodStarted = periodStarted;
    }

    public String getAbsorbentMaterialUsed() {
        return absorbentMaterialUsed;
    }

    public void setAbsorbentMaterialUsed(String absorbentMaterialUsed) {
        this.absorbentMaterialUsed = absorbentMaterialUsed;
    }

    public Boolean getSanitaryPadGiven() {
        return isSanitaryPadGiven;
    }

    public void setSanitaryPadGiven(Boolean sanitaryPadGiven) {
        isSanitaryPadGiven = sanitaryPadGiven;
    }

    public Integer getNoOfSanitaryPadsGiven() {
        return noOfSanitaryPadsGiven;
    }

    public void setNoOfSanitaryPadsGiven(Integer noOfSanitaryPadsGiven) {
        this.noOfSanitaryPadsGiven = noOfSanitaryPadsGiven;
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

    public Boolean getTdInjectionGiven() {
        return isTdInjectionGiven;
    }

    public void setTdInjectionGiven(Boolean tdInjectionGiven) {
        isTdInjectionGiven = tdInjectionGiven;
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

    public Date getAdolescentScreeningDate() {
        return adolescentScreeningDate;
    }

    public void setAdolescentScreeningDate(Date adolescentScreeningDate) {
        this.adolescentScreeningDate = adolescentScreeningDate;
    }

    public Integer getCurrentStudyingStandard() {
        return currentStudyingStandard;
    }

    public void setCurrentStudyingStandard(Integer currentStudyingStandard) {
        this.currentStudyingStandard = currentStudyingStandard;
    }

    public Long getCurrentSchool() {
        return currentSchool;
    }

    public void setCurrentSchool(Long currentSchool) {
        this.currentSchool = currentSchool;
    }

    public String getReligion() {
        return religion;
    }

    public void setReligion(String religion) {
        this.religion = religion;
    }

//    public Long getAnganwadiId() {
//        return anganwadiId;
//    }
//
//    public void setAnganwadiId(Long anganwadiId) {
//        this.anganwadiId = anganwadiId;
//    }

    public String getConcatWs() {
        return concatWs;
    }

    public void setConcatWs(String concatWs) {
        this.concatWs = concatWs;
    }

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    @Override
    public String toString() {
        return "MemberDto{" +
                "id=" + id +
                ", fid=" + fid +
                ", familyId='" + familyId + '\'' +
                ", uniqueHealthId='" + uniqueHealthId + '\'' +
                ", motherId=" + motherId +
                ", areaId='" + areaId + '\'' +
                ", locationId=" + locationId +
                ", locationHierarchy='" + locationHierarchy + '\'' +
                ", firstName='" + firstName + '\'' +
                ", middleName='" + middleName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", husbandName='" + husbandName + '\'' +
                ", grandfatherName='" + grandfatherName + '\'' +
                ", gender='" + gender + '\'' +
                ", dob=" + dob +
                ", age=" + age +
                ", maritalStatus=" + maritalStatus +
                ", yearOfWedding='" + yearOfWedding + '\'' +
                ", aadharNumber='" + aadharNumber + '\'' +
                ", mobileNumber='" + mobileNumber + '\'' +
                ", ifsc='" + ifsc + '\'' +
                ", accountNumber='" + accountNumber + '\'' +
                ", familyHeadFlag=" + familyHeadFlag +
//                ", bplFlag=" + bplFlag +
//                ", caste='" + caste + '\'' +
//                ", maaVatsalyaCardNumber='" + maaVatsalyaCardNumber + '\'' +
                ", isPregnantFlag=" + isPregnantFlag +
                ", lmpDate=" + lmpDate +
                ", edd=" + edd +
                ", normalCycleDays=" + normalCycleDays +
                ", familyPlanningMethod='" + familyPlanningMethod + '\'' +
                ", gravida=" + gravida +
                ", state='" + state + '\'' +
                ", isMobileNumberVerified=" + isMobileNumberVerified +
                ", isNativeFlag=" + isNativeFlag +
                ", educationStatus=" + educationStatus +
                ", currentState=" + currentState +
                ", isReport=" + isReport +
                ", chronicDiseaseDetails=" + chronicDiseaseDetails +
                ", congenitalAnomalyDetails=" + congenitalAnomalyDetails +
                ", currentDiseaseDetails=" + currentDiseaseDetails +
                ", eyeIssueDetails=" + eyeIssueDetails +
                ", isEarlyRegistration=" + isEarlyRegistration +
//                ", isJsyBeneficiary=" + isJsyBeneficiary +
//                ", isIayBeneficiary=" + isIayBeneficiary +
//                ", isChiranjeeviYojnaBeneficiary=" + isChiranjeeviYojnaBeneficiary +
                ", wpdState='" + wpdState + '\'' +
                ", immunisationGiven='" + immunisationGiven + '\'' +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", weight=" + weight +
                ", haemoglobin=" + haemoglobin +
                ", ancVisitDates='" + ancVisitDates + '\'' +
                ", curPregRegDetId=" + curPregRegDetId +
                ", curPregRegDate=" + curPregRegDate +
                ", lastDeliveryDate=" + lastDeliveryDate +
                ", lastDeliveryOutcome='" + lastDeliveryOutcome + '\'' +
                ", additionalInfo='" + additionalInfo + '\'' +
                ", ashaInfo='" + ashaInfo + '\'' +
                ", anmInfo='" + anmInfo + '\'' +
                ", eligibleCoupleDate=" + eligibleCoupleDate +
                ", currentGravida=" + currentGravida +
                ", familyPlanningHealthInfrastructure=" + familyPlanningHealthInfrastructure +
                ", basicState='" + basicState + '\'' +
                ", lastMethodOfContraception='" + lastMethodOfContraception + '\'' +
                ", relationWithHof='" + relationWithHof + '\'' +
                ", chronicDiseases='" + chronicDiseases + '\'' +
                ", rchId='" + rchId + '\'' +
                '}';
    }

}

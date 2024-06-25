/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dto;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

/**
 *
 * <p>
 *     Used for ANC member.
 * </p>
 * @author namrata
 * @since 26/08/20 11:00 AM
 *
 */
public class MemberAncDto extends EntityAuditInfo {

    private Integer id;
    private String familyId;
    private String firstName;
    private String middleName;
    private String lastName;
    private String gender;
    private String maritalStatus;
    private String aadharNumber;
    private String mobileNumber;
    private Boolean familyHeadFlag;
    private Date dob;
    private String uniqueHealthId;
    private String ifsc;
    private String accountNumber;
    private String maaVatsalyaCardNumber;
    private Boolean isPregnantFlag;
    private Date lmpDate;
    private Short normalCycleDays;
    private String familyPlanningMethod;
    private String state;
    private String grandfatherName;
    private String emamtaHealthId;
    private Boolean isMobileNumberVerified;
    private Boolean isNativeFlag;
    private String educationStatus;
    private Integer currentState;
    private Boolean isReport;
    private Integer age;
    private String yearOfWedding;
    private Set<Integer> chronicDiseaseDetails;
    private Set<Integer> congenitalAnomalyDetails;
    private Set<Integer> currentDiseaseDetails;
    private Set<Integer> eyeIssueDetails;
    private String previousIllness;
    private Integer ageAtWedding;
    private String religion;
    private String caste;
    private String earlyRegistration;
    private String tt;
    private String tt1GivenOn;
    private Boolean highRiskConditions;
    private String eligibilityCriteria;
    private List<MemberDto> membersWithLessThan20 = new ArrayList<>();
    private Integer noOfChildrens;
    private Integer noOfMaleChildren;
    private Integer noOfFemaleChildren;

    public MemberAncDto() {
    }

    public MemberAncDto(Integer id, String familyId, String firstName, String middleName, String lastName, String gender, String maritalStatus, String aadharNumber, String mobileNumber, Boolean familyHeadFlag, Date dob, String uniqueHealthId, String ifsc, String accountNumber, String maaVatsalyaCardNumber, Boolean isPregnantFlag, Date lmpDate, Short normalCycleDays, String familyPlanningMethod, String state, String grandfatherName, String emamtaHealthId, Boolean isMobileNumberVerified, Boolean isNativeFlag, String educationStatus, Integer currentState, Boolean isReport, Integer age, String yearOfWedding, String previousIllness,
            Integer ageAtWedding,
            String religion,
            String caste, String earlyRegistration, String tt, String tt1GivenOn, Boolean highRiskConditions, String eligibilityCriteria, Integer noOfChildrens, Integer noOfMaleChildren, Integer noOfFemaleChildren) {
        this.id = id;
        this.familyId = familyId;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
        this.gender = gender;
        this.maritalStatus = maritalStatus;
        this.aadharNumber = aadharNumber;
        this.mobileNumber = mobileNumber;
        this.familyHeadFlag = familyHeadFlag;
        this.dob = dob;
        this.uniqueHealthId = uniqueHealthId;
        this.ifsc = ifsc;
        this.accountNumber = accountNumber;
        this.maaVatsalyaCardNumber = maaVatsalyaCardNumber;
        this.isPregnantFlag = isPregnantFlag;
        this.lmpDate = lmpDate;
        this.normalCycleDays = normalCycleDays;
        this.familyPlanningMethod = familyPlanningMethod;
        this.state = state;
        this.grandfatherName = grandfatherName;
        this.emamtaHealthId = emamtaHealthId;
        this.isMobileNumberVerified = isMobileNumberVerified;
        this.isNativeFlag = isNativeFlag;
        this.educationStatus = educationStatus;
        this.currentState = currentState;
        this.isReport = isReport;
        this.age = age;
        this.yearOfWedding = yearOfWedding;
        this.previousIllness = previousIllness;
        this.ageAtWedding = ageAtWedding;
        this.religion = religion;
        this.caste = caste;
        this.earlyRegistration = earlyRegistration;
        this.tt = tt;
        this.tt1GivenOn = tt1GivenOn;
        this.highRiskConditions = highRiskConditions;
        this.eligibilityCriteria = eligibilityCriteria;
        this.noOfChildrens = noOfChildrens;
        this.noOfMaleChildren = noOfMaleChildren;
        this.noOfFemaleChildren = noOfFemaleChildren;
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

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public String getAadharNumber() {
        return aadharNumber;
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

    public String getMaaVatsalyaCardNumber() {
        return maaVatsalyaCardNumber;
    }

    public Boolean getIsPregnantFlag() {
        return isPregnantFlag;
    }

    public Date getLmpDate() {
        return lmpDate;
    }

    public Short getNormalCycleDays() {
        return normalCycleDays;
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


    public String getEducationStatus() {
        return educationStatus;
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

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
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

    public void setMaaVatsalyaCardNumber(String maaVatsalyaCardNumber) {
        this.maaVatsalyaCardNumber = maaVatsalyaCardNumber;
    }

    public void setIsPregnantFlag(Boolean isPregnantFlag) {
        this.isPregnantFlag = isPregnantFlag;
    }

    public void setLmpDate(Date lmpDate) {
        this.lmpDate = lmpDate;
    }

    public void setNormalCycleDays(Short normalCycleDays) {
        this.normalCycleDays = normalCycleDays;
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

    public void setEducationStatus(String educationStatus) {
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

    public String getPreviousIllness() {
        return previousIllness;
    }

    public void setPreviousIllness(String previousIllness) {
        this.previousIllness = previousIllness;
    }

    public Integer getAgeAtWedding() {
        return ageAtWedding;
    }

    public void setAgeAtWedding(Integer ageAtWedding) {
        this.ageAtWedding = ageAtWedding;
    }

    public String getReligion() {
        return religion;
    }

    public void setReligion(String religion) {
        this.religion = religion;
    }

    public String getCaste() {
        return caste;
    }

    public void setCaste(String caste) {
        this.caste = caste;
    }

    public String getEarlyRegistration() {
        return earlyRegistration;
    }

    public void setEarlyRegistration(String earlyRegistration) {
        this.earlyRegistration = earlyRegistration;
    }

    public String getTt() {
        return tt;
    }

    public void setTt(String tt) {
        this.tt = tt;
    }

    public String getTt1GivenOn() {
        return tt1GivenOn;
    }

    public void setTt1GivenOn(String tt1GivenOn) {
        this.tt1GivenOn = tt1GivenOn;
    }

    public Boolean getHighRiskConditions() {
        return highRiskConditions;
    }

    public void setHighRiskConditions(Boolean highRiskConditions) {
        this.highRiskConditions = highRiskConditions;
    }

    public String getEligibilityCriteria() {
        return eligibilityCriteria;
    }

    public void setEligibilityCriteria(String eligibilityCriteria) {
        this.eligibilityCriteria = eligibilityCriteria;
    }

    public List<MemberDto> getMembersWithLessThan20() {
        return membersWithLessThan20;
    }

    public void setMembersWithLessThan20(List<MemberDto> membersWithLessThan20) {
        this.membersWithLessThan20 = membersWithLessThan20;
    }

    public Integer getNoOfChildrens() {
        return noOfChildrens;
    }

    public void setNoOfChildrens(Integer noOfChildrens) {
        this.noOfChildrens = noOfChildrens;
    }

    public Integer getNoOfMaleChildren() {
        return noOfMaleChildren;
    }

    public void setNoOfMaleChildren(Integer noOfMaleChildren) {
        this.noOfMaleChildren = noOfMaleChildren;
    }

    public Integer getNoOfFemaleChildren() {
        return noOfFemaleChildren;
    }

    public void setNoOfFemaleChildren(Integer noOfFemaleChildren) {
        this.noOfFemaleChildren = noOfFemaleChildren;
    }

    @Override
    public String toString() {
        return "MemberDto{" + "id=" + id + ", familyId=" + familyId + ", firstName=" + firstName + ", middleName=" + middleName + ", lastName=" + lastName + ", gender=" + gender + ", maritalStatus=" + maritalStatus + ", aadharNumber=" + aadharNumber + ", mobileNumber=" + mobileNumber + ", familyHeadFlag=" + familyHeadFlag + ", dob=" + dob + ", uniqueHealthId=" + uniqueHealthId + ", ifsc=" + ifsc + ", accountNumber=" + accountNumber + ", maaVatsalyaCardNumber=" + maaVatsalyaCardNumber + ", isPregnantFlag=" + isPregnantFlag + ", lmpDate=" + lmpDate + ", normalCycleDays=" + normalCycleDays + ", familyPlanningMethod=" + familyPlanningMethod + ", state=" + state + ", grandfatherName=" + grandfatherName + ", emamtaHealthId=" + emamtaHealthId + ", isMobileNumberVerified=" + isMobileNumberVerified + ", isNativeFlag=" + isNativeFlag + ", educationStatus=" + educationStatus + ", currentState=" + currentState + ", isReport=" + isReport  + '}';
    }
}

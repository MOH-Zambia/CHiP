/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.sewa.android.app.model;

import androidx.annotation.NonNull;

import com.argusoft.sewa.android.app.databean.MemberAdditionalInfoDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.google.gson.Gson;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.io.Serializable;
import java.util.Date;

/**
 * @author kunjan
 */
@DatabaseTable
public class MemberBean extends BaseEntity implements Serializable {

    @DatabaseField(index = true)
    private String actualId;

    @DatabaseField(index = true)
    private String familyId;

    @DatabaseField
    private String firstName;

    @DatabaseField
    private String middleName;

    @DatabaseField
    private String lastName;

    @DatabaseField
    private String gender;

    @DatabaseField
    private String maritalStatus;

    @DatabaseField
    private String mobileNumber;

    @DatabaseField
    private String alternateNumber;

    @DatabaseField(index = true)
    private Boolean familyHeadFlag;

    @DatabaseField
    private Date dob;

    @DatabaseField(index = true)
    private String uniqueHealthId;

    @DatabaseField
    private Boolean isPregnantFlag;

    @DatabaseField
    private Date lmpDate;

    @DatabaseField
    private Integer normalCycleDays;

    @DatabaseField
    private String familyPlanningMethod;

    @DatabaseField
    private Date fpInsertOperateDate;

    @DatabaseField
    private String type;

    @DatabaseField
    private String state;

    @DatabaseField
    private String createdBy;

    @DatabaseField
    private String updatedBy;

    @DatabaseField
    private Date createdOn;

    @DatabaseField
    private Date updatedOn;

    @DatabaseField
    private String grandfatherName;

    @DatabaseField
    private String educationStatus;

    @DatabaseField//Comma Separated IDs
    private String congenitalAnomalyIds;

    @DatabaseField//Comma Separated IDs
    private String chronicDiseaseIds;

    @DatabaseField//Comma Separated IDs
    private Boolean underTreatmentChronic;

    @DatabaseField//Comma Separated IDs
    private String currentDiseaseIds;

    @DatabaseField//Comma Separated IDs
    private String eyeIssueIds;

    @DatabaseField
    private String lastMethodOfContraception;

    @DatabaseField
    private Integer yearOfWedding;

    @DatabaseField
    private Boolean isEarlyRegistration;

    @DatabaseField
    private Float haemoglobin;

    @DatabaseField
    private Float weight;

    @DatabaseField
    private Date edd;

    @DatabaseField
    private String ancVisitDates;

    @DatabaseField
    private String immunisationGiven;

    @DatabaseField
    private String bloodGroup;

    @DatabaseField
    private String placeOfBirth;

    @DatabaseField
    private Float birthWeight;

    @DatabaseField
    private Long motherId;

    @DatabaseField
    private Boolean complementaryFeedingStarted;

    @DatabaseField
    private Boolean isHighRiskCase;

    @DatabaseField
    private Long curPregRegDetId;

    @DatabaseField
    private Date curPregRegDate;

    @DatabaseField
    private Boolean menopauseArrived;

    @DatabaseField
    private String syncStatus;

    @DatabaseField
    private Boolean isIucdRemoved;

    @DatabaseField
    private Date iucdRemovalDate;

    @DatabaseField
    private Date lastDeliveryDate;

    @DatabaseField
    private Boolean hysterectomyDone;

    @DatabaseField
    private String childNrcCmtcStatus;

    @DatabaseField
    private String lastDeliveryOutcome;

    //Comma Separated
    @DatabaseField
    private String previousPregnancyComplication;

    @DatabaseField
    private String additionalInfo;

    @DatabaseField
    private Date npcbScreeningDate;

    @DatabaseField
    private Boolean fhsrPhoneVerified;

    @DatabaseField
    private Short currentGravida;

    @DatabaseField
    private Short currentPara;

    @DatabaseField
    private Date dateOfWedding;

    @DatabaseField
    private Long husbandId;

    @DatabaseField
    private String npcbStatus;

    @DatabaseField
    private Boolean isMobileNumberVerified;

    @DatabaseField
    private String relationWithHof;

    @DatabaseField
    private Date cbacDate;

    @DatabaseField
    private String hypYear;         //Comma Separated financial year in which HYPERTENSION Screening is done

    @DatabaseField
    private String oralYear;        //Comma Separated financial year in which ORAL Screening is done

    @DatabaseField
    private String diabetesYear;    //Comma Separated financial year in which DIABETES Screening is done

    @DatabaseField
    private String breastYear;      //Comma Separated financial year in which BREAST Screening is done

    @DatabaseField
    private String cervicalYear;    //Comma Separated financial year in which CERVICAL Screening is done

    @DatabaseField
    private String mentalHealthYear;    //Comma Separated financial year in which Mental health Screening is done

    @DatabaseField
    private String healthYear;    //Comma Separated financial year in which health Screening is done

    @DatabaseField
    private String healthId;

    @DatabaseField
    private String healthIdNumber;

    @DatabaseField
    private Boolean vulnerableFlag;

    @DatabaseField
    private Boolean healthInsurance;

    @DatabaseField
    private String schemeDetail;

    @DatabaseField
    private Boolean isPersonalHistoryDone;

    @DatabaseField
    private Boolean confirmedDiabetes;

    @DatabaseField
    private Boolean suspectedForDiabetes;

    @DatabaseField
    private Integer cbacScore;

    @DatabaseField
    private Boolean sufferingDiabetes;

    @DatabaseField
    private Boolean sufferingHypertension;

    @DatabaseField
    private Boolean sufferingMentalHealth;

    @DatabaseField
    private String alcoholAddiction;

    @DatabaseField
    private String smokingAddiction;

    @DatabaseField
    private String tobaccoAddiction;

    @DatabaseField
    private Boolean moConfirmedDiabetes;

    @DatabaseField
    private Boolean moConfirmedHypertension;

    @DatabaseField
    private Boolean generalScreeningDone;

    @DatabaseField
    private Boolean urineTestDone;

    @DatabaseField
    private String occupation;

    @DatabaseField
    private String physicalDisability;

    @DatabaseField
    private String otherDisability;

    @DatabaseField
    private String cataractSurgery;

    @DatabaseField
    private String otherChronic;

    @DatabaseField
    private String otherEyeIssue;

    @DatabaseField
    private String sickleCellStatus;

    @DatabaseField
    private Boolean isChildGoingSchool;

    @DatabaseField
    private String currentStudyingStandard;

    @DatabaseField
    private String pensionScheme;

    @DatabaseField
    private Long hmisId;

    @DatabaseField
    private Long adolescentScreeningDate;

    @DatabaseField
    private Date hypDiaMentalServiceDate;

    @DatabaseField
    private Date cancerServiceDate;

    @DatabaseField
    private String isHivPositive;

    @DatabaseField
    private String isVdrlPositive;

    @DatabaseField
    private String nutritionStatus;

    @DatabaseField
    private String nrcNumber;

    @DatabaseField
    private Boolean isTbCured;

    @DatabaseField
    private Boolean isTbSuspected;

    @DatabaseField
    private Boolean indexCase;

    @DatabaseField
    private String rdtStatus;

    @DatabaseField
    private String memberReligion;

    @DatabaseField
    private String passportNumber;

    @DatabaseField
    private String searchString;

    @DatabaseField
    private String chronicDiseaseIdsForTreatment;

    @DatabaseField
    private Boolean bcgSurveyStatus;

    @DatabaseField
    private String otherChronicDiseaseTreatment;

    @DatabaseField
    private Boolean bcgEligible;
    @DatabaseField
    private Boolean bcgEligibleFilled;

    @DatabaseField
    private String birthCertNumber;

    @DatabaseField
    private String memberUuid;

    @DatabaseField
    private String familyUuid;

    @DatabaseField
    private String husbandUUID;

    @DatabaseField
    private String motherUUID;

    @DatabaseField
    private Boolean haveNssf;

    @DatabaseField
    private String nssfCardNumber;


    public MemberBean() {
    }

    public MemberBean(MemberDataBean memberDataBean) {
        this.actualId = memberDataBean.getId();
        this.familyId = memberDataBean.getFamilyId();
        this.firstName = memberDataBean.getFirstName();
        this.middleName = memberDataBean.getMiddleName();
        this.lastName = memberDataBean.getLastName();
        this.gender = memberDataBean.getGender();
        this.maritalStatus = memberDataBean.getMaritalStatus();
        this.mobileNumber = memberDataBean.getMobileNumber();
        this.familyHeadFlag = memberDataBean.getFamilyHeadFlag();
        this.uniqueHealthId = memberDataBean.getUniqueHealthId();
        this.isPregnantFlag = memberDataBean.getIsPregnantFlag();
        this.normalCycleDays = memberDataBean.getNormalCycleDays();
        this.familyPlanningMethod = memberDataBean.getFamilyPlanningMethod();
        this.type = memberDataBean.getType();
        this.state = memberDataBean.getState();
        this.createdBy = memberDataBean.getCreatedBy();
        this.updatedBy = memberDataBean.getUpdatedBy();
        this.grandfatherName = memberDataBean.getGrandfatherName();
        this.educationStatus = memberDataBean.getEducationStatus();
        this.congenitalAnomalyIds = memberDataBean.getCongenitalAnomalyIds();
        this.eyeIssueIds = memberDataBean.getEyeIssueIds();
        this.chronicDiseaseIds = memberDataBean.getChronicDiseaseIds();
        this.currentDiseaseIds = memberDataBean.getCurrentDiseaseIds();
        this.lastMethodOfContraception = memberDataBean.getLastMethodOfContraception();
        this.yearOfWedding = memberDataBean.getYearOfWedding();
        this.isEarlyRegistration = memberDataBean.getEarlyRegistration();
        this.haemoglobin = memberDataBean.getHaemoglobin();
        this.weight = memberDataBean.getWeight();
        this.ancVisitDates = memberDataBean.getAncVisitDates();
        this.immunisationGiven = memberDataBean.getImmunisationGiven();
        this.bloodGroup = memberDataBean.getBloodGroup();
        this.birthWeight = memberDataBean.getBirthWeight();
        this.placeOfBirth = memberDataBean.getPlaceOfBirth();
        this.motherId = memberDataBean.getMotherId();
        this.complementaryFeedingStarted = memberDataBean.getComplementaryFeedingStarted();
        this.isHighRiskCase = memberDataBean.getHighRiskCase();
        this.curPregRegDetId = memberDataBean.getCurPregRegDetId();
        this.menopauseArrived = memberDataBean.getMenopauseArrived();
        this.syncStatus = memberDataBean.getSyncStatus();
        this.isIucdRemoved = memberDataBean.getIucdRemoved();
        this.hysterectomyDone = memberDataBean.getHysterectomyDone();
        this.childNrcCmtcStatus = memberDataBean.getChildNrcCmtcStatus();
        this.lastDeliveryOutcome = memberDataBean.getLastDeliveryOutcome();
        this.previousPregnancyComplication = memberDataBean.getPreviousPregnancyComplication();
        this.additionalInfo = memberDataBean.getAdditionalInfo();
        this.fhsrPhoneVerified = memberDataBean.getFhsrPhoneVerified();
        this.currentGravida = memberDataBean.getCurrentGravida();
        this.currentPara = memberDataBean.getCurrentPara();
        this.husbandId = memberDataBean.getHusbandId();
        this.isMobileNumberVerified = memberDataBean.getMobileNumberVerified();
        this.relationWithHof = memberDataBean.getRelationWithHof();
        this.hypYear = memberDataBean.getHypYear();
        this.diabetesYear = memberDataBean.getDiabetesYear();
        this.oralYear = memberDataBean.getOralYear();
        this.breastYear = memberDataBean.getBreastYear();
        this.cervicalYear = memberDataBean.getCervicalYear();
        this.mentalHealthYear = memberDataBean.getMentalHealthYear();
        this.healthId = memberDataBean.getHealthId();
        this.healthIdNumber = memberDataBean.getHealthIdNumber();
        this.vulnerableFlag = memberDataBean.getVulnerableFlag();
        this.healthYear = memberDataBean.getHealthYear();
        this.confirmedDiabetes = memberDataBean.getConfirmedDiabetes();
        this.healthInsurance = memberDataBean.getHealthInsurance();
        this.schemeDetail = memberDataBean.getSchemeDetail();
        this.suspectedForDiabetes = memberDataBean.getSuspectedForDiabetes();
        this.isPersonalHistoryDone = memberDataBean.getPersonalHistoryDone();
        this.cbacScore = memberDataBean.getCbacScore();
        this.sufferingDiabetes = memberDataBean.getSufferingDiabetes();
        this.sufferingHypertension = memberDataBean.getSufferingHypertension();
        this.sufferingMentalHealth = memberDataBean.getSufferingMentalHealth();
        this.alcoholAddiction = memberDataBean.getAlcoholAddiction();
        this.smokingAddiction = memberDataBean.getSmokingAddiction();
        this.tobaccoAddiction = memberDataBean.getTobaccoAddiction();
        this.moConfirmedDiabetes = memberDataBean.getMoConfirmedDiabetes();
        this.moConfirmedHypertension = memberDataBean.getMoConfirmedHypertension();
        this.generalScreeningDone = memberDataBean.getGeneralScreeningDone();
        this.urineTestDone = memberDataBean.getUrineTestDone();
        this.occupation = memberDataBean.getOccupation();
        this.physicalDisability = memberDataBean.getPhysicalDisability();
        this.otherDisability = memberDataBean.getOtherDisability();
        this.otherChronic = memberDataBean.getOtherChronic();
        this.otherEyeIssue = memberDataBean.getOtherEyeIssue();
        this.cataractSurgery = memberDataBean.getCataractSurgery();
        this.sickleCellStatus = memberDataBean.getSickleCellStatus();
        this.isChildGoingSchool = memberDataBean.getIsChildGoingSchool();
        this.currentStudyingStandard = memberDataBean.getCurrentStudyingStandard();
        this.pensionScheme = memberDataBean.getPensionScheme();
        this.underTreatmentChronic = memberDataBean.getUnderTreatmentChronic();
        this.alternateNumber = memberDataBean.getAlternateNumber();
        this.hmisId = memberDataBean.getHmisId();
        this.isHivPositive = memberDataBean.getIsHivPositive();
        this.isVdrlPositive = memberDataBean.getIsVDRLPositive();
        this.nutritionStatus = memberDataBean.getNutritionStatus();
        this.nrcNumber = memberDataBean.getNrcNumber();
        this.memberReligion = memberDataBean.getMemberReligion();
        this.passportNumber = memberDataBean.getPassportNumber();
        this.searchString = memberDataBean.getSearchString();
        this.chronicDiseaseIdsForTreatment = memberDataBean.getChronicDiseaseIdsForTreatment();
        this.otherChronicDiseaseTreatment = memberDataBean.getOtherChronicDiseaseTreatment();
        this.bcgSurveyStatus = memberDataBean.getBcgSurveyStatus();
        this.birthCertNumber = memberDataBean.getBirthCertNumber();
        this.memberUuid = memberDataBean.getMemberUuid();
        this.motherUUID = memberDataBean.getMotherUUID();
        this.husbandUUID = memberDataBean.getHusbandUUID();


        if (memberDataBean.getAdditionalInfo() != null) {
            MemberAdditionalInfoDataBean additionalInfo = new Gson().fromJson(memberDataBean.getAdditionalInfo(), MemberAdditionalInfoDataBean.class);
            this.adolescentScreeningDate = additionalInfo.getAdolescentScreeningDate();
            this.npcbStatus = additionalInfo.getNpcbStatus();
            this.isTbCured = additionalInfo.getTbCured();
            this.isTbSuspected = additionalInfo.getTbSuspected();
            this.indexCase = additionalInfo.getIndexCase();
            this.rdtStatus = additionalInfo.getRdtStatus();
            this.bcgEligible = additionalInfo.getBcgEligible();
            this.bcgEligibleFilled = additionalInfo.getBcgEligibleFilled();

        }

        if (memberDataBean.getDateOfWedding() != null) {
            this.dateOfWedding = new Date(memberDataBean.getDateOfWedding());
        }

        if (memberDataBean.getLmpDate() != null) {
            this.lmpDate = new Date(memberDataBean.getLmpDate());
        }

        if (memberDataBean.getDob() != null) {
            this.dob = new Date(memberDataBean.getDob());
        }

        if (memberDataBean.getCreatedOn() != null) {
            this.createdOn = new Date(memberDataBean.getCreatedOn());
        }

        if (memberDataBean.getUpdatedOn() != null) {
            this.updatedOn = new Date(memberDataBean.getUpdatedOn());
        }

        if (memberDataBean.getEdd() != null) {
            this.edd = new Date(memberDataBean.getEdd());
        }

        if (memberDataBean.getFpInsertOperateDate() != null) {
            this.fpInsertOperateDate = new Date(memberDataBean.getFpInsertOperateDate());
        }

        if (memberDataBean.getIucdRemovalDate() != null) {
            this.iucdRemovalDate = new Date(memberDataBean.getIucdRemovalDate());
        }

        if (memberDataBean.getCurPregRegDate() != null) {
            this.curPregRegDate = new Date(memberDataBean.getCurPregRegDate());
        }

        if (memberDataBean.getLastDeliveryDate() != null) {
            this.lastDeliveryDate = new Date(memberDataBean.getLastDeliveryDate());
        }

        if (memberDataBean.getNpcbScreeningDate() != null) {
            this.npcbScreeningDate = new Date(memberDataBean.getNpcbScreeningDate());
        }

        if (memberDataBean.getCbacDate() != null) {
            this.cbacDate = new Date(memberDataBean.getCbacDate());
        }

        if (memberDataBean.getCancerServiceDate() != null) {
            this.cancerServiceDate = new Date(memberDataBean.getCancerServiceDate());
        }

        if (memberDataBean.getHypDiaMentalServiceDate() != null) {
            this.hypDiaMentalServiceDate = new Date(memberDataBean.getHypDiaMentalServiceDate());
        }
        this.haveNssf = memberDataBean.getHaveNssf();
        this.nssfCardNumber = memberDataBean.getNssfCardNumber();
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

    public String getActualId() {
        return actualId;
    }

    public void setActualId(String actualId) {
        this.actualId = actualId;
    }

    public String getFamilyId() {
        return familyId;
    }

    public void setFamilyId(String familyId) {
        this.familyId = familyId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public Boolean getFamilyHeadFlag() {
        return familyHeadFlag;
    }

    public void setFamilyHeadFlag(Boolean familyHeadFlag) {
        this.familyHeadFlag = familyHeadFlag;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getUniqueHealthId() {
        return uniqueHealthId;
    }

    public void setUniqueHealthId(String uniqueHealthId) {
        this.uniqueHealthId = uniqueHealthId;
    }

    public Boolean getIsPregnantFlag() {
        return isPregnantFlag;
    }

    public void setIsPregnantFlag(Boolean isPregnantFlag) {
        this.isPregnantFlag = isPregnantFlag;
    }

    public Date getLmpDate() {
        return lmpDate;
    }

    public void setLmpDate(Date lmpDate) {
        this.lmpDate = lmpDate;
    }

    public Integer getNormalCycleDays() {
        return normalCycleDays;
    }

    public void setNormalCycleDays(Integer normalCycleDays) {
        this.normalCycleDays = normalCycleDays;
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Date getCreatedOn() {
        return createdOn;
    }

    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }

    public Date getUpdatedOn() {
        return updatedOn;
    }

    public void setUpdatedOn(Date updatedOn) {
        this.updatedOn = updatedOn;
    }

    public String getGrandfatherName() {
        return grandfatherName;
    }

    public void setGrandfatherName(String grandfatherName) {
        this.grandfatherName = grandfatherName;
    }

    public String getEducationStatus() {
        return educationStatus;
    }

    public void setEducationStatus(String educationStatus) {
        this.educationStatus = educationStatus;
    }

    public String getCongenitalAnomalyIds() {
        return congenitalAnomalyIds;
    }

    public void setCongenitalAnomalyIds(String congenitalAnomalyIds) {
        this.congenitalAnomalyIds = congenitalAnomalyIds;
    }

    public String getChronicDiseaseIds() {
        return chronicDiseaseIds;
    }

    public void setChronicDiseaseIds(String chronicDiseaseIds) {
        this.chronicDiseaseIds = chronicDiseaseIds;
    }

    public String getCurrentDiseaseIds() {
        return currentDiseaseIds;
    }

    public void setCurrentDiseaseIds(String currentDiseaseIds) {
        this.currentDiseaseIds = currentDiseaseIds;
    }

    public String getEyeIssueIds() {
        return eyeIssueIds;
    }

    public void setEyeIssueIds(String eyeIssueIds) {
        this.eyeIssueIds = eyeIssueIds;
    }

    public String getLastMethodOfContraception() {
        return lastMethodOfContraception;
    }

    public void setLastMethodOfContraception(String lastMethodOfContraception) {
        this.lastMethodOfContraception = lastMethodOfContraception;
    }

    public Integer getYearOfWedding() {
        return yearOfWedding;
    }

    public void setYearOfWedding(Integer yearOfWedding) {
        this.yearOfWedding = yearOfWedding;
    }

    public Boolean getEarlyRegistration() {
        return isEarlyRegistration;
    }

    public void setEarlyRegistration(Boolean earlyRegistration) {
        isEarlyRegistration = earlyRegistration;
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

    public Date getEdd() {
        return edd;
    }

    public void setEdd(Date edd) {
        this.edd = edd;
    }

    public String getAncVisitDates() {
        return ancVisitDates;
    }

    public void setAncVisitDates(String ancVisitDates) {
        this.ancVisitDates = ancVisitDates;
    }

    public String getImmunisationGiven() {
        return immunisationGiven;
    }

    public void setImmunisationGiven(String immunisationGiven) {
        this.immunisationGiven = immunisationGiven;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public String getPlaceOfBirth() {
        return placeOfBirth;
    }

    public void setPlaceOfBirth(String placeOfBirth) {
        this.placeOfBirth = placeOfBirth;
    }

    public Float getBirthWeight() {
        return birthWeight;
    }

    public void setBirthWeight(Float birthWeight) {
        this.birthWeight = birthWeight;
    }

    public Long getMotherId() {
        return motherId;
    }

    public void setMotherId(Long motherId) {
        this.motherId = motherId;
    }

    public Boolean getComplementaryFeedingStarted() {
        return complementaryFeedingStarted;
    }

    public void setComplementaryFeedingStarted(Boolean complementaryFeedingStarted) {
        this.complementaryFeedingStarted = complementaryFeedingStarted;
    }

    public Boolean getHighRiskCase() {
        return isHighRiskCase;
    }

    public void setHighRiskCase(Boolean highRiskCase) {
        isHighRiskCase = highRiskCase;
    }

    public Long getCurPregRegDetId() {
        return curPregRegDetId;
    }

    public void setCurPregRegDetId(Long curPregRegDetId) {
        this.curPregRegDetId = curPregRegDetId;
    }

    public Date getCurPregRegDate() {
        return curPregRegDate;
    }

    public void setCurPregRegDate(Date curPregRegDate) {
        this.curPregRegDate = curPregRegDate;
    }

    public Boolean getMenopauseArrived() {
        return menopauseArrived;
    }

    public void setMenopauseArrived(Boolean menopauseArrived) {
        this.menopauseArrived = menopauseArrived;
    }

    public String getSyncStatus() {
        return syncStatus;
    }

    public void setSyncStatus(String syncStatus) {
        this.syncStatus = syncStatus;
    }

    public Boolean getIucdRemoved() {
        return isIucdRemoved;
    }

    public void setIucdRemoved(Boolean iucdRemoved) {
        isIucdRemoved = iucdRemoved;
    }

    public Date getIucdRemovalDate() {
        return iucdRemovalDate;
    }

    public void setIucdRemovalDate(Date iucdRemovalDate) {
        this.iucdRemovalDate = iucdRemovalDate;
    }

    public Date getLastDeliveryDate() {
        return lastDeliveryDate;
    }

    public void setLastDeliveryDate(Date lastDeliveryDate) {
        this.lastDeliveryDate = lastDeliveryDate;
    }

    public Boolean getHysterectomyDone() {
        return hysterectomyDone;
    }

    public void setHysterectomyDone(Boolean hysterectomyDone) {
        this.hysterectomyDone = hysterectomyDone;
    }

    public String getChildNrcCmtcStatus() {
        return childNrcCmtcStatus;
    }

    public void setChildNrcCmtcStatus(String childNrcCmtcStatus) {
        this.childNrcCmtcStatus = childNrcCmtcStatus;
    }

    public String getLastDeliveryOutcome() {
        return lastDeliveryOutcome;
    }

    public void setLastDeliveryOutcome(String lastDeliveryOutcome) {
        this.lastDeliveryOutcome = lastDeliveryOutcome;
    }

    public String getPreviousPregnancyComplication() {
        return previousPregnancyComplication;
    }

    public void setPreviousPregnancyComplication(String previousPregnancyComplication) {
        this.previousPregnancyComplication = previousPregnancyComplication;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
        if (additionalInfo != null) {
            this.npcbStatus = new Gson().fromJson(additionalInfo, MemberAdditionalInfoDataBean.class).getNpcbStatus();
            this.adolescentScreeningDate = new Gson().fromJson(additionalInfo, MemberAdditionalInfoDataBean.class).getAdolescentScreeningDate();
        }
    }

    public Date getNpcbScreeningDate() {
        return npcbScreeningDate;
    }

    public void setNpcbScreeningDate(Date npcbScreeningDate) {
        this.npcbScreeningDate = npcbScreeningDate;
    }

    public Boolean getFhsrPhoneVerified() {
        return fhsrPhoneVerified;
    }

    public void setFhsrPhoneVerified(Boolean fhsrPhoneVerified) {
        this.fhsrPhoneVerified = fhsrPhoneVerified;
    }

    public Long getHusbandId() {
        return husbandId;
    }

    public void setHusbandId(Long husbandId) {
        this.husbandId = husbandId;
    }

    public String getNpcbStatus() {
        return npcbStatus;
    }

    public void setNpcbStatus(String npcbStatus) {
        this.npcbStatus = npcbStatus;
    }

    public Boolean getMobileNumberVerified() {
        return isMobileNumberVerified;
    }

    public void setMobileNumberVerified(Boolean mobileNumberVerified) {
        isMobileNumberVerified = mobileNumberVerified;
    }

    public String getRelationWithHof() {
        return relationWithHof;
    }

    public void setRelationWithHof(String relationWithHof) {
        this.relationWithHof = relationWithHof;
    }

    public Date getCbacDate() {
        return cbacDate;
    }

    public void setCbacDate(Date cbacDate) {
        this.cbacDate = cbacDate;
    }

    public String getHypYear() {
        return hypYear;
    }

    public void setHypYear(String hypYear) {
        this.hypYear = hypYear;
    }

    public String getOralYear() {
        return oralYear;
    }

    public void setOralYear(String oralYear) {
        this.oralYear = oralYear;
    }

    public String getDiabetesYear() {
        return diabetesYear;
    }

    public void setDiabetesYear(String diabetesYear) {
        this.diabetesYear = diabetesYear;
    }

    public String getBreastYear() {
        return breastYear;
    }

    public void setBreastYear(String breastYear) {
        this.breastYear = breastYear;
    }

    public String getCervicalYear() {
        return cervicalYear;
    }

    public void setCervicalYear(String cervicalYear) {
        this.cervicalYear = cervicalYear;
    }

    public String getMentalHealthYear() {
        return mentalHealthYear;
    }

    public void setMentalHealthYear(String mentalHealthYear) {
        this.mentalHealthYear = mentalHealthYear;
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

    public Boolean getVulnerableFlag() {
        return vulnerableFlag;
    }

    public void setVulnerableFlag(Boolean vulnerableFlag) {
        this.vulnerableFlag = vulnerableFlag;
    }

    public Boolean getHealthInsurance() {
        return healthInsurance;
    }

    public void setHealthInsurance(Boolean healthInsurance) {
        this.healthInsurance = healthInsurance;
    }

    public String getSchemeDetail() {
        return schemeDetail;
    }

    public void setSchemeDetail(String schemeDetail) {
        this.schemeDetail = schemeDetail;
    }

    public String getHealthYear() {
        return healthYear;
    }

    public void setHealthYear(String healthYear) {
        this.healthYear = healthYear;
    }

    public Boolean getPersonalHistoryDone() {
        return isPersonalHistoryDone;
    }

    public void setPersonalHistoryDone(Boolean personalHistoryDone) {
        isPersonalHistoryDone = personalHistoryDone;
    }

    public Boolean getConfirmedDiabetes() {
        return confirmedDiabetes;
    }

    public void setConfirmedDiabetes(Boolean confirmedDiabetes) {
        this.confirmedDiabetes = confirmedDiabetes;
    }

    public Boolean getSuspectedForDiabetes() {
        return suspectedForDiabetes;
    }

    public void setSuspectedForDiabetes(Boolean suspectedForDiabetes) {
        this.suspectedForDiabetes = suspectedForDiabetes;
    }

    public Integer getCbacScore() {
        return cbacScore;
    }

    public void setCbacScore(Integer cbacScore) {
        this.cbacScore = cbacScore;
    }

    public Boolean getSufferingDiabetes() {
        return sufferingDiabetes;
    }

    public void setSufferingDiabetes(Boolean sufferingDiabetes) {
        this.sufferingDiabetes = sufferingDiabetes;
    }

    public Boolean getSufferingHypertension() {
        return sufferingHypertension;
    }

    public void setSufferingHypertension(Boolean sufferingHypertension) {
        this.sufferingHypertension = sufferingHypertension;
    }

    public Boolean getSufferingMentalHealth() {
        return sufferingMentalHealth;
    }

    public void setSufferingMentalHealth(Boolean sufferingMentalHealth) {
        this.sufferingMentalHealth = sufferingMentalHealth;
    }

    public String getAlcoholAddiction() {
        return alcoholAddiction;
    }

    public void setAlcoholAddiction(String alcoholAddiction) {
        this.alcoholAddiction = alcoholAddiction;
    }

    public String getSmokingAddiction() {
        return smokingAddiction;
    }

    public void setSmokingAddiction(String smokingAddiction) {
        this.smokingAddiction = smokingAddiction;
    }

    public String getTobaccoAddiction() {
        return tobaccoAddiction;
    }

    public void setTobaccoAddiction(String tobaccoAddiction) {
        this.tobaccoAddiction = tobaccoAddiction;
    }

    public Boolean getMoConfirmedDiabetes() {
        return moConfirmedDiabetes;
    }

    public void setMoConfirmedDiabetes(Boolean moConfirmedDiabetes) {
        this.moConfirmedDiabetes = moConfirmedDiabetes;
    }

    public Boolean getMoConfirmedHypertension() {
        return moConfirmedHypertension;
    }

    public void setMoConfirmedHypertension(Boolean moConfirmedHypertension) {
        this.moConfirmedHypertension = moConfirmedHypertension;
    }

    public Boolean getGeneralScreeningDone() {
        return generalScreeningDone;
    }

    public void setGeneralScreeningDone(Boolean generalScreeningDone) {
        this.generalScreeningDone = generalScreeningDone;
    }

    public Boolean getUrineTestDone() {
        return urineTestDone;
    }

    public void setUrineTestDone(Boolean urineTestDone) {
        this.urineTestDone = urineTestDone;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getPhysicalDisability() {
        return physicalDisability;
    }

    public void setPhysicalDisability(String physicalDisability) {
        this.physicalDisability = physicalDisability;
    }

    public String getOtherDisability() {
        return otherDisability;
    }

    public void setOtherDisability(String otherDisability) {
        this.otherDisability = otherDisability;
    }

    public String getCataractSurgery() {
        return cataractSurgery;
    }

    public void setCataractSurgery(String cataractSurgery) {
        this.cataractSurgery = cataractSurgery;
    }

    public String getOtherChronic() {
        return otherChronic;
    }

    public void setOtherChronic(String otherChronic) {
        this.otherChronic = otherChronic;
    }

    public String getOtherEyeIssue() {
        return otherEyeIssue;
    }

    public void setOtherEyeIssue(String otherEyeIssue) {
        this.otherEyeIssue = otherEyeIssue;
    }

    public String getSickleCellStatus() {
        return sickleCellStatus;
    }

    public void setSickleCellStatus(String sickleCellStatus) {
        this.sickleCellStatus = sickleCellStatus;
    }

    public Boolean getIsChildGoingSchool() {
        return isChildGoingSchool;
    }

    public void setIsChildGoingSchool(Boolean isChildGoingSchool) {
        this.isChildGoingSchool = isChildGoingSchool;
    }

    public String getCurrentStudyingStandard() {
        return currentStudyingStandard;
    }

    public void setCurrentStudyingStandard(String currentStudyingStandard) {
        this.currentStudyingStandard = currentStudyingStandard;
    }

    @NonNull
    @Override
    public String toString() {
        return "MemberBean{" +
                "actualId='" + actualId + '\'' +
                ", familyId='" + familyId + '\'' +
                ", firstName='" + firstName + '\'' +
                ", middleName='" + middleName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", gender='" + gender + '\'' +
                ", maritalStatus='" + maritalStatus + '\'' +
                ", mobileNumber='" + mobileNumber + '\'' +
                ", alternateNumber='" + alternateNumber + '\'' +
                ", familyHeadFlag=" + familyHeadFlag +
                ", dob=" + dob +
                ", uniqueHealthId='" + uniqueHealthId + '\'' +
                ", isPregnantFlag=" + isPregnantFlag +
                ", lmpDate=" + lmpDate +
                ", normalCycleDays=" + normalCycleDays +
                ", familyPlanningMethod='" + familyPlanningMethod + '\'' +
                ", fpInsertOperateDate=" + fpInsertOperateDate +
                ", type='" + type + '\'' +
                ", state='" + state + '\'' +
                ", createdBy='" + createdBy + '\'' +
                ", updatedBy='" + updatedBy + '\'' +
                ", createdOn=" + createdOn +
                ", updatedOn=" + updatedOn +
                ", grandfatherName='" + grandfatherName + '\'' +
                ", educationStatus='" + educationStatus + '\'' +
                ", congenitalAnomalyIds='" + congenitalAnomalyIds + '\'' +
                ", chronicDiseaseIds='" + chronicDiseaseIds + '\'' +
                ", underTreatmentChronic=" + underTreatmentChronic +
                ", currentDiseaseIds='" + currentDiseaseIds + '\'' +
                ", eyeIssueIds='" + eyeIssueIds + '\'' +
                ", lastMethodOfContraception='" + lastMethodOfContraception + '\'' +
                ", yearOfWedding=" + yearOfWedding +
                ", isEarlyRegistration=" + isEarlyRegistration +
                ", haemoglobin=" + haemoglobin +
                ", weight=" + weight +
                ", edd=" + edd +
                ", ancVisitDates='" + ancVisitDates + '\'' +
                ", immunisationGiven='" + immunisationGiven + '\'' +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", placeOfBirth='" + placeOfBirth + '\'' +
                ", birthWeight=" + birthWeight +
                ", motherId=" + motherId +
                ", complementaryFeedingStarted=" + complementaryFeedingStarted +
                ", isHighRiskCase=" + isHighRiskCase +
                ", curPregRegDetId=" + curPregRegDetId +
                ", curPregRegDate=" + curPregRegDate +
                ", menopauseArrived=" + menopauseArrived +
                ", syncStatus='" + syncStatus + '\'' +
                ", isIucdRemoved=" + isIucdRemoved +
                ", iucdRemovalDate=" + iucdRemovalDate +
                ", lastDeliveryDate=" + lastDeliveryDate +
                ", hysterectomyDone=" + hysterectomyDone +
                ", childNrcCmtcStatus='" + childNrcCmtcStatus + '\'' +
                ", lastDeliveryOutcome='" + lastDeliveryOutcome + '\'' +
                ", previousPregnancyComplication='" + previousPregnancyComplication + '\'' +
                ", additionalInfo='" + additionalInfo + '\'' +
                ", npcbScreeningDate=" + npcbScreeningDate +
                ", fhsrPhoneVerified=" + fhsrPhoneVerified +
                ", currentGravida=" + currentGravida +
                ", currentPara=" + currentPara +
                ", dateOfWedding=" + dateOfWedding +
                ", husbandId=" + husbandId +
                ", npcbStatus='" + npcbStatus + '\'' +
                ", isMobileNumberVerified=" + isMobileNumberVerified +
                ", relationWithHof='" + relationWithHof + '\'' +
                ", cbacDate=" + cbacDate +
                ", hypYear='" + hypYear + '\'' +
                ", oralYear='" + oralYear + '\'' +
                ", diabetesYear='" + diabetesYear + '\'' +
                ", breastYear='" + breastYear + '\'' +
                ", cervicalYear='" + cervicalYear + '\'' +
                ", mentalHealthYear='" + mentalHealthYear + '\'' +
                ", healthYear='" + healthYear + '\'' +
                ", healthId='" + healthId + '\'' +
                ", healthIdNumber='" + healthIdNumber + '\'' +
                ", vulnerableFlag=" + vulnerableFlag +
                ", healthInsurance=" + healthInsurance +
                ", schemeDetail='" + schemeDetail + '\'' +
                ", isPersonalHistoryDone=" + isPersonalHistoryDone +
                ", confirmedDiabetes=" + confirmedDiabetes +
                ", suspectedForDiabetes=" + suspectedForDiabetes +
                ", cbacScore=" + cbacScore +
                ", sufferingDiabetes=" + sufferingDiabetes +
                ", sufferingHypertension=" + sufferingHypertension +
                ", sufferingMentalHealth=" + sufferingMentalHealth +
                ", alcoholAddiction='" + alcoholAddiction + '\'' +
                ", smokingAddiction='" + smokingAddiction + '\'' +
                ", tobaccoAddiction='" + tobaccoAddiction + '\'' +
                ", moConfirmedDiabetes=" + moConfirmedDiabetes +
                ", moConfirmedHypertension=" + moConfirmedHypertension +
                ", generalScreeningDone=" + generalScreeningDone +
                ", urineTestDone=" + urineTestDone +
                ", occupation='" + occupation + '\'' +
                ", physicalDisability='" + physicalDisability + '\'' +
                ", otherDisability='" + otherDisability + '\'' +
                ", cataractSurgery='" + cataractSurgery + '\'' +
                ", otherChronic='" + otherChronic + '\'' +
                ", otherEyeIssue='" + otherEyeIssue + '\'' +
                ", sickleCellStatus='" + sickleCellStatus + '\'' +
                ", isChildGoingSchool=" + isChildGoingSchool +
                ", currentStudyingStandard='" + currentStudyingStandard + '\'' +
                ", pensionScheme='" + pensionScheme + '\'' +
                ", hmisId=" + hmisId +
                ", adolescentScreeningDate=" + adolescentScreeningDate +
                ", hypDiaMentalServiceDate=" + hypDiaMentalServiceDate +
                ", cancerServiceDate=" + cancerServiceDate +
                ", isHivPositive='" + isHivPositive + '\'' +
                ", isVdrlPositive='" + isVdrlPositive + '\'' +
                ", nutritionStatus='" + nutritionStatus + '\'' +
                ", nrcNumber='" + nrcNumber + '\'' +
                ", isTbCured=" + isTbCured +
                ", isTbSuspected=" + isTbSuspected +
                ", indexCase=" + indexCase +
                ", rdtStatus='" + rdtStatus + '\'' +
                ", memberReligion='" + memberReligion + '\'' +
                ", passportNumber='" + passportNumber + '\'' +
                ", searchString='" + searchString + '\'' +
                ", chronicDiseaseIdsForTreatment='" + chronicDiseaseIdsForTreatment + '\'' +
                ", bcgSurveyStatus=" + bcgSurveyStatus +
                ", otherChronicDiseaseTreatment='" + otherChronicDiseaseTreatment + '\'' +
                ", bcgEligible=" + bcgEligible +
                ", bcgEligibleFilled=" + bcgEligibleFilled +
                ", birthCertNumber='" + birthCertNumber + '\'' +
                ", memberUuid='" + memberUuid + '\'' +
                ", familyUuid='" + familyUuid + '\'' +
                ", husbandUUID='" + husbandUUID + '\'' +
                ", motherUUID='" + motherUUID + '\'' +
                ", haveNssf=" + haveNssf +
                ", nssfCardNumber='" + nssfCardNumber + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        if (!(o instanceof MemberBean)) return false;
        MemberBean that = (MemberBean) o;
        if (this.actualId != null && that.actualId != null) {
            return this.actualId.equals(that.actualId);
        } else if (this.memberUuid != null && that.memberUuid != null) {
            return this.memberUuid.equals(that.memberUuid);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    public String getPensionScheme() {
        return pensionScheme;
    }

    public void setPensionScheme(String pensionScheme) {
        this.pensionScheme = pensionScheme;
    }

    public Boolean getUnderTreatmentChronic() {
        return underTreatmentChronic;
    }

    public void setUnderTreatmentChronic(Boolean underTreatmentChronic) {
        this.underTreatmentChronic = underTreatmentChronic;
    }

    public String getAlternateNumber() {
        return alternateNumber;
    }

    public void setAlternateNumber(String alternateNumber) {
        this.alternateNumber = alternateNumber;
    }

    public Long getHmisId() {
        return hmisId;
    }

    public void setHmisId(Long hmisId) {
        this.hmisId = hmisId;
    }

    public Long getAdolescentScreeningDate() {
        return adolescentScreeningDate;
    }

    public void setAdolescentScreeningDate(Long adolescentScreeningDate) {
        this.adolescentScreeningDate = adolescentScreeningDate;
    }

    public Date getHypDiaMentalServiceDate() {
        return hypDiaMentalServiceDate;
    }

    public void setHypDiaMentalServiceDate(Date hypDiaMentalServiceDate) {
        this.hypDiaMentalServiceDate = hypDiaMentalServiceDate;
    }

    public Date getCancerServiceDate() {
        return cancerServiceDate;
    }

    public void setCancerServiceDate(Date cancerServiceDate) {
        this.cancerServiceDate = cancerServiceDate;
    }

    public String getIsHivPositive() {
        return isHivPositive;
    }

    public void setIsHivPositive(String isHivPositive) {
        this.isHivPositive = isHivPositive;
    }

    public String getIsVdrlPositive() {
        return isVdrlPositive;
    }

    public void setIsVdrlPositive(String isVdrlPositive) {
        this.isVdrlPositive = isVdrlPositive;
    }

    public String getNutritionStatus() {
        return nutritionStatus;
    }

    public void setNutritionStatus(String nutritionStatus) {
        this.nutritionStatus = nutritionStatus;
    }

    public String getNrcNumber() {
        return nrcNumber;
    }

    public void setNrcNumber(String nrcNumber) {
        this.nrcNumber = nrcNumber;
    }

    public Boolean getTbCured() {
        return isTbCured;
    }

    public void setTbCured(Boolean tbCured) {
        isTbCured = tbCured;
    }

    public Boolean getTbSuspected() {
        return isTbSuspected;
    }

    public void setTbSuspected(Boolean tbSuspected) {
        isTbSuspected = tbSuspected;
    }

    public Boolean getIndexCase() {
        return indexCase;
    }

    public void setIndexCase(Boolean indexCase) {
        this.indexCase = indexCase;
    }

    public String getMemberReligion() {
        return memberReligion;
    }

    public void setMemberReligion(String memberReligion) {
        this.memberReligion = memberReligion;
    }

    public String getPassportNumber() {
        return passportNumber;
    }

    public void setPassportNumber(String passportNumber) {
        this.passportNumber = passportNumber;
    }

    public String getSearchString() {
        return searchString;
    }

    public void setSearchString(String searchString) {
        this.searchString = firstName + " " + middleName + " " + lastName + " " + uniqueHealthId + " " + nrcNumber + " " + passportNumber + " " + familyId + " " + mobileNumber;
    }

    public String getChronicDiseaseIdsForTreatment() {
        return chronicDiseaseIdsForTreatment;
    }

    public void setChronicDiseaseIdsForTreatment(String chronicDiseaseIdsForTreatment) {
        this.chronicDiseaseIdsForTreatment = chronicDiseaseIdsForTreatment;
    }

    public Boolean getBcgSurveyStatus() {
        return bcgSurveyStatus;
    }

    public void setBcgSurveyStatus(Boolean bcgSurveyStatus) {
        this.bcgSurveyStatus = bcgSurveyStatus;
    }

    public String getOtherChronicDiseaseTreatment() {
        return otherChronicDiseaseTreatment;
    }

    public void setOtherChronicDiseaseTreatment(String otherChronicDiseaseTreatment) {
        this.otherChronicDiseaseTreatment = otherChronicDiseaseTreatment;
    }

    public Boolean getPregnantFlag() {
        return isPregnantFlag;
    }

    public void setPregnantFlag(Boolean pregnantFlag) {
        isPregnantFlag = pregnantFlag;
    }

    public Boolean getChildGoingSchool() {
        return isChildGoingSchool;
    }

    public void setChildGoingSchool(Boolean childGoingSchool) {
        isChildGoingSchool = childGoingSchool;
    }

    public Boolean getBcgEligible() {
        return bcgEligible;
    }

    public void setBcgEligible(Boolean bcgEligible) {
        this.bcgEligible = bcgEligible;
    }

    public Boolean getBcgEligibleFilled() {
        return bcgEligibleFilled;
    }

    public void setBcgEligibleFilled(Boolean bcgEligibleFilled) {
        this.bcgEligibleFilled = bcgEligibleFilled;
    }

    public String getRdtStatus() {
        return rdtStatus;
    }

    public void setRdtStatus(String rdtStatus) {
        this.rdtStatus = rdtStatus;
    }

    public String getBirthCertNumber() {
        return birthCertNumber;
    }

    public void setBirthCertNumber(String birthCertNumber) {
        this.birthCertNumber = birthCertNumber;
    }

    public String getMemberUuid() {
        return memberUuid;
    }

    public void setMemberUuid(String memberUuid) {
        this.memberUuid = memberUuid;
    }

    public String getFamilyUuid() {
        return familyUuid;
    }

    public void setFamilyUuid(String familyUuid) {
        this.familyUuid = familyUuid;
    }

    public String getHusbandUUID() {
        return husbandUUID;
    }

    public void setHusbandUUID(String husbandUUID) {
        this.husbandUUID = husbandUUID;
    }

    public String getMotherUUID() {
        return motherUUID;
    }

    public void setMotherUUID(String motherUUID) {
        this.motherUUID = motherUUID;
    }

    public Boolean getHaveNssf() {
        return haveNssf;
    }

    public void setHaveNssf(Boolean haveNssf) {
        this.haveNssf = haveNssf;
    }

    public String getNssfCardNumber() {
        return nssfCardNumber;
    }

    public void setNssfCardNumber(String nssfCardNumber) {
        this.nssfCardNumber = nssfCardNumber;
    }
}

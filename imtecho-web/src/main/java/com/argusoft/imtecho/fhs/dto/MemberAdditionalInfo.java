/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dto;

import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;

import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.util.Date;
import java.util.Map;
import java.util.Set;

/**
 * <p>
 * Used for member additional info.
 * </p>
 *
 * @author kunjan
 * @since 26/08/20 11:00 AM
 */
public class MemberAdditionalInfo {

    private Integer height;

    private Float weight;

    private Float haemoglobin;

    private Integer systolicBp;

    private Integer diastolicBp;

    private String ancBloodSugarTest;

    private Integer sugarTestAfterFoodValue;

    private Integer sugarTestBeforeFoodValue;

    private String hbsagTest;

    private String hivTest;

    private String vdrlTest;

    private String sickleCellTest;

    private Boolean albendanzoleGiven;
    private Boolean mebendazoleGiven;
    private Boolean malariaTest;
    private String hivTestResult;
    private Date appointmentDate;
    private Date hivResultDate;
    private String hivStatus;
    private String other;

    private Integer ancIfa;

    private Integer ancFa;

    private Integer ancCalcium;

    private Integer pncIfa;

    private Integer pncCalcium;

    private Boolean pncmebendazole;

    private Date pnctetanus1;

    private Date pnctetanus2;

    private Date pnctetanus3;


    private Integer bloodSugar;

    private String expectedDeliveryPlace;

    private Set<String> previousPregnancyComplication;

    //NCD Related
    private Boolean suspectedForOralCancer;
    //NCD Related
    private Boolean suspectedForCervicalCancer;
    //NCD Related
    private Boolean suspectedForBreastCancer;
    //NCD Related
    private Boolean suspectedForHypertension;
    //NCD Related
    private Boolean suspectedForDiabetes;
    //NCD Related
    private Boolean suspectedForMentalHealth;
    //NCD Related
    private String ncdConfFor;
    //NCD Related
    private Long cbacDate;
    //NCD Related
    private String iaYear;
    private String hypYear;         //Comma Separated financial year in which HYPERTENSION Screening is done
    //NCD Related
    private String oralYear;        //Comma Separated financial year in which ORAL Screening is done
    //NCD Related
    private String diabetesYear;    //Comma Separated financial year in which DIABETES Screening is done
    //NCD Related
    private String breastYear;      //Comma Separated financial year in which BREAST Screening is done
    //NCD Related
    private String cervicalYear;    //Comma Separated financial year in which CERVICAL Screening is done
    //NCD Related
    private String mentalHealthYear;    //Comma Separated financial year in which MENTAL HEALTH Screening is done

    private String healthYear;    //Comma Separated financial year in which HEALTH Screening is done

    private Set<String> cpNegativeQues; //Que Ids Of Cerebral Palsy Questions Where The Answer Was 'No'

    private Long lastServiceLongDate;
    private Long fpServiceDate;

    private String cpState;

    private Boolean phoneVerified;

    private Long lastSamScreeningDate;

    private String ancAshaMorbidity;

    private String wtGainStatus;

    private Map<Long, Float> weightMap;

    private String npcbStatus;

    private Long whatsappConsentOn;

    private Integer givenRUTF;

    private String highRiskReasons;

    private Long lastTHRServiceDate;

    private Float bmi;

    private String diseaseHistory;

    private String otherDiseaseHistory;

    private String riskFactor;

    private String mentalHealthObservation;

    private Boolean confirmedDiabetes;

    private Integer cbacScore;

    private Boolean sufferingDiabetes;

    private Boolean sufferingHypertension;

    private Boolean sufferingMentalHealth;

    private Boolean moConfirmedDiabetes;

    private Boolean moConfirmedHypertension;

    private Boolean generalScreeningDone;

    private Boolean ecgTestDone;

    private Boolean retinopathyTestDone;

    private Boolean urineTestDone;

    private Long hmisId;

    private String schoolActualId;

    private String serviceLocation;

    private transient Set<String> counsellingDoneDetails;

    private String counsellingDone;

    private Boolean isHaemoglobinMeasured;

    private Integer ifaTabTakenLastMonth;

    private Integer ifaTabTakenNow;

    private transient Set<String> absorbentMaterialUsedDetails;

    private String absorbentMaterialUsed;

    private Boolean isSanitaryPadGiven;

    private Integer numberOfSanitaryPadsGiven;

    private Boolean isHavingMenstrualProblem;

    private transient Set<String> issueWithMenstruationDetails;

    private String issueWithMenstruation;

    private Boolean isTDInjectionGiven;

    private Long tdInjectionDate;

    @Temporal(TemporalType.DATE)
    private Date lmpDate;

    private Boolean isAlbandazoleGivenInLastSixMonths;

    private String clinicalDiagnosisHb;

    private String healthInfraId;

    private transient Set<String> addictionDetails;

    private String addiction;

    private transient Set<String> majorIllnessDetails;

    private String majorIllness;

    private Boolean isHavingJuvenileDiabetes;

    private Boolean isInterestedInStudying;

    private Boolean isBehaviourDifferentFromOthers;

    private Boolean isSufferingFromRtiSti;

    private Boolean isHavingSkinDisease;

    private Boolean hadPeriodThisMonth;

    private Boolean isUptDone;

    private String contraceptiveMethodUsed;

    private transient Set<String> contraceptiveMethodUsedDetails;

    private String mentalHealthConditions;

    private transient Set<String> mentalHealthConditionsDetails;

    private Long adolescentScreeningDate;

    private String currentStudyingStandard;

    private String otherDiseases;

    private String pmjayNumber;

    private Boolean isKnowingAboutFamilyPlanning;

    private Boolean isPeriodStarted;

    private Long hypDiaMentalServiceDate;

    private Long cancerServiceDate;

    private String nutritionStatus;

    private String sdScore;

    private Boolean isTbSuspected;

    private Boolean isTbCured;

    private String rdtStatus;
    private Long anemiaServiceDate;
    private String memberAnemiaStatus;

    private Boolean personallyUsingFp;
    private Boolean sickleCellSurveyCompleted; // used for UT survey form related entry check

    private Boolean bcgSurveyStatus;

    private Boolean bcgEligible;

    private Boolean bcgWilling;
    private Boolean indexCase;
    private Boolean bcgEligibleFilled;
    private Boolean havingBirthPlan;
    private Boolean developmentDelays;
    private Short abortionCount;
    private Boolean pmmvyBeneficiary;
    private Boolean pmsmaBeneficiary;
    private Boolean dikariBeneficiary;
    private String hepatitisCTest;
    private Boolean memberRegisteredForAnganwadi;
    private String rchId;
    private Boolean mebendazole1Given;
    private Date mebendazole1Date;
    private Boolean mebendazole2Given;
    private Date mebendazole2Date;

    public Date getPnctetanus1() {
        return pnctetanus1;
    }

    public void setPnctetanus1(Date pnctetanus1) {
        this.pnctetanus1 = pnctetanus1;
    }

    public Date getPnctetanus2() {
        return pnctetanus2;
    }

    public void setPnctetanus2(Date pnctetanus2) {
        this.pnctetanus2 = pnctetanus2;
    }

    public Date getPnctetanus3() {
        return pnctetanus3;
    }

    public void setPnctetanus3(Date pnctetanus3) {
        this.pnctetanus3 = pnctetanus3;
    }

    public Boolean getMebendazole1Given() {
        return mebendazole1Given;
    }

    public void setMebendazole1Given(Boolean mebendazole1Given) {
        this.mebendazole1Given = mebendazole1Given;
    }

    public Date getMebendazole1Date() {
        return mebendazole1Date;
    }

    public void setMebendazole1Date(Date mebendazole1Date) {
        this.mebendazole1Date = mebendazole1Date;
    }

    public Boolean getMebendazole2Given() {
        return mebendazole2Given;
    }

    public void setMebendazole2Given(Boolean mebendazole2Given) {
        this.mebendazole2Given = mebendazole2Given;
    }

    public Date getMebendazole2Date() {
        return mebendazole2Date;
    }

    public void setMebendazole2Date(Date mebendazole2Date) {
        this.mebendazole2Date = mebendazole2Date;
    }


    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Float getHaemoglobin() {
        return haemoglobin;
    }

    public void setHaemoglobin(Float haemoglobin) {
        this.haemoglobin = haemoglobin;
    }

    public Integer getSystolicBp() {
        return systolicBp;
    }

    public void setSystolicBp(Integer systolicBp) {
        this.systolicBp = systolicBp;
    }

    public Integer getDiastolicBp() {
        return diastolicBp;
    }

    public void setDiastolicBp(Integer diastolicBp) {
        this.diastolicBp = diastolicBp;
    }

    public String getAncBloodSugarTest() {
        return ancBloodSugarTest;
    }

    public void setAncBloodSugarTest(String ancBloodSugarTest) {
        this.ancBloodSugarTest = ancBloodSugarTest;
    }

    public Integer getSugarTestAfterFoodValue() {
        return sugarTestAfterFoodValue;
    }

    public void setSugarTestAfterFoodValue(Integer sugarTestAfterFoodValue) {
        this.sugarTestAfterFoodValue = sugarTestAfterFoodValue;
    }

    public Integer getSugarTestBeforeFoodValue() {
        return sugarTestBeforeFoodValue;
    }

    public void setSugarTestBeforeFoodValue(Integer sugarTestBeforeFoodValue) {
        this.sugarTestBeforeFoodValue = sugarTestBeforeFoodValue;
    }

    public String getHbsagTest() {
        return hbsagTest;
    }

    public void setHbsagTest(String hbsagTest) {
        this.hbsagTest = hbsagTest;
    }

    public String getHivTest() {
        return hivTest;
    }

    public void setHivTest(String hivTest) {
        this.hivTest = hivTest;
    }

    public String getVdrlTest() {
        return vdrlTest;
    }

    public void setVdrlTest(String vdrlTest) {
        this.vdrlTest = vdrlTest;
    }

    public String getSickleCellTest() {
        return sickleCellTest;
    }

    public void setSickleCellTest(String sickleCellTest) {
        this.sickleCellTest = sickleCellTest;
    }

    public Boolean getAlbendanzoleGiven() {
        return albendanzoleGiven;
    }

    public void setAlbendanzoleGiven(Boolean albendanzoleGiven) {
        this.albendanzoleGiven = albendanzoleGiven;
    }

    public Boolean getMebendazoleGiven() {
        return mebendazoleGiven;
    }

    public void setMebendazoleGiven(Boolean mebendazoleGiven) {
        this.mebendazoleGiven = mebendazoleGiven;
    }

    public Boolean getMalariaTest() {
        return malariaTest;
    }

    public void setMalariaTest(Boolean malariaTest) {
        this.malariaTest = malariaTest;
    }

    public String getHivTestResult() {
        return hivTestResult;
    }

    public void setHivTestResult(String hivTestResult) {
        this.hivTestResult = hivTestResult;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public Date getHivResultDate() {
        return hivResultDate;
    }

    public void setHivResultDate(Date hivResultDate) {
        this.hivResultDate = hivResultDate;
    }

    public String getHivStatus() {
        return hivStatus;
    }

    public void setHivStatus(String hivStatus) {
        this.hivStatus = hivStatus;
    }

    public String getOther() {
        return other;
    }

    public void setOther(String other) {
        this.other = other;
    }

    public Integer getAncIfa() {
        return ancIfa;
    }

    public void setAncIfa(Integer ancIfa) {
        this.ancIfa = ancIfa;
    }

    public Integer getAncFa() {
        return ancFa;
    }

    public void setAncFa(Integer ancFa) {
        this.ancFa = ancFa;
    }

    public Integer getAncCalcium() {
        return ancCalcium;
    }

    public void setAncCalcium(Integer ancCalcium) {
        this.ancCalcium = ancCalcium;
    }

    public Integer getPncIfa() {
        return pncIfa;
    }

    public void setPncIfa(Integer pncIfa) {
        this.pncIfa = pncIfa;
    }

    public Boolean getPncMebendazole() {
        return pncmebendazole;
    }

    public void setPncMebendazole(Boolean pncmebendazole) {
        this.pncmebendazole = pncmebendazole;
    }

    public Integer getPncCalcium() {
        return pncCalcium;
    }

    public void setPncCalcium(Integer pncCalcium) {
        this.pncCalcium = pncCalcium;
    }

    public Integer getBloodSugar() {
        return bloodSugar;
    }

    public void setBloodSugar(Integer bloodSugar) {
        this.bloodSugar = bloodSugar;
    }

    public String getExpectedDeliveryPlace() {
        return expectedDeliveryPlace;
    }

    public void setExpectedDeliveryPlace(String expectedDeliveryPlace) {
        this.expectedDeliveryPlace = expectedDeliveryPlace;
    }

    public String getIaYear() {
        return iaYear;
    }

    public void setIaYear(String iaYear) {
        this.iaYear = iaYear;
    }

    public Set<String> getPreviousPregnancyComplication() {
        return previousPregnancyComplication;
    }

    public void setPreviousPregnancyComplication(Set<String> previousPregnancyComplication) {
        this.previousPregnancyComplication = previousPregnancyComplication;
    }

    public Boolean getSuspectedForOralCancer() {
        return suspectedForOralCancer;
    }

    public void setSuspectedForOralCancer(Boolean suspectedForOralCancer) {
        this.suspectedForOralCancer = suspectedForOralCancer;
    }

    public Boolean getSuspectedForCervicalCancer() {
        return suspectedForCervicalCancer;
    }

    public void setSuspectedForCervicalCancer(Boolean suspectedForCervicalCancer) {
        this.suspectedForCervicalCancer = suspectedForCervicalCancer;
    }

    public Boolean getSuspectedForBreastCancer() {
        return suspectedForBreastCancer;
    }

    public void setSuspectedForBreastCancer(Boolean suspectedForBreastCancer) {
        this.suspectedForBreastCancer = suspectedForBreastCancer;
    }

    public Long getCbacDate() {
        return cbacDate;
    }

    public void setCbacDate(Long cbacDate) {
        this.cbacDate = cbacDate;
    }

    public Set<String> getCpNegativeQues() {
        return cpNegativeQues;
    }

    public void setCpNegativeQues(Set<String> cpNegativeQues) {
        this.cpNegativeQues = cpNegativeQues;
    }

    public Long getLastServiceLongDate() {
        return lastServiceLongDate;
    }

    public void setLastServiceLongDate(Long lastServiceLongDate) {
        this.lastServiceLongDate = lastServiceLongDate;
    }

    public String getCpState() {
        return cpState;
    }

    public void setCpState(String cpState) {
        this.cpState = cpState;
    }

    public Boolean getPhoneVerified() {
        return phoneVerified;
    }

    public void setPhoneVerified(Boolean phoneVerified) {
        this.phoneVerified = phoneVerified;
    }

    public Long getLastSamScreeningDate() {
        return lastSamScreeningDate;
    }

    public void setLastSamScreeningDate(Long lastSamScreeningDate) {
        this.lastSamScreeningDate = lastSamScreeningDate;
    }

    public String getAncAshaMorbidity() {
        return ancAshaMorbidity;
    }

    public void setAncAshaMorbidity(String ancAshaMorbidity) {
        this.ancAshaMorbidity = ancAshaMorbidity;
    }

    public String getNcdConfFor() {
        return ncdConfFor;
    }

    public void setNcdConfFor(String ncdConfFor) {
        this.ncdConfFor = ncdConfFor;
    }

    public Map<Long, Float> getWeightMap() {
        return weightMap;
    }

    public void setWeightMap(Map<Long, Float> weightMap) {
        this.weightMap = weightMap;
    }

    public String getNpcbStatus() {
        return npcbStatus;
    }

    public void setNpcbStatus(String npcbStatus) {
        this.npcbStatus = npcbStatus;
    }

    public Long getWhatsappConsentOn() {
        return whatsappConsentOn;
    }

    public void setWhatsappConsentOn(Long whatsappConsentOn) {
        this.whatsappConsentOn = whatsappConsentOn;
    }

    public String getWtGainStatus() {
        return wtGainStatus;
    }

    public void setWtGainStatus(String wtGainStatus) {
        this.wtGainStatus = wtGainStatus;
    }

    public Integer getGivenRUTF() {
        return givenRUTF;
    }

    public void setGivenRUTF(Integer givenRUTF) {
        this.givenRUTF = givenRUTF;
    }

    public String getHighRiskReasons() {
        return highRiskReasons;
    }

    public void setHighRiskReasons(String highRiskReasons) {
        this.highRiskReasons = highRiskReasons;
    }

    public Long getLastTHRServiceDate() {
        return lastTHRServiceDate;
    }

    public void setLastTHRServiceDate(Long lastTHRServiceDate) {
        this.lastTHRServiceDate = lastTHRServiceDate;
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

    public Float getBmi() {
        return bmi;
    }

    public void setBmi(Float bmi) {
        this.bmi = bmi;
    }

    public String getDiseaseHistory() {
        return diseaseHistory;
    }

    public void setDiseaseHistory(String diseaseHistory) {
        this.diseaseHistory = diseaseHistory;
    }

    public String getOtherDiseaseHistory() {
        return otherDiseaseHistory;
    }

    public void setOtherDiseaseHistory(String otherDiseaseHistory) {
        this.otherDiseaseHistory = otherDiseaseHistory;
    }

    public String getRiskFactor() {
        return riskFactor;
    }

    public void setRiskFactor(String riskFactor) {
        this.riskFactor = riskFactor;
    }

    public Boolean getSuspectedForHypertension() {
        return suspectedForHypertension;
    }

    public void setSuspectedForHypertension(Boolean suspectedForHypertension) {
        this.suspectedForHypertension = suspectedForHypertension;
    }

    public Boolean getSuspectedForDiabetes() {
        return suspectedForDiabetes;
    }

    public void setSuspectedForDiabetes(Boolean suspectedForDiabetes) {
        this.suspectedForDiabetes = suspectedForDiabetes;
    }

    public String getMentalHealthYear() {
        return mentalHealthYear;
    }

    public void setMentalHealthYear(String mentalHealthYear) {
        this.mentalHealthYear = mentalHealthYear;
    }

    public Boolean getSuspectedForMentalHealth() {
        return suspectedForMentalHealth;
    }

    public void setSuspectedForMentalHealth(Boolean suspectedForMentalHealth) {
        this.suspectedForMentalHealth = suspectedForMentalHealth;
    }

    public String getMentalHealthObservation() {
        return mentalHealthObservation;
    }

    public void setMentalHealthObservation(String mentalHealthObservation) {
        this.mentalHealthObservation = mentalHealthObservation;
    }

    public String getHealthYear() {
        return healthYear;
    }

    public void setHealthYear(String healthYear) {
        this.healthYear = healthYear;
    }

    public Boolean getConfirmedDiabetes() {
        return confirmedDiabetes;
    }

    public void setConfirmedDiabetes(Boolean confirmedDiabetes) {
        this.confirmedDiabetes = confirmedDiabetes;
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

    public Boolean getEcgTestDone() {
        return ecgTestDone;
    }

    public void setEcgTestDone(Boolean ecgTestDone) {
        this.ecgTestDone = ecgTestDone;
    }

    public Boolean getRetinopathyTestDone() {
        return retinopathyTestDone;
    }

    public void setRetinopathyTestDone(Boolean retinopathyTestDone) {
        this.retinopathyTestDone = retinopathyTestDone;
    }

    public Boolean getUrineTestDone() {
        return urineTestDone;
    }

    public void setUrineTestDone(Boolean urineTestDone) {
        this.urineTestDone = urineTestDone;
    }

    public Long getHmisId() {
        return hmisId;
    }

    public void setHmisId(Long hmisId) {
        this.hmisId = hmisId;
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

    public Long getTdInjectionDate() {
        return tdInjectionDate;
    }

    public void setTdInjectionDate(Long tdInjectionDate) {
        this.tdInjectionDate = tdInjectionDate;
    }

    public Boolean getAlbandazoleGivenInLastSixMonths() {
        return isAlbandazoleGivenInLastSixMonths;
    }

    public void setAlbandazoleGivenInLastSixMonths(Boolean albandazoleGivenInLastSixMonths) {
        isAlbandazoleGivenInLastSixMonths = albandazoleGivenInLastSixMonths;
    }

    public Long getAdolescentScreeningDate() {
        return adolescentScreeningDate;
    }

    public void setAdolescentScreeningDate(Long adolescentScreeningDate) {
        this.adolescentScreeningDate = adolescentScreeningDate;
    }

    public Set<String> getIssueWithMenstruationDetails() {
        return issueWithMenstruationDetails;
    }

    public void setIssueWithMenstruationDetails(Set<String> issueWithMenstruationDetails) {
        this.issueWithMenstruationDetails = issueWithMenstruationDetails;
        setIssueWithMenstruation(MemberDataBeanMapper.convertStringSetToCommaSeparatedString(this.issueWithMenstruationDetails, ","));
    }

    public String getClinicalDiagnosisHb() {
        return clinicalDiagnosisHb;
    }

    public void setClinicalDiagnosisHb(String clinicalDiagnosisHb) {
        this.clinicalDiagnosisHb = clinicalDiagnosisHb;
    }

    public String getHealthInfraId() {
        return healthInfraId;
    }

    public void setHealthInfraId(String healthInfraId) {
        this.healthInfraId = healthInfraId;
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

    public String getPmjayNumber() {
        return pmjayNumber;
    }

    public void setPmjayNumber(String pmjayNumber) {
        this.pmjayNumber = pmjayNumber;
    }

    public Boolean getKnowingAboutFamilyPlanning() {
        return isKnowingAboutFamilyPlanning;
    }

    public void setKnowingAboutFamilyPlanning(Boolean knowingAboutFamilyPlanning) {
        isKnowingAboutFamilyPlanning = knowingAboutFamilyPlanning;
    }

    public String getSchoolActualId() {
        return schoolActualId;
    }

    public void setSchoolActualId(String schoolActualId) {
        this.schoolActualId = schoolActualId;
    }

    public Boolean getPeriodStarted() {
        return isPeriodStarted;
    }

    public void setPeriodStarted(Boolean periodStarted) {
        isPeriodStarted = periodStarted;
    }

    public Long getHypDiaMentalServiceDate() {
        return hypDiaMentalServiceDate;
    }

    public void setHypDiaMentalServiceDate(Long hypDiaMentalServiceDate) {
        this.hypDiaMentalServiceDate = hypDiaMentalServiceDate;
    }

    public Long getCancerServiceDate() {
        return cancerServiceDate;
    }

    public void setCancerServiceDate(Long cancerServiceDate) {
        this.cancerServiceDate = cancerServiceDate;
    }

    public String getNutritionStatus() {
        return nutritionStatus;
    }

    public void setNutritionStatus(String nutritionStatus) {
        this.nutritionStatus = nutritionStatus;
    }

    public String getSdScore() {
        return sdScore;
    }

    public void setSdScore(String sdScore) {
        this.sdScore = sdScore;
    }

    public Boolean getTbSuspected() {
        return isTbSuspected;
    }

    public void setTbSuspected(Boolean tbSuspected) {
        isTbSuspected = tbSuspected;
    }

    public Boolean getTbCured() {
        return isTbCured;
    }

    public void setTbCured(Boolean tbCured) {
        isTbCured = tbCured;
    }

    public Long getFpServiceDate() {
        return fpServiceDate;
    }

    public void setFpServiceDate(Long fpServiceDate) {
        this.fpServiceDate = fpServiceDate;
    }

    public Boolean getPersonallyUsingFp() {
        return personallyUsingFp;
    }

    public void setPersonallyUsingFp(Boolean personallyUsingFp) {
        this.personallyUsingFp = personallyUsingFp;
    }

    public Long getAnemiaServiceDate() {
        return anemiaServiceDate;
    }

    public void setAnemiaServiceDate(Long anemiaServiceDate) {
        this.anemiaServiceDate = anemiaServiceDate;
    }

    public String getMemberAnemiaStatus() {
        return memberAnemiaStatus;
    }

    public void setMemberAnemiaStatus(String memberAnemiaStatus) {
        this.memberAnemiaStatus = memberAnemiaStatus;
    }

    public Boolean getBcgSurveyStatus() {
        return bcgSurveyStatus;
    }

    public void setBcgSurveyStatus(Boolean bcgSurveyStatus) {
        this.bcgSurveyStatus = bcgSurveyStatus;
    }

    public Boolean getSickleCellSurveyCompleted() {
        return sickleCellSurveyCompleted;
    }

    public void setSickleCellSurveyCompleted(Boolean sickleCellSurveyCompleted) {
        this.sickleCellSurveyCompleted = sickleCellSurveyCompleted;
    }

    public Boolean getBcgEligible() {
        return bcgEligible;
    }

    public void setBcgEligible(Boolean bcgEligible) {
        this.bcgEligible = bcgEligible;
    }

    public Boolean getBcgWilling() {
        return bcgWilling;
    }

    public void setBcgWilling(Boolean bcgWilling) {
        this.bcgWilling = bcgWilling;
    }

    public Boolean getIndexCase() {
        return indexCase;
    }

    public void setIndexCase(Boolean indexCase) {
        this.indexCase = indexCase;
    }

    public String getRdtStatus() {
        return rdtStatus;
    }

    public void setRdtStatus(String rdtStatus) {
        this.rdtStatus = rdtStatus;
    }

    public Boolean getBcgEligibleFilled() {
        return bcgEligibleFilled;
    }

    public void setBcgEligibleFilled(Boolean bcgEligibleFilled) {
        this.bcgEligibleFilled = bcgEligibleFilled;
    }

    public Boolean getHavingBirthPlan() {
        return havingBirthPlan;
    }

    public void setHavingBirthPlan(Boolean havingBirthPlan) {
        this.havingBirthPlan = havingBirthPlan;
    }

    public Boolean getDevelopmentDelays() {
        return developmentDelays;
    }

    public void setDevelopmentDelays(Boolean developmentDelays) {
        this.developmentDelays = developmentDelays;
    }

    public Short getAbortionCount() {
        return abortionCount;
    }

    public void setAbortionCount(Short abortionCount) {
        this.abortionCount = abortionCount;
    }

    public Boolean getPmmvyBeneficiary() {
        return pmmvyBeneficiary;
    }

    public void setPmmvyBeneficiary(Boolean pmmvyBeneficiary) {
        this.pmmvyBeneficiary = pmmvyBeneficiary;
    }

    public Boolean getPmsmaBeneficiary() {
        return pmsmaBeneficiary;
    }

    public void setPmsmaBeneficiary(Boolean pmsmaBeneficiary) {
        this.pmsmaBeneficiary = pmsmaBeneficiary;
    }

    public Boolean getDikariBeneficiary() {
        return dikariBeneficiary;
    }

    public void setDikariBeneficiary(Boolean dikariBeneficiary) {
        this.dikariBeneficiary = dikariBeneficiary;
    }

    public String getHepatitisCTest() {
        return hepatitisCTest;
    }

    public void setHepatitisCTest(String hepatitisCTest) {
        this.hepatitisCTest = hepatitisCTest;
    }

    public Boolean getMemberRegisteredForAnganwadi() {
        return memberRegisteredForAnganwadi;
    }

    public void setMemberRegisteredForAnganwadi(Boolean memberRegisteredForAnganwadi) {
        this.memberRegisteredForAnganwadi = memberRegisteredForAnganwadi;
    }

    public String getRchId() {
        return rchId;
    }

    public void setRchId(String rchId) {
        this.rchId = rchId;
    }
}

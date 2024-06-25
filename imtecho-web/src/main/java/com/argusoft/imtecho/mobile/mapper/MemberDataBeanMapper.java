package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.mobile.dto.MemberDataBean;
import com.argusoft.imtecho.mobile.dto.SickleCellMemberDataBean;
import com.google.gson.Gson;

import java.util.Set;

/**
 * @author prateek
 */
public class MemberDataBeanMapper {

    private MemberDataBeanMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static MemberDataBean convertMemberEntityToMemberDataBean(MemberEntity member) {
        MemberDataBean memberDataBean = new MemberDataBean();
        StringBuilder sb = new StringBuilder();
        memberDataBean.setId(member.getId());
        memberDataBean.setState(member.getState());
        memberDataBean.setCreatedBy(member.getCreatedBy());
        memberDataBean.setUpdatedBy(member.getModifiedBy());
        memberDataBean.setAccountNumber(member.getAccountNumber());
        memberDataBean.setFamilyHeadFlag(member.getFamilyHeadFlag());
        memberDataBean.setFamilyId(member.getFamilyId());
        sb.append(member.getFamilyId()).append(" ");
        memberDataBean.setFamilyPlanningMethod(member.getFamilyPlanningMethod());
        memberDataBean.setFirstName(member.getFirstName());
        memberDataBean.setMiddleName(member.getMiddleName());
        memberDataBean.setLastName(member.getLastName());
        sb.append(member.getFullName()).append(" ");
        memberDataBean.setIfsc(member.getIfsc());
        memberDataBean.setIsPregnantFlag(member.getIsPregnantFlag());
        memberDataBean.setMaritalStatus(member.getMaritalStatus());
        memberDataBean.setMobileNumber(member.getMobileNumber());
        sb.append(member.getMobileNumber()).append(" ");
        memberDataBean.setNormalCycleDays(member.getNormalCycleDays());
        memberDataBean.setGender(member.getGender());
        memberDataBean.setUniqueHealthId(member.getUniqueHealthId());
        sb.append(member.getUniqueHealthId()).append(" ");
        memberDataBean.setGrandfatherName(member.getGrandfatherName());
        memberDataBean.setEducationStatus(member.getEducationStatus());
        memberDataBean.setCongenitalAnomalyIds(member.getCongenitalAnomaly());
        memberDataBean.setEyeIssueIds(member.getEyeIssue());
        memberDataBean.setChronicDiseaseIds(member.getChronicDisease());
        memberDataBean.setCurrentDiseaseIds(member.getCurrentDisease());
        memberDataBean.setYearOfWedding(member.getYearOfWedding());
//        memberDataBean.setJsyPaymentGiven(member.getJsyPaymentGiven());
        memberDataBean.setIsEarlyRegistration(member.getIsEarlyRegistration());
//        memberDataBean.setJsyBeneficiary(member.getJsyBeneficiary());
//        memberDataBean.setIayBeneficiary(member.getIayBeneficiary());
//        memberDataBean.setKpsyBeneficiary(member.getKpsyBeneficiary());
//        memberDataBean.setChiranjeeviYojnaBeneficiary(member.getChiranjeeviYojnaBeneficiary());
        memberDataBean.setWeight(member.getWeight());
        memberDataBean.setHaemoglobin(member.getHaemoglobin());
        memberDataBean.setAncVisitDates(member.getAncVisitDates());
        memberDataBean.setImmunisationGiven(member.getImmunisationGiven());
        memberDataBean.setBloodGroup(member.getBloodGroup());
        memberDataBean.setPlaceOfBirth(member.getPlaceOfBirth());
        memberDataBean.setBirthWeight(member.getBirthWeight());
        memberDataBean.setComplementaryFeedingStarted(member.getComplementaryFeedingStarted());
        memberDataBean.setLastMethodOfContraception(member.getLastMethodOfContraception());
        memberDataBean.setIsHighRiskCase(member.getIsHighRiskCase());
        memberDataBean.setCurPregRegDetId(member.getCurPregRegDetId());
        memberDataBean.setMotherId(member.getMotherId());
        memberDataBean.setMenopauseArrived(member.getMenopauseArrived());
        memberDataBean.setSyncStatus(member.getSyncStatus());
        memberDataBean.setIsIucdRemoved(member.getIsIucdRemoved());
        memberDataBean.setHysterectomyDone(member.getHysterectomyDone());
        memberDataBean.setChildNrcCmtcStatus(member.getChildNrcCmtcStatus());
        memberDataBean.setLastDeliveryOutcome(member.getLastDeliveryOutcome());
        memberDataBean.setPreviousPregnancyComplication(member.getPreviousPregnancyComplicationCsv());
        memberDataBean.setAdditionalInfo(member.getAdditionalInfo());
        memberDataBean.setFhsrPhoneVerified(member.getFhsrPhoneVerified());
        memberDataBean.setCurrentGravida(member.getCurrentGravida());
        memberDataBean.setCurrentPara(member.getCurrentPara());
        memberDataBean.setHusbandId(member.getHusbandId());
        memberDataBean.setIsMobileNumberVerified(member.getIsMobileNumberVerified());
        memberDataBean.setRelationWithHof(member.getRelationWithHof());
        memberDataBean.setVulnerableFlag(member.getVulnerableFlag());
        memberDataBean.setHealthId(member.getHealthId());
        memberDataBean.setHealthIdNumber(member.getHealthIdNumber());
        memberDataBean.setHealthInsurance(member.getHealthInsurance());
//        memberDataBean.setSchemeDetail(member.getSchemeDetail());
        memberDataBean.setPersonalHistoryDone(member.getPersonalHistoryDone());
        memberDataBean.setOccupation(member.getOccupation());
        memberDataBean.setOtherChronic(member.getOtherChronic());
        memberDataBean.setPhysicalDisability(member.getPhysicalDisability());
        memberDataBean.setOtherDisability(member.getOtherDisability());
        memberDataBean.setOtherEyeIssue(member.getOtherEyeIssue());
        memberDataBean.setSickleCellStatus(member.getSickleCellStatus());
        memberDataBean.setCataractSurgery(member.getCataractSurgery());
        memberDataBean.setIsChildGoingSchool(member.getIsChildGoingSchool());
        memberDataBean.setCurrentStudyingStandard(member.getCurrentStudyingStandard());
//        memberDataBean.setAadharStatus(member.getAadharStatus());
//        memberDataBean.setPensionScheme(member.getPensionScheme());
        memberDataBean.setUnderTreatmentChronic(member.getUnderTreatmentChronic());
        memberDataBean.setAlternateNumber(member.getAlternateNumber());
        memberDataBean.setOtherChronicDiseaseTreatment(member.getOtherChronicDiseaseTreatment());
        memberDataBean.setHaveNssf(member.getHaveNssf());
        memberDataBean.setNssfCardNumber(member.getNssfCardNumber());


        if (member.getLmpDate() != null) {
            memberDataBean.setLmpDate(member.getLmpDate().getTime());
        }

        if (member.getDob() != null) {
            memberDataBean.setDob(member.getDob().getTime());
        }

        if (member.getModifiedOn() != null) {
            memberDataBean.setUpdatedOn(member.getModifiedOn());
        }

        if (member.getCreatedOn() != null) {
            memberDataBean.setCreatedOn(member.getCreatedOn());
        }

        if (member.getEdd() != null) {
            memberDataBean.setEdd(member.getEdd().getTime());
        }

        if (member.getFpInsertOperateDate() != null) {
            memberDataBean.setFpInsertOperateDate(member.getFpInsertOperateDate().getTime());
        }

        if (member.getIucdRemovalDate() != null) {
            memberDataBean.setIucdRemovalDate(member.getIucdRemovalDate().getTime());
        }

        if (member.getCurPregRegDate() != null) {
            memberDataBean.setCurPregRegDate(member.getCurPregRegDate().getTime());
        }

        if (member.getLastDeliveryDate() != null) {
            memberDataBean.setLastDeliveryDate(member.getLastDeliveryDate().getTime());
        }

        if (member.getNpcbScreeningDate() != null) {
            memberDataBean.setNpcbScreeningDate(member.getNpcbScreeningDate().getTime());
        }

        if (member.getDateOfWedding() != null) {
            memberDataBean.setDateOfWedding(member.getDateOfWedding().getTime());
        }

//        if (member.getPmjayAvailability() != null) {
//            memberDataBean.setPmjayAvailability(member.getPmjayAvailability());
//        }

        if (member.getAlcoholAddiction() != null) {
            memberDataBean.setAlcoholAddiction(member.getAlcoholAddiction());
        }

        if (member.getSmokingAddiction() != null) {
            memberDataBean.setSmokingAddiction(member.getSmokingAddiction());
        }

        if (member.getTobaccoAddiction() != null) {
            memberDataBean.setTobaccoAddiction(member.getTobaccoAddiction());
        }

//        if (member.getAadharStatus() != null) {
//            memberDataBean.setAadharStatus(member.getAadharStatus());
//        }

        if (member.getNrcNumber() != null) {
            memberDataBean.setNrcNumber(member.getNrcNumber());
        }

        if (member.getPassportNumber() != null) {
            memberDataBean.setPassportNumber(member.getPassportNumber());
        }

        if (member.getBirthCertificateNumber() != null) {
            memberDataBean.setBirthCertNumber(member.getBirthCertificateNumber());
        }

        if (member.getMemberReligion() != null) {
            memberDataBean.setMemberReligion(member.getMemberReligion());
        }

        if (member.getChronicDiseaseTreatment() != null) {
            memberDataBean.setChronicDiseaseIdsForTreatment(member.getChronicDiseaseTreatment());
        }

        if (member.getMemberUUId() != null) {
            memberDataBean.setMemberUuid(member.getMemberUUId());
        }

        if (!sb.isEmpty()) {
            memberDataBean.setSearchString(sb.toString());
        }


        if (member.getAdditionalInfo() != null) {
            MemberAdditionalInfo additionalInfo = new Gson().fromJson(member.getAdditionalInfo(), MemberAdditionalInfo.class);
            memberDataBean.setCbacDate(additionalInfo.getCbacDate());
            memberDataBean.setHypYear(additionalInfo.getHypYear());
            memberDataBean.setDiabetesYear(additionalInfo.getDiabetesYear());
            memberDataBean.setOralYear(additionalInfo.getOralYear());
            memberDataBean.setBreastYear(additionalInfo.getBreastYear());
            memberDataBean.setCervicalYear(additionalInfo.getCervicalYear());
            memberDataBean.setMentalHealthYear(additionalInfo.getMentalHealthYear());
            memberDataBean.setHealthYear(additionalInfo.getHealthYear());
            memberDataBean.setConfirmedDiabetes(additionalInfo.getConfirmedDiabetes());
            memberDataBean.setSuspectedForDiabetes(additionalInfo.getSuspectedForDiabetes());
            memberDataBean.setCbacScore(additionalInfo.getCbacScore());
            memberDataBean.setSufferingDiabetes(additionalInfo.getSufferingDiabetes());
            memberDataBean.setSufferingMentalHealth(additionalInfo.getSufferingMentalHealth());
            memberDataBean.setSufferingHypertension(additionalInfo.getSufferingHypertension());
            memberDataBean.setMoConfirmedDiabetes(additionalInfo.getMoConfirmedDiabetes());
            memberDataBean.setMoConfirmedHypertension(additionalInfo.getMoConfirmedHypertension());
            memberDataBean.setGeneralScreeningDone(additionalInfo.getGeneralScreeningDone());
            memberDataBean.setUrineTestDone(additionalInfo.getUrineTestDone());
            memberDataBean.setEcgTestDone(additionalInfo.getEcgTestDone());
            memberDataBean.setRetinopathyTestDone(additionalInfo.getRetinopathyTestDone());
            memberDataBean.setHmisId(additionalInfo.getHmisId());
            memberDataBean.setHypDiaMentalServiceDate(additionalInfo.getHypDiaMentalServiceDate());
            memberDataBean.setCancerServiceDate(additionalInfo.getCancerServiceDate());
            memberDataBean.setIsHivPositive(additionalInfo.getHivTest());
            memberDataBean.setIsVDRLPositive(additionalInfo.getVdrlTest());
            memberDataBean.setNutritionStatus(additionalInfo.getNutritionStatus());
            memberDataBean.setBcgSurveyStatus(additionalInfo.getBcgSurveyStatus());
            memberDataBean.setBcgEligible(additionalInfo.getBcgEligible());
        }

        return memberDataBean;
    }

    public static String convertSetToCommaSeparatedString(Set<Integer> list, String separator) {
        if (list != null && !list.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (Integer item : list) {
                if (first) {
                    first = false;
                } else {
                    sb.append(separator);
                }
                sb.append(item);
            }
            return sb.toString();
        } else {
            return null;
        }
    }

    public static String convertStringSetToCommaSeparatedString(Set<String> list, String separator) {
        if (list != null && !list.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (String item : list) {
                if (first) {
                    first = false;
                } else {
                    sb.append(separator);
                }
                sb.append(item);
            }
            return sb.toString();
        } else {
            return null;
        }
    }

}

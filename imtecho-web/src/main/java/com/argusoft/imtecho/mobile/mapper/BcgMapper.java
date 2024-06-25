package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.mobile.model.BcgVaccinationSurveyDetails;

public class BcgMapper {
    public BcgMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static void bcgMapper(BcgVaccinationSurveyDetails bcgVaccinationSurveyDetails, BcgVaccinationSurveyDetails bcgVaccinationSurveyDetailsCopy) {
        if (bcgVaccinationSurveyDetails.getBcgEligible() != null) {
            bcgVaccinationSurveyDetailsCopy.setBcgEligible(bcgVaccinationSurveyDetails.getBcgEligible());
        }

        if (bcgVaccinationSurveyDetails.getLocationId() != null) {
            bcgVaccinationSurveyDetailsCopy.setLocationId(bcgVaccinationSurveyDetails.getLocationId());
        }

        if (bcgVaccinationSurveyDetails.getNikshayId() != null) {
            bcgVaccinationSurveyDetailsCopy.setNikshayId(bcgVaccinationSurveyDetails.getNikshayId());
        }

        if (bcgVaccinationSurveyDetails.getBcgAllergy() != null) {
            bcgVaccinationSurveyDetailsCopy.setBcgAllergy(bcgVaccinationSurveyDetails.getBcgAllergy());
        }

        if (bcgVaccinationSurveyDetails.getBeneficiaryType() != null) {
            bcgVaccinationSurveyDetailsCopy.setBeneficiaryType(bcgVaccinationSurveyDetails.getBeneficiaryType());
        }

        if (bcgVaccinationSurveyDetails.getIsHighRisk() != null) {
            bcgVaccinationSurveyDetailsCopy.setIsHighRisk(bcgVaccinationSurveyDetails.getIsHighRisk());
        }

        if (bcgVaccinationSurveyDetails.getIsCancer() != null) {
            bcgVaccinationSurveyDetailsCopy.setIsCancer(bcgVaccinationSurveyDetails.getIsCancer());
        }

        if (bcgVaccinationSurveyDetails.getBloodTransfusion() != null) {
            bcgVaccinationSurveyDetailsCopy.setBloodTransfusion(bcgVaccinationSurveyDetails.getBloodTransfusion());
        }

        if (bcgVaccinationSurveyDetails.getTbTreatment() != null) {
            bcgVaccinationSurveyDetailsCopy.setTbTreatment(bcgVaccinationSurveyDetails.getTbTreatment());
        }

        if (bcgVaccinationSurveyDetails.getOrganTransplant() != null) {
            bcgVaccinationSurveyDetailsCopy.setOrganTransplant(bcgVaccinationSurveyDetails.getOrganTransplant());
        }

        if (bcgVaccinationSurveyDetails.getOnMedication() != null) {
            bcgVaccinationSurveyDetailsCopy.setOnMedication(bcgVaccinationSurveyDetails.getOnMedication());
        }

        if (bcgVaccinationSurveyDetails.getIsPregnant() != null) {
            bcgVaccinationSurveyDetailsCopy.setIsPregnant(bcgVaccinationSurveyDetails.getIsPregnant());
        }

        if (bcgVaccinationSurveyDetails.getBmi() != null) {
            bcgVaccinationSurveyDetailsCopy.setBmi(bcgVaccinationSurveyDetails.getBmi());
        }

        if (bcgVaccinationSurveyDetails.getWeight() != null) {
            bcgVaccinationSurveyDetailsCopy.setWeight(bcgVaccinationSurveyDetails.getWeight());
        }

        if (bcgVaccinationSurveyDetails.getHeight() != null) {
            bcgVaccinationSurveyDetailsCopy.setHeight(bcgVaccinationSurveyDetails.getHeight());
        }

        if (bcgVaccinationSurveyDetails.getTbPreventTherapy() != null) {
            bcgVaccinationSurveyDetailsCopy.setTbPreventTherapy(bcgVaccinationSurveyDetails.getTbPreventTherapy());
        }

        if (bcgVaccinationSurveyDetails.getCoughForTwoWeeks() != null) {
            bcgVaccinationSurveyDetailsCopy.setCoughForTwoWeeks(bcgVaccinationSurveyDetails.getCoughForTwoWeeks());
        }

        if (bcgVaccinationSurveyDetails.getTbDiagnosed() != null) {
            bcgVaccinationSurveyDetailsCopy.setTbDiagnosed(bcgVaccinationSurveyDetails.getTbDiagnosed());
        }

        if (bcgVaccinationSurveyDetails.getFeverForTwoWeeks() != null) {
            bcgVaccinationSurveyDetailsCopy.setFeverForTwoWeeks(bcgVaccinationSurveyDetails.getFeverForTwoWeeks());
        }

        if (bcgVaccinationSurveyDetails.getSignificantWeightLoss() != null) {
            bcgVaccinationSurveyDetailsCopy.setSignificantWeightLoss(bcgVaccinationSurveyDetails.getSignificantWeightLoss());
        }

        if (bcgVaccinationSurveyDetails.getBloodInSputum() != null) {
            bcgVaccinationSurveyDetailsCopy.setBloodInSputum(bcgVaccinationSurveyDetails.getBloodInSputum());
        }

        if (bcgVaccinationSurveyDetails.getConsentUnavailable() != null) {
            bcgVaccinationSurveyDetailsCopy.setConsentUnavailable(bcgVaccinationSurveyDetails.getConsentUnavailable());
        }

        if (bcgVaccinationSurveyDetails.getBedRidden() != null) {
            bcgVaccinationSurveyDetailsCopy.setBedRidden(bcgVaccinationSurveyDetails.getBedRidden());
        }

        if (bcgVaccinationSurveyDetails.getReasonForNotWilling() != null) {
            bcgVaccinationSurveyDetailsCopy.setReasonForNotWilling(bcgVaccinationSurveyDetails.getReasonForNotWilling());
        }

        if (bcgVaccinationSurveyDetails.getMemberId() != null) {
            bcgVaccinationSurveyDetailsCopy.setMemberId(bcgVaccinationSurveyDetails.getMemberId());
        }

    }

}

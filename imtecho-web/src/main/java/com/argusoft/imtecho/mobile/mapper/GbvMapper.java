package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.chip.model.GbvVisit;
import com.argusoft.imtecho.mobile.dto.GbvDto;

import java.util.Date;

public class GbvMapper {


    public static void mapDtoToGbvVisit(GbvDto gbvdto, GbvVisit gbvVisit) {
        gbvVisit.setFurtherTreatment(gbvdto.getFurtherTreatment());
        gbvVisit.setHealthInfra(gbvdto.getHealthInfra());
        gbvVisit.setServiceDate(new Date(gbvdto.getServiceDate()));
        gbvVisit.setMobileStartDate(new Date(gbvdto.getMobileStartDate()));
        gbvVisit.setMobileEndDate(new Date(gbvdto.getMobileEndDate()));
        gbvVisit.setLatitude(gbvdto.getCurrentLatitude());
        gbvVisit.setLongitude(gbvdto.getCurrentLongitude());
        gbvVisit.setCaseDate(new Date(gbvdto.getCaseDate()));
        gbvVisit.setMemberStatus(gbvdto.getMemberStatus());
        gbvVisit.setSevereCase(gbvdto.isSevereCase());
        gbvVisit.setClientResponse(gbvdto.isClientResponse());
        gbvVisit.setThreatenedWithViolencePast12Months(gbvdto.isThreatenedWithViolencePast12Months());
        gbvVisit.setPhysicallyHurtPast12Months(gbvdto.isPhysicallyHurtPast12Months());
        gbvVisit.setForcedSexPast12Months(gbvdto.isForcedSexPast12Months());
        gbvVisit.setForcedSexForEssentialsPast12Months(gbvdto.isForcedSexForEssentialsPast12Months());
        gbvVisit.setPhysicallyForcedPregnancyPast12Months(gbvdto.isPhysicallyForcedPregnancyPast12Months());
        gbvVisit.setPregnantDueToForce(gbvdto.isPregnantDueToForce());
        gbvVisit.setForcedPregnancyLossPast12Months(gbvdto.isForcedPregnancyLossPast12Months());
        gbvVisit.setCoercedOrForcedMarriagePast12Months(gbvdto.isCoercedOrForcedMarriagePast12Months());
        gbvVisit.setPhotoUniqueId(gbvdto.getPhotoUniqueId());
        gbvVisit.setGbvType(gbvdto.getTypeOfGbv());
        gbvVisit.setDifficultyType(gbvdto.getTypeOfDifficulty());
        gbvVisit.setReferralDone(gbvdto.getReferralRequired());
        gbvVisit.setReferralReason(gbvdto.getOtherReferralReason());
        gbvVisit.setReferralFor(gbvdto.getReferralReason());
        gbvVisit.setIsIecGiven(gbvdto.isIecGiven());
        gbvVisit.setReferralPlace(gbvdto.getReferralPlace());
    }
}

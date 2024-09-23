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
        gbvVisit.setMemberId(Integer.valueOf(gbvdto.getMemberId()));
        gbvVisit.setFamilyId(Integer.valueOf(gbvdto.getFamilyId()));
        gbvVisit.setLatitude(gbvdto.getCurrentLatitude());
        gbvVisit.setLongitude(gbvdto.getCurrentLongitude());
        gbvVisit.setCaseDate(new Date(gbvdto.getCaseDate()));
        gbvVisit.setMemberStatus(gbvdto.getMemberStatus());
        gbvVisit.setSevereCase(gbvdto.getSevereCase());
        gbvVisit.setClientResponse(gbvdto.getSevereCase());
        gbvVisit.setThreatenedWithViolencePast12Months(gbvdto.getThreatenedWithViolencePast12Months());
        gbvVisit.setPhysicallyHurtPast12Months(gbvdto.getPhysicallyHurtPast12Months());
        gbvVisit.setForcedSexPast12Months(gbvdto.getForcedSexPast12Months());
        gbvVisit.setForcedSexForEssentialsPast12Months(gbvdto.getForcedSexForEssentialsPast12Months());
        gbvVisit.setPhysicallyForcedPregnancyPast12Months(gbvdto.getPhysicallyForcedPregnancyPast12Months());
        gbvVisit.setPregnantDueToForce(gbvdto.getPregnantDueToForce());
        gbvVisit.setForcedPregnancyLossPast12Months(gbvdto.getForcedPregnancyLossPast12Months());
        gbvVisit.setCoercedOrForcedMarriagePast12Months(gbvdto.getCoercedOrForcedMarriagePast12Months());
        gbvVisit.setPhotoUniqueId(gbvdto.getPhotoUniqueId());
        gbvVisit.setGbvType(gbvdto.getTypeOfGbv());
        gbvVisit.setDifficultyType(gbvdto.getTypeOfDifficulty());


    }
}

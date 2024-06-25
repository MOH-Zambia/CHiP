package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.model.MemberEntity;

public class ClientMemberMapper {

    /**
     * Convert member entity to dto.
     *
     * @param memberEntity Entity of member.
     * @return Returns details of member.
     */
    public static ClientMemberDto getMemberDto(MemberEntity memberEntity) {
        if (memberEntity != null) {
            ClientMemberDto memberDto = new ClientMemberDto();
            memberDto.setId(memberEntity.getId());

            memberDto.setFamilyId(memberEntity.getFamilyId());
            memberDto.setUniqueHealthId(memberEntity.getUniqueHealthId());
            memberDto.setMotherId(memberEntity.getMotherId());

            memberDto.setFirstName(memberEntity.getFirstName());
            memberDto.setMiddleName(memberEntity.getMiddleName());
            memberDto.setLastName(memberEntity.getLastName());
            memberDto.setHusbandName(memberEntity.getHusbandName());
            memberDto.setGrandfatherName(memberEntity.getGrandfatherName());
            memberDto.setGender(memberEntity.getGender());
            memberDto.setDob(memberEntity.getDob());

            memberDto.setMaritalStatus(memberEntity.getMaritalStatus() != null ? memberEntity.getMaritalStatus() : null);
            memberDto.setMobileNumber(memberEntity.getMobileNumber());
            memberDto.setFamilyHeadFlag(memberEntity.getFamilyHeadFlag());

            memberDto.setIsPregnantFlag(memberEntity.getIsPregnantFlag());
            memberDto.setLmpDate(memberEntity.getLmpDate());
            memberDto.setEdd(memberEntity.getEdd());
            memberDto.setNormalCycleDays(memberEntity.getNormalCycleDays());
            memberDto.setFamilyPlanningMethod(memberEntity.getFamilyPlanningMethod() != null ? memberEntity.getFamilyPlanningMethod() : null);
            memberDto.setState(memberEntity.getState());
            memberDto.setIsMobileNumberVerified(memberEntity.getIsMobileNumberVerified());
            memberDto.setIsNativeFlag(memberEntity.getIsNativeFlag());
            memberDto.setEducationStatus(memberEntity.getEducationStatus() != null ? memberEntity.getEducationStatus() : null);
            memberDto.setIsReport(memberEntity.getIsReport());
            memberDto.setIsEarlyRegistration(memberEntity.getIsEarlyRegistration());
            memberDto.setImmunisationGiven(memberEntity.getImmunisationGiven());
            memberDto.setBloodGroup(memberEntity.getBloodGroup());
            memberDto.setWeight(memberEntity.getWeight());
            memberDto.setHaemoglobin(memberEntity.getHaemoglobin());
            memberDto.setAncVisitDates(memberEntity.getAncVisitDates());
            memberDto.setCurPregRegDetId(memberEntity.getCurPregRegDetId());
            memberDto.setCurPregRegDate(memberEntity.getCurPregRegDate());
            memberDto.setLastDeliveryDate(memberEntity.getLastDeliveryDate());
            memberDto.setLastDeliveryOutcome(memberEntity.getLastDeliveryOutcome());
            memberDto.setHealthInsurance(memberEntity.getHealthInsurance());
//            memberDto.setSchemeDetail(memberEntity.getSchemeDetail());
            memberDto.setChronicDiseaseDetails(memberEntity.getChronicDiseaseDetails());

            memberDto.setAdditionalInfo(memberEntity.getAdditionalInfo());
            memberDto.setEligibleCoupleDate(memberEntity.getEligibleCoupleDate());
            memberDto.setFamilyPlanningHealthInfrastructure(memberEntity.getFamilyPlanningHealthInfrastructure());
            memberDto.setBasicState(memberEntity.getBasicState());
            memberDto.setLastMethodOfContraception(memberEntity.getLastMethodOfContraception());
            memberDto.setRelationWithHof(memberEntity.getRelationWithHof());

            return memberDto;
        }
        return null;
    }

}

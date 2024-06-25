package com.argusoft.imtecho.mobile.mapper;


import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.mobile.dto.HouseHoldLineListMobileDto;

import java.util.Date;

public class HouseHoldLineListMobileMapper {
    public HouseHoldLineListMobileMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static void convertHouseHoldLineListDtoToFamilyEntity(HouseHoldLineListMobileDto houseHoldLineListMobileDto, FamilyEntity familyEntity) {
        if (houseHoldLineListMobileDto.getLocationId() != null) {
            familyEntity.setLocationId(houseHoldLineListMobileDto.getLocationId());
            familyEntity.setAreaId(houseHoldLineListMobileDto.getLocationId());
        }

        familyEntity.setHouseNumber(houseHoldLineListMobileDto.getHouseNumber() != null ? houseHoldLineListMobileDto.getHouseNumber() : familyEntity.getHouseNumber());
        familyEntity.setAddress1(houseHoldLineListMobileDto.getHouseAddress() != null ? houseHoldLineListMobileDto.getHouseAddress() : familyEntity.getAddress1());
        familyEntity.setOutdoorCookingPractices(houseHoldLineListMobileDto.getCookingPractices() != null ? houseHoldLineListMobileDto.getCookingPractices() : familyEntity.getOutdoorCookingPractices());
        familyEntity.setTypeOfToilet(houseHoldLineListMobileDto.getHouseNumber() != null ? houseHoldLineListMobileDto.getHouseNumber() : familyEntity.getHouseNumber());
        familyEntity.setHandwashAvailable(houseHoldLineListMobileDto.getHandWashAvailable() != null ? houseHoldLineListMobileDto.getHandWashAvailable() : familyEntity.getHandwashAvailable());
        familyEntity.setWasteDisposalAvailable(houseHoldLineListMobileDto.getIsWasteDisposalAvailable() != null ? houseHoldLineListMobileDto.getIsWasteDisposalAvailable() : familyEntity.getWasteDisposalAvailable());
        familyEntity.setOtherWasteDisposal(houseHoldLineListMobileDto.getOtherWasteDisposalType() != null ? houseHoldLineListMobileDto.getOtherWasteDisposalType() : familyEntity.getOtherWasteDisposal());
        familyEntity.setWaterSafetyMeetsStandard(houseHoldLineListMobileDto.getIsWaterSafe() != null ? houseHoldLineListMobileDto.getIsWaterSafe() : familyEntity.getWaterSafetyMeetsStandard());
        familyEntity.setDrinkingWaterSource(houseHoldLineListMobileDto.getWaterSource() != null ? houseHoldLineListMobileDto.getWaterSource() : familyEntity.getDrinkingWaterSource());
        familyEntity.setStorageMeetsStandard(houseHoldLineListMobileDto.getStorageStandards() != null ? houseHoldLineListMobileDto.getStorageStandards() : familyEntity.getStorageMeetsStandard());
        familyEntity.setDishrackAvailable(houseHoldLineListMobileDto.getDishRackAvailable() != null ? houseHoldLineListMobileDto.getDishRackAvailable() : familyEntity.getDishrackAvailable());
        familyEntity.setComplaintOfInsects(houseHoldLineListMobileDto.getInsectsFound() != null ? houseHoldLineListMobileDto.getInsectsFound() : familyEntity.getComplaintOfInsects());
        familyEntity.setComplaintOfRodents(houseHoldLineListMobileDto.getRodentsFound() != null ? houseHoldLineListMobileDto.getRodentsFound() : familyEntity.getComplaintOfRodents());
        familyEntity.setSeparateLivestockShelter(houseHoldLineListMobileDto.getLivestockShelterFound() != null ? houseHoldLineListMobileDto.getLivestockShelterFound() : familyEntity.getSeparateLivestockShelter());
        familyEntity.setNoOfMosquitoNetsAvailable(houseHoldLineListMobileDto.getMosquitoNetAvailable() != null ? houseHoldLineListMobileDto.getMosquitoNetAvailable() : familyEntity.getNoOfMosquitoNetsAvailable());
        familyEntity.setIsIecGiven(houseHoldLineListMobileDto.getIsIECGiven() != null ? houseHoldLineListMobileDto.getIsIECGiven() : familyEntity.getIsIecGiven());
        familyEntity.setLatitude(houseHoldLineListMobileDto.getCurrentLatitude() != null ? houseHoldLineListMobileDto.getCurrentLatitude() : familyEntity.getLatitude());
        familyEntity.setLongitude(houseHoldLineListMobileDto.getCurrentLongitude() != null ? houseHoldLineListMobileDto.getCurrentLongitude() : familyEntity.getLongitude());
        familyEntity.setFamilyUuid(houseHoldLineListMobileDto.getUuid() != null ? houseHoldLineListMobileDto.getUuid() : familyEntity.getFamilyUuid());
    }

    public static void convertMemberDetailsToMemberEntity(HouseHoldLineListMobileDto.MemberDetails member, MemberEntity memberEntity, boolean isFromUpdate) {
        if (memberEntity == null) {
            memberEntity = new MemberEntity();
        }
        memberEntity.setFamilyHeadFlag(member.getIsHof() != null ? member.getIsHof() : false);
        memberEntity.setFirstName(member.getFirstName() != null ? member.getFirstName() : memberEntity.getFirstName());
        memberEntity.setMiddleName(member.getMiddleName() != null ? member.getMiddleName() : memberEntity.getMiddleName());
        memberEntity.setLastName(member.getLastName() != null ? member.getLastName() : memberEntity.getLastName());
        memberEntity.setMemberReligion(member.getReligion() != null ? member.getReligion() : memberEntity.getMemberReligion());
        memberEntity.setNrcNumber(member.getNRCNumber() != null ? member.getNRCNumber() : memberEntity.getNrcNumber());
        memberEntity.setPassportNumber(member.getPassportNumber() != null ? member.getPassportNumber() : memberEntity.getPassportNumber());
        memberEntity.setMaritalStatus(member.getMaritalStatus() != null ? member.getMaritalStatus() : memberEntity.getMaritalStatus());
        memberEntity.setMobileNumber(member.getMobileNumber() != null ? extractMobileNumber(member.getMobileNumber()) : memberEntity.getMobileNumber());
        memberEntity.setEducationStatus(member.getEducationStatus() != null ? member.getEducationStatus() : memberEntity.getEducationStatus());
        memberEntity.setHysterectomyDone(member.getHysterectomyArrived() != null ? member.getHysterectomyArrived() : memberEntity.getHysterectomyDone());
        memberEntity.setMenopauseArrived(member.getMenopauseArrived() != null ? member.getMenopauseArrived() : memberEntity.getMenopauseArrived());
        memberEntity.setRelationWithHof(member.getRelationWithHof() != null ? member.getRelationWithHof() : memberEntity.getRelationWithHof());
        memberEntity.setIsChildGoingSchool(member.getIsChildGoingToSchool() != null ? member.getIsChildGoingToSchool() : memberEntity.getIsChildGoingSchool());
        memberEntity.setCurrentStudyingStandard(member.getChildStandard() != null ? member.getChildStandard() : memberEntity.getCurrentStudyingStandard());
        memberEntity.setDateOfWedding(member.getLivingWithPartner() != null ? new Date(member.getLivingWithPartner()) : memberEntity.getDateOfWedding());
        memberEntity.setWhyNoTreatment(member.getWhyNoTreatment() != null ? member.getWhyNoTreatment() : memberEntity.getWhyNoTreatment());

        if (!isFromUpdate) {
            memberEntity.setGender(member.getGender() != null ? checkGenderFromNumber(member.getGender()) : memberEntity.getGender());
            memberEntity.setDob(member.getDob() != null ? new Date(member.getDob()) : memberEntity.getDob());
            memberEntity.setMemberUUId(member.getMemberUuid() != null ? member.getMemberUuid() : memberEntity.getMemberUUId());
        }

        memberEntity.setChronicDisease(member.getChronicDisease() != null ? (convertSetToCommaSeparatedString(member.getChronicDisease())) : memberEntity.getChronicDisease());
        memberEntity.setPhysicalDisability(member.getDisabilityIds() != null ? (convertSetToCommaSeparatedString(member.getDisabilityIds())) : memberEntity.getPhysicalDisability());
        memberEntity.setOtherChronic(member.getOtherChronicDisease() != null ? member.getOtherChronicDisease() : memberEntity.getOtherChronic());
        memberEntity.setOtherDisability(member.getOtherDisabilities() != null ? member.getOtherDisabilities() : memberEntity.getOtherDisability());
        memberEntity.setUnderTreatmentChronic(member.getOnTreatment() != null ? member.getOnTreatment() : memberEntity.getUnderTreatmentChronic());
        memberEntity.setChronicDiseaseTreatment(member.getChronicDiseaseTreatment() != null ? convertSetToCommaSeparatedString(member.getChronicDiseaseTreatment()) : memberEntity.getChronicDiseaseTreatment());
        memberEntity.setOtherChronicDiseaseTreatment(member.getOtherChronicDiseaseTreatment() != null ? member.getOtherChronicDiseaseTreatment() : memberEntity.getOtherChronicDiseaseTreatment());

        if ((member.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(member.getGender()))) ||
                memberEntity.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(memberEntity.getGender()))) {
            memberEntity.setLmpDate(member.getLmpDate() != null ? new Date(member.getLmpDate()) : memberEntity.getLmpDate());
        } else {
            memberEntity.setLmpDate(null);
        }

        if (memberEntity.getIsPregnantFlag() != null && !memberEntity.getIsPregnantFlag()) {
            if ((member.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(member.getGender()))) ||
                    memberEntity.getGender() != null && "F".equalsIgnoreCase(checkGenderFromNumber(memberEntity.getGender()))) {
                if (member.getIsWomanPregnant() == null) {
                    memberEntity.setIsPregnantFlag(null);
                } else {
                    memberEntity.setIsPregnantFlag(member.getIsWomanPregnant());
                }
            } else {
                memberEntity.setIsPregnantFlag(null);
            }
        }
    }

    public static String convertSetToCommaSeparatedString(String[] array) {
        StringBuilder result = new StringBuilder();

        if (array.length > 0) {
            result.append(array[0]);

            for (int i = 1; i < array.length; i++) {
                result.append(", ").append(array[i]);
            }
        }

        return result.toString();
    }

    private static String checkGenderFromNumber(String gender) {
        return switch (gender) {
            case "1", "M" -> "M";
            case "2", "F" -> "F";
            default -> null;
        };
    }

    private static String extractMobileNumber(String mobileNumber) {
        String mob = null;
        if (mobileNumber.contains("F/")) {
            mob = mobileNumber.replace("F/", "");
        }
        if (mobileNumber.contains("T")) {
            mob = mobileNumber.replace("T", "");
        }
        return mob;
    }
}
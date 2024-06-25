package com.argusoft.imtecho.fhs.mapper;

import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import com.argusoft.imtecho.fhs.model.FamilyEntity;

public class HouseholdMapper {

        /**
         * Convert FamilyEntity to HouseholdDto.
         *
         * @param familyEntity Entity of family.
         * @return Returns details of household.
         */
    public static HouseholdDto getHouseholdDto(FamilyEntity familyEntity) {
            HouseholdDto householdDto = new HouseholdDto();
            householdDto.setFamilyId(familyEntity.getFamilyId());
            householdDto.setHouseNumber(familyEntity.getHouseNumber());
            householdDto.setLocationId(familyEntity.getLocationId());
            householdDto.setReligion(familyEntity.getReligion());
            //householdDto.setCaste(familyEntity.getCaste());
           // householdDto.setBplFlag(familyEntity.getBplFlag());
            householdDto.setToiletAvailableFlag(familyEntity.getToiletAvailableFlag());
            householdDto.setIsVerifiedFlag(familyEntity.getIsVerifiedFlag());
            householdDto.setState(familyEntity.getState());
            householdDto.setAssignedTo(familyEntity.getAssignedTo());
            householdDto.setAddress1(familyEntity.getAddress1());
            householdDto.setAddress2(familyEntity.getAddress2());
            householdDto.setAreaId(familyEntity.getAreaId());
            householdDto.setVulnerableFlag(familyEntity.getVulnerableFlag());
            householdDto.setMigratoryFlag(familyEntity.getMigratoryFlag());
            householdDto.setLatitude(familyEntity.getLatitude());
            householdDto.setLongitude(familyEntity.getLongitude());
            householdDto.setComment(familyEntity.getComment());
            householdDto.setCurrentState(familyEntity.getCurrentState());
            householdDto.setIsReport(familyEntity.getIsReport());
            householdDto.setContactPersonId(familyEntity.getContactPersonId());
            return householdDto;
    }
}

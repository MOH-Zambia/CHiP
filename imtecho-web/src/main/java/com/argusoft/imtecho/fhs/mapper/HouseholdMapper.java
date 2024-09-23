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
            householdDto.setAddress1(familyEntity.getAddress1());
            householdDto.setAreaId(familyEntity.getAreaId());
            householdDto.setLatitude(familyEntity.getLatitude());
            householdDto.setLongitude(familyEntity.getLongitude());
            householdDto.setDishrackAvailable(familyEntity.getDishrackAvailable());
            householdDto.setComplaintOfInsects(familyEntity.getComplaintOfInsects());
            householdDto.setIsIecGiven(familyEntity.getIsIecGiven());
            householdDto.setComplaintOfRodents(familyEntity.getComplaintOfRodents());
            householdDto.setDrinkingWaterSource(familyEntity.getDrinkingWaterSource());
            householdDto.setOutdoorCookingPractice(familyEntity.getOutdoorCookingPractices());
            householdDto.setWaterSafetyMeetsStandard(familyEntity.getWaterSafetyMeetsStandard());
            householdDto.setTypeOfToilet(familyEntity.getTypeOfToilet());
            householdDto.setStorageMeetsStandard(familyEntity.getStorageMeetsStandard());
            householdDto.setSeparateLivestockShelter(familyEntity.getSeparateLivestockShelter());
            householdDto.setNoOfMosquitoNetsAvailable(familyEntity.getNoOfMosquitoNetsAvailable());
            householdDto.setHandwashAvailable(familyEntity.getHandwashAvailable());
            householdDto.setOtherWasteDisposal(familyEntity.getOtherWasteDisposal());
            return householdDto;
    }
}

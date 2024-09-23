package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.List;

/**
 * <p>
 * DTO for Household Details.
 * </p>
 */
@Data
public class HouseholdDto {

    private String familyId;

    private String houseNumber;

    private Integer locationId;

    private String address1;

    private Integer areaId;

    private Boolean outdoorCookingPractice;

    private String typeOfToilet;

    private String drinkingWaterSource;

    private Boolean handwashAvailable;

    private String otherWasteDisposal;

    private Boolean storageMeetsStandard;

    private Boolean waterSafetyMeetsStandard;

    private Boolean dishrackAvailable;

    private Boolean complaintOfInsects;

    private Boolean complaintOfRodents;

    private Boolean separateLivestockShelter;

    private Integer noOfMosquitoNetsAvailable;

    private Boolean isIecGiven;

    private String latitude;

    private String longitude;

    private List<ClientMemberDto> members;

}

package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.LinkedList;

@Setter
@Getter
public class HouseHoldLineListMobileDto {
    private String currentLatitude;
    private String currentLongitude;
    private Integer locationId;
    private String familyNumber;
    private String familyHead;
    private String familyAvailable;
    private String houseNumber;
    private String houseAddress;
    private String toiletType;
    private Boolean cookingPractices;
    private Boolean handWashAvailable;
    private Boolean isWasteDisposalAvailable;
    private String[] wasteDisposalType;
    private String otherWasteDisposalType;
    private Boolean isWaterSafe;
    private String waterSource;
    private Boolean storageStandards;
    private Boolean dishRackAvailable;
    private Boolean insectsFound;
    private Boolean rodentsFound;
    private Boolean livestockShelterFound;
    private Integer mosquitoNetAvailable;
    private Boolean isIECGiven;
    private LinkedList<MemberDetails> memberDetails;
    private String motherRelation;
    private String husbandRelation;
    private String uuid;

    @Setter
    @Getter
    public static class MemberDetails {
        private String uniqueHealthId;
        private String memberUuid;
        private String memberName;
        private String motherName;
        private String husbandName;
        private String memberStatus;
        private Boolean isHof;
        private String relationWithHof;
        private String firstName;
        private String middleName;
        private String lastName;
        private String nextOfKin;
        private String religion;
        private String identityProof;
        private String NRCNumber;
        private String passportNumber;
        private String birthCertificateNumber;
        private String gender;
        private Integer maritalStatus;
        private Long dob;
        private Long age;
        private Boolean isWomanPregnant;
        private String mobileNumber;
        private Boolean menstruationArrived;
        private Boolean hysterectomyArrived;
        private Boolean menopauseArrived;
        private Long lmpDate;
        private Boolean isLivingWithPartner;
        private Long livingWithPartner;
        private Integer educationStatus;
        private Boolean isChildGoingToSchool;
        private String childStandard;
        private Boolean familyPlanning;
        private String[] chronicDisease;
        private String[] disabilityIds;
        private String otherDisabilities;
        private Boolean onTreatment;
        private String whyNoTreatment;
        private String[] chronicDiseaseTreatment;
        private String otherChronicDiseaseTreatment;
        private String otherChronicDisease;
        private String locationId;
        private String familyId;
        private Long deathDate;
        private String deathPlace;
        private String otherDeathPlace;
        private String deathReason;
        private String otherDeathReason;
        private String deathHealthInfraId;
        private String newHofId;
        private String motherId;
    }
}

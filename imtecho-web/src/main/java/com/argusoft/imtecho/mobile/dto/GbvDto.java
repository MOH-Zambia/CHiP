package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GbvDto {
    private Boolean furtherTreatment;
    private String healthInfra;
    private Long serviceDate;
    private long mobileStartDate;
    private long mobileEndDate;
    private String memberId;
    private String memberUuid;
    private String familyId;
    private String currentLatitude;
    private String currentLongitude;
    private long caseDate;
    private String memberStatus;
    private boolean severeCase;
    private boolean clientResponse;
    private boolean threatenedWithViolencePast12Months;
    private boolean physicallyHurtPast12Months;
    private boolean forcedSexPast12Months;
    private boolean forcedSexForEssentialsPast12Months;
    private boolean physicallyForcedPregnancyPast12Months;
    private boolean pregnantDueToForce;
    private boolean forcedPregnancyLossPast12Months;
    private boolean coercedOrForcedMarriagePast12Months;
    private String photoDocId;
    private String photoUniqueId;
    private String typeOfGbv;
    private String typeOfDifficulty;
    private String referralRequired;
    private String referralReason;
    private String otherReferralReason;
    private Integer referralPlace;
    private boolean iecGiven;
}

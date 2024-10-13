package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

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
    @Getter
    @Setter
    private String photoDocId;
    @Getter
    @Setter
    private String photoUniqueId;
    @Getter
    @Setter
    private String typeOfGbv;
    @Setter
    @Getter
    private String typeOfDifficulty;

    public Boolean getFurtherTreatment() {
        return furtherTreatment;
    }

    public void setFurtherTreatment(Boolean furtherTreatment) {
        this.furtherTreatment = furtherTreatment;
    }

    public String getHealthInfra() {
        return healthInfra;
    }

    public void setHealthInfra(String healthInfra) {
        this.healthInfra = healthInfra;
    }

    public Long getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Long serviceDate) {
        this.serviceDate = serviceDate;
    }

    public long getMobileStartDate() {
        return mobileStartDate;
    }

    public void setMobileStartDate(long mobileStartDate) {
        this.mobileStartDate = mobileStartDate;
    }

    public long getMobileEndDate() {
        return mobileEndDate;
    }

    public void setMobileEndDate(long mobileEndDate) {
        this.mobileEndDate = mobileEndDate;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getFamilyId() {
        return familyId;
    }

    public void setFamilyId(String familyId) {
        this.familyId = familyId;
    }

    public String getCurrentLatitude() {
        return currentLatitude;
    }

    public void setCurrentLatitude(String currentLatitude) {
        this.currentLatitude = currentLatitude;
    }

    public String getCurrentLongitude() {
        return currentLongitude;
    }

    public void setCurrentLongitude(String currentLongitude) {
        this.currentLongitude = currentLongitude;
    }

    public long getCaseDate() {
        return caseDate;
    }

    public void setCaseDate(long caseDate) {
        this.caseDate = caseDate;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }

    public boolean getSevereCase() {
        return severeCase;
    }

    public void setSevereCase(boolean severeCase) {
        this.severeCase = severeCase;
    }

    public boolean getClientResponse() {
        return clientResponse;
    }

    public void setClientResponse(boolean clientResponse) {
        this.clientResponse = clientResponse;
    }

    public boolean getThreatenedWithViolencePast12Months() {
        return threatenedWithViolencePast12Months;
    }

    public void setThreatenedWithViolencePast12Months(boolean threatenedWithViolencePast12Months) {
        this.threatenedWithViolencePast12Months = threatenedWithViolencePast12Months;
    }

    public boolean getPhysicallyHurtPast12Months() {
        return physicallyHurtPast12Months;
    }

    public void setPhysicallyHurtPast12Months(boolean physicallyHurtPast12Months) {
        this.physicallyHurtPast12Months = physicallyHurtPast12Months;
    }

    public boolean getForcedSexPast12Months() {
        return forcedSexPast12Months;
    }

    public void setForcedSexPast12Months(boolean forcedSexPast12Months) {
        this.forcedSexPast12Months = forcedSexPast12Months;
    }

    public boolean getForcedSexForEssentialsPast12Months() {
        return forcedSexForEssentialsPast12Months;
    }

    public void setForcedSexForEssentialsPast12Months(boolean forcedSexForEssentialsPast12Months) {
        this.forcedSexForEssentialsPast12Months = forcedSexForEssentialsPast12Months;
    }

    public boolean getPhysicallyForcedPregnancyPast12Months() {
        return physicallyForcedPregnancyPast12Months;
    }

    public void setPhysicallyForcedPregnancyPast12Months(boolean physicallyForcedPregnancyPast12Months) {
        this.physicallyForcedPregnancyPast12Months = physicallyForcedPregnancyPast12Months;
    }

    public boolean getPregnantDueToForce() {
        return pregnantDueToForce;
    }

    public void setPregnantDueToForce(boolean pregnantDueToForce) {
        this.pregnantDueToForce = pregnantDueToForce;
    }

    public boolean getForcedPregnancyLossPast12Months() {
        return forcedPregnancyLossPast12Months;
    }

    public void setForcedPregnancyLossPast12Months(boolean forcedPregnancyLossPast12Months) {
        this.forcedPregnancyLossPast12Months = forcedPregnancyLossPast12Months;
    }

    public boolean getCoercedOrForcedMarriagePast12Months() {
        return coercedOrForcedMarriagePast12Months;
    }

    public void setCoercedOrForcedMarriagePast12Months(boolean coercedOrForcedMarriagePast12Months) {
        this.coercedOrForcedMarriagePast12Months = coercedOrForcedMarriagePast12Months;
    }

    public String getMemberUuid() {
        return memberUuid;
    }

    public void setMemberUuid(String memberUuid) {
        this.memberUuid = memberUuid;
    }
}

package com.argusoft.imtecho.scpro.dto;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ReferralDTO {
    private String referralId;
    private String referredFrom;
    private String referredTo;
    private Date referredOn;
    private String referredBy;
    private List<String> reasons;
    private String typeOfReferral;
    private String serviceArea;
    private String notes;
    private String clientNupn;
}
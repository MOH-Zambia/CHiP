package com.argusoft.imtecho.scpro.dto;
import lombok.Data;

import java.util.Date;

@Data
public class ReferralDTO {
    private String referralId;
    private String referredFrom;
    private String referredTo;
    private Date referredOn;
    private String referredBy;
    private String reasons;
    private String typeOfReferral;
    private String serviceArea;
    private String notes;
    private String clientNUPN;
}
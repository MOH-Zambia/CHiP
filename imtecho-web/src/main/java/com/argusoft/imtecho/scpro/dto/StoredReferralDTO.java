package com.argusoft.imtecho.scpro.dto;

import lombok.Data;

@Data
public class StoredReferralDTO {
    private Integer id;
    private String nupn;
    private String facility;
    private String reasonForReferral;
    private String referralType;
    private String province;
    private String district;
    private String additionalComments;
}

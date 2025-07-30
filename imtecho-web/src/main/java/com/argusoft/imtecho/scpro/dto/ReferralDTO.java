package com.argusoft.imtecho.scpro.dto;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ReferralDTO {
    private String nupn;
    private String facility;
    private String reasonForReferral;
    private String referralType;
    private String province;
    private String district;
    private String additionalComments;

}
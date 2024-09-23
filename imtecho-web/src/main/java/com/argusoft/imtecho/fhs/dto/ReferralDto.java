package com.argusoft.imtecho.fhs.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;

/**
 * <p>
 * DTO for Referral Details.
 * </p>
 */
@Data
public class ReferralDto {

    private String referredFrom;
    private String referredTo;

    @JsonFormat(pattern = "yyyy-MM-dd' 'HH:mm:ss")
    private String uniqueId;
    private Date referredOn;
    private String referredBy;
    private String reasons;
    private String  typeCode = "310449005";
    private String typeDescription = "Referral to hospital";
    private String serviceArea;
    private String notes;
    private String systemClientId;
    private String patientId;
    private String firstName;
    private String middleName;
    private String lastName;
    private String religion;
    private String NRC;
    private String gender;
    private String maritalStatus;
    private Date dateOfBirth;
    private String mobileNumber;
    private String location;
}

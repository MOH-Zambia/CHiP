package com.argusoft.imtecho.fhs.dto;

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
    private Integer referredTo;
    private Date referredOn;
    private Integer referredBy;
    private String reasons;
    private String  typeCode;
    private String typeDescription;
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
    private Integer maritalStatus;
    private Date dateOfBirth;
    private String mobileNumber;
    private Integer location;
}

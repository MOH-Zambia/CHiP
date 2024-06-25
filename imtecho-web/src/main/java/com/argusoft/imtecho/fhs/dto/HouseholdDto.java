package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.util.Date;
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

    private String religion;

    private String caste;

    private Boolean bplFlag;

    private Integer anganwadiId;

    private Boolean toiletAvailableFlag;

    private Boolean isVerifiedFlag;

    private String state;

    private Integer assignedTo;

    private String address1;

    private String address2;

    private String maaVatsalyaNumber;

    private Integer areaId;

    private Boolean vulnerableFlag;

    private Boolean migratoryFlag;

    private String latitude;

    private String longitude;

    private String rsbyCardNumber;

    private String comment;

    private Integer currentState;

    private Boolean isReport;

    private Integer contactPersonId;

    private Integer createdBy;

    private Date createdOn;

    private Integer modifiedBy;

    private Date modifiedOn;

    private List<ClientMemberDto> members;
}

package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * @author batul
 */
@Getter
@Setter
public class AnemiaMemberDataBean {

    private Integer actualId;

    private String opdId;

    private Integer labId;

    private Integer locationId;

    private String firstName;

    private String middleName;

    private String lastName;

    private String gender;

    private String mobileNumber;

    private Long dob;

    private Boolean isPregnantFlag;

    private Boolean isEligibleForAnemia;

    private Long lmpDate;

    private String caste;

    private String religion;

    private String occupation;

    private Date modifiedOn;

}

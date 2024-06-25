package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * @author batul
 */
@Getter
@Setter
public class HUMemberDataBean {

    private Integer actualId;

    private String uniqueHealthId;

    private String opdId;

    private Integer locationId;

    private String firstName;

    private String middleName;

    private String lastName;

    private String mobileNumber;

    private Long dob;

    private Long lmpDate;

    private Boolean medicalAssessmentDone;

    private String state;

    private Long lastServiceDate;

    private Long nextFollowupDate;

    private Date modifiedOn;

}

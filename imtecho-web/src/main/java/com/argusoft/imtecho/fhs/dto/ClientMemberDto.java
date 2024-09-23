package com.argusoft.imtecho.fhs.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Set;

/**
 * <p>
 * Used for client member.
 * </p>
 */
@Data
public class ClientMemberDto {

    private Integer id;
    private String firstName;
    private String middleName;
    private String lastName;
    private String gender;
    private String maritalStatus;
    private String mobileNumber;
    private Date dob;
    private String uniqueHealthId;
    private Boolean isPregnantFlag;
    private Date lmpDate;
    private String familyPlanningMethod;
    private String educationStatus;
    private Boolean underTreatmentChronic;
    private String otherChronic;
    private String nrcNumber;
    private String passportNumber;
    private String bloodGroup;

    private transient Set<Integer> chronicDiseaseDetails;
    private transient Set<Integer> chronicDiseaseTreatmentDetails;
    private transient Set<Integer> congenitalAnomalyDetails;
    private transient Set<Integer> currentDiseaseDetails;

    private BigDecimal haemoglobin;
    private BigDecimal weight;
    private Date edd;
    private String immunisationGiven;
    private String lastMethodOfContraception;
    private Boolean menopauseArrived;
    private String congenitalAnomaly;
    private String chronicDisease;
    private String currentDisease;
    private Boolean hysterectomyDone;
    private String physicalDisability;
    private String otherDisability;
    private String chronicDiseaseTreatment;
    private String otherChronicDiseaseTreatment;
    private String memberReligion;

}

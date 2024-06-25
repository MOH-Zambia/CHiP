package com.argusoft.imtecho.fhs.dto;

import com.argusoft.imtecho.cfhc.model.MemberCFHCEntity;
import lombok.Data;

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
    private String familyId;
    private String firstName;
    private String middleName;
    private String lastName;
    private String husbandName;
    private Integer husbandId;
    private String gender;
    private Integer maritalStatus;
    private String mobileNumber;
    private Boolean familyHeadFlag;
    private Date dob;
    private String uniqueHealthId;
    private Boolean isPregnantFlag;
    private transient boolean markedPregnant;
    private Date lmpDate;
    private Short normalCycleDays;
    private String familyPlanningMethod;
    private Date fpInsertOperateDate;
    private String state;
    private String grandfatherName;
    private Boolean isMobileNumberVerified;
    private Boolean isNativeFlag;
    private Integer educationStatus;
    private Boolean isReport;
    private String occupation;
    private Boolean underTreatmentChronic;
    private String otherChronic;
    private String otherEyeIssue;
    private String motherName;
    private String nrcNumber;
    private String passportNumber;
    private String birthCertificateNumber;
    private String fpStage;

    private transient boolean isDuplicateNrc;
    private transient boolean isDuplicatePassport;
    private transient boolean isDuplicateBirthCert;
    private transient String duplicateNrcNumber;
    private transient String duplicatePassportNumber;
    private transient String duplicateBirthCertNumber;
    private transient Set<Integer> chronicDiseaseDetails;
    private transient Set<Integer> chronicDiseaseTreatmentDetails;
    private transient Set<Integer> congenitalAnomalyDetails;
    private transient Set<Integer> currentDiseaseDetails;
    private transient Set<Integer> eyeIssueDetails;

    private String mergedFromFamilyId;
    private Boolean agreedToShareAadhar;
    private String aadharStatus;
    private Short yearOfWedding;
    private Date dateOfWedding;
    private Boolean jsyPaymentGiven;
    private Boolean isEarlyRegistration;
    private Integer motherId;
    private Boolean jsyBeneficiary;
    private Boolean iayBeneficiary;
    private Boolean kpsyBeneficiary;
    private Boolean chiranjeeviYojnaBeneficiary;
    private Float haemoglobin;
    private Float weight;
    private Date edd;
    private String ancVisitDates;
    private String immunisationGiven;
    private String bloodGroup;
    private String placeOfBirth;
    private Float birthWeight;
    private Boolean complementaryFeedingStarted;
    private String lastMethodOfContraception;
    private Boolean isHighRiskCase;
    private Integer curPregRegDetId;
    private Date curPregRegDate;
    private Boolean menopauseArrived;
    private String syncStatus;
    private Boolean isIucdRemoved;
    private Date iucdRemovalDate;
    private String congenitalAnomaly;
    private String chronicDisease;
    private String currentDisease;
    private String eyeIssue;
    private Date lastDeliveryDate;
    private Boolean hysterectomyDone;
    private String childNrcCmtcStatus;
    private String lastDeliveryOutcome;
    private transient Set<String> previousPregnancyComplication;
    private String previousPregnancyComplicationCsv;
    private String remarks;
    private String additionalInfo;
    private Boolean suspectedCp;
    private Date npcbScreeningDate;
    private Boolean fhsrPhoneVerified;
    private String basicState;
    private Date eligibleCoupleDate;
    private Short currentGravida;
    private Short currentPara;
    private Integer familyPlanningHealthInfrastructure;
    private String relationWithHof;
    private String memberUUId; //This column hold Unique UUID for member. While using it check if value not exist then generate and persist in DB
    private Boolean vulnerableFlag;
    private String abhaStatus;
    private String healthId;
    private String healthIdNumber;
    private Boolean healthInsurance;
    private String schemeDetail;
    private Boolean isPersonalHistoryDone;
    private String pmjayAvailability;
    private String alcoholAddiction;
    private String smokingAddiction;
    private String tobaccoAddiction;
    private String rchId;
    private Boolean hospitalizedEarlier;
    private String alternateNumber;
    private String physicalDisability;
    private String otherDisability;
    private String cataractSurgery;
    private String sickleCellStatus;
    private String pensionScheme;
    private String otherHofRelation;
    private Boolean isChildGoingSchool;
    private String currentStudyingStandard;
    private transient String ndhmHealthId;
    private transient MemberCFHCEntity memberCFHCEntity;
    private Boolean isAbhaFailed;
    private String chronicDiseaseTreatment;
    private String otherChronicDiseaseTreatment;
    private String fpSubMethod;
    private String fpAlternativeMainMethod;

    private String fpAlternativeSubMethod;

    private String memberReligion;

    private String notUsingFpReason;

    private Boolean startedMenstruating;

    private Boolean planningForFamily;
    private Boolean personallyUsingFp;
    private String nextOfKin;

    private Boolean isIecGiven;

    private String whyStopFp;

    private Boolean haveNssf;

    private String nssfCardNumber;

    private String whyNoTreatment;

}

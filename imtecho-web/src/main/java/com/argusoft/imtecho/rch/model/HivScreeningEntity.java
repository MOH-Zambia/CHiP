package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "rch_hiv_screening_master")
public class HivScreeningEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "family_id")
    private Integer familyId;

    @Column(name = "location_id")
    private Integer locationId;

    @Column(name = "previous_hiv_test_result")
    private boolean childHivTest;

    @Column(name = "hiv_test_result")
    private boolean hivTestResult;

    @Column(name = "child_currently_on_art")
    private boolean childCurrentlyOnArt;

    @Column(name = "child_art_enrollment_number")
    private String childArtEnrollmentNumber;

    @Column(name = "child_mother_hiv_positive")
    private boolean childMotherHivPositive;

    @Column(name = "child_parent_dead")
    private boolean childParentDead;

    @Column(name = "child_has_tb_symptoms")
    private boolean childHasTbSymptoms;

    @Column(name = "child_sick")
    private boolean childSick;

    @Column(name = "child_rashes")
    private boolean childRashes;

    @Column(name = "pus_near_ear")
    private boolean pusNearEar;

    @Column(name = "child_eligible_for_test")
    private boolean childEligibleForTest;

    @Column(name = "ever_told_hiv_positive")
    private boolean everToldHivPositive;

    @Column(name = "receiving_art")
    private boolean receivingArt;

    @Column(name = "client_art_number")
    private String clientArtNumber;

    @Column(name = "tested_for_hiv_in_12_months")
    private boolean testedForHivIn12Months;

    @Column(name = "symptoms")
    private boolean symptoms;

    @Column(name = "private_parts_symptoms")
    private boolean privatePartsSymptoms;

    @Column(name = "exposed_to_hiv")
    private boolean exposedToHiv;

    @Column(name = "unprotected_sex_in_last_6_months")
    private boolean unprotectedSexInLast6Months;

    @Column(name = "pregnant_or_breastfeeding")
    private boolean pregnantOrBreastfeeding;

    @Column(name = "eligible_for_hiv")
    private boolean eligibleForHiv;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "member_status")
    private String memberStatus;
}

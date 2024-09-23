package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "tuberculosis_screening_details")
@Getter
@Setter
public class ChipTBEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "family_id")
    private Integer familyId;

    @Column(name = "location_id")
    private Integer locationId;

    @Column(name = "tuberculosis_symptoms")
    private String tuberculosisSymptoms;

    @Column(name = "is_tb_testing_done")
    private Boolean isTbTestingDone;

    @Column(name = "tb_test_type")
    private String tbTestType;

    @Column(name = "is_tb_suspected")
    private Boolean isTbSuspected;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "referral_for")
    private String referralFor;

    @Column(name = "is_tb_cured")
    private Boolean isTbCured;

    @Column(name = "is_patient_taking_medicines")
    private Boolean isPatientTakingMedicines;

    @Column(name = "any_reaction_or_side_effect")
    private Boolean anyReactionOrSideEffect;

    @Column(name = "form_type")
    private String formType;

    @Column(name = "other_tb_symptoms")
    private String otherTbSymptoms;

    @Column(name = "is_referral_done")
    private String referralDone;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "started_menstruating")
    private Boolean startedMenstruating;

    @Column(name = "lmp_date")
    @Temporal(TemporalType.DATE)
    private Date lmpDate;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    @Column(name = "member_status")
    private String memberStatus;

    @Column(name = "reason_for_not_testing")
    private String reasonForNotTesting;

}

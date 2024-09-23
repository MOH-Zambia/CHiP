package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "malaria_details")
@Getter
@Setter
public class ChipMalariaEntity extends EntityAuditInfo implements Serializable {

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

    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "active_malaria_symptoms")
    private String activeMalariaSymptoms;

    private transient Set<Integer> activeMalariaSDetails;

    @Column(name = "rdt_test_status")
    private String rdtTestStatus;

    @Column(name = "having_travel_history")
    private Boolean havingTravelHistory;

    @Column(name = "malaria_treatment_history")
    private Boolean malariaTreatmentHistory;

    @Column(name = "is_treatment_being_given")
    private Boolean isTreatmentBeingGiven;

    @Column(name = "referral_place")
    private Integer referralPlace;

    @Column(name = "malaria_type")
    private String malariaType;

    @Column(name = "other_malaria_symptoms")
    private String otherMalariaSymtoms;

    @Column(name = "is_referral_done")
    private String referralDone;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "referral_for")
    private String referralFor;

    @Column(name = "started_menstruating")
    private Boolean startedMenstruating;

    @Column(name = "lmp_date")
    @Temporal(TemporalType.DATE)
    private Date lmpDate;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    @Column(name = "is_index_case")
    private Boolean isIndexCase;

    @Column(name = "member_status")
    private String memberStatus;

    @Column(name = "treatment_given")
    private String treatmentGiven;


}

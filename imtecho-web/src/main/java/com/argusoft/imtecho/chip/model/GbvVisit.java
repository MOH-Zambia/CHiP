package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.rch.model.VisitCommonFields;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "gbv_visit_master")
public class GbvVisit extends VisitCommonFields implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;
    @Column(name = "further_treatment")
    private Boolean furtherTreatment;
    @Column(name = "health_infra")
    private String healthInfra;
    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;
    @Column(name = "case_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date caseDate;
    @Column(name = "member_status")
    private String memberStatus;
    @Column(name = "severe_case")
    private boolean severeCase;
    @Column(name = "client_response")
    private boolean clientResponse;
    @Column(name = "threatened_with_violence_past_12_months")
    private boolean threatenedWithViolencePast12Months;
    @Column(name = "physically_hurt_past_12_months")
    private boolean physicallyHurtPast12Months;
    @Column(name = "forced_sex_past_12_months")
    private boolean forcedSexPast12Months;
    @Column(name = "forced_sex_for_essentials_past_12_months")
    private boolean forcedSexForEssentialsPast12Months;
    @Column(name = "physically_forced_pregnancy_past_12_months")
    private boolean physicallyForcedPregnancyPast12Months;
    @Column(name = "pregnant_due_to_force")
    private boolean pregnantDueToForce;
    @Column(name = "forced_pregnancy_loss_past")
    private boolean forcedPregnancyLossPast12Months;
    @Column(name = "coerced_or_forced_marriage_past_12_months")
    private boolean coercedOrForcedMarriagePast12Months;
}

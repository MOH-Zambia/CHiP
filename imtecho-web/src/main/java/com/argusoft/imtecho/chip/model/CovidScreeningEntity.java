package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "covid_screening_details")
@Getter
@Setter
public class CovidScreeningEntity extends EntityAuditInfo implements Serializable {

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
    @Column(name = "is_dose_one_taken")
    private Boolean isDoseOneTaken;
    @Column(name = "dose_one_name")
    private String doseOneName;
    @Column(name = "dose_one_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseOneDate;
    @Column(name = "is_dose_two_taken")
    private Boolean isDoseTwoTaken;
    @Column(name = "dose_two_name")
    private String doseTwoName;
    @Column(name = "dose_two_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseTwoDate;
    @Column(name = "willing_for_booster_vaccine")
    private Boolean willingForBoosterVaccine;
    @Column(name = "is_booster_dose_given")
    private Boolean isBoosterDoseGiven;
    @Column(name = "booster_name")
    private String boosterName;
    @Column(name = "booster_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date boosterDate;
    @Column(name = "dose_one_schedule_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseOneScheduleDate;
    @Column(name = "dose_two_schedule_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doseTwoScheduleDate;
    @Column(name = "booster_dose_schedule_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date boosterDoseScheduleDate;
    @Column(name = "any_reactions")
    private Boolean anyReactions;
    @Column(name = "referral_for")
    private String referralFor;
    @Column(name = "is_iec_given")
    private Boolean isIecGiven;
    @Column(name = "member_status")
    private String memberStatus;
    @Column(name = "reation_and_effects")
    private String reactionAndEffects;
    @Column(name = "other_effects")
    private String otherEffects;
    @Column(name = "is_referral_done")
    private String referralDone;
    @Column(name = "referral_reason")
    private String referralReason;
    @Column(name = "referral_place")
    private Integer referralPlace;
    @Column(name = "vaccination_status")
    private String vaccinationStatus;


}

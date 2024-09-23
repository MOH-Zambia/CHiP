package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Getter
@Setter
@Table(name = "malaria_index_case_details")
public class MalariaIndexCaseEntity extends EntityAuditInfo implements Serializable {
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
    @Column(name = "gps_location")
    private String gpsLocation;
    @Column(name = "was_visit_conducted")
    private Boolean wasVisitConducted;
    @Column(name = "reason_for_no_visit")
    private String reasonForNoVisit;
    @Column(name = "individuals_living")
    private Integer individualsLiving;
    @Column(name = "sprayable_surface")
    private String sprayableSurface;
    @Column(name = "non_sprayable_surface")
    private String nonSprayableSurface;
    @Column(name = "was_irs_conducted")
    private Boolean wasIrsConducted;
    @Column(name = "date_of_last_spray")
    @Temporal(TemporalType.DATE)
    private Date dateOfLastSpray;
    @Column(name = "having_llin")
    private Boolean havingLlin;
    @Column(name = "are_llin_hanging")
    private Boolean areLlinHanging;
    @Column(name = "number_of_llins_hanging")
    private Integer numberOfLlinsHanging;
    @Column(name = "sleep_under_llin")
    private Boolean sleepUnderLlin;
    @Column(name = "sleeping_in_sprayed_room")
    private Boolean sleepingInSprayedRoom;
    @Column(name = "days_passed_of_diagnosis")
    private Integer daysPassedOfDiagnosis;
    @Column(name = "patient_adhered_to_treatment")
    private Boolean patientAdheredToTreatment;
    @Column(name = "day_of_treatment")
    private String dayOfTreatment;
    @Column(name = "where_evidence_is_seen")
    private String whereEvidenceIsSeen;
    @Column(name = "temperature")
    private String temperature;
    @Column(name = "were_you_referred")
    private Boolean wereYouReferred;
    @Column(name = "went_to_referral_place")
    private Boolean wentToReferralPlace;
    @Column(name = "patient_showing_signs")
    private String patientShowingSigns;
    @Column(name = "patient_experiencing_signs")
    private String patientExperiencingSigns;
    @Column(name = "other_exp_signs")
    private String otherExpSigns;
    @Column(name = "was_dbs_collected")
    private Boolean wasDbsCollected;
    @Column(name = "blood_spot_result")
    private String bloodSpotResult;
    @Column(name = "blood_splot_value")
    private String bloodSplotValue;
    @Column(name = "member_status")
    private String memberStatus;
    @Column(name = "latitude")
    private String latitude;
    @Column(name = "longitude")
    private String longitude;
    @Column(name = "other_showing_signs")
    private String otherShowingSigns;

}

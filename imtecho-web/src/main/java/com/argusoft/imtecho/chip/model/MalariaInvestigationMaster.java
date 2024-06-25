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
@Table(name = "malaria_investigation_master")
public class MalariaInvestigationMaster extends EntityAuditInfo implements Serializable {

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
    @Column(name = "latitude")
    private String latitude;
    @Column(name = "longitude")
    private String longitude;
    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;
    @Column(name = "breeding_site_flag")
    private Boolean breedingSiteFlag;
    @Column(name = "breeding_site_location")
    private String breedingSiteLocation;
    @Column(name = "anopheles_detected")
    private Boolean anophelesDetected;
    @Column(name = "anopheles_stage")
    private String anophelesStage;
    @Column(name = "site_permanence")
    private String sitePermanence;

    @Column(name = "site_type")
    private String siteType;
    @Column(name = "other_site_type")
    private String otherSiteType;

    @Column(name = "recommended_actions")
    private String recommendedActions;
    @Column(name = "other_recommended_actions")
    private String otherRecommendedActions;

    @Column(name = "actions_taken")
    private String actionsTaken;
    @Column(name = "other_actions_taken")
    private String otherActionsTaken;

    @Column(name = "structures_found")
    private Integer structuresFound;
    @Column(name = "eligible_structures")
    private Integer eligibleStructures;
    @Column(name = "strc_sprayed_last_12_month")
    private Integer strSprayedLast12Month;

    @Column(name = "total_people")
    private Integer totalPeople;
    @Column(name = "llin_dist_last_12_month")
    private Integer llinDistLast12Month;
    @Column(name = "llin_people_slept")
    private Integer llinPeopleSlept;

}

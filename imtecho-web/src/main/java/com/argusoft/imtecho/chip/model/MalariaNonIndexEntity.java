package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(name = "malaria_non_index_case_details")
public class MalariaNonIndexEntity extends EntityAuditInfo implements Serializable {
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
    @Column(name = "gps_location")
    private String gpsLocation;
    @Column(name = "has_consent_sought")
    private Boolean hasConsentSought;
    @Column(name = "reason_for_no_consent")
    private String reasonForNoConsent;
    @Column(name = "individuals_living")
    private Integer individualsLiving;
    @Column(name = "individuals_on_last_night")
    private Integer individualsOnLastNight;
    @Column(name = "people_tested_in_household")
    private Integer peopleTestedInHousehold;
    @Column(name = "people_rcd_positive")
    private Integer peopleRcdPositive;
    @Column(name = "sprayable_surface")
    private String sprayableSurface;
    @Column(name = "non_sprayable_surface")
    private String nonSprayableSurface;
    @Column(name = "was_irs_conducted")
    private Boolean wasIrsConducted;
    @Column(name = "date_of_last_spray")
    @Temporal(TemporalType.DATE)
    private Date dateOfLastSpray;
    @Column(name = "having_llin_in_house")
    private String havingLlinInHouse;
    @Column(name = "number_of_llins_hanging")
    private Integer numberOfLlinsHanging;
    @Column(name = "sleep_under_llin")
    private Boolean sleepUnderLlin;
    @Column(name = "took_dhap")
    private Boolean tookDhap;
    @Column(name = "took_med_for_malaria_prevention")
    private Boolean tookMedForMalariaPrevention;
    @Column(name = "received_any_other_prevention")
    private Boolean receivedAnyOtherPrevention;
    @Column(name = "other_preventive_measure")
    private String otherPreventiveMeasure;
    @Column(name = "member_status")
    private String memberStatus;
    @Column(name = "latitude")
    private String latitude;
    @Column(name = "longitude")
    private String longitude;
}

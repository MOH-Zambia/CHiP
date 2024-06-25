package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "rch_hiv_known_master")
public class HivKnownPositiveEntity extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private int id;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "family_id")
    private Integer familyId;

    @Column(name = "location_id")
    private Integer locationId;

    @Column(name = "serptrin")
    private boolean septrin;

    @Temporal(TemporalType.DATE)
    @Column(name = "duration")
    private Date duration;

    @Column(name = "arv_taken")
    private boolean arvTaken;

    @Column(name = "prep_or_pep")
    private boolean prepOrPep;

    @Column(name = "arv_during_pregnancy")
    private boolean arvDuringPregnancy;

    @Column(name = "stopped_art")
    private boolean stoppedArt;

    @Column(name = "taken_art")
    private boolean takenArt;

    @Column(name = "when_stopped")
    private String whenStopped;

    @Column(name = "place_received_art")
    private String placeReceivedArt;

    @Column(name = "other_medication_along")
    private Boolean otherMedicationAlong;

    @Column(name = "enough_medication")
    private Boolean enoughMedication;

    @Column(name = "viral_load_test")
    private Boolean viralLoadTest;

    @Column(name = "viral_load_suppressed")
    private Boolean viralLoadSuppressed;

    @Column(name = "unprotected_sex")
    private Boolean unprotectedSex;

    @Column(name = "hiv_status_of_member_known")
    private Boolean hivStatusOfMemberKnown;

    @Column(name = "willing_to_share_status")
    private Boolean willingToShareStatus;

    @Column(name = "name")
    private String name;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "address")
    private String address;

    @Column(name = "lmp_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lmpDate;

    @Column(name = "member_status")
    private String memberStatus;
}

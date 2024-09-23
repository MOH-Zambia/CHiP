/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;


@Entity
@Table(name = "rch_preg_hiv_positive_master")
@Getter
@Setter
public class HivPositiveEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;
    @Column(name = "member_id")
    private Integer memberId;
    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private java.util.Date serviceDate;
    @Column(name = "family_id")
    private Integer familyId;
    @Column(name = "location_id")
    private Integer locationId;
    @Column(name = "expected_delivery_place")
    private String expectedDeliveryPlace;
    @Column(name = "is_on_art")
    private Boolean isOnArt;
    @Column(name = "is_referral_done")
    private String isReferralDone;
    @Column(name = "referral_place")
    private String referralPlace;
    @Column(name = "referral_reason")
    private String referralReason;
    @Column(name = "referral_for")
    private String referralFor;
    @Column(name = "member_status")
    private String memberStatus;

}

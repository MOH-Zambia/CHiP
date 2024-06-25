/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;
import java.io.Serializable;


@Entity
@Table(name = "rch_preg_hiv_positive_master")
public class HivPositiveEntity extends EntityAuditInfo implements Serializable {

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


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getExpectedDeliveryPlace() {
        return expectedDeliveryPlace;
    }

    public void setExpectedDeliveryPlace(String expectedDeliveryPlace) {
        this.expectedDeliveryPlace = expectedDeliveryPlace;
    }

    public Boolean getOnArt() {
        return isOnArt;
    }

    public void setOnArt(Boolean onArt) {
        isOnArt = onArt;
    }

    public String getReferralDone() {
        return isReferralDone;
    }

    public void setReferralDone(String referralDone) {
        isReferralDone = referralDone;
    }

    public String getReferralPlace() {
        return referralPlace;
    }

    public void setReferralPlace(String referralPlace) {
        this.referralPlace = referralPlace;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    public String getReferralReason() {
        return referralReason;
    }

    public void setReferralReason(String referralReason) {
        this.referralReason = referralReason;
    }

    public String getReferralFor() {
        return referralFor;
    }

    public void setReferralFor(String referralFor) {
        this.referralFor = referralFor;
    }

    public String getMemberStatus() {
        return memberStatus;
    }

    public void setMemberStatus(String memberStatus) {
        this.memberStatus = memberStatus;
    }
}

package com.argusoft.imtecho.chip.model;
import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "store_referral_details")
@Data
public class StoreReferralDetails extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name="referral_id")
    private Integer referralId;

    @Column(name = "referral_reason")
    private String referralReason;

    @Column(name = "service_area")
    private String serviceArea;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "nupn_id")
    private String nupnId;

    @Column(name = "referred_by")
    private Integer referredBy;

    @Column(name = "referred_from")
    private Integer referredFrom;

    @Column(name = "referred_to")
    private Integer referredTo;

    @Column(name="sync_status")
    private Boolean syncStatus;

    @Column(name="notes")
    private String notes;

    @Column(name="referred_on")
    private Date referredOn;

    @Column(name="visit_id")
    private Integer visitId;

}

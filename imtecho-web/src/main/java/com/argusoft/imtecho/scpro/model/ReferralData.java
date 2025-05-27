package com.argusoft.imtecho.scpro.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "referred_patient_data")
public class ReferralData extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "referral_id", nullable = false, unique = true)
    private String referralId;

    @Column (name="client_nupn",nullable = false)
    private String clientNUPN;

    // Getters and Setters

}

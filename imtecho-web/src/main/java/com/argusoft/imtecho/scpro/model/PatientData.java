package com.argusoft.imtecho.scpro.model;
import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "patient_data")

public class PatientData extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "referral_id", nullable = false, unique = true)
    private String referralId;

    @Column(name = "nrc", nullable = false)
    private String nrc;
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * Define rch_vaccine_adverse_effect entity and its fields.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Entity
@Table(name = "rch_vaccine_adverse_effect")
@Getter
@Setter
public class VaccineAdverseEffectMaster extends VisitCommonFields implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "adverse_effect", length = 15)
    private String adverseEffect;

    @Column(name = "vaccine_name", length = 50)
    private String vaccineName;

    @Column(name = "batch_number", length = 50)
    private String batchNumber;

    @Column(name = "expiry_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date expiryDate;

    @Column(name = "manufacturer", length = 50)
    private String manufacturer;

    @Column(name = "session_site")
    private String sessionSite;

    @Column(name = "cluster")
    private Boolean cluster;

    @Column(name = "vaccination_place")
    private String vaccinationPlace;

    @Column(name = "notification_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date notificationDate;

    @Column(name = "vaccination_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date vaccinationDate;

    @Column(name = "vaccination_in")
    private String vaccinationIn;

    @Column(name = "number_of_cluster")
    private Integer numberOfCluster;

    @Column(name = "cluster_id")
    private Integer clusterId;
    @Column(name = "adverse_effect_type", length = 10)
    private String adverseEffectType;
    @Column(name = "vaccination_infra_id")
    private Integer vaccinationInfraId;

}

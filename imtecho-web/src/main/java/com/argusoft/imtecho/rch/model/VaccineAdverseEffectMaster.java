/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.model;

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
public class VaccineAdverseEffectMaster extends VisitCommonFields implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

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


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAdverseEffect() {
        return adverseEffect;
    }

    public void setAdverseEffect(String adverseEffect) {
        this.adverseEffect = adverseEffect;
    }

    public String getVaccineName() {
        return vaccineName;
    }

    public void setVaccineName(String vaccineName) {
        this.vaccineName = vaccineName;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getSessionSite() {
        return sessionSite;
    }

    public void setSessionSite(String sessionSite) {
        this.sessionSite = sessionSite;
    }

    public Boolean getCluster() {
        return cluster;
    }

    public void setCluster(Boolean cluster) {
        this.cluster = cluster;
    }

    public String getVaccinationPlace() {
        return vaccinationPlace;
    }

    public void setVaccinationPlace(String vaccinationPlace) {
        this.vaccinationPlace = vaccinationPlace;
    }

    public Date getNotificationDate() {
        return notificationDate;
    }

    public void setNotificationDate(Date notificationDate) {
        this.notificationDate = notificationDate;
    }

    public Date getVaccinationDate() {
        return vaccinationDate;
    }

    public void setVaccinationDate(Date vaccinationDate) {
        this.vaccinationDate = vaccinationDate;
    }

    public String getVaccinationIn() {
        return vaccinationIn;
    }

    public void setVaccinationIn(String vaccinationIn) {
        this.vaccinationIn = vaccinationIn;
    }

    public Integer getNumberOfCluster() {
        return numberOfCluster;
    }

    public void setNumberOfCluster(Integer numberOfCluster) {
        this.numberOfCluster = numberOfCluster;
    }

    public Integer getClusterId() {
        return clusterId;
    }

    public void setClusterId(Integer clusterId) {
        this.clusterId = clusterId;
    }

    public String getAdverseEffectType() {
        return adverseEffectType;
    }

    public void setAdverseEffectType(String adverseEffectType) {
        this.adverseEffectType = adverseEffectType;
    }

    public Integer getVaccinationInfraId() {
        return vaccinationInfraId;
    }

    public void setVaccinationInfraId(Integer vaccinationInfraId) {
        this.vaccinationInfraId = vaccinationInfraId;
    }
}

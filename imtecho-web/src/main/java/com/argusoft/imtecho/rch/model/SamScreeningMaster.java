package com.argusoft.imtecho.rch.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * <p>
 *     Define rch_sam_screening_master entity and its fields.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
@Entity
@Table(name = "rch_sam_screening_master")
public class SamScreeningMaster extends EntityAuditInfo implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "family_id")
    private Integer familyId;

    @Column(name = "location_id")
    private Integer locationId;

    @Column(name = "notification_id")
    private Integer notificationId;

    @Column(name = "child_visit_id")
    private Integer childVisitId;

    @Column(name = "screened_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date screenedOn;

    @Column(name = "height")
    private Integer height;

    @Column(name = "weight", columnDefinition = "numeric", precision = 7, scale = 3)
    private Float weight;

    @Column(name = "mid_arm_circumference", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float midArmCircumference;

    @Column(name = "have_pedal_edema")
    private Boolean havePedalEdema;

    @Column(name = "sd_score")
    private String sdScore;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "rch_sam_screening_diseases_rel", joinColumns = @JoinColumn(name = "sam_screening_id"))
    @Column(name = "diseases")
    private Set<Integer> diseases;

    @Column(name = "other_diseases")
    private String otherDiseases;

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

    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getChildVisitId() {
        return childVisitId;
    }

    public void setChildVisitId(Integer childVisitId) {
        this.childVisitId = childVisitId;
    }

    public Date getScreenedOn() {
        return screenedOn;
    }

    public void setScreenedOn(Date screenedOn) {
        this.screenedOn = screenedOn;
    }

    public Integer getHeight() {
        return height;
    }

    public void setHeight(Integer height) {
        this.height = height;
    }

    public Float getWeight() {
        return weight;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }

    public Float getMidArmCircumference() {
        return midArmCircumference;
    }

    public void setMidArmCircumference(Float midArmCircumference) {
        this.midArmCircumference = midArmCircumference;
    }

    public Boolean getHavePedalEdema() {
        return havePedalEdema;
    }

    public void setHavePedalEdema(Boolean havePedalEdema) {
        this.havePedalEdema = havePedalEdema;
    }

    public String getSdScore() {
        return sdScore;
    }

    public void setSdScore(String sdScore) {
        this.sdScore = sdScore;
    }

    public Set<Integer> getDiseases() {
        return diseases;
    }

    public void setDiseases(Set<Integer> diseases) {
        this.diseases = diseases;
    }

    public String getOtherDiseases() {
        return otherDiseases;
    }

    public void setOtherDiseases(String otherDiseases) {
        this.otherDiseases = otherDiseases;
    }
}

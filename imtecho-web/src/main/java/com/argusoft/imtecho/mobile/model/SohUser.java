package com.argusoft.imtecho.mobile.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;

@Entity
@Table(name = "soh_user")
public class SohUser extends EntityAuditInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    private String name;

    @Column(name = "designation")
    private String designation;

    @Column(name = "organization")
    private String organization;

    @Column(name = "purpose")
    private String purpose;

    @Column(name = "otp")
    private String otp;

    /*
    -- PENDING              when request come
    -- CODE_GENERATED       when admin generate code
    -- ACTIVE               when user verified valid code
    -- INACTIVE             when inactive the user
     */
    @Column(name = "state")
    private String state;

    @Column(name = "mobile_no")
    private String mobileNo;

    @Column(name = "disapproval_reason")
    private String disapprovalReason;

    @Column(name = "user_id")
    private Integer userId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getOrganization() {
        return organization;
    }

    public void setOrganization(String organization) {
        this.organization = organization;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public String getDisapprovalReason() {
        return disapprovalReason;
    }

    public void setDisapprovalReason(String disapprovalReason) {
        this.disapprovalReason = disapprovalReason;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}

package com.argusoft.imtecho.mobile.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author prateek on 4 Feb, 2019
 */
@Entity
@Table(name = "user_installed_apps")
public class UserInstalledAppsMaster extends EntityAuditInfo implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "user_id")
    private Integer userId;
    
    @Column(name = "imei")
    private String imei;

    @Column(name = "application_name")
    private String applicationName;

    @Column(name = "package_name")
    private String packageName;

    @Column(name = "uid")
    private Integer uid;
    
    @Column(name = "version_name")
    private String versionName;
    
    @Column(name = "version_code")
    private Integer versionCode;

    @Column(name = "installed_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date installedDate;
    
    @Column(name = "last_update_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastUpdateDate;
    
    @Column(name = "used_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date usedDate;
    
    @Column(name = "recieved_data")
    private Integer receivedData;
    
    @Column(name = "sent_data")
    private Integer sentData;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getImei() {
        return imei;
    }

    public void setImei(String imei) {
        this.imei = imei;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getVersionName() {
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    public Integer getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(Integer versionCode) {
        this.versionCode = versionCode;
    }

    public Integer getUid() {
        return uid;
    }

    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public Date getInstalledDate() {
        return installedDate;
    }

    public void setInstalledDate(Date installedDate) {
        this.installedDate = installedDate;
    }

    public Date getLastUpdateDate() {
        return lastUpdateDate;
    }

    public void setLastUpdateDate(Date lastUpdateDate) {
        this.lastUpdateDate = lastUpdateDate;
    }

    public Date getUsedDate() {
        return usedDate;
    }

    public void setUsedDate(Date usedDate) {
        this.usedDate = usedDate;
    }

    public Integer getReceivedData() {
        return receivedData;
    }

    public void setReceivedData(Integer receivedData) {
        this.receivedData = receivedData;
    }

    public Integer getSentData() {
        return sentData;
    }

    public void setSentData(Integer sentData) {
        this.sentData = sentData;
    }
}

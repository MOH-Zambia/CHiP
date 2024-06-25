/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.dto;

/**
 *
 * @author prateek
 */
public class MigrationConfirmationDataBean {
    
    private Integer notificationId;

    private Integer memberId;

    private Integer migrationId;

    private Integer familyId;

    private String migrationType;
    
    private Boolean hasMigrationHappened;

    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Integer getMigrationId() {
        return migrationId;
    }

    public void setMigrationId(Integer migrationId) {
        this.migrationId = migrationId;
    }

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public String getMigrationType() {
        return migrationType;
    }

    public void setMigrationType(String migrationType) {
        this.migrationType = migrationType;
    }

    public Boolean getHasMigrationHappened() {
        return hasMigrationHappened;
    }

    public void setHasMigrationHappened(Boolean hasMigrationHappened) {
        this.hasMigrationHappened = hasMigrationHappened;
    }

    @Override
    public String toString() {
        return "MigrationConfirmationDataBean{" + "notificationId=" + notificationId + ", memberId=" + memberId + ", migrationId=" + migrationId + ", familyId=" + familyId + ", migrationType=" + migrationType + ", hasMigrationHappened=" + hasMigrationHappened + '}';
    }
}

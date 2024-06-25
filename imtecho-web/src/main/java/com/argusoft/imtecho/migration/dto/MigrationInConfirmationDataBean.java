package com.argusoft.imtecho.migration.dto;

/**
 *
 * @author prateek on 18 Mar, 2019
 */
public class MigrationInConfirmationDataBean {

    private Integer notificationId;
    private Integer migrationId;
    private Integer memberId;
    private Boolean hasMigrationHappened;
    private Integer familyMigratedTo;

    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getMigrationId() {
        return migrationId;
    }

    public void setMigrationId(Integer migrationId) {
        this.migrationId = migrationId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Boolean getHasMigrationHappened() {
        return hasMigrationHappened;
    }

    public void setHasMigrationHappened(Boolean hasMigrationHappened) {
        this.hasMigrationHappened = hasMigrationHappened;
    }

    public Integer getFamilyMigratedTo() {
        return familyMigratedTo;
    }

    public void setFamilyMigratedTo(Integer familyMigratedTo) {
        this.familyMigratedTo = familyMigratedTo;
    }
    
}

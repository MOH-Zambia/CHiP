package com.argusoft.imtecho.migration.dto;

/**
 *
 * @author prateek on Aug 20, 2019
 */
public class FamilyMigrationInConfirmationDataBean {

    private Integer notificationId;
    private Integer migrationId;
    private Integer familyId;
    private Boolean hasMigrationHappened;
    private Integer locationMigratedTo;
    private Integer areaMigratedTo;

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

    public Integer getFamilyId() {
        return familyId;
    }

    public void setFamilyId(Integer familyId) {
        this.familyId = familyId;
    }

    public Boolean getHasMigrationHappened() {
        return hasMigrationHappened;
    }

    public void setHasMigrationHappened(Boolean hasMigrationHappened) {
        this.hasMigrationHappened = hasMigrationHappened;
    }

    public Integer getLocationMigratedTo() {
        return locationMigratedTo;
    }

    public void setLocationMigratedTo(Integer locationMigratedTo) {
        this.locationMigratedTo = locationMigratedTo;
    }

    public Integer getAreaMigratedTo() {
        return areaMigratedTo;
    }

    public void setAreaMigratedTo(Integer areaMigratedTo) {
        this.areaMigratedTo = areaMigratedTo;
    }

}

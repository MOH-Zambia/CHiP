package com.argusoft.sewa.android.app.model;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.io.Serializable;

@DatabaseTable
public class HealthInfraTypeLocationBean extends BaseEntity implements Serializable {
    @DatabaseField
    private Long healthInfraTypeId;

    @DatabaseField
    private String healthInfraTypeName;

    @DatabaseField
    private Integer locationLevel;

    public Long getHealthInfraTypeId() {
        return healthInfraTypeId;
    }

    public void setHealthInfraTypeId(Long healthInfraTypeId) {
        this.healthInfraTypeId = healthInfraTypeId;
    }

    public String getHealthInfraTypeName() {
        return healthInfraTypeName;
    }

    public void setHealthInfraTypeName(String healthInfraTypeName) {
        this.healthInfraTypeName = healthInfraTypeName;
    }

    public Integer getLocationLevel() {
        return locationLevel;
    }

    public void setLocationLevel(Integer locationLevel) {
        this.locationLevel = locationLevel;
    }
}

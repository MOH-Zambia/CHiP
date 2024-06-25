package com.argusoft.imtecho.common.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class AnnouncementHealthInfraDetailPKey implements Serializable {

    @Basic(optional = false)
    @Column(name = "announcement")
    private Integer id;

    @Basic(optional = false)
    @Column(name = "health_infra_id")
    private Integer healthInfraId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getHealthInfraId() {
        return healthInfraId;
    }

    public void setHealthInfraId(Integer healthInfraId) {
        this.healthInfraId = healthInfraId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AnnouncementHealthInfraDetailPKey that = (AnnouncementHealthInfraDetailPKey) o;
        return Objects.equals(id, that.id) && Objects.equals(healthInfraId, that.healthInfraId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, healthInfraId);
    }
}

package com.argusoft.imtecho.location.model;

import javax.persistence.*;
import java.io.Serializable;

/**
 *
 * <p>
 *     Define location_wards_mapping entity and its fields.
 * </p>
 * @author akshar
 * @since 26/08/20 11:00 AM
 *
 */
@Entity
@Table(name = "location_wards_mapping")
public class LocationWardsMapping implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "ward_id")
    private Integer wardId;

    @Column(name = "location_id")
    private Integer locationId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getWardId() {
        return wardId;
    }

    public void setWardId(Integer wardId) {
        this.wardId = wardId;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }
}

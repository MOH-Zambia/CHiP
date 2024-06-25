/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.common.model;

import java.io.Serializable;
import java.util.Objects;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * <p>Defines fields related to user</p>
 *
 * @author smeet
 * @since 26/08/2020 5:30
 */
@Embeddable
public class AnnouncementLocationDetailPKey implements Serializable {

    @Basic(optional = false)
    @Column(name = "announcement")
    private Integer id;

    @Basic(optional = false)
    @Column(name = "location")
    private Integer location;

    @Basic(optional = false)
    @Column(name = "announcement_for")
    private String announcementFor;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getLocation() {
        return location;
    }

    public void setLocation(Integer location) {
        this.location = location;
    }

    public String getAnnouncementFor() {
        return announcementFor;
    }

    public void setAnnouncementFor(String announcementFor) {
        this.announcementFor = announcementFor;
    }

    @Override
    public String toString() {
        return "AnnouncementLocationDetailPKey{" +
                "id=" + id +
                ", location=" + location +
                ", announcementFor='" + announcementFor + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AnnouncementLocationDetailPKey that = (AnnouncementLocationDetailPKey) o;
        return Objects.equals(id, that.id) && Objects.equals(location, that.location) && Objects.equals(announcementFor, that.announcementFor);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, location, announcementFor);
    }
}

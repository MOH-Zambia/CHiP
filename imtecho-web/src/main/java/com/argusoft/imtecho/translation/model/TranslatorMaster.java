package com.argusoft.imtecho.translation.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;


@Entity
@Table(name = "translation_master")
public class TranslatorMaster extends EntityAuditInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "app")
    private Short app;
    @Column(name = "language")
    private Short language;
    @Column(name = "key",nullable = false)
    private String key;
    @Column(name = "value", nullable = false)
    private String value;
    @Column(name = "is_active", nullable = false)
    private Boolean isActive;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Short getApp() {
        return app;
    }

    public void setApp(Short app) {
        this.app = app;
    }

    public Short getLanguage() {
        return language;
    }

    public void setLanguage(Short language) {
        this.language = language;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Boolean getIsActive() {
        return this.isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

}

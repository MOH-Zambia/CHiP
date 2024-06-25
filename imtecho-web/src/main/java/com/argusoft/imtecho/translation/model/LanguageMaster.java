package com.argusoft.imtecho.translation.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;
import java.io.Serializable;

//id serial primary key,
//language_key character varying(10) unique not null,
//language_value text not null,
//is_ltr boolean not null,
//is_active boolean not null,
//);

@Entity
@Table(name = "language_master")
public class LanguageMaster extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "language_key",length = 10,unique = true,nullable = false)
    private String languageKey;

    @Column(name = "language_value",nullable = false)
    private String languageValue;

    @Column(name = "is_ltr",nullable = false)
    private Boolean isLtr;

    @Column(name = "is_active",nullable = false)
    private Boolean isActive;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLanguageKey() {
        return languageKey;
    }

    public void setLanguageKey(String languageKey) {
        this.languageKey = languageKey;
    }
    public String getLanguage_key() {
        return languageKey;
    }

    public void setLanguage_key(String languageKey) {
        this.languageKey = languageKey;
    }

    public String getLanguageValue() {
        return languageValue;
    }

    public void setLanguageValue(String languageValue) {
        this.languageValue = languageValue;
    }
    public String getLanguage_value() {
        return languageValue;
    }

    public void setLanguage_value(String languageValue) {
        this.languageValue = languageValue;
    }

    public Boolean getIsLtr() {
        return isLtr;
    }

    public void setIsLtr(Boolean ltr) {
        isLtr = ltr;
    }

    public Boolean getIs_ltr() {
        return isLtr;
    }

    public void setIs_ltr(Boolean ltr) {
        isLtr = ltr;
    }


    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = active;
    }

    public Boolean getIs_active() {
        return isActive;
    }

    public void setIs_active(Boolean active) {
        isActive = active;
    }

    public static class Fields {
        private Fields() {

        }

        public static final String IS_ACTIVE = "isActive";
    }


}

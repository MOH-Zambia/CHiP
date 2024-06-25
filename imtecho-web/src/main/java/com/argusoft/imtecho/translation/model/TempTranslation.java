package com.argusoft.imtecho.translation.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "temp_translation")
public class TempTranslation {
    @Id
    private Integer id;
    @Column(name = "app")
    private Short app;
    @Column(name = "key")
    private String key;
    @Column(name = "value")
    private String value;

    public Short getApp() {
        return app;
    }

    public void setApp(Short app) {
        this.app = app;
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

}

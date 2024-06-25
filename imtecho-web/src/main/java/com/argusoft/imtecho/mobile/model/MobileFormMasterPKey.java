package com.argusoft.imtecho.mobile.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MobileFormMasterPKey implements Serializable {

    @Basic(optional = false)
    @Column(name = "id")
    private int id;

    @Basic(optional = false)
    @Column(name = "form_code")
    private String formCode;

    public MobileFormMasterPKey() {
    }

    public MobileFormMasterPKey(int id, String formCode) {
        this.id = id;
        this.formCode = formCode;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFormCode() {
        return formCode;
    }

    public void setFormCode(String formCode) {
        this.formCode = formCode;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MobileFormMasterPKey that = (MobileFormMasterPKey) o;
        return id == that.id && Objects.equals(formCode, that.formCode);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, formCode);
    }
}

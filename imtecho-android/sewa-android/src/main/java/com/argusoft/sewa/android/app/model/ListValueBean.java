/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.sewa.android.app.model;

import androidx.annotation.NonNull;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;
import java.util.Objects;

/**
 * @author kelvin
 */
@DatabaseTable
public class ListValueBean extends BaseEntity {

    @DatabaseField
    private int idOfValue;
    @DatabaseField
    private String formCode;
    @DatabaseField
    private String field;
    @DatabaseField
    private String fieldType;
    @DatabaseField
    private String value;
    @DatabaseField
    private String isDownloaded;
    @DatabaseField
    private String constant;
    @DatabaseField
    private Date modifiedOn;
    @DatabaseField
    private Integer listOrder;

    public int getIdOfValue() {
        return idOfValue;
    }

    public void setIdOfValue(int idOfValue) {
        this.idOfValue = idOfValue;
    }

    public String getFormCode() {
        return formCode;
    }

    public void setFormCode(String formCode) {
        this.formCode = formCode;
    }

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public String getFieldType() {
        return fieldType;
    }

    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getIsDownloaded() {
        return isDownloaded;
    }

    public void setIsDownloaded(String isDownloaded) {
        this.isDownloaded = isDownloaded;
    }

    public Date getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Date modifiedOn) {
        this.modifiedOn = modifiedOn;
    }

    public Integer getListOrder() {
        return listOrder;
    }

    public void setListOrder(Integer listOrder) {
        this.listOrder = listOrder;
    }

    public String getConstant() {
        return constant;
    }

    public void setConstant(String constant) {
        this.constant = constant;
    }

    @NonNull
    @Override
    public String toString() {
        return "ListValueBean{" + "idOfValue=" + idOfValue + ", formCode=" + formCode + ", field=" + field + ", fieldType=" + fieldType + ", value=" + value + ", isDownloaded=" + isDownloaded + '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ListValueBean that = (ListValueBean) o;
        return listOrder != null && that.listOrder != null && Objects.equals(listOrder, that.listOrder);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }
}

package com.argusoft.sewa.android.app.model;

import com.argusoft.sewa.android.app.databean.OcrFormDataBean;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.io.Serializable;
import java.util.Date;

@DatabaseTable
public class OcrFormBean extends BaseEntity implements Serializable {

    @DatabaseField
    private String formName;
    @DatabaseField
    private String formJson;
    @DatabaseField
    private Date modifiedOn;

    public OcrFormBean() {
    }

    public OcrFormBean(OcrFormDataBean ocrFormDataBean) {
        this.formName = ocrFormDataBean.getFormName();
        this.formJson = ocrFormDataBean.getFormJson();
        this.modifiedOn = ocrFormDataBean.getModifiedOn();
    }

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public String getFormJson() {
        return formJson;
    }

    public void setFormJson(String formJson) {
        this.formJson = formJson;
    }

    public Date getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Date modifiedOn) {
        this.modifiedOn = modifiedOn;
    }
}

package com.argusoft.sewa.android.app.databean;

import com.argusoft.sewa.android.app.model.OcrFormBean;

import java.util.Date;

public class OcrFormDataBean {
    private String formName;
    private String formJson;
    private Date modifiedOn;

    public OcrFormDataBean(OcrFormBean ocrFormDataBean) {
        this.formName = ocrFormDataBean.getFormName();
        this.formJson = ocrFormDataBean.getFormJson();;
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

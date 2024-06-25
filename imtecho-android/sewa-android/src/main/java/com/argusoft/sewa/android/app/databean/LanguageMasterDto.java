package com.argusoft.sewa.android.app.databean;

public class LanguageMasterDto {

    private Integer id;
    private String languageKey;
    private String languageValue;
    private Boolean isLtr;
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

    public String getLanguageValue() {
        return languageValue;
    }

    public void setLanguageValue(String languageValue) {
        this.languageValue = languageValue;
    }

    public Boolean getLtr() {
        return isLtr;
    }

    public void setLtr(Boolean ltr) {
        isLtr = ltr;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = active;
    }
}

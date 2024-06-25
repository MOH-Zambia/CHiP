package com.argusoft.imtecho.translation.dto;


public class LanguageDto {
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

    public void setLanguagevalue(String languagevalue) {
        this.languageValue = languagevalue;
    }

    public Boolean getIsLtr() {
        return isLtr;
    }

    public void setIsLtr(Boolean ltr) {
        isLtr = ltr;
    }

    public Boolean getActive() {
        return isActive;
    }

    public void setActive(Boolean active) {
        isActive = active;
    }
}

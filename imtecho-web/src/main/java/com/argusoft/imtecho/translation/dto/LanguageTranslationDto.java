package com.argusoft.imtecho.translation.dto;

public class LanguageTranslationDto {
    private Integer id;
    private String language;
    private String language_key;
    private String translation;
    private String key;

    public LanguageTranslationDto(String key, String language_key, String translation) {
        this.key = key;
        this.language_key = language_key;
        this.translation = translation;
    }

    public LanguageTranslationDto() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getLanguage_key() {
        return language_key;
    }

    public void setLanguage_key(String language_key) {
        this.language_key = language_key;
    }

    public String getTranslation() {
        return translation;
    }

    public void setTranslation(String translation) {
        this.translation = translation;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }
}

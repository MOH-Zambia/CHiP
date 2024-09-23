package com.argusoft.imtecho.formconfigurator.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.LinkedHashMap;

@Getter
@Setter
public class MedplatFormDataQueryDto {
    private LinkedHashMap<String, Object> params;
    private LinkedHashMap<String, Object> response;

    public MedplatFormDataQueryDto() {
        this.params = new LinkedHashMap<>();
        this.response = new LinkedHashMap<>();
    }
}

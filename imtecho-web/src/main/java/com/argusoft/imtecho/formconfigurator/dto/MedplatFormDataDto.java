package com.argusoft.imtecho.formconfigurator.dto;

import com.argusoft.imtecho.event.dto.Event;
import com.google.gson.JsonElement;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
public class MedplatFormDataDto {
    private JsonElement formDataElement;
    private JsonElement formMetaDataElement;
    private Map<String, MedplatFormDataQueryDto> queries;
    private Event event;

    public MedplatFormDataDto() {
        this.queries = new HashMap<>();
    }
}

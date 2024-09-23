package com.argusoft.imtecho.formconfigurator.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
public class MedplatFormDataQueryConfigDto {
    private String queryCode;
    private String query;
    private String queryPath;
    private Boolean hasLoop;
    private Boolean isEventResource;
    private UUID eventUUID;
    private String eventResourceIdKey;
    private List<MedplatFormDataQueryParamDto> params;
    private List<MedplatFormDataQueryConfigDto> subQueries;
}

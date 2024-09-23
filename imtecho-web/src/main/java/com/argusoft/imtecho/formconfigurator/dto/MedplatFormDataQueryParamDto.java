package com.argusoft.imtecho.formconfigurator.dto;

import com.argusoft.imtecho.formconfigurator.enums.FormDataQueryParamType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MedplatFormDataQueryParamDto {
    private FormDataQueryParamType type;
    private String key;
    private String valueKey;
    private Object value;
    private String referenceQuery;
    private String referenceParam;
}

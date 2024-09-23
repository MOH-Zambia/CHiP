package com.argusoft.imtecho.formconfigurator.dto;

import com.argusoft.imtecho.formconfigurator.enums.FieldKeyValueType;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MedplatFieldKeyDto {
    private String fieldKeyCode;
    private String fieldKeyName;
    private FieldKeyValueType fieldKeyValueType;
    private String defaultValue;
    private Boolean isRequired;
    private Short orderNo;
}

package com.argusoft.imtecho.formconfigurator.dto;

import com.argusoft.imtecho.formconfigurator.enums.FieldKeyValueType;
import lombok.Data;

import java.util.UUID;

@Data
public class MedplatFieldKeyMasterDto {
    private UUID uuid;
    private UUID fieldMasterUuid;
    private String fieldKeyCode;
    private String fieldKeyName;
    private FieldKeyValueType fieldKeyValueType;
    private String defaultValue;
    private Boolean isRequired;
    private Short orderNo;
}

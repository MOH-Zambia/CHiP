package com.argusoft.imtecho.formconfigurator.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class MedplatFieldKeyMapDto {
    private String fieldCode;
    private String fieldName;
    private List<MedplatFieldKeyDto> fieldKeyDto;
}

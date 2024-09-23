package com.argusoft.imtecho.formconfigurator.dto;

import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Data
public class MedplatFormMasterDto {
    private UUID uuid;
    private String formName;
    private String formCode;
    private String state;
    private String currentVersion;
    private Integer menuConfigId;
    private String menuName;
    private String availableVersion;
    private String description;
    private String user;
    private Date modified_on;
    private Integer modified_by;
}

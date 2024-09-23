package com.argusoft.imtecho.formconfigurator.dto;

import com.argusoft.imtecho.formconfigurator.enums.State;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class MedplatFormConfigurationDto {
    private UUID formMasterUuid;
    private UUID versionHistoryUuid;
    private String formName;
    private String formCode;
    private String version;
    private String currentVersion;
    private String templateConfig;
    private String fieldConfig;
    private Integer menuConfigId;
    private State state;
    private String formObject;
    private String templateCss;
    private String formVm;
    private String executionSequence;
    private String description;
    private String queryConfig;
}

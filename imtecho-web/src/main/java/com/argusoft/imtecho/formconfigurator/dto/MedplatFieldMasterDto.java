package com.argusoft.imtecho.formconfigurator.dto;

import com.argusoft.imtecho.systemconstraint.dto.SystemConstraintFieldValueMasterDto;
import lombok.Data;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Data
public class MedplatFieldMasterDto {
    private UUID uuid;
    private UUID formMasterUuid;
    private String fieldKey;
    private String fieldName;
    private String fieldType;
    private String ngModel;
    private String appName;
    private UUID standardFieldMasterUuid;
    private Date createdOn;
    private Integer createdBy;
    private List<MedplatFieldKeyMasterDto> medplatFieldKeyMasterDtos;
    private List<UUID> fieldValueUuidsToBeRemoved;
}

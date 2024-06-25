package com.argusoft.imtecho.systemconstraint.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.systemconstraint.dto.SystemConstraintFieldMasterDto;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintFieldMaster;

import java.util.List;
import java.util.UUID;

public interface SystemConstraintFieldMasterDao extends GenericDao<SystemConstraintFieldMaster, UUID> {

    void deleteSystemConstraintFieldConfigByUuid(UUID uuid);

    String getSystemConstraintFieldConfigByUuid(UUID uuid);

    List<SystemConstraintFieldMasterDto> getSystemConstraintFieldsByFormMasterUuid(UUID formMasterUuid);
}

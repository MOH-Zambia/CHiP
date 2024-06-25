package com.argusoft.imtecho.systemconstraint.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintStandardFieldMaster;

import java.util.UUID;

public interface SystemConstraintStandardFieldMasterDao extends GenericDao<SystemConstraintStandardFieldMaster, UUID> {

    String getSystemConstraintFieldConfigByUuid(UUID standardFieldMappingMasterUuid);
}

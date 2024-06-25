package com.argusoft.imtecho.systemconstraint.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintFieldValueMaster;

import java.util.List;
import java.util.UUID;

public interface SystemConstraintFieldValueMasterDao extends GenericDao<SystemConstraintFieldValueMaster, UUID> {

    void deleteSystemConstraintFieldValueConfigsByUuids(List<UUID> fieldValueUuidsToBeRemoved);
}

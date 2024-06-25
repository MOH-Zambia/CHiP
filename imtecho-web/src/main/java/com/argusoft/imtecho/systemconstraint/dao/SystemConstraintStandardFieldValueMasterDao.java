package com.argusoft.imtecho.systemconstraint.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintStandardFieldValueMaster;

import java.util.List;
import java.util.UUID;

public interface SystemConstraintStandardFieldValueMasterDao extends GenericDao<SystemConstraintStandardFieldValueMaster, UUID> {

    void deleteSystemConstraintStandardFieldValueConfigsByUuids(List<UUID> standardFieldValueUuidsToBeRemoved);
}

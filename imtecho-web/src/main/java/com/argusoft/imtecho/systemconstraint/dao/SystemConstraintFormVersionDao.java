package com.argusoft.imtecho.systemconstraint.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintFormVersion;

import java.util.UUID;

public interface SystemConstraintFormVersionDao
        extends GenericDao<SystemConstraintFormVersion, UUID> {

    SystemConstraintFormVersion getFormVersionByFormUuidAndType(UUID formUuid, String type);
}

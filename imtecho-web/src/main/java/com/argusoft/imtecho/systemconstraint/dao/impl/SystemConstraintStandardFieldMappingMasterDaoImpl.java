package com.argusoft.imtecho.systemconstraint.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.systemconstraint.dao.SystemConstraintStandardFieldMappingMasterDao;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintStandardFieldMappingMaster;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public class SystemConstraintStandardFieldMappingMasterDaoImpl extends GenericDaoImpl<SystemConstraintStandardFieldMappingMaster, UUID> implements SystemConstraintStandardFieldMappingMasterDao {
}

package com.argusoft.imtecho.formconfigurator.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldKeyMaster;

import java.util.List;
import java.util.UUID;

public interface MedplatFieldKeyMasterDao extends GenericDao<MedplatFieldKeyMaster, UUID> {
    List<MedplatFieldKeyMaster> retrieveByFieldMasterUuid(UUID fieldMasterUuid);
}

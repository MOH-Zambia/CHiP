package com.argusoft.imtecho.formconfigurator.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldMaster;

import java.util.List;
import java.util.UUID;

public interface MedplatFieldMasterDao extends GenericDao<MedplatFieldMaster, UUID> {
    MedplatFieldMaster retrieveFieldMasterByFieldCode(String fieldCode);
}

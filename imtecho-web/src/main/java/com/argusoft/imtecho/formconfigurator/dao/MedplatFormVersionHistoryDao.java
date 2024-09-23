package com.argusoft.imtecho.formconfigurator.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormConfigurationDto;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormVersionHistory;

import java.util.UUID;

public interface MedplatFormVersionHistoryDao extends GenericDao<MedplatFormVersionHistory, UUID> {

    MedplatFormVersionHistory retrieveMedplatFormByCriteria(UUID formMasterUuid, String version);

    MedplatFormConfigurationDto getLatestVersionByFormMasterUUID(UUID formMasterUuid);
}

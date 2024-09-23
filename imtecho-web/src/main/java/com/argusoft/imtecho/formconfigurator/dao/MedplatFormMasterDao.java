package com.argusoft.imtecho.formconfigurator.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormMasterDto;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormMaster;

import java.util.List;
import java.util.UUID;

public interface MedplatFormMasterDao extends GenericDao<MedplatFormMaster, UUID> {
    List<MedplatFormMasterDto> getMedplatForms(Integer menuConfigId);

    MedplatFormMasterDto getMedplatFormByUuid(UUID uuid);

    String getMedplatFormConfigByUuid(UUID uuid);

    String getMedplatConfigsByMenuConfigId(Integer menuConfigId);

    String getMedplatFormConfigByUuidAndVersion(UUID uuid, String version);

    String getMedplatFormConfigByUuidForEdit(UUID uuid);

    String getMedplatFormConfigByFormCode(String formCode);

    MedplatFormMaster retrieveByFormCode(String formCode);
}

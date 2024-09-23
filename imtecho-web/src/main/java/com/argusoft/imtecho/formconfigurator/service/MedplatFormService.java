package com.argusoft.imtecho.formconfigurator.service;

import com.argusoft.imtecho.formconfigurator.dto.MedplatFieldKeyMapDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormConfigurationDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormMasterDto;

import java.util.List;
import java.util.UUID;

public interface MedplatFormService {
    void saveMedplatFormConfiguration(MedplatFormConfigurationDto medplatFormConfigurationDto);

    List<MedplatFieldKeyMapDto> getMedplatFieldKeyMap(String fieldCode);

    List<MedplatFormMasterDto> getMedplatForms(Integer menuConfigId);

    MedplatFormMasterDto getMedplatFormByUuid(UUID uuid);

    String getMedplatFormConfigByUuid(UUID uuid);

    String getMedplatConfigsByMenuConfigId(Integer menuConfigId);

    void updateMedplatFormConfiguration(MedplatFormConfigurationDto medplatFormConfigurationDto);

    void updateMedplatFormVersion(MedplatFormConfigurationDto medplatFormConfigurationDto);

    String getMedplatFormConfigByUuidAndVersion(UUID uuid, String version);

    void saveMedplatFormConfigurationStable(MedplatFormConfigurationDto medplatFormConfigurationDto);

    void updateMedplatFormVersionHistoryByField(MedplatFormConfigurationDto medplatFormConfigurationDto, String field);

    String getMedplatFormConfigByUuidForEdit(UUID uuid);

    String getMedplatFormConfigByFormCode(String formCode);
}

package com.argusoft.imtecho.formconfigurator.service.impl;

import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFieldKeyMasterDao;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFieldMasterDao;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormMasterDao;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormVersionHistoryDao;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFieldKeyMapDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormConfigurationDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormMasterDto;
import com.argusoft.imtecho.formconfigurator.enums.State;
import com.argusoft.imtecho.formconfigurator.mapper.MedplatFormConfiguratorMapper;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldKeyMaster;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldMaster;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormMaster;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormVersionHistory;
import com.argusoft.imtecho.formconfigurator.service.MedplatFormService;
import com.argusoft.imtecho.translation.dao.AppDao;
import com.argusoft.imtecho.translation.dao.LanguageDao;
import com.argusoft.imtecho.translation.dao.TranslatorDao;
import com.argusoft.imtecho.translation.model.App;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import com.argusoft.imtecho.translation.model.TranslatorMaster;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@Transactional
public class MedplatFormServiceImpl implements MedplatFormService {

    @Autowired
    private MedplatFormMasterDao medplatFormMasterDao;

    @Autowired
    private MedplatFormVersionHistoryDao medplatFormVersionHistoryDao;

    @Autowired
    private MedplatFieldMasterDao medplatFieldMasterDao;

    @Autowired
    private MedplatFieldKeyMasterDao medplatFieldKeyMasterDao;

    @Autowired
    private AppDao appDao;

    @Autowired
    private LanguageDao languageDao;

    @Autowired
    private TranslatorDao translatorDao;

    @Autowired
    private ImtechoSecurityUser user;

    @Override
    public void saveMedplatFormConfiguration(MedplatFormConfigurationDto medplatFormConfigurationDto) {
        UUID formMasterUuid = UUID.randomUUID();
        medplatFormConfigurationDto.setFormMasterUuid(formMasterUuid);
        medplatFormConfigurationDto.setCurrentVersion("1");
        this.saveOrUpdateMedplatFormVersionHistoryByGivenVersion(medplatFormConfigurationDto, "1");
        medplatFormConfigurationDto.setCurrentVersion("DRAFT");
        this.saveOrUpdateMedplatFormVersionHistoryByGivenVersion(medplatFormConfigurationDto, "DRAFT");
        MedplatFormMaster medplatFormMaster = new MedplatFormMaster();
        medplatFormMaster.setUuid(medplatFormConfigurationDto.getFormMasterUuid());
        medplatFormMaster.setFormName(medplatFormConfigurationDto.getFormName());
        medplatFormMaster.setFormCode(medplatFormConfigurationDto.getFormCode());
        medplatFormMaster.setCurrentVersion(medplatFormConfigurationDto.getCurrentVersion());
        medplatFormMaster.setMenuConfigId(medplatFormConfigurationDto.getMenuConfigId());
        medplatFormMaster.setState(State.ACTIVE);
        medplatFormMaster.setDescription(medplatFormConfigurationDto.getDescription());
        medplatFormMaster.setCurrentVersion(medplatFormConfigurationDto.getCurrentVersion());
        medplatFormMasterDao.create(medplatFormMaster);
    }

    @Override
    public void updateMedplatFormConfiguration(MedplatFormConfigurationDto medplatFormConfigurationDto) {
        MedplatFormMaster medplatFormMaster = medplatFormMasterDao.retrieveById(medplatFormConfigurationDto.getFormMasterUuid());
        if (medplatFormMaster == null) {
            throw new ImtechoUserException("Form master does not exist", 400);
        }
        medplatFormMaster.setFormName(medplatFormConfigurationDto.getFormName());
        medplatFormMaster.setMenuConfigId(medplatFormConfigurationDto.getMenuConfigId());
        medplatFormMaster.setState(medplatFormConfigurationDto.getState());
        medplatFormMaster.setDescription(medplatFormConfigurationDto.getDescription());
        medplatFormMasterDao.update(medplatFormMaster);
    }

    @Override
    public void updateMedplatFormVersion(MedplatFormConfigurationDto medplatFormConfigurationDto) {
        MedplatFormMaster medplatFormMaster = medplatFormMasterDao.retrieveById(medplatFormConfigurationDto.getFormMasterUuid());
        if (medplatFormMaster == null) {
            throw new ImtechoUserException("Form master does not exist", 400);
        }
        medplatFormMaster.setCurrentVersion(medplatFormConfigurationDto.getVersion());
        medplatFormMasterDao.update(medplatFormMaster);
    }

    @Override
    public String getMedplatFormConfigByUuidAndVersion(UUID uuid, String version) {
        return medplatFormMasterDao.getMedplatFormConfigByUuidAndVersion(uuid, version);
    }

    @Override
    public void saveMedplatFormConfigurationStable(MedplatFormConfigurationDto medplatFormConfigurationDto) {
        MedplatFormConfigurationDto formConfigurationDto = medplatFormVersionHistoryDao.getLatestVersionByFormMasterUUID(medplatFormConfigurationDto.getFormMasterUuid());
        MedplatFormVersionHistory medplatFormVersionHistory = medplatFormVersionHistoryDao.retrieveMedplatFormByCriteria(medplatFormConfigurationDto.getFormMasterUuid(), "DRAFT");
        if (formConfigurationDto != null) {
            String latestVersion = formConfigurationDto.getVersion();
            Integer newVersion = Integer.parseInt(latestVersion) + 1;
            MedplatFormVersionHistory medplatFormVersionHistoryNew = new MedplatFormVersionHistory();
            medplatFormVersionHistoryNew.setUuid(UUID.randomUUID());
            medplatFormVersionHistoryNew.setFormMasterUuid(medplatFormVersionHistory.getFormMasterUuid());
            medplatFormVersionHistoryNew.setTemplateConfig(medplatFormVersionHistory.getTemplateConfig());
            medplatFormVersionHistoryNew.setFieldConfig(medplatFormVersionHistory.getFieldConfig());
            medplatFormVersionHistoryNew.setVersion(newVersion.toString());
            medplatFormVersionHistoryNew.setFormObject(medplatFormVersionHistory.getFormObject());
            medplatFormVersionHistoryNew.setTemplateCss(medplatFormVersionHistory.getTemplateCss());
            medplatFormVersionHistoryNew.setFormVm(medplatFormVersionHistory.getFormVm());
            medplatFormVersionHistoryNew.setExecutionSequence(medplatFormVersionHistory.getExecutionSequence());
            medplatFormVersionHistoryNew.setQueryConfig(medplatFormVersionHistory.getQueryConfig());
            medplatFormVersionHistoryDao.create(medplatFormVersionHistoryNew);
        }
    }

    @Override
    public void updateMedplatFormVersionHistoryByField(MedplatFormConfigurationDto medplatFormConfigurationDto, String field) {
        MedplatFormMaster medplatFormMaster = medplatFormMasterDao.retrieveById(medplatFormConfigurationDto.getFormMasterUuid());
        if (medplatFormMaster == null) {
            throw new ImtechoUserException("Form master does not exist", 400);
        }
        medplatFormConfigurationDto.setVersion(medplatFormMaster.getCurrentVersion());
        this.saveOrUpdateMedplatFormVersionHistory(medplatFormConfigurationDto, field);
    }

    @Override
    public String getMedplatFormConfigByUuidForEdit(UUID uuid) {
        return medplatFormMasterDao.getMedplatFormConfigByUuidForEdit(uuid);
    }

    @Override
    public String getMedplatFormConfigByFormCode(String formCode) {
        return medplatFormMasterDao.getMedplatFormConfigByFormCode(formCode);
//        return setTranslations(medplatFormConfigByFormCode, formCode);
    }

    @Override
    public List<MedplatFieldKeyMapDto> getMedplatFieldKeyMap(String fieldCode) {
        List<MedplatFieldKeyMapDto> medplatFieldKeyMapDtos = new ArrayList<>();
        if (fieldCode != null) {
            MedplatFieldMaster medplatFieldMaster = medplatFieldMasterDao.retrieveFieldMasterByFieldCode(fieldCode);
            List<MedplatFieldKeyMaster> medplatFieldKeyMasters = medplatFieldKeyMasterDao.retrieveByFieldMasterUuid(medplatFieldMaster.getUuid());
            medplatFieldKeyMapDtos.add(MedplatFormConfiguratorMapper.convertToMedplatFieldKeyMapDto(medplatFieldKeyMasters, medplatFieldMaster));
        } else {
            List<MedplatFieldMaster> medplatFieldMasters = medplatFieldMasterDao.retrieveAll();
            medplatFieldMasters.forEach(field -> {
                List<MedplatFieldKeyMaster> medplatFieldKeyMasters = medplatFieldKeyMasterDao.retrieveByFieldMasterUuid(field.getUuid());
                medplatFieldKeyMapDtos.add(MedplatFormConfiguratorMapper.convertToMedplatFieldKeyMapDto(medplatFieldKeyMasters, field));
            });
        }
        return medplatFieldKeyMapDtos;
    }

    @Override
    public List<MedplatFormMasterDto> getMedplatForms(Integer menuConfigId) {
        return medplatFormMasterDao.getMedplatForms(menuConfigId);
    }

    @Override
    public MedplatFormMasterDto getMedplatFormByUuid(UUID uuid) {
        return medplatFormMasterDao.getMedplatFormByUuid(uuid);
    }

    @Override
    public String getMedplatFormConfigByUuid(UUID uuid) {
        return medplatFormMasterDao.getMedplatFormConfigByUuid(uuid);
    }

    @Override
    public String getMedplatConfigsByMenuConfigId(Integer menuConfigId) {
        return medplatFormMasterDao.getMedplatConfigsByMenuConfigId(menuConfigId);
    }


    private MedplatFormVersionHistory saveOrUpdateMedplatFormVersionHistoryByGivenVersion(MedplatFormConfigurationDto medplatFormConfigurationDto, String version) {
        MedplatFormVersionHistory medplatFormVersionHistory = medplatFormVersionHistoryDao.retrieveMedplatFormByCriteria(medplatFormConfigurationDto.getFormMasterUuid(), medplatFormConfigurationDto.getCurrentVersion());
        if (medplatFormVersionHistory == null) {
            medplatFormVersionHistory = new MedplatFormVersionHistory();
            medplatFormVersionHistory.setUuid(UUID.randomUUID());
            medplatFormVersionHistory.setVersion(version);
        }
        medplatFormVersionHistory.setFormMasterUuid(medplatFormConfigurationDto.getFormMasterUuid());
        medplatFormVersionHistory.setFieldConfig(medplatFormConfigurationDto.getFieldConfig());
        medplatFormVersionHistoryDao.createOrUpdate(medplatFormVersionHistory);
        return medplatFormVersionHistory;
    }


    private MedplatFormVersionHistory saveOrUpdateMedplatFormVersionHistory(MedplatFormConfigurationDto medplatFormConfigurationDto, String field) {
        MedplatFormVersionHistory medplatFormVersionHistory = medplatFormVersionHistoryDao.retrieveMedplatFormByCriteria(medplatFormConfigurationDto.getFormMasterUuid(), "DRAFT");
        switch (field) {
            case "FIELD_CONFIG":
                medplatFormVersionHistory.setFieldConfig(medplatFormConfigurationDto.getFieldConfig());
                break;
            case "FORM_VM":
                medplatFormVersionHistory.setFormVm(medplatFormConfigurationDto.getFormVm());
                break;
            case "FORM_OBJECT":
                medplatFormVersionHistory.setFormObject(medplatFormConfigurationDto.getFormObject());
                break;
            case "FORM_TEMPLATE_CONFIG":
                medplatFormVersionHistory.setTemplateCss(medplatFormConfigurationDto.getTemplateCss());
                medplatFormVersionHistory.setTemplateConfig(medplatFormConfigurationDto.getTemplateConfig());
                break;
            case "EXECUTION_SEQUENCE":
                medplatFormVersionHistory.setExecutionSequence(medplatFormConfigurationDto.getExecutionSequence());
                break;
            case "FORM_QUERY_CONFIG":
                medplatFormVersionHistory.setQueryConfig(medplatFormConfigurationDto.getQueryConfig());
                break;
        }
        medplatFormVersionHistoryDao.createOrUpdate(medplatFormVersionHistory);
        return medplatFormVersionHistory;
    }

    private MedplatFormVersionHistory saveOrUpdateMedplatFormVersionHistory(MedplatFormConfigurationDto medplatFormConfigurationDto) {
        MedplatFormVersionHistory medplatFormVersionHistory = medplatFormVersionHistoryDao.retrieveMedplatFormByCriteria(medplatFormConfigurationDto.getFormMasterUuid(), medplatFormConfigurationDto.getVersion());
        if (medplatFormVersionHistory == null) {
            medplatFormVersionHistory = new MedplatFormVersionHistory();
            medplatFormVersionHistory.setUuid(UUID.randomUUID());
        }
        medplatFormVersionHistory.setFormMasterUuid(medplatFormConfigurationDto.getFormMasterUuid());
        medplatFormVersionHistory.setTemplateConfig(medplatFormConfigurationDto.getTemplateConfig());
        medplatFormVersionHistory.setFieldConfig(medplatFormConfigurationDto.getFieldConfig());
        medplatFormVersionHistoryDao.createOrUpdate(medplatFormVersionHistory);
        return medplatFormVersionHistory;
    }

//    private String setTranslations(String medplatFormConfigByFormCode, String formCode) {
//        App app = appDao.retrieveAppByKey("WEB");
//        LanguageMaster language = languageDao.retrieveByKey(user.getLanguagePreference());
//        JsonObject formObject = JsonParser.parseString(medplatFormConfigByFormCode).getAsJsonObject();
//        for (Map.Entry<String, JsonElement> entry : formObject.get("medplatFieldConfigs").getAsJsonObject()
//                .get(formCode).getAsJsonObject().entrySet()) {
//            String labelKey;
//            JsonObject fieldConfig = entry.getValue().getAsJsonObject();
////            String translationKey = fieldConfig.get("translationKey").getAsString();
//            String translationKey = "Bloodgroup";
//            if (translationKey != null && !translationKey.isEmpty()) {
//                TranslatorMaster translatorMaster = translatorDao.retrieveByCriteria(translationKey, app.getId(), language.getId());
//                if (translatorMaster != null) {
//                    fieldConfig.addProperty("translatedLabel", translatorMaster.getValue());
//                    entry.setValue(fieldConfig);
//                }
//            }
//        }
//        return formObject.toString();
//    }
}
package com.argusoft.imtecho.translation.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.translation.dto.LanguageTranslationDto;
import com.argusoft.imtecho.translation.model.TranslatorMaster;

import java.util.List;

public interface TranslatorDao extends GenericDao<TranslatorMaster, Integer> {
    void toggleActive(String key,Boolean isActive,Short app);
    void translateForNewLanguage(Integer languageId);
    List<LanguageTranslationDto> getAllLanguageLabels();
}

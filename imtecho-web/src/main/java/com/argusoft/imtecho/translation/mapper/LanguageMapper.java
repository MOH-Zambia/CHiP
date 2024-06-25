package com.argusoft.imtecho.translation.mapper;

import com.argusoft.imtecho.translation.dto.LanguageDto;
import com.argusoft.imtecho.translation.model.LanguageMaster;

public class LanguageMapper {
    public static LanguageMaster convertLanguageDtoToLanguage(LanguageDto languageDto, LanguageMaster existingLanguage) {

        LanguageMaster language = new LanguageMaster();
        if (existingLanguage != null) {
            language = existingLanguage;
        }

        language.setId(languageDto.getId());
        language.setLanguageKey(languageDto.getLanguageKey());
        language.setLanguageValue(languageDto.getLanguageValue());
        language.setIsLtr(languageDto.getIsLtr());
        language.setActive(languageDto.getActive());

        return language;
    }
}

package com.argusoft.imtecho.translation.mapper;

import com.argusoft.imtecho.translation.dto.LanguageTranslationDto;
import com.argusoft.imtecho.translation.model.LanguageMaster;

public class LanguageTranslationMapper {
    public static LanguageTranslationDto mapper(LanguageMaster language, String translation){
        LanguageTranslationDto dto = new LanguageTranslationDto();
        dto.setId(language.getId());
        dto.setLanguage(language.getLanguageValue());
        dto.setLanguage_key(language.getLanguageKey());
        dto.setTranslation(translation);
        return dto;
    }
}

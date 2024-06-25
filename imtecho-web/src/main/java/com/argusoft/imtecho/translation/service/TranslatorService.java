package com.argusoft.imtecho.translation.service;

import com.argusoft.imtecho.translation.dto.LanguageTranslationDto;
import com.argusoft.imtecho.translation.dto.TranslatorDto;
import com.argusoft.imtecho.translation.model.TranslatorMaster;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public interface TranslatorService {

    void createOrUpdateAll(List<TranslatorDto> labelList);
    void toggleActive(String key,Boolean isActive, Short app);
    List<LanguageTranslationDto> translate(String targetLangs, String text);
    void loadAllLanguageLabels();
    String getLabelByKeyAndLanguageCode(String key, String languageCode);


}

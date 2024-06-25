package com.argusoft.imtecho.translation.service;

import com.argusoft.imtecho.translation.dto.LanguageDto;
import com.argusoft.imtecho.translation.model.LanguageMaster;

import java.util.List;


public interface LanguageService {
     void createOrUpdate(LanguageDto languagedto);
     List<LanguageMaster> getALlLanguage();

     List<LanguageMaster> getAllActiveLanguage();

}

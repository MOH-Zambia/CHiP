package com.argusoft.imtecho.translation.service.impl;

import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.timer.dto.TimerEventDto;
import com.argusoft.imtecho.timer.model.TimerEvent;
import com.argusoft.imtecho.timer.service.TimerEventHadlerService;
import com.argusoft.imtecho.timer.service.TimerEventService;
import com.argusoft.imtecho.translation.config.IBMConfig;
import com.argusoft.imtecho.translation.dao.LanguageDao;
import com.argusoft.imtecho.translation.dto.LanguageDto;
import com.argusoft.imtecho.translation.mapper.LanguageMapper;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import com.argusoft.imtecho.translation.service.LanguageService;

import com.ibm.watson.language_translator.v3.model.TranslateOptions;
import com.ibm.watson.language_translator.v3.model.TranslationResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.*;

import com.ibm.watson.language_translator.v3.LanguageTranslator;
import com.ibm.watson.language_translator.v3.model.Language;
import com.ibm.watson.language_translator.v3.model.Languages;

@Service
@Transactional
public class LanguageServiceImpl implements LanguageService {
    @Autowired
    private LanguageDao languageDao;
    @Autowired
    @Qualifier("timerEventServiceDefault")
    private TimerEventService timerEventService;
    @Autowired
    private IBMConfig ibmConfig;

    @Autowired
    private UserDao userDao;


    @Override
    public void createOrUpdate(LanguageDto languageDto) {

        if (languageDto.getId() != null) {
            LanguageMaster existingLanguage = languageDao.retrieveById(languageDto.getId());
            LanguageMaster language = LanguageMapper.convertLanguageDtoToLanguage(languageDto, existingLanguage);
            if (existingLanguage != null) {
                languageDao.update(language);
                if (Boolean.FALSE.equals(language.getActive())) {
                    userDao.updatePreferredLanguageForInactiveLanguage(language.getLanguageKey(), "en");
                }
            } else {
                throw new ImtechoSystemException("LanguageMaster not found", 500);
            }
        } else {
            LanguageMaster language = LanguageMapper.convertLanguageDtoToLanguage(languageDto, null);
            Integer id = languageDao.create(language);
            languageDao.flush();
            timerEventService.scheduleTimerEvent( new TimerEventDto(id, TimerEvent.TYPE.ADD_LANGUAGE,new Date() ,null,null,null,null));
        }

    }

    @Override
    public List<LanguageMaster> getALlLanguage() {
        return languageDao.retrieveAll();
    }

    @Override
    public List<LanguageMaster> getAllActiveLanguage() {
        return languageDao.getAllActiveLanguage();
    }

}

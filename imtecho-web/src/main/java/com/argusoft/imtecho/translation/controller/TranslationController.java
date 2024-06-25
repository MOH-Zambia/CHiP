package com.argusoft.imtecho.translation.controller;

import com.argusoft.imtecho.translation.dto.AppDto;
import com.argusoft.imtecho.translation.dto.LanguageDto;
import com.argusoft.imtecho.translation.dto.LanguageTranslationDto;
import com.argusoft.imtecho.translation.dto.TranslatorDto;
import com.argusoft.imtecho.translation.model.App;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import com.argusoft.imtecho.translation.service.AppService;
import com.argusoft.imtecho.translation.service.LanguageService;
import com.argusoft.imtecho.translation.service.TranslatorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/translation")
public class TranslationController {

    @Autowired
    LanguageService languageService;
    @Autowired
    AppService appService;
    @Autowired
    TranslatorService translatorService;

    @RequestMapping(value = "/apps", method = RequestMethod.GET)
    public List<App> getApps(Integer id) {
        return appService.getAllApp();
    }

    @RequestMapping(value = "/languages", method = RequestMethod.GET)
    public List<LanguageMaster> getLanguages() {
        return languageService.getALlLanguage();
    }

    @RequestMapping(value = "/activeLanguages", method = RequestMethod.GET)
    public List<LanguageMaster> getActiveLanguages() {
        return languageService.getAllActiveLanguage();
    }

    @RequestMapping(value = "/languages", method = RequestMethod.POST)
    public void createLanguage(@RequestBody LanguageDto languageDto) {
        languageService.createOrUpdate(languageDto);
    }

    @RequestMapping(value = "/apps", method = RequestMethod.POST)
    public void createApp(@RequestBody AppDto appDto) {
        appService.createOrUpdate(appDto);
    }

    @RequestMapping(value = "/languages", method = RequestMethod.PUT)
    public void updateLanguage(@RequestBody LanguageDto languageDto) {
        languageService.createOrUpdate(languageDto);
    }

    @RequestMapping(value = "/apps", method = RequestMethod.PUT)
    public void updateApp(@RequestBody AppDto appDto) {
        appService.createOrUpdate(appDto);
    }


    @RequestMapping(value = "/labels", method = RequestMethod.POST)
    public void createOrUpdate(@RequestBody List<TranslatorDto> labelList) {
        translatorService.createOrUpdateAll(labelList);
    }

    @RequestMapping(value = "/toggleActive", method = RequestMethod.PUT)
    public void getAppsByIds(@RequestParam(name = "key") String key, @RequestParam(name = "isActive") Boolean isActive, @RequestParam(name = "app") Short app) {
        translatorService.toggleActive(key, isActive, app);
    }


    @RequestMapping(value="/translate",method = RequestMethod.GET)
    public List<LanguageTranslationDto> getTranslations(@RequestParam(name="targetLangs") String targetLangs,
                                                  @RequestParam(name="englishText") String text){
        return translatorService.translate(targetLangs,text);
    }
}

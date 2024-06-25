package com.argusoft.imtecho.translation.service.impl;

import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.translation.config.IBMConfig;
import com.argusoft.imtecho.translation.constant.TranslatorConstant;
import com.argusoft.imtecho.translation.dao.LanguageDao;
import com.argusoft.imtecho.translation.dao.TranslatorDao;
import com.argusoft.imtecho.translation.dto.LanguageTranslationDto;
import com.argusoft.imtecho.translation.dto.TranslatorDto;
import com.argusoft.imtecho.translation.mapper.LanguageTranslationMapper;
import com.argusoft.imtecho.translation.mapper.TranslatorMapper;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import com.argusoft.imtecho.translation.model.TranslatorMaster;
import com.argusoft.imtecho.translation.service.TranslatorService;
import com.ibm.watson.language_translator.v3.LanguageTranslator;
import com.ibm.watson.language_translator.v3.model.TranslateOptions;
import org.apache.commons.collections4.map.MultiKeyMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.transaction.Transactional;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
@Transactional
public class TranslatorServiceImpl implements TranslatorService {

    @Autowired
    TranslatorDao translatorDao;
    @Autowired
    LanguageDao languageDao;
    @Autowired
    private IBMConfig ibmConfig;
    public static ThreadPoolTaskExecutor translationThreadPool;
    private static String labelsMapLastUpdatedAt;

    static {
        translationThreadPool = new ThreadPoolTaskExecutor();
        translationThreadPool.setCorePoolSize(3);
        translationThreadPool.setMaxPoolSize(5);
        translationThreadPool.initialize();
    }

    @Override
    public void createOrUpdateAll(List<TranslatorDto> labelList) {

        List<TranslatorMaster> translatorListUpdate = new ArrayList<>();
        List<TranslatorMaster> translatorList = new ArrayList<>();
        for (TranslatorDto label : labelList) {
            if (label.getId() != null) {
                TranslatorMaster translator = translatorDao.retrieveById(label.getId());
                if (translator != null) {
                    TranslatorMaster translatorMaster = TranslatorMapper.convertDtoToMaster(label, translator);
                    translatorListUpdate.add(translatorMaster);
                } else {
                    throw new ImtechoSystemException("label not found", 500);
                }
            } else {
                TranslatorMaster translatorMaster = TranslatorMapper.convertDtoToMaster(label, null);
                translatorList.add(translatorMaster);
            }
        }
        if (translatorList != null) {
            translatorDao.createOrUpdateAll(translatorList);
        }
        if (translatorListUpdate != null) {
            translatorDao.updateAll(translatorListUpdate);
        }
    }

    @Override
    public void toggleActive(String key, Boolean isActive, Short app) {
        translatorDao.toggleActive(key, isActive, app);
    }

    @Override
    public List<LanguageTranslationDto> translate(String targetLangs, String text) {
        LanguageTranslator languageTranslator = ibmConfig.getLanguageTranslatorInstance();
        List<LanguageMaster> languages = new ArrayList<>();
        List<LanguageTranslationDto> dtoList = new ArrayList<>();
        int[] LanguageIds = Arrays.stream(targetLangs.split(","))
                .mapToInt(Integer::parseInt)
                .toArray();
        for (Integer id : LanguageIds) {
            languages.add(languageDao.retrieveById(id));
        }

        List<CompletableFuture<Void>> futures = new ArrayList<>();

        for (LanguageMaster language : languages) {
            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                LanguageTranslationDto translations = new LanguageTranslationDto();
                TranslateOptions translateOptions = new TranslateOptions.Builder()
                        .addText(text)
                        .source("en")
                        .target(language.getLanguageKey())
                        .build();
                String result = languageTranslator.translate(translateOptions)
                        .execute()
                        .getResult()
                        .getTranslations()
                        .get(0)
                        .getTranslation();

                dtoList.add(LanguageTranslationMapper.mapper(language, result));
            }, translationThreadPool);

            futures.add(future);
        }

        // Wait for all CompletableFuture to complete
        CompletableFuture<Void> allOf = CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
        allOf.join();
        return dtoList;

    }

    @Override
    public void loadAllLanguageLabels() {
        MultiKeyMap<String, String> labelsMultiKeyMap = new MultiKeyMap<>();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        labelsMapLastUpdatedAt = df.format(new Date());

        List<LanguageTranslationDto> labels = translatorDao.getAllLanguageLabels();

        if (!CollectionUtils.isEmpty(labels)) {
            for (LanguageTranslationDto label : labels) {
                labelsMultiKeyMap.put(label.getKey(), label.getLanguage_key(), label.getTranslation());
            }
        }
        TranslatorConstant.labelsMultiKeyMap = labelsMultiKeyMap;
    }

    @Override
    public String getLabelByKeyAndLanguageCode(String key, String languageCode) {
        if (TranslatorConstant.labelsMultiKeyMap.get(key, languageCode) == null) {
            return key;
        }
        return TranslatorConstant.labelsMultiKeyMap.get(key, languageCode);
    }

}

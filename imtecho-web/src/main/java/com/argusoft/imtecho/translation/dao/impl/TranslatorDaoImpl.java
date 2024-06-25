package com.argusoft.imtecho.translation.dao.impl;

import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.translation.config.IBMConfig;
import com.argusoft.imtecho.translation.dao.LanguageDao;
import com.argusoft.imtecho.translation.dao.TranslatorDao;
import com.argusoft.imtecho.translation.dto.LanguageTranslationDto;
import com.argusoft.imtecho.translation.dto.TranslatorDto;
import com.argusoft.imtecho.translation.mapper.TranslatorMapper;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import com.argusoft.imtecho.translation.model.TempTranslation;
import com.argusoft.imtecho.translation.model.TranslatorMaster;
import com.ibm.watson.language_translator.v3.LanguageTranslator;
import com.ibm.watson.language_translator.v3.model.TranslateOptions;
import com.ibm.watson.language_translator.v3.model.Translation;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Repository
@Transactional
public class TranslatorDaoImpl extends GenericDaoImpl<TranslatorMaster, Integer> implements TranslatorDao {
    @Autowired
    private ImtechoSecurityUser currentUser;

    @Autowired
    private IBMConfig ibmConfig;

    @Autowired
    private LanguageDao languageDao;

    public static ThreadPoolTaskExecutor translationThreadPool;

    static {
        translationThreadPool = new ThreadPoolTaskExecutor();
        translationThreadPool.setCorePoolSize(3);
        translationThreadPool.setMaxPoolSize(5);
        translationThreadPool.initialize();
    }

    @Override
    public void toggleActive(String key, Boolean isActive,Short app) {
        String query = "update TranslatorMaster set is_active = :isActive, modified_on = now(), modified_by =:id where key = :key and app = :app";
        Query q = getCurrentSession().createQuery(query);
        q.setParameter("isActive", isActive).setParameter("key", key).setParameter("app",app).setParameter("id", currentUser.getId());
        q.executeUpdate();
    }


    public void translateForNewLanguage(Integer languageId){
        LanguageMaster language = languageDao.retrieveById(languageId);

        String query1 ="insert into temp_translation (app,key,value)\n" +
                " (\n" +
                "with details as (\n" +
                "\tSELECT key,app\n" +
                "    FROM translation_master\n" +
                "    where is_active\n" +
                "    and language = :newLanguageId\n" +
                ")select \n" +
                "\tdistinct translation_master.app,\n" +
                "\ttranslation_master.key,\n" +
                "\tvalue\n" +
                "from translation_master\n" +
                "left join details on \n" +
                "\ttranslation_master.\"key\"  = details.key\n" +
                "\tand translation_master.app = details.app\n" +
                "where details.key is null\n" +
                "\tand details.app is null\n" +
                "\tand \"language\"  = :englishLanguageId\n" +
                "\tand is_active \n" +
                " ) returning *;";

        Session session = sessionFactory.getCurrentSession();

        NativeQuery<TempTranslation> q1 = session.createNativeQuery(query1, TempTranslation.class);
        q1.setParameter("englishLanguageId",65)
          .setParameter("newLanguageId",languageId);
        List<TempTranslation> labelsToBeTranslated = q1.list();

        int totalElements = labelsToBeTranslated.size();
        List<TranslatorMaster> dtoList = new ArrayList<>();
        List<String> labelValues = new ArrayList<>();
        List<CompletableFuture<Void>> futures = new ArrayList<>();
        LanguageTranslator languageTranslator = ibmConfig.getLanguageTranslatorInstance();

        for(TempTranslation label : labelsToBeTranslated){
            labelValues.add(label.getValue());
        }

            for (int i = 0; i < totalElements; i += 100) {

                int finalI = i;
                CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                    int endIndex = Math.min(finalI + 100, totalElements);
                    List<String> sublist = labelValues.subList(finalI, endIndex);
                    TranslateOptions translateOptions = new TranslateOptions.Builder()
                            .text(sublist)
                            .source("en")
                            .target(language.getLanguageKey())
                            .build();
                    List<Translation> result = languageTranslator.translate(translateOptions)
                            .execute()
                            .getResult()
                            .getTranslations();
                    int counter = 0;

                for (TempTranslation label : labelsToBeTranslated) {
                    TranslatorDto dto = new TranslatorDto();
                    dto.setKey(label.getKey());
                    dto.setLanguage(Short.parseShort(String.valueOf(language.getId())));
                    dto.setApp(label.getApp());
                    dto.setValue(result.get(counter).getTranslation());
                    dto.setIsActive(true);
                    dtoList.add(TranslatorMapper.convertDtoToMaster(dto, null));
                    counter++;
                }
                },translationThreadPool);
                futures.add(future);
            }

        CompletableFuture<Void> allOf = CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
        allOf.join();
        String query2 = "truncate table temp_translation;";
        NativeQuery<Integer> q2 = session.createNativeQuery(query2);
        q2.executeUpdate();
        createOrUpdateAll(dtoList);
    }

    @Override
    public List<LanguageTranslationDto> getAllLanguageLabels() {
        Session session = sessionFactory.getCurrentSession();

        String query = "select \n" +
                "\ttm.key , lm.language_key , tm.value as translation  \n" +
                "from translation_master tm \n" +
                "left join language_master lm on tm.language = lm.id\n" +
                "left join app_master am on tm.app = am.id\n" +
                "where am.app_value = 'WEB'";

        List<LanguageTranslationDto> result = session.createNativeQuery(query).setResultTransformer(Transformers.aliasToBean(LanguageTranslationDto.class)).list();

        return result;
    }
}


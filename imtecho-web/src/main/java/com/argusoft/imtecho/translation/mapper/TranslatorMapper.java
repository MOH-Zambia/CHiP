package com.argusoft.imtecho.translation.mapper;

import com.argusoft.imtecho.translation.dto.TranslatorDto;
import com.argusoft.imtecho.translation.model.TranslatorMaster;

public class TranslatorMapper {

    public static TranslatorMaster convertDtoToMaster(TranslatorDto translatorDto,TranslatorMaster existingTranslationObj){
        TranslatorMaster translationObj = new TranslatorMaster();
        if(existingTranslationObj != null){
            translationObj = existingTranslationObj;
        }
        translationObj.setApp(translatorDto.getApp());
        translationObj.setLanguage(translatorDto.getLanguage());
        translationObj.setKey(translatorDto.getKey());
        translationObj.setValue(translatorDto.getValue());
        translationObj.setIsActive(translatorDto.getIsActive());
        return translationObj;
    }
}

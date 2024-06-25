package com.argusoft.imtecho.translation.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import org.springframework.stereotype.Repository;

import java.util.List;

public interface LanguageDao extends GenericDao<LanguageMaster,Integer> {


    List<LanguageMaster> getAllActiveLanguage();
}

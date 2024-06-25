package com.argusoft.imtecho.course.dao;

import com.argusoft.imtecho.course.model.QuestionBankConfiguration;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.List;

public interface QuestionBankConfigurationDao extends GenericDao<QuestionBankConfiguration, Integer> {

    public List<QuestionBankConfiguration> getQuestionBanksByQuestionSetId(Integer questionSetId);
}

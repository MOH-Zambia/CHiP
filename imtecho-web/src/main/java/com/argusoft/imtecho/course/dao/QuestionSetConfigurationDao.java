package com.argusoft.imtecho.course.dao;

import com.argusoft.imtecho.course.model.QuestionSetConfiguration;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.List;

public interface QuestionSetConfigurationDao extends GenericDao<QuestionSetConfiguration, Integer> {

    public List<QuestionSetConfiguration> getQuestionSetByReferenceIdAndType(Integer refId, String refType, Integer questionSetType);
}

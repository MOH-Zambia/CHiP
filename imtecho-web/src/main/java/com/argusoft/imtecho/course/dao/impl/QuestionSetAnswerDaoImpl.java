package com.argusoft.imtecho.course.dao.impl;

import com.argusoft.imtecho.course.dao.QuestionSetAnswerDao;
import com.argusoft.imtecho.course.model.QuestionSetAnswerMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

@Repository
public class QuestionSetAnswerDaoImpl extends GenericDaoImpl<QuestionSetAnswerMaster, Integer> implements QuestionSetAnswerDao {
}

package com.argusoft.imtecho.course.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

public interface QuestionSetAnswerService {

    Integer storeQuestionSetAnswerForMobile(ParsedRecordBean parsedRecordBean, UserMaster user);
}

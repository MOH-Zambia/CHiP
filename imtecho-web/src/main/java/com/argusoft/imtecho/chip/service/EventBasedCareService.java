package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface EventBasedCareService {

    public Integer storeEventBasedCareForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
}

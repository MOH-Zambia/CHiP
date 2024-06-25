package com.argusoft.imtecho.rch.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;


public interface IMomCareWpdService {
    Integer storeWpdVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);

}

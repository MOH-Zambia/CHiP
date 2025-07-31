package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface HelpDeskService {
    Integer storeHelpDeskForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    void updateRecord(String status, Integer recordId);
}
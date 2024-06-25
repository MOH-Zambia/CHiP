package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface ChipTBScreeningService {
    Integer storeTBForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeTBFormOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeTBFollowUpForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
}

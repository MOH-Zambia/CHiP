package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface ChipMalariaScreeningService {
    Integer storeActiveMalariaForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeActiveMalariaFormFromOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);

    Integer storeMalariaIndexCaseForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeMalariaIndexCaseOcrForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);

    Integer storePassiveMalariaForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storePassiveMalariaFormOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);

    Integer storeActiveMalariaFormFollowUp(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeMalariaNonIndexForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeMalariaNonIndexOcrForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
    Integer storeMalariaIndexInvestigationForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);
}

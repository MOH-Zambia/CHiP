package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface BcgVaccineService {
    Integer storeBcgVaccinationSurveyForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeBcgEligibleForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
}

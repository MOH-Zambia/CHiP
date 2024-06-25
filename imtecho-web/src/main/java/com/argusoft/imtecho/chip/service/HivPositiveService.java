/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface HivPositiveService {

    /**
     * Store anc visit form details.
     *
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param keyAndAnswerMap  Contains key and answers.
     * @param user             User details.
     * @return Returns id of store details.
     */
    Integer storeHivPositiveForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeHivPositiveFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeHivScreeningForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeHivScreeningFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeHivScreeningFUForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeAnswersForKnownPositive(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeAnswersForKnownPositiveOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeAnswersForEMTCT(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
    Integer storeAnswersForEMTCTOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
}

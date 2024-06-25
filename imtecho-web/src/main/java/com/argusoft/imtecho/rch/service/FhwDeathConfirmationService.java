package com.argusoft.imtecho.rch.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import java.util.Map;

/**
 *
 * <p>
 *     Define services for FHW death confirmation.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
public interface FhwDeathConfirmationService {

    /**
     * Store death confirmation details.
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param keyAndAnswerMap Contains key and answers.
     * @param user User details.
     * @return Returns id of store details.
     */
    Integer storeDeathConfirmationForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);
}

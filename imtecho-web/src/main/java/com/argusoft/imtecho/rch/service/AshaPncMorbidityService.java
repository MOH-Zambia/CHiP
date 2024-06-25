package com.argusoft.imtecho.rch.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import java.util.Map;

/**
 *
 * <p>
 *     Define services for ASHA pnc morbidity.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
public interface AshaPncMorbidityService {

    /**
     * Store ASHA pnc morbidity details.
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param dependencyId Dependency id.
     * @param keyAndAnswerMap Contains key and answers.
     * @param user User details.
     * @return Returns id of store details.
     */
    Integer storeAshaPncMorbidity(ParsedRecordBean parsedRecordBean, Integer dependencyId, Map<String, String> keyAndAnswerMap, UserMaster user);
}

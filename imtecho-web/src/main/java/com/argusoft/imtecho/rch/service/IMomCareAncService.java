package com.argusoft.imtecho.rch.service;


import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.dto.AncMasterDto;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * Define services for anc.
 * </p>
 *
 * @author khyati
 * @since 15/03/24 12:20 PM
 */
public interface IMomCareAncService {
    /**
     * Store anc visit form details.
     *
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param keyAndAnswerMap  Contains key and answers.
     * @param user             User details.
     * @return Returns id of store details.
     */
    Integer storeAncVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);


}

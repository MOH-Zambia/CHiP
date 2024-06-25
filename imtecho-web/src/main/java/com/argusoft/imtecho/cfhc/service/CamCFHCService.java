package com.argusoft.imtecho.cfhc.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

public interface CamCFHCService {
    /**
     * Stores comprehensive family health census form
     *
     * @param parsedRecordBean instance of ParsedRecordBean
     * @param user             instance of UserMaster
     * @return map of string
     */
    Map<String, String> storeComprehensiveFamilyHealthCensusForm(ParsedRecordBean parsedRecordBean, UserMaster user);
}

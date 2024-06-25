/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.cfhc.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

/**
 * <p>Defines methods for Community First Health Co-op survey.</p>
 *
 * @author rahul
 * @since 25/08/20 4:30 PM
 */
public interface CFHCService {
    /**
     * Stores comprehensive family health census form
     *
     * @param parsedRecordBean instance of ParsedRecordBean
     * @param user             instance of UserMaster
     * @return map of string
     */
    Map<String, String> storeComprehensiveFamilyHealthCensusForm(ParsedRecordBean parsedRecordBean, UserMaster user);
}

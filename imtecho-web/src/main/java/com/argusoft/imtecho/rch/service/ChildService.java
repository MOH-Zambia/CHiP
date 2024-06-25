/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.dto.ChildServiceMasterDto;
import java.util.Map;

/**
 *
 * <p>
 *     Define services for child visit.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
public interface ChildService {

    /**
     * Store child service visit form details.
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param keyAndAnswerMap Contains key and answers.
     * @param user User details.
     * @return Returns id of store details.
     */
    Integer storeChildServiceForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);

    /**
     * Retrieves medical complications details by member id.
     * @param memberId Member id.
     * @return Returns medical complication details.
     */
    String retrieveMedicalComplications(Integer memberId);

    /**
     * Add child service visit details.
     * @param childServiceMasterDto Child service visit details.
     */
    void create(ChildServiceMasterDto childServiceMasterDto);

    /**
     * Retrieves last child visit details.
     * @param memberId Member id.
     * @return Returns last child visit details.
     */
    ChildServiceMasterDto getLastChildVisit(Integer memberId);
}

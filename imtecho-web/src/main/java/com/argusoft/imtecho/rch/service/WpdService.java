/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.dto.WpdChildDto;
import com.argusoft.imtecho.rch.dto.WpdMasterDto;
import com.argusoft.imtecho.rch.dto.WpdMotherDto;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * Define services for volunteers.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
public interface WpdService {

    /**
     * Store wpd visit form details.
     *
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param keyAndAnswerMap  Contains key and answers.
     * @param user             User details.
     * @return Returns id of store details.
     */
    Integer storeWpdVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);



    /**
     * Store wpd discharge form details.
     *
     * @param parsedRecordBean Contains details like form fill up time, relative id, village id etc.
     * @param keyAndAnswerMap  Contains key and answers.
     * @param user             User details.
     * @return Returns id of store details.
     */
    Integer storeWpdDischargeForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user);

    /**
     * Add wpd form details.
     *
     * @param wpdMasterDto Wpd form details.
     * @return Returns list of member details.
     */
    List<MemberDto> create(WpdMasterDto wpdMasterDto);

    /**
     * Retrieves wpd children by member id.
     *
     * @param memberId Member id.
     * @return Returns list of wpd children.
     */
    List<WpdChildDto> getWpdChildbyMemberid(Integer memberId);

    /**
     * Retrieves wpd mother by member id.
     *
     * @param memberId Member id.
     * @return Returns wpd mother details for given member id.
     */
    List<WpdMotherDto> getWpdMotherbyMemberid(Integer memberId);

    /**
     * Retrieves pending discharge details.
     *
     * @param userId User id.
     * @return Returns list of pending discharge details.
     */
    List<WpdMasterDto> retrievePendingDischargeList(Integer userId);

    /**
     * Save discharge details.
     *
     * @param wpdMasterDto Discharge details.
     */
    void saveDischargeDetails(WpdMasterDto wpdMasterDto);

    List<MemberDto> retrieveWpdMembers(Boolean byId, Boolean byMemberId, Boolean byFamilyId, Boolean byMobileNumber, Boolean byName, Boolean byLmp, Boolean byEdd, Boolean byOrganizationUnit, Boolean byAbhaNumber, Boolean byAbhaAddress, Integer locationId, String searchString, Boolean byFamilyMobileNumber, Integer limit, Integer offSet);
}

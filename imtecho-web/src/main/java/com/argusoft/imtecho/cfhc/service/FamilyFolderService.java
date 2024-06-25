package com.argusoft.imtecho.cfhc.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import java.util.Map;

/**
 * Defines methods for FamilyFolderService
 *
 * @author prateek
 * @since 26/05/23 6:32 pm
 */
public interface FamilyFolderService {

    Map<String, String> storeFamilyFolderForm(ParsedRecordBean parsedRecordBean, UserMaster user);
    Map<String, String> storeFamilyFolderForm2(ParsedRecordBean parsedRecordBean, UserMaster user);
    Map<String, String> familyFolderMemberUpdateForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswersMap, UserMaster user);
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import java.util.List;
import java.util.Map;

/**
 *
 * @author kunjan
 */
public interface PatchService {

    void patchForChildEntryNotDone();

    ParsedRecordBean parseRecordStringToBean(String record);

    void patchToUpdateLastServiceDateOfMember();

    List<SyncStatus> retrieveSyncStatusForUpdatingBreastFeedingForWPD();

    void updateProcessedSyncStatusId(String syncStatusId);

    int updateWpdMotherMasterForBreastFeeding(Map<String, String> keyAndAnswerMap, SyncStatus syncStatus, Boolean breastFeeding, int updatedCount);

}

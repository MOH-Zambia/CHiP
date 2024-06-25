/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import java.util.Date;
import java.util.List;

/**
 *
 * @author prateek
 */
public interface SyncStatusDao extends GenericDao<SyncStatus, String> {

    void updateProcessingStringsToPendingOnServerStartup();

    List<SyncStatus> retrieveSyncStatusBetweenActionDates(Date from, Date to);

    List<SyncStatus> retrieveSyncStatusBetweenActionDatesLikeRecordString(Date from, Date to, String recordString, Integer userId, String status);
    
    List<SyncStatus> retrieveSyncStatusForUpdatingBreastFeedingForWPD();
    
    void updateSyncedWpdMotherMaster(String syncStatusId);
}

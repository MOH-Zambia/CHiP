package com.argusoft.imtecho.common.service;

import com.argusoft.imtecho.common.model.SyncStatusFileUpload;

public interface SyncStatusFileUploadService {

    String create(SyncStatusFileUpload syncStatus);

    SyncStatusFileUpload retrieveById(String uniqueId);

    void update(SyncStatusFileUpload syncStatus);

}

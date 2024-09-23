package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.SyncStatusFileUpload;
import com.argusoft.imtecho.database.common.GenericDao;

public interface SyncStatusFileUploadDao extends GenericDao<SyncStatusFileUpload, String> {

    SyncStatusFileUpload getSyncStatusFileUploadByUniqueId(String uniqueId);
}

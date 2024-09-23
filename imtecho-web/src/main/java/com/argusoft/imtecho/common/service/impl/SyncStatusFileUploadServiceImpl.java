package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.SyncStatusFileUploadDao;
import com.argusoft.imtecho.common.model.SyncStatusFileUpload;
import com.argusoft.imtecho.common.service.SyncStatusFileUploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class SyncStatusFileUploadServiceImpl implements SyncStatusFileUploadService {

    @Autowired
    private SyncStatusFileUploadDao syncStatusFileUploadDao;

    @Override
    public String create(SyncStatusFileUpload syncStatus) {
        return syncStatusFileUploadDao.create(syncStatus);
    }

    @Override
    public SyncStatusFileUpload retrieveById(String uniqueId) {
        return syncStatusFileUploadDao.getSyncStatusFileUploadByUniqueId(uniqueId);
    }

    @Override
    public void update(SyncStatusFileUpload syncStatus) {
        syncStatusFileUploadDao.update(syncStatus);
    }
}

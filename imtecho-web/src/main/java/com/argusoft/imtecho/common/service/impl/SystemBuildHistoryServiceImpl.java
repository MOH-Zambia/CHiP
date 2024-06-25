
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.SystemBuildHistoryDao;
import com.argusoft.imtecho.common.model.SystemBuildHistory;
import com.argusoft.imtecho.common.service.SystemBuildHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of SystemBuildHistoryService
 * @author smeet
 * @since 28/08/2020 4:30
 */
@Service
@Transactional
public class SystemBuildHistoryServiceImpl implements SystemBuildHistoryService {

    @Autowired
    SystemBuildHistoryDao systemBuildHistoryDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public SystemBuildHistory retrieveLastBuildHistory() {
        return systemBuildHistoryDao.retrieveLastSystemBuild();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void create(SystemBuildHistory systemBuildHistory) {
        systemBuildHistoryDao.create(systemBuildHistory);
    }

}

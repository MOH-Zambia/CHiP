package com.argusoft.imtecho.systemfunction.service.impl;

import com.argusoft.imtecho.systemfunction.dao.SystemFunctionMasterDao;
import com.argusoft.imtecho.systemfunction.model.SystemFunctionMaster;
import com.argusoft.imtecho.systemfunction.service.SystemFunctionMasterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>Methods implementation for system function master service</p>
 * @author ketul
 * @since 08/09/20 04:00 PM
 * 
 */
@Service
public class SystemFunctionMasterServiceImpl implements SystemFunctionMasterService {
    @Autowired
    private SystemFunctionMasterDao systemFunctionMasterDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public SystemFunctionMaster retrieveSystemFunctionById(Integer id) {
        return this.systemFunctionMasterDao.retrieveById(id);
    }
}

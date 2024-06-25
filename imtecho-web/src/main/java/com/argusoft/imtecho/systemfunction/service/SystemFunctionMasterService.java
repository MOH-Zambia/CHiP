package com.argusoft.imtecho.systemfunction.service;

import com.argusoft.imtecho.systemfunction.model.SystemFunctionMaster;

/**
 * <p>Methods signature for system function master service</p>
 * @author ketul
 * @since 08/09/20 04:00 PM
 * 
 */
public interface SystemFunctionMasterService {
    
    /**
     * Returns system function master details
     * @param id id
     * @return System function master detail
     */
    SystemFunctionMaster retrieveSystemFunctionById(Integer id);
}

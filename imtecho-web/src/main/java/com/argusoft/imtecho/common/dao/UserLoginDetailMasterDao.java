package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.UserLoginDetailMaster;
import com.argusoft.imtecho.database.common.GenericDao;

/**
 * <p>
 *     Defines database method for user login detail
 * </p>
 * @author shrey
 * @since 31/08/2020 10:30
 */
public interface UserLoginDetailMasterDao extends GenericDao<UserLoginDetailMaster, Integer> {

    UserLoginDetailMaster getLastLoginDetailByUserId(Integer userId);
    
}

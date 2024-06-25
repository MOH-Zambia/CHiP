package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.RoleCategoryMaster;
import com.argusoft.imtecho.database.common.GenericDao;
import java.util.List;

/**
 * <p>Defines database method for role category</p>
 * @author vaishali
 * @since 31/08/2020 10:30
 */
public interface RoleCategoryDao  extends GenericDao<RoleCategoryMaster, Integer>{
    /**
     * Returns a list of role category of given id of role
     * @param roleId An id of role
     * @return A list of RoleCategoryMaster
     */
    List<RoleCategoryMaster> retrieveByRoleId(Integer roleId);
    
}

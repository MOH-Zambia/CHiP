package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.RoleManagement;
import com.argusoft.imtecho.database.common.GenericDao;
import java.util.List;

/**
 * <p>Defines database method for role management</p>
 * @author vaishali
 * @since 31/08/2020 10:30
 */

public interface RoleManagementDao extends GenericDao<RoleManagement, Integer>{
    /**
     * Returns a list of RoleManagement managed by given role id
     * @param roleId An id of role
     * @return A list of RoleManagement
     */
    List<RoleManagement> retrieveRolesManagedByRoleId(Integer roleId);

    /**
     * Returns a list of RoleManagement of given role id
     * @param roleId An id of role
     * @return A list of RoleManagement
     */
    List<RoleManagement> retrieveRolesManagementByRoleId(Integer roleId);

    /**
     * Returns a list of active RoleManagement of given role id
     * @param roleId An id of role
     * @return A list of RoleManagement
     */
    List<RoleManagement> retrieveActiveRolesManagementByRoleId(Integer roleId);
    
}

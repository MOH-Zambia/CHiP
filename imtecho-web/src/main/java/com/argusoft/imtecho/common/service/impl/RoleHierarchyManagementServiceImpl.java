
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.RoleDao;
import com.argusoft.imtecho.common.dao.RoleHierarchyManagementDao;
import com.argusoft.imtecho.common.mapper.RoleHierarchyManagementMapper;
import com.argusoft.imtecho.common.mapper.RoleMapper;
import com.argusoft.imtecho.common.model.RoleHierarchyManagement;
import com.argusoft.imtecho.common.model.RoleMaster;
import com.argusoft.imtecho.common.service.RoleHierarchyManagementService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of RoleHierarchyManagementService
 * @author vaishali
 * @since 28/08/2020 4:30
 */
@Service()
@Transactional
public class RoleHierarchyManagementServiceImpl implements RoleHierarchyManagementService {

    @Autowired
    RoleHierarchyManagementDao roleHierarchyManagementdao;
    @Autowired
    RoleDao roleDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public Map<String, Object> retrieveLocationHierarchyByRoleId(Integer roleId) {
        Map<String, Object> result = new HashMap<>();
        
        List<RoleHierarchyManagement> roleHierarchyList = roleHierarchyManagementdao.retrieveLocationByRoleId(roleId);
        RoleMaster roleMaster = roleDao.retrieveById(roleId);
        if (roleHierarchyList != null) {
            result.put("hierarchy", RoleHierarchyManagementMapper.convertMasterListToDtoList(roleHierarchyList));
        }
        if(roleMaster != null) {
            result.put("roles", RoleMapper.convertRoleMasterToDto(roleMaster));
        }
        
        return result;
    }

}

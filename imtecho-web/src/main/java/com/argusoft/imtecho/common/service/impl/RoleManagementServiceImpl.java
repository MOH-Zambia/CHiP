
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.RoleManagementDao;
import com.argusoft.imtecho.common.dto.RoleMasterDto;
import com.argusoft.imtecho.common.mapper.RoleMapper;
import com.argusoft.imtecho.common.model.RoleManagement;
import com.argusoft.imtecho.common.service.RoleManagementService;
import java.util.LinkedList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of RoleManagementService
 * @author vaishali
 * @since 28/08/2020 4:30
 */
@Service()
@Transactional
public class RoleManagementServiceImpl implements RoleManagementService {

    @Autowired
    private RoleManagementDao roleManagementDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<RoleMasterDto> retrieveRolesManagedByRoleId(Integer roleId) {
        List<RoleMasterDto> roles = new LinkedList<>();
        for (RoleManagement role : roleManagementDao.retrieveRolesManagedByRoleId(roleId)) {
            roles.add(RoleMapper.convertRoleMasterToDto(role.getRoleMaster()));
        }
        return roles;
    }

}

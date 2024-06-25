package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.MenuConfigDao;
import com.argusoft.imtecho.common.dao.MenuGroupDao;
import com.argusoft.imtecho.common.dao.UserMenuItemDao;
import com.argusoft.imtecho.common.dto.MenuConfigDto;
import com.argusoft.imtecho.common.mapper.MenuConfigMapper;
import com.argusoft.imtecho.common.model.MenuConfig;
import com.argusoft.imtecho.common.model.UserMenuItem;
import com.argusoft.imtecho.common.service.MenuConfigService;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of MenuConfigService
 * @author charmi
 * @since 28/08/2020 4:30
 */
@Service
@Transactional
public class MenuConfigServiceImpl implements MenuConfigService {

    @Autowired
    private MenuConfigDao menuConfigDao;

    @Autowired
    private UserMenuItemDao userMenuItemDao;

    @Autowired
    private MenuGroupDao menuGroupDao;
    @Autowired
    private ImtechoSecurityUser user;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MenuConfig> getActiveMenusByUserIdAndDesignationAndGroup(Boolean fetchGroupObjects, Integer userId, Integer designationId) {

        return menuConfigDao.getActiveMenusByUserIdAndDesignationAndGroup(fetchGroupObjects, userId, designationId);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<String> getConfigurationTypes() {
        return menuConfigDao.getConfigurationTypes();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MenuConfigDto getMenuConfigByIdWithUserList(Integer menuConfigId) {
        return menuConfigDao.getMenuConfigByIdWithUserList(menuConfigId);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MenuConfigDto> getMenuConfigListByType(String type) {
        Boolean isUserAdmin=Boolean.FALSE;
        if(SystemConstantUtil.ARGUS_ADMIN_ROLE.equals(user.getRoleCode())){
            isUserAdmin=Boolean.TRUE;
        }
        List<MenuConfig> menuConfigList = menuConfigDao.getMenuConfigListByType(type,isUserAdmin, MenuConfig.MenuConfigJoin.MENU_GROUP, MenuConfig.MenuConfigJoin.SUB_GROUP);
        return MenuConfigMapper.getMenuDtoList(menuConfigList, MenuConfig.MenuConfigJoin.MENU_GROUP, MenuConfig.MenuConfigJoin.SUB_GROUP);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void saveUserMenuItem(List<UserMenuItem> userMenuItems) {
        userMenuItemDao.createOrUpdateAll(userMenuItems);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void deleteUserMenuItem(Integer id) {
        userMenuItemDao.deleteById(id);
    }

}

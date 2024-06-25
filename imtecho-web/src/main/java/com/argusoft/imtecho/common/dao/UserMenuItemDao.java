package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.UserMenuItem;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.List;

/**
 * <p>Defines database method for user menu items</p>
 * @author charmi
 * @since 31/08/2020 10:30
 */
public interface UserMenuItemDao extends GenericDao<UserMenuItem, Integer>{

    public List<UserMenuItem> retrieveByMenuConfigId(Integer menuConfigId);
    
}
package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.UserInstalledAppsMaster;

/**
 *
 * @author prateek on 5 Feb, 2019
 */
public interface UserInstalledAppsMasterDao extends GenericDao<UserInstalledAppsMaster, Integer> {

    void deleteUserInstalledAppsByUserIdAndImei(Integer userId, String imei);
}

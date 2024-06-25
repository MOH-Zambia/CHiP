package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.UserInstalledAppsMasterDao;
import com.argusoft.imtecho.mobile.model.UserInstalledAppsMaster;
import org.hibernate.query.NativeQuery;
import org.springframework.stereotype.Repository;

/**
 * @author prateek on 5 Feb, 2019
 */
@Repository
public class UserInstalledAppsMasterDaoImpl extends GenericDaoImpl<UserInstalledAppsMaster, Integer> implements UserInstalledAppsMasterDao {

    @Override
    public void deleteUserInstalledAppsByUserIdAndImei(Integer userId, String imei) {
        String q = "delete from user_installed_apps where user_id = :userId and imei = :imei";
        NativeQuery<Integer> sQLQuery = getCurrentSession().createNativeQuery(q);
        sQLQuery.setParameter("userId", userId);
        sQLQuery.setParameter("imei", imei);
        sQLQuery.executeUpdate();
    }
}

package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.SohUser;


public interface SohUserDao extends GenericDao<SohUser, Integer> {

    int countUserByMobileNo(String mobileNo);

    void deleteByMobileNo(String mobileNo);
}

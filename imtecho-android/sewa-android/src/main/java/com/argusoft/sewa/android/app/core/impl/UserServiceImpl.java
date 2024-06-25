package com.argusoft.sewa.android.app.core.impl;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import com.argusoft.sewa.android.app.core.UserService;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.LoginBean;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;

@EBean(scope = Singleton)
public class UserServiceImpl implements UserService {

    @OrmLiteDao(helper = DBConnection.class)
    Dao<LoginBean, Integer> loginBeanDao;

    public LoginBean getLoginBeanFromDb() {
        try {
            return loginBeanDao.queryForAll().get(0);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createOrUpdate(LoginBean loginBean) {
        try {
            if (loginBean.getId() != null) {
                loginBeanDao.update(loginBean);
            } else {
                loginBeanDao.create(loginBean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

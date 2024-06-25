package com.argusoft.sewa.android.app.core.impl;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.core.HealthInfraTypeLocationService;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.HealthInfraTypeLocationBean;
import com.argusoft.sewa.android.app.util.Log;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

@EBean(scope = Singleton)
public class HealthInfraTypeLocationServiceImpl implements HealthInfraTypeLocationService {

    @OrmLiteDao(helper = DBConnection.class)
    Dao<HealthInfraTypeLocationBean, Integer> infraTypeLocationBeanDao;

    @Override
    public List<Integer> retrieveLocationLevelsById(Long id) {
        List<Integer> locationLevels = new LinkedList<>();
        try {
            List<HealthInfraTypeLocationBean> healthInfraTypeLocationBeans = infraTypeLocationBeanDao.queryBuilder().where()
                    .eq(FieldNameConstants.HEALTH_INFRA_TYPE_ID, id).query();

            for (HealthInfraTypeLocationBean bean : healthInfraTypeLocationBeans) {
                locationLevels.add(bean.getLocationLevel());
            }
        } catch (SQLException e) {
            Log.e(getClass().getName(), null, e);
        }
        return locationLevels;
    }
}


package com.argusoft.sewa.android.app.core.impl;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.core.StockManagementService;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.StockInventoryBean;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.Where;

import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;

@EBean(scope = Singleton)
public class StockManagementServiceImpl implements StockManagementService {

    @OrmLiteDao(helper = DBConnection.class)
    Dao<StockInventoryBean, Integer> stockInventoryBeanDao;

    @Override
    public Integer getStockAmountById(int medicineId) throws SQLException {
        Where<StockInventoryBean, Integer> where = stockInventoryBeanDao.queryBuilder().where();
        where.eq(FieldNameConstants.MEDICINE_ID, medicineId);
        StockInventoryBean stockInventoryBean = where.queryForFirst();
        return stockInventoryBean != null ? stockInventoryBean.getDeliveredQuantity() - stockInventoryBean.getUsed() : 0;

    }
}

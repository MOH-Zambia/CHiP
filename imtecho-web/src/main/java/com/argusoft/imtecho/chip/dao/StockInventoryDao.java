package com.argusoft.imtecho.chip.dao;

import com.argusoft.imtecho.chip.model.StockInventoryEntity;
import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.dto.StockInventoryDataBean;

import java.util.Date;
import java.util.List;

public interface StockInventoryDao extends GenericDao<StockInventoryEntity, Integer> {
    StockInventoryEntity retrieveByUserIdAndMedicineId(Long userId, Integer medicineId);

    StockInventoryEntity retrieveByUserIdAndMedicineName(Long userId, String medicineName);

    StockInventoryDataBean retrieveDeliveredRecords(Long userId, Integer medicineId);

    List<StockInventoryDataBean> retrieveStockInventoryForMobile(Long userId, Date lastModifiedOn);
}

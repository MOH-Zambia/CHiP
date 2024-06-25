package com.argusoft.imtecho.chip.dao;

import com.argusoft.imtecho.chip.model.StockManagementDataBean;
import com.argusoft.imtecho.chip.model.StockManagementEntity;
import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.dto.StockInventoryDataBean;
import lombok.Data;

import java.util.Date;
import java.util.List;

public interface StockManagementDao extends GenericDao<StockManagementEntity, Integer> {
    //Boolean compareQty (StockManagementEntity stock, Integer qty);
    void handleRelTables(StockManagementEntity stockManagementEntity);

    void updateStock(List<StockManagementDataBean> stockManagementDataBeans, Integer healthInfraId, Integer userId);

    List<StockManagementDataBean> getStockManagementDataBeans(Long requestedBy, Boolean getApproved);

    Integer markStockStatusAsDelivered(Integer stockReqId, Integer medicineId);

    List<StockInventoryDataBean> getStockInventoryDataBeans(int requestedBy, Date lastModifiedOn);

}
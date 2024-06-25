package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.chip.model.StockManagementDataBean;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.dto.StockInventoryDataBean;

import java.util.List;
import java.util.Map;

public interface StockManagementService {
    Integer storeSMForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);

    void updateStock(List<StockManagementDataBean> stockManagementDataBeans, Integer healthInfraId, Integer userId);

    List<StockManagementDataBean> getStockManagementDataBeans(Long requestedBy, Boolean getApproved);

    List<StockInventoryDataBean> getStockInventoryDataBeans(int requestedBy, Long lastModifiedOn);

    Integer markStockStatusAsDelivered(Integer stockReqId, Integer medicineId, Long userId);

    void updateStockInventory( StockManagementDataBean stockManagementDataBean);
}
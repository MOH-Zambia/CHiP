package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.StockInventoryDao;
import com.argusoft.imtecho.chip.dao.StockManagementDao;
import com.argusoft.imtecho.chip.model.StockInventoryEntity;
import com.argusoft.imtecho.chip.model.StockManagementDataBean;
import com.argusoft.imtecho.chip.model.StockManagementEntity;
import com.argusoft.imtecho.chip.service.StockManagementService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.dto.StockInventoryDataBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class StockManagementServiceImpl implements StockManagementService {
    @Autowired
    private StockManagementDao stockManagementDao;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private StockInventoryDao stockInventoryDao;

    @Override
    public Integer storeSMForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        StockManagementEntity stockManagementEntity = new StockManagementEntity();
        stockManagementEntity.setRequestedBy(user.getId());

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToEntity(key, answer, stockManagementEntity, keyAndAnswerMap);
        }

        stockManagementDao.create(stockManagementEntity);
        stockManagementDao.flush();
        stockManagementDao.handleRelTables(stockManagementEntity);

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.STOCK_MANAGEMENT, stockManagementEntity.getId()));
        return stockManagementEntity.getId();
    }

    private void setAnswersToEntity(String key, String answer, StockManagementEntity stockManagementEntity, Map<String, String> keyAndAnswerMap) {
        switch (key) {
            case "-2":
                stockManagementEntity.setLatitude(answer);
                break;
            case "-1":
                stockManagementEntity.setLongitude(answer);
                break;
            case "1":
                if (answer != null && !answer.isEmpty()) {
                    String mainAns = answer.replace("{", "").replace("}", "");
                    Set<StockManagementDataBean> beanSet = new HashSet<>();
                    String[] diseasesArray = mainAns.split(",");
                    for (String s : diseasesArray) {
                        String[] medicineIdAndQty = s.trim().split("=");
                        StockManagementDataBean stockManagementDataBean = new StockManagementDataBean();
                        stockManagementDataBean.setMedicineId(Integer.valueOf(medicineIdAndQty[0]));
                        stockManagementDataBean.setMedicineQuantity(Integer.valueOf(medicineIdAndQty[1]));
                        stockManagementDataBean.setStatus(StockStatus.REQUESTED.name());
                        beanSet.add(stockManagementDataBean);
                        stockManagementEntity.setStockManagementDataBeans(beanSet);
                    }
                }
                break;
            case "8669":
                stockManagementEntity.setHealthInfraId(Integer.valueOf(answer));
                break;
            case "8672":
                // if user don't want to change the default infra
                if (keyAndAnswerMap.containsKey("8673") && keyAndAnswerMap.get("8673").equalsIgnoreCase("2")) {
                    // if infra id from mobile is not null
                    if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                        stockManagementEntity.setHealthInfraId(Integer.valueOf(keyAndAnswerMap.get("-20")));
                    }
                }
                break;
            default:
        }
    }

    public void updateStock(List<StockManagementDataBean> stockManagementDataBeans, Integer healthInfraId, Integer userId) {
        stockManagementDao.updateStock(stockManagementDataBeans, healthInfraId, userId);
    }

    public List<StockManagementDataBean> getStockManagementDataBeans(Long requestedBy, Boolean getApproved) {
        return stockManagementDao.getStockManagementDataBeans(requestedBy, getApproved);
    }

    @Override
    public List<StockInventoryDataBean> getStockInventoryDataBeans(int requestedBy, Long lastModifiedOn) {
        Date dt = null;
        if (lastModifiedOn != null) {
            dt = new Date(lastModifiedOn);
        }
        return stockInventoryDao.retrieveStockInventoryForMobile(Long.valueOf(requestedBy), dt);
    }

    public Integer markStockStatusAsDelivered(Integer stockReqId, Integer medicineId, Long userId) {
        int id = stockManagementDao.markStockStatusAsDelivered(stockReqId, medicineId);
        createRecordInStockInventory(userId, medicineId);
        return id;

    }

    private void createRecordInStockInventory(Long userId, Integer medicineId) {
        StockInventoryDataBean stockInventoryDataBeans = stockInventoryDao.retrieveDeliveredRecords(userId, medicineId);
        StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(userId, medicineId);
        if (stockInventoryEntity == null) {
            stockInventoryEntity = new StockInventoryEntity();
            stockInventoryEntity.setRequestedBy(Math.toIntExact(userId));
            stockInventoryEntity.setMedicineId(medicineId);
            stockInventoryEntity.setUsed(0);
            stockInventoryEntity.setApprovedBy(stockInventoryDataBeans.getApprovedBy());
            stockInventoryEntity.setHealthInfraId(stockInventoryDataBeans.getHealthInfraId());
            stockInventoryEntity.setMedicineStockAmount(0);
        }
        stockInventoryEntity.setMedicineStockAmount(stockInventoryEntity.getMedicineStockAmount() + stockInventoryDataBeans.getDeliveredQuantity());
        stockInventoryDao.createOrUpdate(stockInventoryEntity);


    }

    public void updateStockInventory( StockManagementDataBean stockManagementDataBean){
        StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(stockManagementDataBean.getRequestedBy()), stockManagementDataBean.getMedicineId());
        if(stockInventoryEntity == null) {
            stockInventoryEntity = new StockInventoryEntity();
            stockInventoryEntity.setRequestedBy(stockManagementDataBean.getRequestedBy());
            stockInventoryEntity.setMedicineId(stockManagementDataBean.getMedicineId());
            stockInventoryEntity.setUsed(0);
            stockInventoryEntity.setApprovedBy(stockManagementDataBean.getApprovedBy());
            stockInventoryEntity.setHealthInfraId(stockManagementDataBean.getHealthInfraId());
            stockInventoryEntity.setMedicineStockAmount(stockManagementDataBean.getApprovedQuantity());
        }
        else
            stockInventoryEntity.setMedicineStockAmount(stockInventoryEntity.getMedicineStockAmount() + stockManagementDataBean.getApprovedQuantity());
        stockInventoryDao.createOrUpdate(stockInventoryEntity);
        stockInventoryDao.flush();
    }

    public enum StockStatus {
        REQUESTED,
        APPROVED,
        ACKNOWLEDGED,
        REJECTED
    }


}
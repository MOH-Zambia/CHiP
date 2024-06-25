package com.argusoft.imtecho.chip.controller;

import com.argusoft.imtecho.chip.model.StockManagementDataBean;
import com.argusoft.imtecho.chip.service.StockManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stockmanagement")
public class StockManagementController {
    @Autowired
    StockManagementService stockManagementService;

    @PutMapping("/update")
    public void updateStockQuantity(
            @RequestBody List<StockManagementDataBean> stockManagementDataBeans,
            @RequestParam Integer healthInfraId,
            @RequestParam Integer userId
    ) {
        stockManagementService.updateStock(stockManagementDataBeans, healthInfraId, userId);
    }

    @GetMapping("/getStockManagementDataBeans")
    public List<StockManagementDataBean> getStockManagementDataBeans(
            @RequestParam Long requestedBy,
            @RequestParam Boolean getApproved
    ) {
        return stockManagementService.getStockManagementDataBeans(requestedBy, getApproved);
    }

    @PostMapping("/markStockStatusAsDelivered")
    public Integer getStockManagementDataBeans(
            @RequestParam(name = "stockReqId") Integer stockReqId,
            @RequestParam(name = "medicineId") Integer medicineId,
            @RequestParam(name = "userId") Long userId
    ) {
        return stockManagementService.markStockStatusAsDelivered(stockReqId, medicineId, userId);
    }

    @PutMapping("/updateMedicineStock")
    public void updateMedicines(

            @RequestBody StockManagementDataBean stockManagementDataBean
    ){
        stockManagementService.updateStockInventory(stockManagementDataBean);
    }

}
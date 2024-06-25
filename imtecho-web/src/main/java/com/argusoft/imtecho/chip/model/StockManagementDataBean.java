package com.argusoft.imtecho.chip.model;

import lombok.Data;

import java.util.Date;

@Data
public class StockManagementDataBean {
    private Integer id; // Stock Management ID
    private Integer medicineId;
    private Integer medicineQuantity;
    private Integer approvedQuantity;
    private Integer approvedBy;
    private Date approvedOn;
    private String status;
    private String reason;
    private Integer inventoryId; // Stock Inventory Entity ID
    private Integer healthInfraId;
    private Integer requestedBy;
}
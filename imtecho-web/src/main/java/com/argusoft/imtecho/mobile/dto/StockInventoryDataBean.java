package com.argusoft.imtecho.mobile.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class StockInventoryDataBean {
    private int healthInfraId;
    private int medicineId;
    private int deliveredQuantity;
    private int approvedBy;
    private int requestedBy;
    private int used;
    private int createdBy;
    private Date createdOn;
    private int modifiedBy;
    private Date modifiedOn;
}

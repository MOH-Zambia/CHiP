package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Getter
@Setter
@Entity(name = "stock_inventory_entity")
public class StockInventoryEntity extends EntityAuditInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "health_infra_id")
    private Integer healthInfraId;

    @Column(name = "medicine_id")
    private Integer medicineId;

    @Column(name = "medicine_stock_amount")
    private Integer medicineStockAmount;

    @Column(name = "approved_by")
    private Integer approvedBy;

    @Column(name = "requested_by")
    private Integer requestedBy;

    private Integer used;
}

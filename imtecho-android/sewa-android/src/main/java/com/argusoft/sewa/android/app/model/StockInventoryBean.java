package com.argusoft.sewa.android.app.model;

import com.argusoft.sewa.android.app.databean.StockInventoryDataBean;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.io.Serializable;
import java.util.Date;

@DatabaseTable
public class StockInventoryBean extends BaseEntity implements Serializable {
    @DatabaseField
    private int healthInfraId;
    @DatabaseField
    private int medicineId;
    @DatabaseField
    private int deliveredQuantity;
    @DatabaseField
    private int approvedBy;
    @DatabaseField
    private int used;
    @DatabaseField
    private Date modifiedOn;
    @DatabaseField
    private int modifiedBy;

    @DatabaseField
    private int requestedBy;
    @DatabaseField
    private Date createdOn;
    @DatabaseField
    private int createdBy;

    public StockInventoryBean() {
    }

    public StockInventoryBean(StockInventoryDataBean stockInventoryDataBean) {
        this.healthInfraId = stockInventoryDataBean.getHealthInfraId();
        this.medicineId = stockInventoryDataBean.getMedicineId();
        this.deliveredQuantity = stockInventoryDataBean.getDeliveredQuantity();
        this.approvedBy = stockInventoryDataBean.getApprovedBy();
        this.requestedBy = stockInventoryDataBean.getRequestedBy();
        this.createdBy = stockInventoryDataBean.getCreatedBy();
        this.modifiedBy = stockInventoryDataBean.getModifiedBy();
        this.createdOn = stockInventoryDataBean.getCreatedOn();
        this.modifiedOn = stockInventoryDataBean.getModifiedOn();
        this.used = stockInventoryDataBean.getUsed();

    }

    public int getHealthInfraId() {
        return healthInfraId;
    }

    public void setHealthInfraId(int healthInfraId) {
        this.healthInfraId = healthInfraId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public int getDeliveredQuantity() {
        return deliveredQuantity;
    }

    public void setDeliveredQuantity(int deliveredQuantity) {
        this.deliveredQuantity = deliveredQuantity;
    }

    public int getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(int approvedBy) {
        this.approvedBy = approvedBy;
    }

    public Date getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Date modifiedOn) {
        this.modifiedOn = modifiedOn;
    }

    public int getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(int modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public Date getCreatedOn() {
        return createdOn;
    }

    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getUsed() {
        return used;
    }

    public void setUsed(int used) {
        this.used = used;
    }

    public int getRequestedBy() {
        return requestedBy;
    }

    public void setRequestedBy(int requestedBy) {
        this.requestedBy = requestedBy;
    }
}

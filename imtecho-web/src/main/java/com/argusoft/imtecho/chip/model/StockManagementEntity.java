package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

@Entity
@Getter
@Setter
@Table(name = "stock_management_details")
public class StockManagementEntity extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;
    @Column(name = "latitude")
    private String latitude;
    @Column(name = "longitude")
    private String longitude;
    @Column(name = "requested_by")
    private Integer requestedBy;
    @Column(name = "health_infra_id")
    private Integer healthInfraId;
    @Transient
    private Set<StockManagementDataBean> stockManagementDataBeans;
}

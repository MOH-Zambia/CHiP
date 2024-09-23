package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Getter
@Setter
@Table(name = "emtct_details")
public class EMTCTEntity extends EntityAuditInfo implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;
    @Column(name = "member_id")
    private Integer memberId;
    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;

    @Column(name = "family_id")
    private Integer familyId;
    @Column(name = "location_id")
    private Integer locationId;
    @Column(name = "dbs_test_done")
    private Boolean dbsTestDone;
    @Column(name = "dbs_result")
    private String dbsResult;
    @Column(name = "member_status")
    private String memberStatus;
}

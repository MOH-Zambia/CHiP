package com.argusoft.imtecho.formconfigurator.models;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "medplat_form_data_master")
@Getter
@Setter
public class MedplatFormDataMaster extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "form_code")
    private String formCode;

    @Column(name = "data")
    private String data;

    @Column(name = "version")
    private String version;

    @Column(name = "is_processed")
    private Boolean isProcessed;

    @Column(name = "has_error")
    private Boolean hasError;

    @Column(name = "error")
    private String error;
}

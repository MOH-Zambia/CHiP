package com.argusoft.imtecho.formconfigurator.models;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.UUID;

@Entity
@Table(name = "medplat_form_version_history")
@Getter
@Setter
public class MedplatFormVersionHistory extends EntityAuditInfo implements Serializable {
    @Id
    @Column(name = "uuid")
    @Type(type = "org.hibernate.type.PostgresUUIDType")
    private UUID uuid;

    @Column(name = "form_master_uuid")
    @NotNull(message = "Form master UUID cannot be null")
    @Type(type = "org.hibernate.type.PostgresUUIDType")
    private UUID formMasterUuid;

    @Column(name = "template_config")
    private String templateConfig;

    @Column(name = "field_config")
    private String fieldConfig;

    @Column(name = "version")
    private String version;

    @Column(name = "form_object")
    private String formObject;

    @Column(name = "template_css")
    private String templateCss;

    @Column(name = "form_vm")
    private String formVm;

    @Column(name = "execution_sequence")
    private String executionSequence;

    @Column(name = "query_config")
    private String queryConfig;

}

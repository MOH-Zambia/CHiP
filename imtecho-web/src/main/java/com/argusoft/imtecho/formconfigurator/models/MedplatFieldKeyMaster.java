package com.argusoft.imtecho.formconfigurator.models;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.formconfigurator.enums.FieldKeyValueType;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.io.Serializable;
import java.util.UUID;

@Entity
@Table(name = "medplat_field_key_master")
@Getter
@Setter
public class MedplatFieldKeyMaster extends EntityAuditInfo implements Serializable {
    @Id
    @Column(name = "uuid")
    @Type(type = "org.hibernate.type.PostgresUUIDType")
    private UUID uuid;

    @Column(name = "field_master_uuid")
    @Type(type = "org.hibernate.type.PostgresUUIDType")
    private UUID fieldMasterUuid;

    @Column(name = "field_key_code")
    private String fieldKeyCode;

    @Column(name = "field_key_name")
    private String fieldKeyName;

    @Column(name = "field_key_value_type")
    @Enumerated(EnumType.STRING)
    private FieldKeyValueType fieldKeyValueType;

    @Column(name = "default_value")
    private String defaultValue;

    @Column(name = "is_required")
    private Boolean isRequired;

    @Column(name = "order_no")
    private Short orderNo;
}

package com.argusoft.imtecho.formconfigurator.models;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.formconfigurator.enums.State;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.UUID;

@Entity
@Table(name = "medplat_field_master")
@Getter
@Setter
public class MedplatFieldMaster extends EntityAuditInfo implements Serializable {
    @Id
    @Column(name = "uuid")
    @Type(type = "org.hibernate.type.PostgresUUIDType")
    private UUID uuid;

    @Column(name = "field_code")
    private String fieldCode;

    @Column(name = "field_name")
    private String fieldName;

    @Column(name = "state")
    @NotNull(message = "Form state cannot be null")
    @Enumerated(EnumType.STRING)
    private State state;
}

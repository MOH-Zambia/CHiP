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
@Table(name = "medplat_form_master")
@Getter
@Setter
public class MedplatFormMaster extends EntityAuditInfo implements Serializable {
    @Id
    @Column(name = "uuid")
    @Type(type = "org.hibernate.type.PostgresUUIDType")
    private UUID uuid;

    @Column(name = "form_name")
    @NotNull(message = "Form Name cannot be null")
    private String formName;

    @Column(name = "form_code")
    @NotNull(message = "Form code cannot be null")
    private String formCode;

    @Column(name = "current_version")
    private String currentVersion;

    @Column(name = "state")
    @NotNull(message = "Form state cannot be null")
    @Enumerated(EnumType.STRING)
    private State state;

    @Column(name = "menu_config_id")
    private Integer menuConfigId;

    @Column(name = "description")
    private String description;
}

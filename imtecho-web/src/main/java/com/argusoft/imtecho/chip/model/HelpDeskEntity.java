package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Set;

@Entity
@Table(name = "help_desk_details")
@Getter
@Setter
public class HelpDeskEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;

    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "issue_type")
    private String issueType;

    @Column(name = "module_type")
    private String moduleType;

    @Column(name = "issue_description")
    private String issueDesc;

    @Column(name = "other_description")
    private String otherDesc;

    @Column(name = "status")
    private String status;
}

package com.argusoft.imtecho.listvalues.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name="listvalue_field_value_detail")
public class ListValueFieldValueDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "is_archive")
    private Boolean isArchive;

    @Column(name = "last_modified_by")
    private String lastModifiedBy;

    @Column(name = "last_modified_on")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModifiedOn;

    @Column(name = "value")
    private String value;

    @Column(name = "field_key")
    private String fieldKey;

    @Column(name = "file_size")
    private Integer fileSize;

    @Column(name = "multimedia_type")
    private String multimediaType;

    @Column(name = "code")
    private String code;

    @Column(name = "constant")
    private String constant;
}
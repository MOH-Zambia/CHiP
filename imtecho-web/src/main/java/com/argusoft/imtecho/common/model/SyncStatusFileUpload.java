package com.argusoft.imtecho.common.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "system_sync_status_file_upload")
public class SyncStatusFileUpload implements Serializable {

    @Id
    @Column(name = "unique_id")
    private String uniqueId;

    @Basic(optional = false)
    @Column(name = "action_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date actionDate;

    @Basic(optional = false)
    @Column(name = "status")
    private String status;

    @Column(name = "checksum")
    private String checksum;

    @Column(name = "token")
    private String token;

    @Column(name = "form_type")
    private String formType;

    @Column(name = "file_type")
    private String fileType;

    @Column(name = "file_name")
    private String fileName;

    @Column(name = "user_name")
    private String userName;

    @Column(name = "parent_status")
    private String parentStatus;

    @Column(name = "no_of_attempt")
    private Integer noOfAttempt;

    @Column(name = "file_path")
    private String path;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "exception")
    private String exception;
}

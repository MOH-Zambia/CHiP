package com.argusoft.imtecho.common.model;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Data
@Table(name = "dhis2_api_call_log", schema = "public")
public class Dhis2CallLog implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "request_body")
    private String requestBody;

    @Column(name = "response_body")
    private String responseBody;

    @Column(name = "created_on")
    private Date createdOn;

    @Column(name = "http_status")
    private Integer httpStatus;

    @Temporal(TemporalType.DATE)
    @Column(name = "month")
    private Date month;
}

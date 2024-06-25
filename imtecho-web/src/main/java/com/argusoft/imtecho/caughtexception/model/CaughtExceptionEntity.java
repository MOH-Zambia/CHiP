package com.argusoft.imtecho.caughtexception.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;


/**
 * <p>
 * Defines fields for caught exception
 * </p>
 *
 * @author dhruvil
 * @since 26/05/2023 10:17 am
 */
@Entity
@Table(name = "caught_exception")
@Data
public class CaughtExceptionEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "exception_msg")
    private String exceptionMsg;

    @Column(name = "exception_type")
    private String exceptionType;

    @Column(name = "exception_stack_trace")
    private String exceptionStackTrace;

    @Column(name = "username")
    private String username;

    @Column(name = "request_url")
    private String requestUrl;

    @Column(name = "data_string")
    private String dataString;
}


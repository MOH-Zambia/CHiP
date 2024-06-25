/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * <p>
 *     Defines database fields for query history
 * </p>
 * @author vaishali
 * @since 03/09/2020 10:30
 */
@Entity
@Table(name = "query_history")
public class QueryHistory extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "query")
    private String query;
    @Column(name = "user_id")
    private Integer userId;
    @Column(name = "returns_result_set")
    private Boolean returnsResultSet;
    @Column(name = "params")
    private String params;
    @Column(name = "executed_state")
    private String executedState;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public Boolean getReturnsResultSet() {
        return returnsResultSet;
    }

    public void setReturnsResultSet(Boolean returnsResultSet) {
        this.returnsResultSet = returnsResultSet;
    }

    public String getParams() {
        return params;
    }

    public void setParams(String params) {
        this.params = params;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getExecutedState() {
        return executedState;
    }

    public void setExecutedState(String executedState) {
        this.executedState = executedState;
    }

    public enum State {

        SUCCESS, FAIL, WAITING
    }

    public static class Fields {

        /**
         * An util class for string constants of query history
         */
        private Fields(){
        }

        public static final String ID = "id";
        public static final String QUERY = "query";
        public static final String USER_ID = "userId";
        public static final String RETURNS_RESULT_SET = "returnsResultSet";
        public static final String PARAMS = "params";
        public static final String EXECUTED_STATE = "executedState";
    }
}

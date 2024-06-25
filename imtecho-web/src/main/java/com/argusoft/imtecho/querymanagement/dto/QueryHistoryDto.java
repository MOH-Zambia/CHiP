/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.dto;

/**
 * <p>
 *     Defines fields for query history
 * </p>
 * @author Hiren Morzariya
 * @since 03/09/2020 10:30
 */
public class QueryHistoryDto {

    private Integer id;
    private String query;
    private Integer userId;
    private Boolean returnsResultSet;
    private String params;
    private String executedState;
    private String userName;
    private String userFullName;

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

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
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

    public String getExecutedState() {
        return executedState;
    }

    public void setExecutedState(String executedState) {
        this.executedState = executedState;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    
}

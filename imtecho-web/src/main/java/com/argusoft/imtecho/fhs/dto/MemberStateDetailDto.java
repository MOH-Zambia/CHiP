/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dto;

import java.util.Date;

/**
 *
 * <p>
 *     Used for member state.
 * </p>
 * @author harsh
 * @since 26/08/20 11:00 AM
 *
 */
public class MemberStateDetailDto {

    private Integer memberId;

    private String fromState;

    private String toState;

    private Integer parent;

    private String comment;
    
    private Integer createdBy;
    
    private Date createdOn;

    public MemberStateDetailDto() {
        //
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public void setFromState(String fromState) {
        this.fromState = fromState;
    }

    public void setToState(String toState) {
        this.toState = toState;
    }

    public void setParent(Integer parent) {
        this.parent = parent;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public String getFromState() {
        return fromState;
    }

    public String getToState() {
        return toState;
    }

    public Integer getParent() {
        return parent;
    }

    public String getComment() {
        return comment;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public Date getCreatedOn() {
        return createdOn;
    }

    @Override
    public String toString() {
        return "MemberStateDetailDto{" + "memberId=" + memberId + ", fromState=" + fromState + ", toState=" + toState + ", parent=" + parent + ", comment=" + comment + '}';
    }
}

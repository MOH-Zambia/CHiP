/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.model.MemberStateDetailEntity;

/**
 *
 * <p>
 * Define methods for member state.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
public interface MemberStateDetailDao extends GenericDao<MemberStateDetailEntity, Integer> {

    /**
     * Retrieves current state of member.
     * @param memberId Id of member.
     * @return Returns id of current state.
     */
    Integer retrieveMemberCurrentState(Integer memberId);

    
}

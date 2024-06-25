/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dao.MemberStateDetailDao;
import com.argusoft.imtecho.fhs.model.MemberStateDetailEntity;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.springframework.stereotype.Repository;

/**
 *
 * <p>
 * Implementation of methods define in member state dao.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
@Repository
public class MemberStateDetailDaoImpl extends GenericDaoImpl<MemberStateDetailEntity, Integer> implements MemberStateDetailDao  {
    /**
     * {@inheritDoc}
     */
    @Override
    public Integer retrieveMemberCurrentState(Integer memberId) {
        Session currentSession = getCurrentSession();
        NativeQuery<Integer> q = currentSession.createNativeQuery("select current_state from imt_member where id = :memberId");
        q.setParameter("memberId", memberId);
        return q.uniqueResult();
    }
}

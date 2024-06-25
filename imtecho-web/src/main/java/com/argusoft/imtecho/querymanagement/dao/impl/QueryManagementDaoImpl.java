/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.dao.impl;

import com.argusoft.imtecho.common.component.AliasToEntityLinkedMapResultTransformer;
import com.argusoft.imtecho.querymanagement.dao.QueryManagementDao;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;

/**
 * <p>
 *     Implements methods of QueryManagementDao
 * </p>
 * @author bhumika
 * @since 03/09/2020 10:30
 */
@Repository
@Transactional
public class QueryManagementDaoImpl implements QueryManagementDao {

    @Autowired
    SessionFactory sessionFactory;

    /**
     * {@inheritDoc}
     */
    @Override
    public int execute(String queryString) {
        NativeQuery<Integer> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
        return query.executeUpdate();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LinkedHashMap<String, Object>> retrieveQuery(String queryString) {
        NativeQuery<LinkedHashMap<String, Object>> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
        query.setResultTransformer(AliasToEntityLinkedMapResultTransformer.INSTANCE);
        return query.list();
    }

}

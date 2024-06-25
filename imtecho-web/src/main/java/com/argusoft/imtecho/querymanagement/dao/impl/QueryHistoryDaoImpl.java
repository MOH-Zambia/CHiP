/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.querymanagement.dao.QueryHistoryDao;
import com.argusoft.imtecho.querymanagement.model.QueryHistory;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 *     Implements methods of QueryHistoryDao
 * </p>
 * @author Hiren Morzariya
 * @since 03/09/2020 10:30
 */
@Repository
public class QueryHistoryDaoImpl extends GenericDaoImpl<QueryHistory, Integer> implements QueryHistoryDao {

    private static final int DEFAULT_MAX_ROW_QUERY_HISTORY = 100;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<QueryHistory> retrieveByCriteria(Integer userId, Integer offset, Integer limit, String orderBy, String order, String searchString) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
        CriteriaQuery<QueryHistory> criteriaQuery = criteriaBuilder.createQuery(QueryHistory.class);
        Root<QueryHistory> root = criteriaQuery.from(QueryHistory.class);
        List<Predicate> predicates = new ArrayList<>();
        if (userId != null) {
            Predicate userIdEqual = criteriaBuilder.equal(root.get(QueryHistory.Fields.USER_ID), userId);
            predicates.add(userIdEqual);
        }
        if (searchString != null) {
            Predicate searchStringEqual = criteriaBuilder.like(root.get(QueryHistory.Fields.QUERY), searchString);
            predicates.add(searchStringEqual);
        }
        if (!predicates.isEmpty()) {
            Predicate[] predicate = new Predicate[predicates.size()];
            criteriaQuery.select(root).where(criteriaBuilder.and(predicates.toArray(predicate)));
        }
        if (orderBy != null && "desc".equalsIgnoreCase(order)) {
            criteriaQuery.orderBy(criteriaBuilder.desc(root.get(orderBy)));
        } else if (orderBy != null) {
            criteriaQuery.orderBy(criteriaBuilder.asc(root.get(orderBy)));
        }
        Query<QueryHistory> query = session.createQuery(criteriaQuery);
        query.setFirstResult(offset != null ? offset : 0);
        query.setMaxResults(limit != null ? limit : DEFAULT_MAX_ROW_QUERY_HISTORY);
        return query.getResultList();
    }

}

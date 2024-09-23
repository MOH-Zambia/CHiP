package com.argusoft.imtecho.listvalues.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.listvalues.dao.ListValueFieldValueDetailDao;
import com.argusoft.imtecho.listvalues.model.ListValueFieldValueDetail;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

@Repository
public class ListValueFieldValueDetailDaoImpl extends GenericDaoImpl<ListValueFieldValueDetail, Integer> implements ListValueFieldValueDetailDao {
    @Override
    public String retrieveValueFromId(Integer id) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<String> cq = cb.createQuery(String.class);
        Root<ListValueFieldValueDetail> root = cq.from(ListValueFieldValueDetail.class);
        cq.select(root.get("value")).where(cb.equal(root.get("id"), id));
        return session.createQuery(cq).uniqueResult();
    }

    @Override
    public Integer retrieveIdFromConstant(String constant) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<Integer> cq = cb.createQuery(Integer.class);
        Root<ListValueFieldValueDetail> root = cq.from(ListValueFieldValueDetail.class);
        cq.select(root.get("id")).where(cb.equal(root.get("constant"), constant));
        return session.createQuery(cq).uniqueResult() != null ?
                session.createQuery(cq).uniqueResult() : null;
    }
}
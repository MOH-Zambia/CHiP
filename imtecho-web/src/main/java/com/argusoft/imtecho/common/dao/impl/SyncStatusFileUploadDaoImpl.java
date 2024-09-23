package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.SyncStatusFileUploadDao;
import com.argusoft.imtecho.common.model.SyncStatusFileUpload;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

@Repository
public class SyncStatusFileUploadDaoImpl extends GenericDaoImpl<SyncStatusFileUpload, String> implements SyncStatusFileUploadDao {


    @Override
    public SyncStatusFileUpload getSyncStatusFileUploadByUniqueId(String uniqueId) {
        CriteriaBuilder cb = getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<SyncStatusFileUpload> cq = cb.createQuery(SyncStatusFileUpload.class);
        Root<SyncStatusFileUpload> root = cq.from(SyncStatusFileUpload.class);
        cq.select(root);

        Predicate conditions = cb.equal(root.get("uniqueId"), uniqueId);

        cq.where(conditions);

        return getCurrentSession().createQuery(cq).uniqueResult();
    }
}

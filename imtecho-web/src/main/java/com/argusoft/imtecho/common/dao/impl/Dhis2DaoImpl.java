package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.Dhis2Dao;
import com.argusoft.imtecho.common.model.Dhis2CallLog;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.Date;
import java.util.List;

@Repository
public class Dhis2DaoImpl extends GenericDaoImpl<Dhis2CallLog, Long> implements Dhis2Dao {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public String getData(Date monthEnd, Integer facilityId) {

        String sql = "select cast(get_dhis2_payload as text) from get_dhis2_payload(:monthEnd, :facilityId)";

        Query query = entityManager.createNativeQuery(sql).setParameter("monthEnd", monthEnd).setParameter("facilityId", facilityId);

        String result = (String) query.getSingleResult();

        return result;
    }

    @Override
    public List<Integer> getEnabledFacilities() {
        String sql = "select id from health_infrastructure_details where is_enabled = true and dhis2_uid is not null";
        Query query = entityManager.createNativeQuery(sql);
        List<Integer> result = query.getResultList();
        return result;
    }

}

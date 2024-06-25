package com.argusoft.imtecho.location.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.location.dao.LocationWardsMappingDao;
import com.argusoft.imtecho.location.model.LocationWardsMapping;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;

/**
 *
 * <p>
 * Implementation of methods define in location ward dao.
 * </p>
 *
 * @author dhaval
 * @since 26/08/20 10:19 AM
 */
@Repository
@Transactional
public class LocationWardsMappingDaoImpl extends GenericDaoImpl<LocationWardsMapping, Integer> implements LocationWardsMappingDao {
    /**
     * {@inheritDoc}
     */
    @Override
    public void deleteByWardId(Integer wardId) {
        String query = "DELETE FROM location_wards_mapping where ward_id = :wardId ;";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<Integer> q = session.createNativeQuery(query);
        q.setParameter("wardId", wardId);
        q.executeUpdate();
    }
}

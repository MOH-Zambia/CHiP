package com.argusoft.imtecho.location.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.location.model.LocationWardsMapping;

/**
 *
 * <p>
 * Define methods for location wards mapping.
 * </p>
 *
 * @author akshar
 * @since 26/08/20 10:19 AM
 */
public interface LocationWardsMappingDao extends GenericDao<LocationWardsMapping, Integer> {
    /**
     * Delete ward by id.
     * @param wardId Ward id.
     */
    void deleteByWardId(Integer wardId);
}

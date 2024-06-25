/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.LocationMobileFeature;
import java.util.List;

/**
 *
 * @author kunjan
 */
public interface LocationMobileFeatureDao extends GenericDao<LocationMobileFeature, Integer> {
    
    List<String> retrieveFeaturesAssignedToTheAoi(Integer userId);
    
    LocationMobileFeature retrieveByLocationId(Integer locationId);
}

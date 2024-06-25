/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.location.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * <p>
 * Implementation of methods define in location level hierarchy details dao.
 * </p>
 *
 * @author Harshit
 * @since 26/08/20 10:19 AM
 */
@Repository
public class LocarionLevelHierachyDaoImpl extends GenericDaoImpl<LocationLevelHierarchy, Integer> implements LocationLevelHierarchyDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public LocationLevelHierarchy retrieveByLocationId(Integer locationId) {
        return findEntityByCriteriaList((root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(LocationLevelHierarchy.Fields.LOCATION_ID), locationId));
            return predicates;
        });
    }

}

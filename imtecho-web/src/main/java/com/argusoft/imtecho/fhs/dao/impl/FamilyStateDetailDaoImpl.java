/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao.impl;

import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dao.FamilyStateDetailDao;
import com.argusoft.imtecho.fhs.model.FamilyStateDetailEntity;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * <p>
 * Implementation of methods define in family state dao.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
@Repository
public class FamilyStateDetailDaoImpl extends GenericDaoImpl<FamilyStateDetailEntity, Integer> implements FamilyStateDetailDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public FamilyStateDetailEntity retrieveById(Integer id) {
        PredicateBuilder<FamilyStateDetailEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(FamilyStateDetailEntity.Fields.ID), id));
            return predicates;
        };
        return findEntityByCriteriaList(predicateBuilder);
    }

}

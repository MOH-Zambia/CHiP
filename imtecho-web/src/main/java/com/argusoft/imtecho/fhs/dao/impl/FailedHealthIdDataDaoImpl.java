/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao.impl;

import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dao.FailedHealthIdDataDao;
import com.argusoft.imtecho.fhs.model.FailedHealthIdDataEntity;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 * Implementation of methods define in member dao.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
@Repository
@Transactional
public class FailedHealthIdDataDaoImpl extends GenericDaoImpl<FailedHealthIdDataEntity, Integer> implements FailedHealthIdDataDao {

    public static final String ID_PROPERTY = "id";

    @Override
    public FailedHealthIdDataEntity updateFailedHealthIdData(FailedHealthIdDataEntity failedHealthIdDataEntity) {
        super.update(failedHealthIdDataEntity);
        return failedHealthIdDataEntity;
    }

    @Override
    public FailedHealthIdDataEntity retrieveFailedHealthIdDataById(Integer id) {
        if (id == null) {
            return null;
        }
        PredicateBuilder<FailedHealthIdDataEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(ID_PROPERTY), id));
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }

    @Override
    public FailedHealthIdDataEntity createFailedHealthIdData(FailedHealthIdDataEntity failedHealthIdDataEntity) {
        super.createOrUpdate(failedHealthIdDataEntity);
        return failedHealthIdDataEntity;
    }
}

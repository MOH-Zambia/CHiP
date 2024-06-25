/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.UncaughtExceptionMobileDao;
import com.argusoft.imtecho.mobile.model.UncaughtExceptionMobile;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 * @author kunjan
 */
@Repository
public class UncaughtExceptionMobileDaoImpl extends GenericDaoImpl<UncaughtExceptionMobile, Integer> implements UncaughtExceptionMobileDao {

    private static final String IS_ACTIVE = "isActive";

    @Override
    public List<UncaughtExceptionMobile> retrieveActiveUncaughtExceptions() {
        PredicateBuilder<UncaughtExceptionMobile> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(IS_ACTIVE), Boolean.TRUE));
            return predicates;
        };
        return super.findByCriteriaList(predicateBuilder);
    }

}

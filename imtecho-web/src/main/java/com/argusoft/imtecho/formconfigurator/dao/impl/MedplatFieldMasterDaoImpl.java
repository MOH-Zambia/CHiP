package com.argusoft.imtecho.formconfigurator.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFieldMasterDao;
import com.argusoft.imtecho.formconfigurator.enums.State;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldMaster;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class MedplatFieldMasterDaoImpl extends GenericDaoImpl<MedplatFieldMaster, UUID> implements MedplatFieldMasterDao {
    @Override
    public MedplatFieldMaster retrieveFieldMasterByFieldCode(String fieldCode) {
        return super.findEntityByCriteriaList((root, criteriaBuilder, criteriaQuery) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(criteriaBuilder.equal(root.get("fieldCode"), fieldCode));
            return predicates;
        });
    }

    @Override
    public List<MedplatFieldMaster> retrieveAll() {
        return super.findByCriteriaList((root, criteriaBuilder, criteriaQuery) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(criteriaBuilder.equal(root.get("state"), State.ACTIVE));
            return predicates;
        });
    }
}

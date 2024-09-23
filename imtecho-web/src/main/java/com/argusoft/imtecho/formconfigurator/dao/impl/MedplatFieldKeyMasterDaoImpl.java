package com.argusoft.imtecho.formconfigurator.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFieldKeyMasterDao;
import com.argusoft.imtecho.formconfigurator.models.MedplatFieldKeyMaster;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class MedplatFieldKeyMasterDaoImpl extends GenericDaoImpl<MedplatFieldKeyMaster, UUID> implements MedplatFieldKeyMasterDao {
    @Override
    public List<MedplatFieldKeyMaster> retrieveByFieldMasterUuid(UUID fieldMasterUuid) {
        return super.findByCriteriaList((root, criteriaBuilder, criteriaQuery) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(criteriaBuilder.equal(root.get("fieldMasterUuid"), fieldMasterUuid));
            criteriaQuery.orderBy(criteriaBuilder.asc(root.get("orderNo")));
            return predicates;
        });
    }
}

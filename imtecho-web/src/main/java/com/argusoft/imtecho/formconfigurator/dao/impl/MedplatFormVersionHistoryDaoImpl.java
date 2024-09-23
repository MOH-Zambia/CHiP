package com.argusoft.imtecho.formconfigurator.dao.impl;

import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormVersionHistoryDao;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormConfigurationDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormMasterDto;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormVersionHistory;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.util.CollectionUtils;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Repository
public class MedplatFormVersionHistoryDaoImpl extends GenericDaoImpl<MedplatFormVersionHistory, UUID> implements MedplatFormVersionHistoryDao {
    @Override
    public MedplatFormVersionHistory retrieveMedplatFormByCriteria(UUID formMasterUuid, String version) {
        return super.findEntityByCriteriaList(((root, criteriaBuilder, criteriaQuery) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (formMasterUuid != null) {
                predicates.add(criteriaBuilder.equal(root.get("formMasterUuid"), formMasterUuid));
            }
            if (version != null) {
                predicates.add(criteriaBuilder.equal(root.get("version"), version));
            }
            return predicates;
        }));
    }

    @Override
    public MedplatFormConfigurationDto getLatestVersionByFormMasterUUID(UUID formMasterUuid) {
        Session session = sessionFactory.getCurrentSession();
        String query = "select max(cast(version as integer)) as \"version\" from medplat_form_version_history mfvh where \"version\" <> 'DRAFT' and form_master_uuid = :formMasterUuid ;";

        SQLQuery sqlQuery = session.createSQLQuery(query);
        sqlQuery.setParameter("formMasterUuid", formMasterUuid);
        sqlQuery.addScalar("version", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(MedplatFormConfigurationDto.class));
        return (MedplatFormConfigurationDto) sqlQuery.uniqueResult();
    }
}

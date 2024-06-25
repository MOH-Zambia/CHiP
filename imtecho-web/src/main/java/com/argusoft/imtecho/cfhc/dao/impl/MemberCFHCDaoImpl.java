package com.argusoft.imtecho.cfhc.dao.impl;

import com.argusoft.imtecho.cfhc.dao.MemberCFHCDao;
import com.argusoft.imtecho.cfhc.model.MemberCFHCEntity;
import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>Implements methods of MemberCFHCDao</p>
 *
 * @author rahul
 * @since 25/08/20 2:30 PM
 */

@Repository
public class MemberCFHCDaoImpl extends GenericDaoImpl<MemberCFHCEntity, Long> implements MemberCFHCDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberCFHCEntity> retrieveMemberCFHCEntitiesByFamilyId(Integer familyId) {
        PredicateBuilder<MemberCFHCEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(MemberCFHCEntity.Fields.FAMILY_ID_PROPERTY), familyId));
            return predicates;
        };
        return new ArrayList<>(super.findByCriteriaList(predicateBuilder));
    }

    @Override
    public MemberCFHCEntity retrieveMemberCFHCEntitiesByMemberId(Integer id) {
        PredicateBuilder<MemberCFHCEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (id != null) {
                predicates.add(builder.equal(root.get(MemberCFHCEntity.Fields.MEMBER_ID_PROPERTY), id));
            }
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }
}

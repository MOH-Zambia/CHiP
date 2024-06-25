
package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.RoleHierarchyManagementDao;
import com.argusoft.imtecho.common.model.RoleHierarchyManagement;
import com.argusoft.imtecho.common.model.RoleManagement;
import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 *     Implements methods of RoleHierarchyManagementDao
 * </p>
 * @author vaishali
 * @since 31/08/2020 4:30
 */
@Repository
public class RoleHierarchyManagementDaoImpl extends GenericDaoImpl<RoleHierarchyManagement, Integer> implements RoleHierarchyManagementDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public List<RoleHierarchyManagement> retrieveLocationByRoleId(Integer roleId) {
        PredicateBuilder<RoleHierarchyManagement> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(RoleHierarchyManagement.Fields.ROLE_ID), roleId));
            predicates.add(builder.equal(root.get(RoleHierarchyManagement.Fields.STATE), RoleHierarchyManagement.State.ACTIVE));
            return predicates;
        };
        return super.findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<RoleHierarchyManagement> retrieveActiveLocationByRoleId(Integer roleId) {
        PredicateBuilder<RoleHierarchyManagement> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(RoleHierarchyManagement.Fields.ROLE_ID), roleId));
            predicates.add(builder.equal(root.get(RoleHierarchyManagement.Fields.STATE), RoleManagement.State.ACTIVE));
            return predicates;
        };
        return super.findByCriteriaList(predicateBuilder);
    }

}

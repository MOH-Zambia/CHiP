package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.UserMenuItemDao;
import com.argusoft.imtecho.common.model.UserMenuItem;
import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 *     Implements methods of UserMenuItemDao
 * </p>
 * @author charmi
 * @since 31/08/2020 4:30
 */
@Repository
public class UserMenuItemDaoImpl extends GenericDaoImpl<UserMenuItem, Integer> implements UserMenuItemDao {

    @Override
    public List<UserMenuItem> retrieveByMenuConfigId(Integer menuConfigId) {
        PredicateBuilder<UserMenuItem> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get("menuConfigId"), menuConfigId));
            return predicates;
        };
        List<UserMenuItem> list = super.findByCriteriaList(predicateBuilder);
        return list;
    }

}

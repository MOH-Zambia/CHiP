
package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.RoleDao;
import com.argusoft.imtecho.common.dto.AssignRoleWithFeatureDto;
import com.argusoft.imtecho.common.model.RoleMaster;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.List;
import java.util.Set;

/**
 * <p>
 *     Implements methods of RoleDao
 * </p>
 * @author vaishali
 * @since 31/08/2020 4:30
 */
@Repository
@Transactional
public class RoleDaoImpl extends GenericDaoImpl<RoleMaster, Integer> implements RoleDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public List<RoleMaster> retrieveAll(Boolean isActive) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<RoleMaster> cq = cb.createQuery(RoleMaster.class);
        Root<RoleMaster> root = cq.from(RoleMaster.class);

        cq.select(root).orderBy(cb.asc(root.get("name")));
        if (Boolean.TRUE.equals(isActive)) {
            cq.where(cb.equal(root.get(RoleMaster.Fields.STATE), UserMaster.State.ACTIVE));
        } else if (Boolean.FALSE.equals(isActive)) {
            cq.where(cb.notEqual(root.get(RoleMaster.Fields.STATE), UserMaster.State.ACTIVE));
        }

        return session.createQuery(cq).getResultList();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public RoleMaster retrieveById(Integer roleId) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<RoleMaster> cq = cb.createQuery(RoleMaster.class);
        Root<RoleMaster> root = cq.from(RoleMaster.class);

        cq.select(root).where(cb.equal(root.get(RoleMaster.Fields.ID), roleId));
        return session.createQuery(cq).uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public RoleMaster retrieveByCode(String code) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<RoleMaster> cq = cb.createQuery(RoleMaster.class);
        Root<RoleMaster> root = cq.from(RoleMaster.class);

        cq.select(root).where(cb.equal(root.get(RoleMaster.Fields.CODE), code));
        return session.createQuery(cq).uniqueResult();
    }

    public List<RoleMaster> getRolesByIds(Set<Integer> trainerRoleIds) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery<RoleMaster> cq = cb.createQuery(RoleMaster.class);
        Root<RoleMaster> root = cq.from(RoleMaster.class);

        cq.select(root).where(root.get(RoleMaster.Fields.ID).in(trainerRoleIds));
        return session.createQuery(cq).getResultList();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getAssignedFeaturesByRoleId(Integer roleId) {
        String query = "select string_agg(menu_config.menu_name,',') as features from user_menu_item \n"
                + "left join menu_config on user_menu_item.menu_config_id=menu_config.id\n"
                + "where user_menu_item.role_id=" + roleId + " and menu_config.active=true";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<String> q = session.createNativeQuery(query);
        return q.uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<AssignRoleWithFeatureDto> getAssignedFeatureList(Integer roleId){
        String query = "select menu_config.menu_name as \"featureName\",menu_config.id as \"featureId\", user_menu_item.user_menu_id as \"userMenuItemId\", menu_config.description as \"description\" from user_menu_item \n"
                + "left join menu_config on user_menu_item.menu_config_id=menu_config.id\n"
                + "where user_menu_item.role_id=" + roleId + " and menu_config.active=true";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<AssignRoleWithFeatureDto> q = session.createSQLQuery(query).addScalar("featureName", StandardBasicTypes.STRING).addScalar("featureId", StandardBasicTypes.INTEGER)
                .addScalar("userMenuItemId", StandardBasicTypes.INTEGER)
                .addScalar("description", StandardBasicTypes.STRING);
        return q.setResultTransformer(Transformers.aliasToBean(AssignRoleWithFeatureDto.class)).list();
    }

    @Override
    public void handleMobileMenuInsertion(String roleName, Integer roleId, Integer createdBy){
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<Integer> q = session.createNativeQuery("with menu_master as (\n" +
            "insert into mobile_menu_master (menu_name, config_json, created_on, created_by, modified_on, modified_by)\n" +
            "values (:menuName, :config, now(), :userId, now(), :userId)\n" +
            "returning id)\n" +
            "insert into mobile_menu_role_relation(menu_id, role_id)\n" +
            "select (select id from menu_master), :roleId ;");
        q.setParameter("menuName", roleName + " Menu");
        q.setParameter("config", "[{\"mobile_constant\":\"LIBRARY\",\"order\":1},{\"mobile_constant\":\"ANNOUNCEMENTS\",\"order\":2},{\"mobile_constant\":\"WORK_LOG\",\"order\":3},{\"mobile_constant\":\"LEARNING_MANAGEMENT_SYSTEM\",\"order\":4}]");
        q.setParameter("userId", createdBy);
        q.setParameter("roleId", roleId);
        q.executeUpdate();
    }
}
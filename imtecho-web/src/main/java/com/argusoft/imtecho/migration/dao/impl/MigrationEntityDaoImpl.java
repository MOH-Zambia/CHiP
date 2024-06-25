/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.migration.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.migration.dao.MigrationEntityDao;
import com.argusoft.imtecho.migration.dto.MigratedMembersDataBean;
import com.argusoft.imtecho.migration.dto.MigrationInDataBean;
import com.argusoft.imtecho.migration.model.MigrationEntity;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.google.gson.Gson;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * @author kunjan
 */
@Repository
public class MigrationEntityDaoImpl extends GenericDaoImpl<MigrationEntity, Integer> implements MigrationEntityDao {

    @Override
    public List<MigratedMembersDataBean> retrieveMigrationByLocation(Integer userId) {

        String query = "with migrations as (\n"
                + "select mm.id as \"migrationId\", m.id as \"memberId\", m.unique_health_id as \"healthId\",\n"
                + "concat(m.first_name, ' ', m.middle_name, ' ', m.last_name) as \"name\",\n"
                + "mm.location_migrated_from as \"fromLocationId\", mm.location_migrated_to as \"toLocationId\",\n"
                + "mm.family_migrated_from as \"familyMigratedFrom\", mm.family_migrated_to as \"familyMigratedTo\",\n"
                + "(extract(epoch from mm.modified_on) * 1000) as \"modifiedOn\",\n"
                + "case when mm.state = 'CONFIRMED' then true else false end as \"isConfirmed\",\n"
                + "case when mm.state = 'LFU' then true else false end as \"isLfu\", "
                + "mm.out_of_state as \"outOfState\""
                + "from migration_master mm\n"
                + "inner join imt_member m on mm.member_id = m.id\n"
                + "where mm.state in ('REPORTED', 'CONFIRMED', 'LFU')\n"
                + "and (\n"
                + "mm.location_migrated_from in (\n"
                + "select l.child_id from um_user_location ul\n"
                + "inner join um_user u on u.id = ul.user_id\n"
                + "inner join location_hierchy_closer_det l on ul.loc_id = l.parent_id\n"
                + "where u.state = 'ACTIVE' and ul.state = 'ACTIVE'\n"
                + "and u.id = :userId\n"
                + ") or mm.location_migrated_to in (\n"
                + "select l.child_id from um_user_location ul\n"
                + "inner join um_user u on u.id = ul.user_id\n"
                + "inner join location_hierchy_closer_det l on ul.loc_id = l.parent_id\n"
                + "where u.state = 'ACTIVE' and ul.state = 'ACTIVE'\n"
                + "and u.id = :userId\n"
                + ")\n"
                + ")\n"
                + "), dist_loc as (\n"
                + "select distinct \"fromLocationId\" as loc_id from migrations\n"
                + "union\n"
                + "select distinct  \"toLocationId\" from migrations\n"
                + "), hierarchy as (\n"
                + "select ld.child_id, string_agg(l.name,' > ' order by ld.depth desc) as hierarchy \n"
                + "from location_hierchy_closer_det ld, location_master l \n"
                + "where ld.parent_id = l.id and ld.child_id in (select loc_id from dist_loc)\n"
                + "group by ld.child_id\n"
                + ")\n"
                + "select migrations.*, h1.hierarchy as \"locationMigratedFrom\", h2.hierarchy as \"locationMigratedTo\" \n"
                + "from migrations \n"
                + "left join hierarchy as h1 on h1.child_id = migrations.\"fromLocationId\"\n"
                + "left join hierarchy as h2 on h2.child_id = migrations.\"toLocationId\"";

        NativeQuery<MigratedMembersDataBean> q = getCurrentSession().createNativeQuery(query)
                .addScalar("migrationId", StandardBasicTypes.INTEGER)
                .addScalar("memberId", StandardBasicTypes.INTEGER)
                .addScalar("name", StandardBasicTypes.STRING)
                .addScalar("healthId", StandardBasicTypes.STRING)
                .addScalar("familyMigratedFrom", StandardBasicTypes.STRING)
                .addScalar("familyMigratedTo", StandardBasicTypes.STRING)
                .addScalar("locationMigratedFrom", StandardBasicTypes.STRING)
                .addScalar("locationMigratedTo", StandardBasicTypes.STRING)
                .addScalar("fromLocationId", StandardBasicTypes.INTEGER)
                .addScalar("toLocationId", StandardBasicTypes.INTEGER)
                .addScalar("modifiedOn", StandardBasicTypes.LONG)
                .addScalar("outOfState", StandardBasicTypes.BOOLEAN)
                .addScalar("isConfirmed", StandardBasicTypes.BOOLEAN)
                .addScalar("isLfu", StandardBasicTypes.BOOLEAN);
        q.setParameter("userId", userId);
        return q.setResultTransformer(Transformers.aliasToBean(MigratedMembersDataBean.class)).list();
    }

    @Override
    public List<MigrationEntity> retrieveMigrationForCreatingTemporaryMembers(Boolean fromCron) {
        return super.findByCriteriaList((root, builder, type) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get("type"), RchConstants.MIGRATION.MIGRATION_TYPE_IN));
            predicates.add(builder.equal(root.get("isTemporary"), true));
            predicates.add(builder.equal(root.get("state"), RchConstants.MIGRATION.MIGRATION_STATE_REPORTED));
            predicates.add(builder.isNull(root.get("memberId")));
            if (fromCron) {
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.DATE, -7);
                predicates.add(builder.lessThanOrEqualTo(root.get("modifiedOn"), calendar.getTime()));
            }
            return predicates;
        });
    }

    @Override
    public List<MigrationEntity> retrieveMigrationOutWithNoResponse() {
        return super.findByCriteriaList((root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get("type"), RchConstants.MIGRATION.MIGRATION_TYPE_OUT));
            predicates.add(builder.equal(root.get("state"), RchConstants.MIGRATION.MIGRATION_STATE_REPORTED));
            predicates.add(builder.or(builder.isNull(root.get("outOfState")), builder.equal(root.get("outOfState"), Boolean.FALSE)));
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DATE, -7);
            predicates.add(builder.lessThanOrEqualTo(root.get("reportedOn"), calendar.getTime()));
            return predicates;
        });
    }

    @Override
    public List<MigrationEntity> retrieveMigrationInWithNoResponse() {
        return super.findByCriteriaList((root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get("type"), RchConstants.MIGRATION.MIGRATION_TYPE_IN));
            predicates.add(builder.equal(root.get("state"), RchConstants.MIGRATION.MIGRATION_STATE_REPORTED));
            predicates.add(builder.equal(root.get("outOfState"), Boolean.FALSE));
            predicates.add(builder.equal(root.get("isTemporary"), Boolean.FALSE));
            predicates.add(builder.isNotNull(root.get("memberId")));
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DATE, -7);
            predicates.add(builder.lessThanOrEqualTo(root.get("modifiedOn"), calendar.getTime()));
            return predicates;
        });
    }

    @Override
    public List<Integer> retrieveSimilarMemberIds(MigrationEntity migrationEntity) {
        if (migrationEntity.getMobileData() != null) {
            MigrationInDataBean migrationInDataBean = new Gson().fromJson(migrationEntity.getMobileData(), MigrationInDataBean.class);

            if (migrationInDataBean != null) {
                if (!migrationInDataBean.getBankAccountNumber().isEmpty() || !migrationInDataBean.getPhoneNumber().isEmpty() || !migrationInDataBean.getFirstname().isEmpty() || !migrationInDataBean.getLastName().isEmpty()) {
                    String bankAccNum = migrationInDataBean.getBankAccountNumber().isEmpty() ? null : migrationInDataBean.getBankAccountNumber();
                    String phoneNumber = migrationInDataBean.getPhoneNumber().isEmpty() ? null : migrationInDataBean.getPhoneNumber();
                    String firstName = migrationInDataBean.getFirstname().isEmpty() ? null : migrationInDataBean.getFirstname();
                    String lastName = migrationInDataBean.getLastName().isEmpty() ? null : migrationInDataBean.getLastName();
                    String sql = "select m.id as memberId from   imt_member m\n"
                            + "\n"
                            + "inner join imt_family f on f.family_id= m.family_id\n"
                            + "where is_pregnant=true\n"
                            + "and "
                            + "f.location_id in (select child_id from location_hierchy_closer_det  where parent_id= " + migrationInDataBean.getNearestLocId() + " and child_loc_type='V') and\n"
                            + "( case when '" + bankAccNum + "' <> 'null' then m.account_number='" + bankAccNum + "' end\n"
                            + "\n"
                            + "or case when '" + phoneNumber + "' <> 'null' then  m.mobile_number='" + phoneNumber + "' end\n"
                            + "or(case when '" + firstName + "' <> 'null' and '" + lastName + "' <> 'null' then ( similarity('" + firstName + "',first_name) >= 0.50\n"
                            + "and similarity('" + lastName + "',last_name) >= 0.60) end)\n"
                            + "\n"
                            + "\n"
                            + ")";
                    Session session = sessionFactory.getCurrentSession();
                    return session.createNativeQuery(sql)
                            .addScalar("memberId", StandardBasicTypes.INTEGER)
                            .list();
                }
            }
        }
        return null;
    }

    @Override
    public List<MigrationEntity> retrieveMigrationInMembers(Boolean isUnverifiedOnly) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
        CriteriaQuery<MigrationEntity> criteria = criteriaBuilder.createQuery(MigrationEntity.class);
        Root<MigrationEntity> root = criteria.from(MigrationEntity.class);
        Predicate typeIn = criteriaBuilder.equal(root.get("type"), "IN");
        Predicate state = criteriaBuilder.equal(root.get("state"), RchConstants.MIGRATION.MIGRATION_STATE_REPORTED);
        Predicate outOfStateNull = criteriaBuilder.isNull(root.get("outOfState"));
        Predicate outOfStateFalse = criteriaBuilder.equal(root.get("outOfState"), false);
        Predicate nullMember = criteriaBuilder.isNull(root.get("memberId"));
        Predicate orPredicate = criteriaBuilder.or(outOfStateNull, outOfStateFalse);
        if (isUnverifiedOnly) {
            Predicate similarVerifiedNull = criteriaBuilder.isNull(root.get("similarMemberVerified"));
            Predicate similarVerifiedFalse = criteriaBuilder.equal(root.get("similarMemberVerified"), false);
            Predicate orPredicate1 = criteriaBuilder.or(similarVerifiedNull, similarVerifiedFalse);
            criteria.select(root).where(criteriaBuilder.and(typeIn, state, nullMember, orPredicate, orPredicate1));
        } else {
            criteria.select(root).where(criteriaBuilder.and(typeIn, state, nullMember, orPredicate));
        }
        return session.createQuery(criteria).getResultList();
    }

    @Override
    public List<MemberDto> retrieveSimilarMembersFound(Integer migrationId) {
        String sql = "with member as(select m.id,m.first_name as firstName,\n"
                + "m.middle_name as middleName,\n"
                + "m.last_name as lastName,\n"
                + "m.unique_health_id as uniqueHealthId,\n"
                + "m.mobile_number as mobileNumber,\n"
                + "f.location_id as locationId,cast(f.area_id as text) as areaId,\n"
                + "m.family_id as familyId from imt_member m\n"
                + "inner join migration_in_member_analytics a on a.member_id = m.id\n"
                + "inner join imt_family f on f.family_id = m.family_id\n"
                + "where a.migration_id=:migrationId)\n"
                + "select string_agg(name,'>' order by depth) as locationHierarchy,member.* from member, location_master m\n"
                + "inner join location_hierchy_closer_det c on m.id=c.child_id\n"
                + "where parent_id=member.locationId\n"
                + "group by member.id, member.firstName,member.lastName,member.uniqueHealthId,member.mobileNumber,member.locationId,member.familyId,member.areaId,member.middleName\n"
                + "";

        Session session = sessionFactory.getCurrentSession();
        return session.createNativeQuery(sql)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("firstName", StandardBasicTypes.STRING)
                .addScalar("lastName", StandardBasicTypes.STRING)
                .addScalar("uniqueHealthId", StandardBasicTypes.STRING)
                .addScalar("mobileNumber", StandardBasicTypes.STRING)
                .addScalar("familyId", StandardBasicTypes.STRING)
                .addScalar("locationHierarchy", StandardBasicTypes.STRING)
                .addScalar("middleName", StandardBasicTypes.STRING)
                .addScalar("areaId", StandardBasicTypes.STRING)
                .addScalar("locationId", StandardBasicTypes.INTEGER)
                .setParameter("migrationId", migrationId)
                .setResultTransformer(Transformers.aliasToBean(MemberDto.class)).list();
    }

    @Override
    public List<MigrationEntity> retrieveMigrationInWithoutPhoneNumber() {
        return super.findByCriteriaList((root, builder, type) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get("type"), RchConstants.MIGRATION.MIGRATION_TYPE_IN));
            predicates.add(builder.equal(root.get("isTemporary"), true));
            predicates.add(builder.isNull(root.get("memberId")));
            predicates.add(builder.equal(root.get("state"), RchConstants.MIGRATION.MIGRATION_STATE_REPORTED));
            predicates.add(builder.isNotNull(root.get("mobileData")));
            predicates.add(builder.not(builder.like(root.get("mobileData"), "%phoneNumber%")));
            return predicates;
        });
    }

    @Override
    public boolean checkIfMigrationOutAlreadyReported(Integer memberId) {
        List<MigrationEntity> list = super.findByCriteriaList((root, builder, type) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get("type"), RchConstants.MIGRATION.MIGRATION_TYPE_OUT));
            predicates.add(builder.equal(root.get("memberId"), memberId));
            predicates.add(builder.equal(root.get("state"), RchConstants.MIGRATION.MIGRATION_STATE_REPORTED));
            return predicates;
        });

        return !list.isEmpty();
    }
}

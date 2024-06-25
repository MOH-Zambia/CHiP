package com.argusoft.imtecho.migration.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.migration.dao.FamilyMigrationEntityDao;
import com.argusoft.imtecho.migration.dto.MigratedFamilyDataBean;
import com.argusoft.imtecho.migration.dto.MigratedMembersDataBean;
import com.argusoft.imtecho.migration.model.FamilyMigrationEntity;
import org.hibernate.SQLQuery;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 *
 * @author prateek on Aug 19, 2019
 */
@Repository
public class FamilyMigrationEntityDaoImpl extends GenericDaoImpl<FamilyMigrationEntity, Integer> implements FamilyMigrationEntityDao {
    @Override
    public List<MigratedFamilyDataBean> retrieveMigrationByLocation(Integer userId) {
        String query = "with migrations as (\n" +
                "\tselect ifmm.id as \"migrationId\", f.id as \"familyId\", f.family_id as \"familyIdString\",\n" +
                "\tifmm.location_migrated_from as \"fromLocationId\", ifmm.location_migrated_to as \"toLocationId\",\n" +
                "\t(extract(epoch from ifmm.modified_on) * 1000) as \"modifiedOn\",\n" +
                "\tcase when ifmm.state = 'CONFIRMED' then true else false end as \"isConfirmed\",\n" +
                "    case when ifmm.state = 'LFU' then true else false end as \"isLfu\",\n" +
                "    ifmm.is_split_family as \"isSplitFamily\",\n" +
                "    sf.id as \"sFamilyId\", sf.family_id as \"sFamilyIdString\",\n" +
                "    ifmm.out_of_state as \"outOfState\",\n" +
                "    case when ifmm.member_ids is null then null else \n" +
                "\t(\n" +
                "\t\tselect string_agg(concat(im.unique_health_id, ' - ', im.first_name, ' ', im.middle_name, ' ', im.last_name), ',') as md\n" +
                "\t\tfrom (select unnest(string_to_array(ifmm.member_ids, ',')) id) sm\n" +
                "\t\tinner join imt_member im on im.id = cast(sm.id as integer) \n" +
                "\t) end as \"splitMembersDetail\"\n" +
                " \tfrom imt_family_migration_master ifmm \n" +
                "\tinner join imt_family f on f.id = ifmm.family_id\n" +
                "\tleft join imt_family sf on sf.id = ifmm.split_family_id \n" +
                "\twhere ifmm.state in ('REPORTED', 'CONFIRMED', 'LFU')\n" +
                "\tand (\n" +
                "\t\tifmm.location_migrated_from in (\n" +
                " \t    \tselect l.child_id from um_user_location ul\n" +
                " \t        inner join um_user u on u.id = ul.user_id\n" +
                " \t        inner join location_hierchy_closer_det l on ul.loc_id = l.parent_id\n" +
                " \t        where u.state = 'ACTIVE' and ul.state = 'ACTIVE'\n" +
                " \t        and u.id = :userId\n" +
                " \t    ) or ifmm.location_migrated_to in (\n" +
                " \t    \tselect l.child_id from um_user_location ul\n" +
                " \t        inner join um_user u on u.id = ul.user_id\n" +
                " \t        inner join location_hierchy_closer_det l on ul.loc_id = l.parent_id\n" +
                " \t        where u.state = 'ACTIVE' and ul.state = 'ACTIVE'\n" +
                " \t        and u.id = :userId\n" +
                " \t    )\n" +
                "\t)\n" +
                "), dist_loc as (\n" +
                " \tselect distinct \"fromLocationId\" as loc_id from migrations\n" +
                " \tunion\n" +
                " \tselect distinct  \"toLocationId\" from migrations\n" +
                " ), hierarchy as (\n" +
                " \tselect ld.child_id, string_agg(l.name,' > ' order by ld.depth desc) as hierarchy \n" +
                " \tfrom location_hierchy_closer_det ld, location_master l \n" +
                " \twhere ld.parent_id = l.id and ld.child_id in (select loc_id from dist_loc)\n" +
                " \tgroup by ld.child_id\n" +
                " )\n" +
                " select migrations.*, h1.hierarchy as \"locationMigratedFrom\", h2.hierarchy as \"locationMigratedTo\" \n" +
                " from migrations\n" +
                " left join hierarchy as h1 on h1.child_id = migrations.\"fromLocationId\"\n" +
                " left join hierarchy as h2 on h2.child_id = migrations.\"toLocationId\";";

        NativeQuery<MigratedFamilyDataBean> q = getCurrentSession().createNativeQuery(query)
                .addScalar("migrationId", StandardBasicTypes.INTEGER)
                .addScalar("familyId", StandardBasicTypes.INTEGER)
                .addScalar("familyIdString", StandardBasicTypes.STRING)
                .addScalar("locationMigratedFrom", StandardBasicTypes.STRING)
                .addScalar("locationMigratedTo", StandardBasicTypes.STRING)
                .addScalar("fromLocationId", StandardBasicTypes.INTEGER)
                .addScalar("toLocationId", StandardBasicTypes.INTEGER)
                .addScalar("modifiedOn", StandardBasicTypes.LONG)
                .addScalar("outOfState", StandardBasicTypes.BOOLEAN)
                .addScalar("isConfirmed", StandardBasicTypes.BOOLEAN)
                .addScalar("isLfu", StandardBasicTypes.BOOLEAN)
                .addScalar("isSplitFamily", StandardBasicTypes.BOOLEAN)
                .addScalar("sFamilyId", StandardBasicTypes.INTEGER)
                .addScalar("sFamilyIdString", StandardBasicTypes.STRING)
                .addScalar("splitMembersDetail", StandardBasicTypes.STRING);
        q.setParameter("userId", userId);
        List<MigratedFamilyDataBean> migratedFamilyDataBeans = q.setResultTransformer(Transformers.aliasToBean(MigratedFamilyDataBean.class)).list();
        return migratedFamilyDataBeans;
    }
}

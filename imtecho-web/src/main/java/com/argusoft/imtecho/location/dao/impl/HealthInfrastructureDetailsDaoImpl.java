package com.argusoft.imtecho.location.dao.impl;

import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.location.dao.HealthInfrastructureDetailsDao;
import com.argusoft.imtecho.location.model.HealthInfrastructureDetails;
import com.argusoft.imtecho.location.model.HealthInfrastructureLocationName;
import com.argusoft.imtecho.mobile.dto.HealthInfraTypeLocationBean;
import com.argusoft.imtecho.mobile.dto.HealthInfrastructureBean;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.Date;
import java.util.List;

/**
 * <p>
 * Implementation of methods define in health infrastructure dao.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 10:19 AM
 */
@Repository
@Transactional
public class HealthInfrastructureDetailsDaoImpl extends GenericDaoImpl<HealthInfrastructureDetails, Integer> implements HealthInfrastructureDetailsDao {

    public static final String TYPE_ID = "typeId";

    @Autowired
    private ImtechoSecurityUser currentUser;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<HealthInfrastructureBean> retrieveAllHealthInfrastructureForMobile(Date lastUpdatedOn) {
        String query = "select health_infrastructure_details.id as \"actualId\",\n" +
                "    health_infrastructure_details.name,\n" +
                "    health_infrastructure_details.name_in_english as \"englishName\",\n" +
                "    health_infrastructure_details.location_id as \"locationId\",\n" +
                "    health_infrastructure_details.type as \"typeId\",\n" +
                "    listvalue_field_value_detail.value as \"typeName\",\n" +
                "    is_nrc as \"isNrc\",\n" +
                "    is_cmtc as \"isCmtc\",\n" +
                "    is_fru as \"isFru\",\n" +
                "    is_sncu as \"isSncu\",\n" +
                "    is_chiranjeevi_scheme as \"isChiranjeevi\",\n" +
                "    is_balsaka as \"isBalsaka\",\n" +
                "    is_pmjy as \"isPmjy\",\n" +
                "    is_blood_bank as \"isBloodBank\",\n" +
                "    is_gynaec as \"isGynaec\",\n" +
                "    is_pediatrician as \"isPediatrician\",\n" +
                "    is_cpconfirmationcenter as \"isCpConfirmationCenter\",\n" +
                "    is_balsakha1 as \"isBalsakha1\",\n" +
                "    is_balsakha3 as \"isBalsakha3\",\n" +
                "    is_usg_facility as \"isUsgFacility\",\n" +
                "    is_referral_facility as \"isReferralFacility\",\n" +
                "    is_ma_yojna as \"isMaYojna\",\n" +
                "    latitude as \"latitude\",\n" +
                "    longitude as \"longitude\",\n" +
                "    abhay_parimiti_id as \"abhayParimitiId\",\n" +
                "    health_infrastructure_details.state,\n" +
                "    health_infrastructure_details.modified_on as \"modifiedOn\"\n" +
                "from health_infrastructure_details\n" +
                "    inner join listvalue_field_value_detail on health_infrastructure_details.type = listvalue_field_value_detail.id\n" +
                "where health_infrastructure_details.state = 'ACTIVE' and listvalue_field_value_detail.is_active = true";

        if (lastUpdatedOn != null) {
            query = query + " and modified_on > :lastModifiedOn";
        }

        Session session = sessionFactory.getCurrentSession();
        NativeQuery<HealthInfrastructureBean> sQLQuery = session.createNativeQuery(query)
                .addScalar("actualId", StandardBasicTypes.INTEGER)
                .addScalar("name", StandardBasicTypes.STRING)
                .addScalar("englishName", StandardBasicTypes.STRING)
                .addScalar("locationId", StandardBasicTypes.INTEGER)
                .addScalar(TYPE_ID, StandardBasicTypes.INTEGER)
                .addScalar("typeName", StandardBasicTypes.STRING)
                .addScalar("isNrc", StandardBasicTypes.BOOLEAN)
                .addScalar("isCmtc", StandardBasicTypes.BOOLEAN)
                .addScalar("isFru", StandardBasicTypes.BOOLEAN)
                .addScalar("isSncu", StandardBasicTypes.BOOLEAN)
                .addScalar("isChiranjeevi", StandardBasicTypes.BOOLEAN)
                .addScalar("isBalsaka", StandardBasicTypes.BOOLEAN)
                .addScalar("isPmjy", StandardBasicTypes.BOOLEAN)
                .addScalar("isBloodBank", StandardBasicTypes.BOOLEAN)
                .addScalar("isGynaec", StandardBasicTypes.BOOLEAN)
                .addScalar("isPediatrician", StandardBasicTypes.BOOLEAN)
                .addScalar("isCpConfirmationCenter", StandardBasicTypes.BOOLEAN)
                .addScalar("isBalsakha1", StandardBasicTypes.BOOLEAN)
                .addScalar("isBalsakha3", StandardBasicTypes.BOOLEAN)
                .addScalar("isUsgFacility", StandardBasicTypes.BOOLEAN)
                .addScalar("isReferralFacility", StandardBasicTypes.BOOLEAN)
                .addScalar("isMaYojna", StandardBasicTypes.BOOLEAN)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("latitude", StandardBasicTypes.STRING)
                .addScalar("longitude", StandardBasicTypes.STRING)
                .addScalar("abhayParimitiId", StandardBasicTypes.STRING);

        if (lastUpdatedOn != null) {
            sQLQuery.setParameter("lastModifiedOn", lastUpdatedOn);
        }

        return sQLQuery.setResultTransformer(Transformers.aliasToBean(HealthInfrastructureBean.class)).list();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public HealthInfrastructureDetails save(HealthInfrastructureDetails entity) {
        Session session = sessionFactory.getCurrentSession();
        session.save(entity);
        session.flush();
        return entity;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public HealthInfrastructureDetails getHealthInfraByMemberIdAndType(String type, Integer memberId) {

        String query = "select hid.id as id, hid.name_in_english as nameInEnglish, hid.address as address , " +
                "hid.mobile_number as mobileNumber , hid.postal_code as postalCode, hid.location_id as locationId " +  ", hid.hfr_facility_id as hfrFacilityId " +
                ", hid.is_link_to_bridge_id as isLinkToBridgeId " +
                "from imt_member im \n" +
                "inner join imt_family ifm on ifm.family_id = im.family_id \n" +
                "inner join location_master lm on ifm.location_id = lm.id \n" +
                "inner join location_hierchy_closer_det lhcd on lhcd.child_id = lm.id \n" +
                "inner join health_infrastructure_details hid on hid.location_id = lhcd.parent_id \n" +
                "where im.id=:memberId\n" +
                "and lhcd.parent_loc_type = :type ;";
        Session session = sessionFactory.getCurrentSession();
        SQLQuery sQLQuery = session.createSQLQuery(query);
        sQLQuery.setParameter("type", type);
        sQLQuery.addScalar("id", StandardBasicTypes.INTEGER);
        sQLQuery.addScalar("nameInEnglish", StandardBasicTypes.STRING);
//        sQLQuery.addScalar("contactPersonName", StandardBasicTypes.STRING);
//        sQLQuery.addScalar("contactNumber", StandardBasicTypes.STRING);
        sQLQuery.addScalar("address", StandardBasicTypes.STRING);
        sQLQuery.addScalar("mobileNumber", StandardBasicTypes.STRING);
        sQLQuery.addScalar("postalCode", StandardBasicTypes.STRING);
        sQLQuery.addScalar("locationId", StandardBasicTypes.INTEGER);
        sQLQuery.addScalar("hfrFacilityId", StandardBasicTypes.STRING);
        sQLQuery.addScalar("isLinkToBridgeId", StandardBasicTypes.BOOLEAN);
        sQLQuery.setParameter("memberId", memberId);

        sQLQuery.setResultTransformer(Transformers.aliasToBean(HealthInfrastructureDetails.class));
        if (!sQLQuery.list().isEmpty()) {
            return (HealthInfrastructureDetails) sQLQuery.list().get(0);
        } else {
            return null;
        }
    }

        /**
         * {@inheritDoc}
         */
    public List<HealthInfrastructureBean> getHealthInfrastructureByType(Integer typeId, String searchQuery) {
        String query = "select health_infrastructure_details.id as \"actualId\", health_infrastructure_details.name, \n" +
                "health_infrastructure_details.name_in_english as \"englishName\", \n" +
                "health_infrastructure_details.location_id as \"locationId\", \n" +
                "health_infrastructure_details.type as \"typeId\", \n" +
                "--listvalue_field_value_detail.value as \"typeName\", \n" +
                "is_nrc as \"isNrc\", is_cmtc as \"isCmtc\", is_fru as \"isFru\", is_sncu as \"isSncu\", \n" +
                "is_chiranjeevi_scheme as \"isChiranjeevi\", is_balsaka as \"isBalsaka\", is_pmjy as \"isPmjy\", \n" +
                "is_blood_bank as \"isBloodBank\", is_gynaec as \"isGynaec\", is_pediatrician as \"isPediatrician\", get_location_hierarchy(location_Id) as location,\n \n" +
                "is_cpconfirmationcenter as \"isCpConfirmationCenter\", \n" +
                "is_balsakha1 as \"isBalsakha1\", is_balsakha3 as \"isBalsakha3\", is_usg_facility as \"isUsgFacility\", \n" +
                "is_referral_facility as \"isReferralFacility\", is_ma_yojna as \"isMaYojna\", \n" +
                "health_infrastructure_details.state, health_infrastructure_details.modified_on as \"modifiedOn\" \n" +
                "from health_infrastructure_details \n" +
                "where type= :typeId and (name ilike '%" + searchQuery + "%' or name_in_english ilike '%" + searchQuery + "%') LIMIT 50";

        Session session = sessionFactory.getCurrentSession();
        NativeQuery<HealthInfrastructureBean> sQLQuery = session.createNativeQuery(query)
                .addScalar("actualId", StandardBasicTypes.INTEGER)
                .addScalar("name", StandardBasicTypes.STRING)
                .addScalar("englishName", StandardBasicTypes.STRING)
                .addScalar("locationId", StandardBasicTypes.INTEGER)
                .addScalar(TYPE_ID, StandardBasicTypes.INTEGER)
                .addScalar("isNrc", StandardBasicTypes.BOOLEAN)
                .addScalar("isCmtc", StandardBasicTypes.BOOLEAN)
                .addScalar("isFru", StandardBasicTypes.BOOLEAN)
                .addScalar("isSncu", StandardBasicTypes.BOOLEAN)
                .addScalar("isChiranjeevi", StandardBasicTypes.BOOLEAN)
                .addScalar("isBalsaka", StandardBasicTypes.BOOLEAN)
                .addScalar("isPmjy", StandardBasicTypes.BOOLEAN)
                .addScalar("isBloodBank", StandardBasicTypes.BOOLEAN)
                .addScalar("isGynaec", StandardBasicTypes.BOOLEAN)
                .addScalar("isPediatrician", StandardBasicTypes.BOOLEAN)
                .addScalar("isCpConfirmationCenter", StandardBasicTypes.BOOLEAN)
                .addScalar("forNcd", StandardBasicTypes.BOOLEAN)
                .addScalar("isBalsakha1", StandardBasicTypes.BOOLEAN)
                .addScalar("isBalsakha3", StandardBasicTypes.BOOLEAN)
                .addScalar("isUsgFacility", StandardBasicTypes.BOOLEAN)
                .addScalar("isReferralFacility", StandardBasicTypes.BOOLEAN)
                .addScalar("isMaYojna", StandardBasicTypes.BOOLEAN)
                .addScalar("isNpcb", StandardBasicTypes.BOOLEAN)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("location", StandardBasicTypes.STRING);

        sQLQuery.setParameter(TYPE_ID, typeId);

        return sQLQuery.setResultTransformer(Transformers.aliasToBean(HealthInfrastructureBean.class)).list();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public HealthInfrastructureDetails getPHCHealthInfraByMemberId(Integer memberId) {

        String query = "select hid.id as id, hid.name_in_english as nameInEnglish,hid.address as address , " +
                "hid.mobile_number as mobileNumber , hid.postal_code as postalCode, hid.location_id as locationId, hid.hfr_facility_id as hfrFacilityId" +
                "from imt_member im \n" +
                "inner join imt_family ifm on ifm.family_id = im.family_id \n" +
                "inner join location_master lm on ifm.location_id = lm.id \n" +
                "inner join location_hierchy_closer_det lhcd on lhcd.child_id = lm.id \n" +
                "inner join health_infrastructure_details hid on hid.location_id = lhcd.parent_id \n" +
                "where im.id=:memberId\n" +
                "and lhcd.parent_loc_type = 'P';";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<HealthInfrastructureDetails> nativeQuery = session.createNativeQuery(query);
        nativeQuery.setParameter("memberId", memberId);
        nativeQuery.addScalar("id", StandardBasicTypes.INTEGER);
        nativeQuery.addScalar("nameInEnglish", StandardBasicTypes.STRING);
        nativeQuery.addScalar("address", StandardBasicTypes.STRING);
        nativeQuery.addScalar("mobileNumber", StandardBasicTypes.STRING);
        nativeQuery.addScalar("postalCode", StandardBasicTypes.STRING);
        nativeQuery.addScalar("locationId", StandardBasicTypes.INTEGER);
        nativeQuery.addScalar("hfrFacilityId", StandardBasicTypes.STRING);
        nativeQuery.setResultTransformer(Transformers.aliasToBean(HealthInfrastructureDetails.class));
        if (!nativeQuery.getResultList().isEmpty()) {
            return nativeQuery.getResultList().get(0);
        } else {
            return null;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public HealthInfrastructureDetails retrieveByHFRFacilityId(String hfrFacilityId) {
        var session = sessionFactory.getCurrentSession();
        var cb = session.getCriteriaBuilder();
        CriteriaQuery<HealthInfrastructureDetails> cq = cb.createQuery(HealthInfrastructureDetails.class);
        Root<HealthInfrastructureDetails> root = cq.from(HealthInfrastructureDetails.class);
        cq.select(root).where(
                cb.equal(root.get(HealthInfrastructureDetails.Fields.HFR_FACILITY_ID), hfrFacilityId)
        );
        return session.createQuery(cq).uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    public HealthInfrastructureLocationName getLocationName(Integer locationId) {
        String query = "select child_id, string_agg(location_master.name,' > ' order by depth desc) as \"locationname\" \n" +
                "from location_hierchy_closer_det, location_master \n" +
                "where child_id = :locationId \n" +
                "and location_master.id = location_hierchy_closer_det.parent_id group by child_id";

        Session session = sessionFactory.getCurrentSession();
        NativeQuery<HealthInfrastructureLocationName> nativeQuery = session.createNativeQuery(query);
        nativeQuery.addScalar("locationname", StandardBasicTypes.STRING);
        nativeQuery.setParameter("locationId", locationId);
        nativeQuery.setResultTransformer(Transformers.aliasToBean(HealthInfrastructureLocationName.class));
        if (!nativeQuery.getResultList().isEmpty()) {
            return nativeQuery.getResultList().get(0);
        } else {
            return null;
        }
    }

    @Override
    public List<HealthInfrastructureDetails> getHealthInfraByUserIdAndType(Integer userId, String type) {
        String query = "select hid.id as id, hid.name_in_english as nameInEnglish, hid.location_id as locationId " +
                "from health_infrastructure_details hid\n" +
                "where location_id in (\n" +
                "select parent_id from location_hierchy_closer_det\n" +
                "where child_id in (\n" +
                "select loc_id from um_user_location\n" +
                "where user_id = :userId\n" +
                ") and parent_loc_type = :type\n" +
                ");";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<HealthInfrastructureDetails> nativeQuery = session.createNativeQuery(query);
        nativeQuery.setParameter("userId", userId);
        nativeQuery.setParameter("type", type);
        nativeQuery.addScalar("id", StandardBasicTypes.INTEGER);
        nativeQuery.addScalar("nameInEnglish", StandardBasicTypes.STRING);
        nativeQuery.addScalar("locationId", StandardBasicTypes.INTEGER);
        return nativeQuery.setResultTransformer(Transformers.aliasToBean(HealthInfrastructureDetails.class)).list();
//        if(!nativeQuery.getResultList().isEmpty()){
//            return nativeQuery.getResultList();
//        } else {
//            return null;
//        }
    }

    @Override
    public HealthInfrastructureDetails getHealthInfrastructureDetailsById(Integer healthInfraId) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery();
        Root<HealthInfrastructureDetails> root = cq.from(HealthInfrastructureDetails.class);
        cq.select(root).where(cb.equal(root.get("id"), healthInfraId));
        Query<HealthInfrastructureDetails> query = session.createQuery(cq);
        return query.uniqueResult();
    }

    @Override
    public HealthInfrastructureDetails getHealthInfrastructureDetailsByHFRId(String hfrFacilityId) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder cb = session.getCriteriaBuilder();
        CriteriaQuery cq = cb.createQuery();
        Root<HealthInfrastructureDetails> root = cq.from(HealthInfrastructureDetails.class);
        cq.select(root).where(cb.equal(root.get("hfrFacilityId"), hfrFacilityId));
        Query<HealthInfrastructureDetails> query = session.createQuery(cq);
        return query.uniqueResult();
    }

    public void toggleActive(Integer healthInfraId, String state) {
        String Newstate = state.equals("ACTIVE")?"INACTIVE":"ACTIVE";
        String query = "update health_infrastructure_details set state = :state, modified_on = now(),modified_by= :userId where id = :id ";
        NativeQuery<Integer> q = getCurrentSession().createNativeQuery(query);
        q.setParameter("state", Newstate)
                .setParameter("id", healthInfraId)
                .setParameter("userId",currentUser.getId());
        q.executeUpdate();

        if(Newstate.equals("INACTIVE")){
            String query2 = "update user_health_infrastructure set state = :state, modified_on = now(),modified_by = :userId where health_infrastrucutre_id = :id and state != :state ";
            NativeQuery<Integer> q2 = getCurrentSession().createNativeQuery(query2);
            q2.setParameter("state", Newstate)
                    .setParameter("userId",currentUser.getId())
                    .setParameter("id", healthInfraId);
            q2.executeUpdate();
        }
    }

    @Override
    public List<HealthInfraTypeLocationBean> getHealthInfrastructureLocation() {
        String query = "select distinct health_infrastructure_type_location.health_infra_type_id as \"healthInfraTypeId\", " +
                "health_infrastructure_type_location.location_level as \"locationLevel\"," +
                "listvalue_field_value_detail.\"value\" as \"healthInfraTypeName\" from health_infrastructure_type_location \n" +
                "inner join listvalue_field_value_detail \n" +
                "on health_infrastructure_type_location.health_infra_type_id = listvalue_field_value_detail.id\n" +
                "where listvalue_field_value_detail.is_active = true;";

        Session session = sessionFactory.getCurrentSession();
        NativeQuery<HealthInfraTypeLocationBean> sQLQuery = session.createNativeQuery(query);
        sQLQuery.addScalar("healthInfraTypeId", StandardBasicTypes.INTEGER)
                .addScalar("locationLevel", StandardBasicTypes.INTEGER)
                .addScalar("healthInfraTypeName", StandardBasicTypes.STRING);

        return sQLQuery.setResultTransformer(Transformers.aliasToBean(HealthInfraTypeLocationBean.class)).list();
    }
}

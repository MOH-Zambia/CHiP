/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao.impl;

import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.database.common.PredicateBuilder;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.*;
import com.argusoft.imtecho.fhs.mapper.*;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import org.apache.commons.lang.time.DateUtils;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * <p>
 * Implementation of methods define in member dao.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
@Repository
@Transactional
public class MemberDaoImpl extends GenericDaoImpl<MemberEntity, Integer> implements MemberDao {

    public static final String ID_PROPERTY = "id";
    public static final String MEMBER_ID_PROPERTY = "memberId";
    public static final String FAMILY_ID_PROPERTY = "familyId";
    public static final String FAMILY_ID_STR_PROPERTY = "famId";
    public static final String UNIQUE_HEALTH_ID_PROPERTY = "uniqueHealthId";
    public static final String MEMBER_UUID = "memberUUId";
    public static final String MOTHER_ID_PROPERTY = "motherId";
    public static final String STATE_PROPERTY = "state";
    public static final String LOCATION_ID_PROPERTY = "locationId";
    public static final String AREA_ID_PROPERTY = "areaId";
    public static final String ACCOUNT_NUMBER_PROPERTY = "accountNumber";
    public static final String MODIFIED_ON_PROPERTY = "modifiedOn";
    public static final String LOCATION_HIERARCHY_PROPERTY = "locationHierarchy";
    public static final String LOCATION_NAME_PROPERTY = "locationName";
    public static final String MOBILE_NUMBER_PROPERTY = "mobileNumber";
    public static final String NAME_PROPERTY = "name";
    public static final String FAMILY_MOBILE_NUMBER_PROPERTY = "familyMobileNumber";
    public static final String ORG_UNIT_PROPERTY = "orgUnit";
    public static final String VILLAGE_NAME_PROPERTY = "villageName";
    public static final String AADHAR_PROPERTY = "aadhar";
    public static final String DISEASE_PROPERTY = "disease";
    public static final String REFERRED_FOR_HYPERTENSION = "referredForHypertension";
    public static final String REFERRED_FOR_DIABETES = "referredForDiabetes";
    public static final String REFERRED_FOR_BREAST = "referredForBreast";
    public static final String REFERRED_FOR_ORAL = "referredForOral";
    public static final String REFERRED_FOR_CERVICAL = "referredForCervical";
    public static final String FOLLOW_UP_DATE = "followUpDate";
    public static final String EXAMINE_ALLOWED = "examineAllowed";
    public static final String REFERRED_FOR_DISEASES = "referredForDiseases";
    public static final String GENDER = "gender";

    public static final String OFFSET = "offset";
    public static final String LIMIT = "limit";
    public static final String HOF_MOBILE_NUMBER_PROPERTY = "hofMobileNumber";
    private static final String SCREENING_DATE = "lastScreeningDate";

    private static final Logger logger = LoggerFactory.getLogger(MemberDaoImpl.class);

    @PersistenceContext
    private EntityManager entityManager;

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberEntity updateMember(MemberEntity memberEntity) {
        super.update(memberEntity);
        return memberEntity;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberEntity retrieveMemberById(Integer id) {
        if (id == null) {
            return null;
        }
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(ID_PROPERTY), id));
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberEntity retrieveMemberByUniqueHealthId(String uniqueHealthId) {
        if (Objects.isNull(uniqueHealthId)) {
            return null;
        }
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(UNIQUE_HEALTH_ID_PROPERTY), uniqueHealthId));
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }
    @Override
    public MemberEntity retrieveMemberByUuid(String uuid) {
        if (Objects.isNull(uuid)) {
            return null;
        }
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(MEMBER_UUID), uuid));
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ClientMemberDto> findMembers(Integer facilityCode, Date registrationStartDate, Date registrationEndDate, String householdId, Integer zoneId, Integer cbvId) {
        StringBuilder queryBuilder = new StringBuilder(
                "SELECT i.unique_health_id, i.is_pregnant, i.gender, i.lmp, i.other_chronic_disease_treatment, " +
                        "    i.chronic_disease_treatment, i.under_treatment_chronic, i.other_disability, i.other_chronic, " +
                        "    i.physical_disability, i.chronic_disease, i.dob, i.menopause_arrived, i.hysterectomy_done, " +
                        "    (SELECT lvfvd.value FROM listvalue_field_value_detail lvfvd WHERE lvfvd.id = i.education_status), " +
                        "    i.mobile_number,(SELECT lvfvd.value FROM listvalue_field_value_detail lvfvd WHERE lvfvd.id = i.marital_status) as marital_status, i.passport_number, i.nrc_number, " +
                        "    (SELECT lvfvd.value FROM listvalue_field_value_detail lvfvd WHERE lvfvd.id = cast(i.member_religion as int)) as religion, i.last_name, i.middle_name, i.first_name, i.family_planning_method, " +
                        "    i.haemoglobin, i.weight, i.edd, i.last_method_of_contraception, i.blood_group, i.id, i.immunisation_given " +
                        "FROM imt_member i " +
                        "INNER JOIN um_user u ON i.created_by = u.id " +
                        "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                        "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                        "WHERE h.id = :facilityCode " +
                        "AND i.created_on >= :registrationStartDate AND i.created_on < :registrationEndDate "

        );

        if (cbvId != null) {
            queryBuilder.append("AND i.created_by = :cbvId ");
        }

        if (householdId != null) {
            queryBuilder.append("AND i.family_id = :householdId ");
        }

        if (zoneId != null) {
            queryBuilder.append("AND h.location_id = :zoneId ");
        }


        queryBuilder.append("ORDER BY i.created_on DESC LIMIT 1000");

        Session session = sessionFactory.openSession();
        NativeQuery<Object[]> nativeQuery = session.createNativeQuery(queryBuilder.toString())
                .setParameter("facilityCode", facilityCode)
                .setParameter("registrationStartDate", registrationStartDate)
                .setParameter("registrationEndDate", registrationEndDate);

        if (cbvId != null) {
            nativeQuery.setParameter("cbvId", cbvId);
        }

        if (householdId != null) {
            nativeQuery.setParameter("householdId", householdId);
        }

        if (zoneId != null) {
            nativeQuery.setParameter("zoneId", zoneId);
        }

        List<Object[]> resultList = nativeQuery.getResultList();
        List<ClientMemberDto> members = new ArrayList<>();

        for (Object[] row : resultList) {
            members.add(ClientMemberMapper.getMemberDto(row));
        }

        return members;
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> getMembers(List<String> states, List<Integer> locationIds, List<String> projectionList, List<String> familyIdsForQuery, Date lastUpdatedDate, List<String> basicStates) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (locationIds != null && !locationIds.isEmpty()) {
                Subquery<FamilyEntity> subquery = query.subquery(FamilyEntity.class);
                Root<FamilyEntity> from = subquery.from(FamilyEntity.class);

                subquery.select(from.get(FAMILY_ID_PROPERTY));
                subquery.where(
                        builder.or(
                                from.get(FamilyEntity.Fields.LOCATION_ID).in(locationIds),
                                from.get(FamilyEntity.Fields.AREA_ID).in(locationIds)
                        )
                );

                predicates.add(root.get(FAMILY_ID_PROPERTY).in(subquery));
            }

            if (states != null && !states.isEmpty()) {
                predicates.add(builder.in(root.get(STATE_PROPERTY)).value(states));
            }

            if (!CollectionUtils.isEmpty(familyIdsForQuery)) {
                predicates.add(builder.in(root.get(FAMILY_ID_PROPERTY)).value(familyIdsForQuery));
            }

            if (lastUpdatedDate != null) {
                predicates.add(builder.greaterThanOrEqualTo(root.get(MODIFIED_ON_PROPERTY), lastUpdatedDate));
            }

            return predicates;
        };
        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> getMembersForAsha(List<String> states, List<Integer> areaIds, List<String> projectionList, List<String> familyIdsForQuery, Date lastUpdatedDate) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (areaIds != null && !areaIds.isEmpty()) {
                String q = "select family_id as \"id\" from imt_family where area_id in :areaIds";
                NativeQuery<String> nativeQuery = getCurrentSession().createNativeQuery(q);
                nativeQuery.setParameter("areaIds", areaIds)
                        .addScalar("id", StandardBasicTypes.STRING);
                List<String> familyIds = nativeQuery.getResultList();
                predicates.add(builder.in(root.get(FAMILY_ID_PROPERTY)).value(familyIds));
            }
            if (states != null && !states.isEmpty()) {
                predicates.add(builder.in(root.get(STATE_PROPERTY)).value(states));
            }

            if (!CollectionUtils.isEmpty(familyIdsForQuery)) {
                predicates.add(builder.in(root.get(FAMILY_ID_PROPERTY)).value(familyIdsForQuery));
            }

            if (lastUpdatedDate != null) {
                predicates.add(builder.greaterThanOrEqualTo(root.get(MODIFIED_ON_PROPERTY), lastUpdatedDate));
            }
            return predicates;
        };
        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retrieveMemberEntitiesByFamilyId(String familyId) {
        if (familyId == null) {
            return new ArrayList<>();
        }
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(FAMILY_ID_PROPERTY), familyId));
            return predicates;
        };
        return new ArrayList<>(super.findByCriteriaList(predicateBuilder));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Integer> retrieveMemberIdsByFamilyId(String familyId) {
        String query = "select id from imt_member where family_id = :familyId " +
                "and (basic_state in ('NEW','VERIFIED','REVERIFICATION') or state = 'IDSP_TEMP')";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<Integer> q = session.createNativeQuery(query);
        q.setParameter(FAMILY_ID_PROPERTY, familyId);
        q.addScalar(ID_PROPERTY, StandardBasicTypes.INTEGER);
        return q.list();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> searchMembers(String searchString) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.like(
                    builder.lower(root.get(UNIQUE_HEALTH_ID_PROPERTY)),
                    builder.lower(builder.literal(searchString))
            ));
            return predicates;
        };
        return new ArrayList<>(super.findByCriteriaList(predicateBuilder));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberEntity createMember(MemberEntity memberEntity) {
        super.create(memberEntity);
        return memberEntity;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberEntity getMemberByUniqueHealthIdAndFamilyId(String uniqueHealthId, String familyId) {
        if (!(uniqueHealthId != null && !uniqueHealthId.isEmpty()) && !(familyId != null && !familyId.isEmpty())) {
            return null;
        }
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (uniqueHealthId != null && !uniqueHealthId.isEmpty()) {
                predicates.add(builder.equal(root.get(UNIQUE_HEALTH_ID_PROPERTY), uniqueHealthId));
            }
            if (familyId != null && !familyId.isEmpty()) {
                predicates.add(builder.equal(root.get(FAMILY_ID_PROPERTY), familyId));
            }
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void deleteDiseaseRelationsOfMember(Integer memberId) {
        String query = "DELETE FROM imt_member_chronic_disease_rel  where member_id = :memberId ; "
                + " DELETE FROM imt_member_current_disease_rel  where member_id = :memberId ; "
                + " DELETE FROM imt_member_eye_issue_rel  where member_id = :memberId ; "
                + " DELETE FROM imt_member_congenital_anomaly_rel where member_id = :memberId ; ";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<Integer> q = session.createNativeQuery(query);
        q.setParameter(MEMBER_ID_PROPERTY, memberId);
        q.executeUpdate();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void insertDiseaseRelationsOfMember(Integer memberId, Set<Integer> diseaseIds, String diseaseType) {
        String tableName = "";
        StringBuilder queryString = new StringBuilder();
        switch (diseaseType) {
            case "CHRONIC":
                tableName = "insert into imt_member_chronic_disease_rel values ";
                break;
            case "CONGENITAL":
                tableName = "insert into imt_member_congenital_anomaly_rel values ";
                break;
            case "CURRENT":
                tableName = "insert into imt_member_current_disease_rel values ";
                break;
            case "EYE":
                tableName = "insert into imt_member_eye_issue_rel values ";
                break;
            default:
        }

        for (Integer diseaseId : diseaseIds) {
            queryString.append(String.format("%s (%d,%d);%n", tableName, memberId, diseaseId));
        }

        Session session = sessionFactory.getCurrentSession();
        NativeQuery<Integer> q = session.createNativeQuery(queryString.toString());
        q.executeUpdate();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getFamilyIdByMemberUniqueHealthId(String uniqueHealthId) {
        String query = "select family_id as \"familyId\" from imt_member where unique_health_id like :uniqueHealthId ;";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<MemberEntity> q = session.createNativeQuery(query);
        q.setParameter(UNIQUE_HEALTH_ID_PROPERTY, uniqueHealthId);
        List<MemberEntity> memberEntities = q.setResultTransformer(Transformers.aliasToBean(MemberEntity.class)).list();
        if (!CollectionUtils.isEmpty(memberEntities)) {
            return memberEntities.get(0).getFamilyId();
        } else {
            return null;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<String> getFamilyIdsByMemberUniqueHealthIds(List<String> uniqueHealthId) {
        List<String> familyids = new ArrayList<>();
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (!CollectionUtils.isEmpty(uniqueHealthId)) {
                predicates.add(builder.in(root.get(UNIQUE_HEALTH_ID_PROPERTY)).value(uniqueHealthId));
            }
            return predicates;
        };
        List<MemberEntity> memberEntities = findByCriteriaList(predicateBuilder);
        if (!CollectionUtils.isEmpty(memberEntities)) {
            for (MemberEntity member : memberEntities) {
                familyids.add(member.getFamilyId());
            }
            return familyids;
        } else {
            return Collections.emptyList();
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> getChildMembersByMotherId(Integer motherId, Boolean noDeadMember) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (noDeadMember != null && noDeadMember) {
                predicates.add(builder.notEqual(root.get(MemberEntity.Fields.STATE), FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_DEAD));
            }
            predicates.add(builder.equal(root.get(MemberEntity.Fields.MOTHER_ID), motherId));
            return predicates;
        };
        return new ArrayList<>(super.findByCriteriaList(predicateBuilder));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberDto retrieveDetailsByMemberId(Integer memberId) {
        final String query = """
                with wpd_details as (
                		select
                        pregnancy_reg_det_id,
                        string_agg(lfvd.value, ',') as motherComplication,
                        rch_wpd_mother_master.pregnancy_outcome as deliveryOutcome,
                        rch_wpd_mother_master.delivery_place as deliveryPlace,
                        rch_wpd_mother_master.type_of_delivery as deliveryType
                    from rch_wpd_mother_master
                    left join rch_wpd_mother_danger_signs_rel on rch_wpd_mother_danger_signs_rel.wpd_id = rch_wpd_mother_master.id
                    left join listvalue_field_value_detail lfvd on rch_wpd_mother_danger_signs_rel.mother_danger_signs=lfvd.id
                    where rch_wpd_mother_master.has_delivery_happened
                    and rch_wpd_mother_master.member_id = :memberId
                    group by 1,3,4,5
                	)
                select
                    imt_member.id as id,
                	imt_member.unique_health_id as uniqueHealthId,
                	imt_member.health_id as healthId,
                	imt_member.health_id_number as healthIdNumber,
                	imt_member.dob as dob,
                	imt_member.family_id as familyId,
                	imt_member.first_name as firstName,
                	imt_member.middle_name as middleName,
                	imt_member.last_name as lastName,
                	imt_member.gender as gender,
                	imt_member.mobile_number as mobileNumber,
                	imt_member.account_number as accountNumber,
                	imt_member.ifsc as ifsc,
                	imt_member.cur_preg_reg_det_id as curPregRegDetId,
                	imt_member.cur_preg_reg_date as curPregRegDate,
                	imt_member.early_registration as isEarlyRegistration,
                	imt_member.is_high_risk_case as isHighRiskCase,
                	imt_member.blood_group as bloodGroup,
                	imt_member.weight as weight,
                	imt_member.haemoglobin as haemoglobin,
                	imt_member.is_pregnant as isPregnantFlag,
                	imt_member.current_gravida as currentGravida,
                	imt_member.family_planning_method as familyPlanningMethod,
                	imt_member.last_method_of_contraception as lastMethodOfContraception,
                	imt_member.immunisation_given as immunisationGiven,
                	imt_member.mother_id as motherId,
                	cast(imt_member.last_delivery_date as date) as lastDeliveryDate,
                	imt_member.additional_info as additionalInfo,
                	rch_pregnancy_registration_det.state as wpdState,
                	rch_pregnancy_registration_det.edd as edd,
                	rch_pregnancy_registration_det.lmp_date as lmpDate,
                	get_location_hierarchy(rch_pregnancy_registration_det.current_location_id) as locationHierarchy,
                	concat(imt_family.address1,' ', imt_family.address2) as address ,
                	imt_family.area_id as areaId,
                	imt_family.location_id as locationId,
                	imt_family.id as fid,
                	wpd_details.motherComplication as motherComplication,
                	wpd_details.deliveryOutcome as deliveryOutcome,
                	wpd_details.deliveryPlace as deliveryPlace,
                	wpd_details.deliveryType as deliveryType,
                	listvalue_field_value_detail.value as caste,
                	hof.mobile_number as hofMobileNumber\s
                	from imt_member
                	left join rch_pregnancy_registration_det on imt_member.cur_preg_reg_det_id = rch_pregnancy_registration_det.id
                	and rch_pregnancy_registration_det.member_id = imt_member.id
                	inner join imt_family on imt_member.family_id = imt_family.family_id
                	left join wpd_details on imt_member.cur_preg_reg_det_id=wpd_details.pregnancy_reg_det_id
                	left join imt_member hof on imt_family.hof_id = hof.id
                	left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as text)
                where imt_member.basic_state in ('NEW','VERIFIED','REVERIFICATION','TEMPORARY')
                and imt_member.id = :memberId
                """;
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<MemberDto> q = session.createNativeQuery(query);
        return q
                .setParameter(MEMBER_ID_PROPERTY, memberId)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("fid", StandardBasicTypes.INTEGER)
                .addScalar("additionalInfo", StandardBasicTypes.STRING)
                .addScalar("lastDeliveryDate", StandardBasicTypes.DATE)
                .addScalar(FAMILY_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar(LOCATION_ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar(AREA_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("firstName", StandardBasicTypes.STRING)
                .addScalar("middleName", StandardBasicTypes.STRING)
                .addScalar("lastName", StandardBasicTypes.STRING)
                .addScalar(MOTHER_ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar(UNIQUE_HEALTH_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("healthId", StandardBasicTypes.STRING)
                .addScalar("healthIdNumber", StandardBasicTypes.STRING)
                .addScalar("dob", StandardBasicTypes.DATE)
                .addScalar("immunisationGiven", StandardBasicTypes.STRING)
                .addScalar("wpdState", StandardBasicTypes.STRING)
                .addScalar("edd", StandardBasicTypes.DATE)
                .addScalar("lmpDate", StandardBasicTypes.DATE)
                .addScalar(MOBILE_NUMBER_PROPERTY, StandardBasicTypes.STRING)
                .addScalar(ACCOUNT_NUMBER_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("ifsc", StandardBasicTypes.STRING)
//                .addScalar("bplFlag", StandardBasicTypes.BOOLEAN)
                .addScalar("caste", StandardBasicTypes.STRING)
                .addScalar(LOCATION_HIERARCHY_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("isPregnantFlag", StandardBasicTypes.BOOLEAN)
                .addScalar("gender", StandardBasicTypes.STRING)
                .addScalar("currentGravida", StandardBasicTypes.SHORT)
                .addScalar("familyPlanningMethod", StandardBasicTypes.STRING)
                .addScalar("lastMethodOfContraception", StandardBasicTypes.STRING)
                .addScalar("hofMobileNumber", StandardBasicTypes.STRING)
                .addScalar("curPregRegDetId", StandardBasicTypes.INTEGER)
                .addScalar("curPregRegDate", StandardBasicTypes.DATE)
                .addScalar("isEarlyRegistration", StandardBasicTypes.BOOLEAN)
                .addScalar("isHighRiskCase", StandardBasicTypes.BOOLEAN)
                .addScalar("bloodGroup", StandardBasicTypes.STRING)
                .addScalar("haemoglobin", StandardBasicTypes.FLOAT)
                .addScalar("weight", StandardBasicTypes.FLOAT)
                .addScalar("deliveryOutcome", StandardBasicTypes.STRING)
                .addScalar("deliveryPlace", StandardBasicTypes.STRING)
                .addScalar("deliveryType", StandardBasicTypes.STRING)
                .addScalar("motherComplication", StandardBasicTypes.STRING)
                .addScalar("address", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(MemberDto.class)).uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retrieveChildDetails(Integer id) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(MOTHER_ID_PROPERTY), id));
            query.orderBy(builder.desc(root.get("dob")));
            return predicates;
        };
        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean checkIfMemberAlreadyMarkedDead(Integer memberId) {
        String query = "select count(*) from rch_member_death_deatil where member_id = :memberId";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<BigInteger> q = session.createNativeQuery(query);
        q.setParameter(MEMBER_ID_PROPERTY, memberId);
        BigInteger uniqueResult = q.uniqueResult();
        return uniqueResult != null && uniqueResult.intValue() != 0;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<String> retrieveAshaPhoneNumberByMemberId(Integer memberId) {
        String query = "select contact_number from um_user \n"
                + "inner join um_role_master on\n"
                + "um_user.role_id = um_role_master.id\n"
                + "where um_user.id in\n"
                + "(select user_id from um_user_location where loc_id in\n"
                + "(select area_id from imt_family where family_id in\n"
                + "(select family_id from imt_member where id=" + memberId + ")))\n"
                + "and um_role_master.code='ASHA'";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<String> sQLQuery = session.createNativeQuery(query);
        return sQLQuery.list();
    }

    @Override
    public List<String> retrieveMembersOnStatus(Integer memberId) {
        String query = "select distinct status from ncd_member_diseases_diagnosis where member_id ="+memberId;
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<String> sQLQuery = session.createNativeQuery(query);
        return sQLQuery.list();
    }

    @Override
    public List<String> retrieveMembersSC(Integer locId) {
        String query = "select name from location_master lm\n" +
                "    left join location_hierchy_closer_det lhcd on lhcd.parent_id=lm.id\n" +
                "    where child_id="+locId+" and parent_loc_type='SC'";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<String> sQLQuery = session.createNativeQuery(query);
        return sQLQuery.list();
    }
    ;
    /**
     * {@inheritDoc}
     */
    @Override
    public MemberInformationDto getMemberInfoByUniqueHealthId(String memberUniqueHealthId) {
        String query = "select m.id as \"memberId\", m.first_name || ' ' || m.middle_name || ' ' || m.last_name  as \"memberName\", \n"
                + "to_char(m.created_on, 'dd/mm/yyyy') as \"createdOn\",to_char(m.modified_on, 'dd/mm/yyyy') as \"modifiedOn\",m.modified_by as \"modifiedBy\","
                + "m.family_id as \"familyId\", to_char(m.dob, 'dd/mm/yyyy') as \"dob\", \n"
                + "case when m.aadhar_number_encrypted is not null then 'Yes' else 'No' end as \"aadharAvailable\",\n"
                + "m.mobile_number as \"mobileNumber\", m.is_pregnant as \"isPregnantFlag\", m.gender, \n"
                + "m.state as \"memberState\", m.ifsc, m.account_number as \"accountNumber\", \n"
                + "m.family_head as \"familyHeadFlag\", m.immunisation_given as \"immunisationGiven\",\n"
                + "case when (m.dob > now() - interval '5 years') then 'Yes' else 'No' end as \"isChild\",\n"
                + "case when (m.dob < now() - interval '18 years' and m.dob > now() - interval '45 years')  then 'Yes' else 'No' end as \"isEligibleCouple\","
                + "(select string_agg(to_char(created_on, 'dd/mm/yyyy'),',' order by created_on desc) \n"
                + "from rch_child_service_master  where member_id  = m.id group by member_id) as \"childServiceVisitDatesList\",\n"
                + "m.weight as weight, m.haemoglobin,\n"
                + "usr.first_name || ' ' || usr.middle_name || ' ' || usr.last_name  as \"fhwName\",\n"
                + "ashaName.first_name || ' ' || ashaName.middle_name || ' ' || ashaName.last_name  as \"ashaName\","
                + "usr.user_name as \"fhwUserName\", usr.contact_number as \"fhwMobileNumber\",\n"
                + "(select first_name || ' ' || middle_name || ' ' || last_name from imt_member where id = m.mother_id) as \"motherName\" ,\n"
                + "(select string_agg(to_char(created_on, 'dd/mm/yyyy'),',' order by created_on desc) \n"
                + "from rch_anc_master where member_id  = m.id group by member_id) as \"ancVisitDatesList\",\n"
                + "f.state as \"familyState\",\n"
                + "string_agg(lm.name,'> ' order by lhcd.depth desc) as \"memberLocation\"\n"
                + "from imt_member m \n"
                + "inner join imt_family f on f.family_id = m.family_id\n"
                + "left join um_user_location ul on f.location_id = ul.loc_id  and ul.state = 'ACTIVE'\n"
                + "left join um_user usr on ul.user_id = usr.id and usr.role_id = 30 and usr.state = 'ACTIVE'\n"
                + "left join um_user_location ashaLoc on f.area_id = ashaLoc.loc_id  and ashaLoc.state = 'ACTIVE'\n"
                + "left join um_user ashaName on ashaLoc.user_id = ashaname.id and ashaName.role_id = 24 and ashaName.state = 'ACTIVE'"
                + "left join location_hierchy_closer_det lhcd on (case when f.area_id is null then f.location_id else cast(f.area_id as bigint) end) = lhcd.child_id\n"
                + "left join location_master lm on lm.id = lhcd.parent_id\n"
                + "left join location_type_master loc_name on lm.type = loc_name.type\n"
                + "where unique_health_id = :uniqueHealthId\n"
                + "group by m.id,usr.first_name,usr.middle_name,usr.last_name,usr.user_name,usr.contact_number,f.state,ashaName.first_name,ashaName.middle_name,ashaName.last_name";

        NativeQuery<MemberInformationDto> q = getCurrentSession().createNativeQuery(query)
                .addScalar(MEMBER_ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar("memberName", StandardBasicTypes.STRING)
                .addScalar(FAMILY_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("dob", StandardBasicTypes.STRING)
                .addScalar("aadharAvailable", StandardBasicTypes.STRING)
                .addScalar(MOBILE_NUMBER_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("isPregnantFlag", StandardBasicTypes.BOOLEAN)
                .addScalar("isChild", StandardBasicTypes.STRING)
                .addScalar("gender", StandardBasicTypes.STRING)
                .addScalar("familyHeadFlag", StandardBasicTypes.BOOLEAN)
                .addScalar("memberState", StandardBasicTypes.STRING)
                .addScalar("ifsc", StandardBasicTypes.STRING)
                .addScalar(ACCOUNT_NUMBER_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("motherName", StandardBasicTypes.STRING)
                .addScalar("haemoglobin", StandardBasicTypes.FLOAT)
                .addScalar("weight", StandardBasicTypes.FLOAT)
                .addScalar("childServiceVisitDatesList", StandardBasicTypes.STRING)
                .addScalar("ancVisitDatesList", StandardBasicTypes.STRING)
                .addScalar("immunisationGiven", StandardBasicTypes.STRING)
                .addScalar("familyState", StandardBasicTypes.STRING)
                .addScalar("fhwName", StandardBasicTypes.STRING)
                .addScalar("fhwMobileNumber", StandardBasicTypes.STRING)
                .addScalar("fhwUserName", StandardBasicTypes.STRING)
                .addScalar("memberLocation", StandardBasicTypes.STRING)
                .addScalar("isEligibleCouple", StandardBasicTypes.STRING)
                .addScalar("ashaName", StandardBasicTypes.STRING)
                .addScalar("createdOn", StandardBasicTypes.STRING)
                .addScalar(MODIFIED_ON_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("modifiedBy", StandardBasicTypes.INTEGER);

        q.setParameter(UNIQUE_HEALTH_ID_PROPERTY, memberUniqueHealthId);
        List<MemberInformationDto> memberInformationDto
                = q.setResultTransformer(Transformers.aliasToBean(MemberInformationDto.class)).list();

        if (memberInformationDto.isEmpty()) {
            return null;
        }

        return memberInformationDto.get(0);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<PregnancyRegistrationDetailDto> getPregnancyRegistrationDetailByMemberId(Integer memberId) {
        String query = "select mthr_reg_no as \"motherRegNo\", to_char(lmp_date, 'dd/mm/yyyy') as \"lmpDate\", \n"
                + "to_char(edd, 'dd/mm/yyyy') as \"expectedDeliveryDate\",to_char(reg_date, 'dd/mm/yyyy') as \"registrationDate\",\n"
                + "state as \"pregnancyState\" from rch_pregnancy_registration_det where member_id = :memberId";

        NativeQuery<PregnancyRegistrationDetailDto> q = getCurrentSession().createNativeQuery(query)
                .addScalar("motherRegNo", StandardBasicTypes.STRING)
                .addScalar("lmpDate", StandardBasicTypes.STRING)
                .addScalar("expectedDeliveryDate", StandardBasicTypes.STRING)
                .addScalar("registrationDate", StandardBasicTypes.STRING)
                .addScalar("pregnancyState", StandardBasicTypes.STRING);

        q.setParameter(MEMBER_ID_PROPERTY, memberId);
        List<PregnancyRegistrationDetailDto> pregnancyRegistrationDetailDtos
                = q.setResultTransformer(Transformers.aliasToBean(PregnancyRegistrationDetailDto.class)).list();

        if (pregnancyRegistrationDetailDtos.isEmpty()) {
            return Collections.emptyList();
        }
        return pregnancyRegistrationDetailDtos;
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retrieveMemberForMigration(Boolean byAadhar, String aadhar, Boolean byHealthId, String healthId) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (Boolean.TRUE.equals(byHealthId)) {
                predicates.add(builder.equal(root.get(MemberEntity.Fields.UNIQUE_HEALTH_ID), healthId.toUpperCase()));
            }
            return predicates;
        };
        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retrieveChildUnder5ByMotherId(Integer motherId) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            query.orderBy(builder.desc(root.get(MemberEntity.Fields.DOB)));

            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.YEAR, -5);
            Calendar truncate = DateUtils.truncate(calendar, Calendar.DATE);

            predicates.add(builder.equal(root.get(MemberEntity.Fields.MOTHER_ID), motherId));
            predicates.add(builder.lessThanOrEqualTo(root.get(MemberEntity.Fields.DOB), truncate.getTime()));

            return predicates;
        };
        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberDto> searchMembers(String searchString, String searchBy, Integer limit, Integer offset) {
        if (searchString != null) {
            searchString = searchString.replace("'", "''");
        }
        String query = "";
        switch (searchBy) {
            case MEMBER_ID_PROPERTY:
                query += "with  members as(\n"
                        + "select m.id , m.first_name  ,m.last_name  ,\n"
                        + "m.family_id, \n"
                        + "m.mobile_number ,  \n"
                        + " m.account_number, \n"
                        + " f.location_id , \n"
                        + " m.middle_name , \n"
                        + " f.area_id  \n"
                        + "\n"
                        + "from imt_member m \n"
                        + "inner join imt_family f on f.family_id = m.family_id\n"
                        + "where unique_health_id ='" + searchString + "' \n"
                        + "limit :limit "
                        + "offset :offset\n"
                        + ")";

                break;
            case FAMILY_ID_PROPERTY:
                query += "with  members as(\n"
                        + "select m.id , m.first_name  ,m.last_name  ,\n"
                        + "m.family_id, \n"
                        + "m.mobile_number ,  \n"
                        + " m.account_number, \n"
                        + " f.location_id , \n"
                        + " m.middle_name , \n"
                        + " f.area_id  \n"
                        + "\n"
                        + "from imt_member m \n"
                        + "inner join imt_family f on f.family_id = m.family_id\n"
                        + "where m.family_id ='" + searchString + "' \n"
                        + "limit :limit offset :offset\n"
                        + ")";

                break;
            case FAMILY_MOBILE_NUMBER_PROPERTY:

                query += "with  members as(\n"
                        + "select m.id , m.first_name  ,m.last_name  ,\n"
                        + "m.family_id, \n"
                        + "m.mobile_number ,  \n"
                        + " m.account_number, \n"
                        + " f.location_id , \n"
                        + " m.middle_name , \n"
                        + " f.area_id  \n"
                        + "\n"
                        + "from imt_member m \n"
                        + "inner join imt_family f on f.family_id = m.family_id\n"
                        + "where f.family_id in (select family_id from imt_member where mobile_number='" + searchString + "')"
                        + "limit :limit offset :offset\n"
                        + ")";

                break;

            case MOBILE_NUMBER_PROPERTY:
                query += "with  members as(\n"
                        + "select m.id , m.first_name  ,m.last_name  ,\n"
                        + "m.family_id, \n"
                        + "m.mobile_number ,  \n"
                        + " m.account_number, \n"
                        + " f.location_id , \n"
                        + " m.middle_name , \n"
                        + " f.area_id  \n"
                        + "\n"
                        + "from imt_member m \n"
                        + "inner join imt_family f on f.family_id = m.family_id\n"
                        + "\n"
                        + "where m.mobile_number ='" + searchString + "' \n"
                        + "limit :limit offset :offset\n"
                        + ")"
                        + "";

                break;
            case ORG_UNIT_PROPERTY:
                query = "with  members as(\n"
                        + "select m.id , m.first_name  ,m.last_name  ,\n"
                        + "m.family_id, \n"
                        + "m.mobile_number ,  \n"
                        + " m.account_number, \n"
                        + " f.location_id , \n"
                        + " m.middle_name , \n"
                        + " f.area_id  \n"
                        + "\n"
                        + "from imt_member m \n"
                        + "inner join imt_family f on f.family_id = m.family_id\n"
                        + "\n"
                        + "where f.location_id in ( select child_id from location_hierchy_closer_det   where parent_id = " + searchString + ")\n"
                        + "limit :limit offset :offset\n"
                        + ")";
                break;
            default:

        }
        query += " select m.id as \"id\", m.first_name as firstName ,m.last_name  as \"lastName\", \n"
                + "m.family_id as \"familyId\", \n"
                + "m.mobile_number as \"mobileNumber\",  \n"
                + " m.account_number as \"accountNumber\", \n"
                + " f.location_id as \"locationId\", \n"
                + " m.middle_name as \"middleName\", \n"
                + " cast(f.area_id as text) as \"areaId\", \n"
                + "string_agg(lm.name,'> ' order by lhcd.depth desc) as \"locationHierarchy\"\n"
                + "from members m \n"
                + "inner join imt_family f on f.family_id = m.family_id\n"
                + "left join location_hierchy_closer_det lhcd on (case when f.area_id is null then f.location_id else cast(f.area_id as bigint) end) = lhcd.child_id\n"
                + "left join location_master lm on lm.id = lhcd.parent_id\n"
                + "left join location_type_master loc_name on lm.type = loc_name.type\n"
                + " group by m.id, f.location_id,f.area_id ,m.first_name,m.last_name,m.family_id,m.mobile_number,m.account_number ,m.middle_name ";
        Session currentSession = sessionFactory.getCurrentSession();
        NativeQuery<MemberDto> nativeQuery = currentSession.createNativeQuery(query);
        return nativeQuery
                .addScalar(ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar(LOCATION_ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar("firstName", StandardBasicTypes.STRING)
                .addScalar("middleName", StandardBasicTypes.STRING)
                .addScalar("lastName", StandardBasicTypes.STRING)
                .addScalar(AREA_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar(MOBILE_NUMBER_PROPERTY, StandardBasicTypes.STRING)
                .addScalar(ACCOUNT_NUMBER_PROPERTY, StandardBasicTypes.STRING)
                .addScalar(FAMILY_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar(LOCATION_HIERARCHY_PROPERTY, StandardBasicTypes.STRING)
                .setParameter(LIMIT, limit)
                .setParameter(OFFSET, offset)
                .setResultTransformer(Transformers.aliasToBean(MemberDto.class))
                .list();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void updateMotherIdInChildren(Integer motherId, List<Integer> childIds) {
        String query = "update imt_member set mother_id = :motherId, modified_on = now() where id in (:childIds)";

        NativeQuery<Integer> q = getCurrentSession().createNativeQuery(query);
        q.setParameter(MOTHER_ID_PROPERTY, motherId);
        q.setParameterList("childIds", childIds);
        q.executeUpdate();
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retrieveMembersByFamilyList(List<String> familyIds) {
        if (familyIds == null || familyIds.isEmpty()) {
            return new ArrayList<>();
        }

        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get(MemberEntity.Fields.FAMILY_ID).in(familyIds));
            return predicates;
        };
        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retrieveMembersByPhoneNumber(String phoneNumber, String familyId) {
        if (phoneNumber == null || phoneNumber.isEmpty()) {
            return Collections.emptyList();
        }

        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(MemberEntity.Fields.MOBILE_NUMBER), phoneNumber));
            predicates.add(root.get(MemberEntity.Fields.BASIC_STATE).in(FamilyHealthSurveyServiceConstants.VALID_MEMBERS_BASIC_STATES));
            if (familyId != null) {
                predicates.add(builder.equal(root.get(MemberEntity.Fields.FAMILY_ID), familyId));
            }
            return predicates;
        };

        return findByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Boolean checkIfDOBIsUnique(String familyId, String mobileNumber) {
        String query = "select CASE WHEN count(distinct dob)= count(dob)\n"
                + "THEN true ELSE false END \n"
                + " FROM imt_member  where family_id=:familyId and mobile_number =:mobileNumber and basic_state in ('VERIFIED','NEW')";
        return (Boolean) getCurrentSession().createNativeQuery(query)
                .setParameter(FAMILY_ID_PROPERTY, familyId)
                .setParameter(MOBILE_NUMBER_PROPERTY, mobileNumber)
                .uniqueResult();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> verifyMemberDetailByFamilyId(String familyId, Long dob, String aadharNumber) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (dob != null) {
                predicates.add(builder.equal(root.get(MemberEntity.Fields.DOB), new Date(dob)));
            }
            predicates.add(builder.equal(root.get(MemberEntity.Fields.FAMILY_ID), familyId));
            predicates.add(builder.in(root.get(MemberEntity.Fields.BASIC_STATE)).value(FamilyHealthSurveyServiceConstants.VALID_MEMBERS_BASIC_STATES));
            return predicates;
        };
        List<MemberEntity> memberEntities = super.findByCriteriaList(predicateBuilder);
        if (CollectionUtils.isEmpty(memberEntities)) {
            return Collections.emptyList();
        }
        return memberEntities;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void deleteMobileNumberInFamilyExceptVerifiedFamily(String verifiedFamilyId, String mobileNumber) {
        String query = "update imt_member set mobile_number = null where mobile_number =:mobileNumber and family_id <> :familyId";

        NativeQuery<Integer> q = getCurrentSession().createNativeQuery(query);
        q.setParameter(FAMILY_ID_PROPERTY, verifiedFamilyId);
        q.setParameter(MOBILE_NUMBER_PROPERTY, mobileNumber);

        q.executeUpdate();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public MemberEntity getFamilyHeadMemberDetail(String familyId) {
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(MemberEntity.Fields.FAMILY_HEAD_FLAG), true));
            predicates.add(builder.equal(root.get(MemberEntity.Fields.FAMILY_ID), familyId));
            predicates.add(builder.in(root.get(MemberEntity.Fields.BASIC_STATE)).value(FamilyHealthSurveyServiceConstants.VALID_MEMBERS_BASIC_STATES));
            return predicates;
        };
        return super.findEntityByCriteriaList(predicateBuilder);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ElasticSearchMemberDto> retrieveMembersByIds(List<Integer> ids) {
        String query = "SELECT id,unique_health_id as \"uniquehealthid\","
                + "first_name as \"firstname\" ,last_name as \"lastname\" ,"
                + "middle_name as \"middlename\"  from imt_member where id in ( :ids ) ";

        NativeQuery<ElasticSearchMemberDto> sQLQuery = getCurrentSession().createNativeQuery(query);
        List<ElasticSearchMemberDto> elasticSearchMemberDtos = sQLQuery
                .addScalar(ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar(UNIQUE_HEALTH_ID_PROPERTY, StandardBasicTypes.STRING)
                .addScalar("firstname", StandardBasicTypes.STRING)
                .addScalar("lastname", StandardBasicTypes.STRING)
                .addScalar("middlename", StandardBasicTypes.STRING)
                .setParameterList("ids", ids)
                .setResultTransformer(Transformers.aliasToBean(ElasticSearchMemberDto.class)).list();

        if (CollectionUtils.isEmpty(elasticSearchMemberDtos)) {
            return Collections.emptyList();
        }
        return elasticSearchMemberDtos;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ElasticSearchMemberDto> retrieveMembersByQuery(String quries) {
        String query = "SELECT id,unique_health_id as \"uniquehealthid\","
                + "first_name as \"firstname\" ,last_name as \"lastname\" ,"
                + "middle_name as \"middlename\"  from imt_member where first_name ilike '%" + quries + "%' limit 10;";

        NativeQuery<ElasticSearchMemberDto> sQLQuery = getCurrentSession().createNativeQuery(query);
        List<ElasticSearchMemberDto> elasticSearchMemberDtos = sQLQuery
                .addScalar(ID_PROPERTY, StandardBasicTypes.INTEGER)
                .addScalar("uniquehealthid", StandardBasicTypes.STRING)
                .addScalar("firstname", StandardBasicTypes.STRING)
                .addScalar("lastname", StandardBasicTypes.STRING)
                .addScalar("middlename", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(ElasticSearchMemberDto.class)).list();

        if (CollectionUtils.isEmpty(elasticSearchMemberDtos)) {
            return Collections.emptyList();
        }
        return elasticSearchMemberDtos;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> getEqualDobMembers(String familyId, String dob) {
        try {
            Date date1 = new SimpleDateFormat("yyyy-MM-dd").parse(dob);
            PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
                List<Predicate> predicates = new ArrayList<>();
                if (dob != null) {
                    predicates.add(builder.equal(root.get(MemberEntity.Fields.DOB), new Date(date1.getTime())));
                }
                predicates.add(builder.equal(root.get(MemberEntity.Fields.FAMILY_ID), familyId));
                return predicates;
            };
            return new ArrayList<>(super.findByCriteriaList(predicateBuilder));
        } catch (ParseException e) {
            return Collections.emptyList();
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MemberEntity> retriveMemberByFamilyIdAndStates(String familyId, List<String> states) {
        if (familyId == null) {
            return new ArrayList<>();
        }
        PredicateBuilder<MemberEntity> predicateBuilder = (root, builder, query) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(builder.equal(root.get(FAMILY_ID_PROPERTY), familyId));
            predicates.add(builder.in(root.get(STATE_PROPERTY)).value(states));
            return predicates;
        };
        return new ArrayList<>(super.findByCriteriaList(predicateBuilder));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean checkIfDeathEntryExists(Integer memberId) {
        String query = "select count(*) from rch_member_death_deatil where member_id = :memberId";
        NativeQuery<BigInteger> sqlQuery = getCurrentSession().createNativeQuery(query);
        sqlQuery.setParameter(MEMBER_ID_PROPERTY, memberId);
        BigInteger count = sqlQuery.uniqueResult();
        return count.intValue() != 0;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer retrieveIdOfListValuesByFieldKeyAndValue(String fieldKey, String value) {
        String query = "select id from listvalue_field_value_detail where value = :value and field_key = :fieldKey ";
        NativeQuery<Integer> sqlQuery = getCurrentSession().createNativeQuery(query);
        sqlQuery.setParameter("fieldKey", fieldKey);
        sqlQuery.setParameter("value", value);
        return sqlQuery.uniqueResult();
    }


    @Override
    public String getFamilyIdByPhoneNumber(String hofMobileNumber, String mobileNumber) {
        String query = "select imt_member.family_id as \"familyId\", imt_family.state as \"familyState\" from imt_member\n" +
                "inner join imt_family on imt_member.family_id = imt_family.family_id\n" +
                "where (imt_member.mobile_number = :hofMobileNumber or imt_member.mobile_number = :mobileNumber) and imt_member.basic_state in ('VERIFIED','REVERIFICATION','NEW','TEMPORARY') ;";
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<MemberInformationDto> q = session.createNativeQuery(query);
        q.setParameter(HOF_MOBILE_NUMBER_PROPERTY, hofMobileNumber);
        q.setParameter(MOBILE_NUMBER_PROPERTY, mobileNumber);
        List<MemberInformationDto> memberInformationDtos = q.setResultTransformer(Transformers.aliasToBean(MemberInformationDto.class)).list();
        if (!CollectionUtils.isEmpty(memberInformationDtos)) {
            if (memberInformationDtos.size() > 1) {
                List<MemberInformationDto> filteredList = memberInformationDtos.stream()
                        .filter(member -> member.getFamilyState().equals("CFHC_FN"))
                        .collect(Collectors.toList());
                if (!filteredList.isEmpty()) {
                    return filteredList.get(0).getFamilyId();
                }
            }
            return memberInformationDtos.get(0).getFamilyId();
        } else {
            return null;
        }
    }

    @Override
    public boolean checkSameNrcExists(String nrcNumber) {
        String query = "select count(*) from imt_member im where nrc_number = :nrcNumber";
        NativeQuery<BigInteger> sqlQuery = getCurrentSession().createNativeQuery(query);
        sqlQuery.setParameter("nrcNumber", nrcNumber);
        BigInteger count = sqlQuery.uniqueResult();
        return count.intValue() > 1; // Return true if duplicate exists
    }

    @Override
    public boolean checkSamePassportExists(String passNumber) {
        String query = "select count(*) from imt_member im where passport_number = :passNumber";
        NativeQuery<BigInteger> sqlQuery = getCurrentSession().createNativeQuery(query);
        sqlQuery.setParameter("passNumber", passNumber);
        BigInteger count = sqlQuery.uniqueResult();
        return count.intValue() > 1; // Return true if duplicate exists
    }

    @Override
    public boolean checkSameBirthCertificateExists(String birthCertNumber) {
        String query = "select count(*) from imt_member im where birth_cert_number = :birthCertNumber";
        NativeQuery<BigInteger> sqlQuery = getCurrentSession().createNativeQuery(query);
        sqlQuery.setParameter("birthCertNumber", birthCertNumber);
        BigInteger count = sqlQuery.uniqueResult();
        return count.intValue() > 1; // Return true if duplicate exists
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ReferralDto> getReferral(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, String householdId, Integer zoneId, Integer cbvId) {
        Timestamp startDateWithTime = null;
        Timestamp endDateWithTime = null;

        if (serviceStartDate != null) {
            startDateWithTime = new Timestamp(serviceStartDate.getTime());
            startDateWithTime.setHours(0);
        }

        if (serviceEndDate != null) {
            endDateWithTime = new Timestamp(serviceEndDate.getTime());
            endDateWithTime.setHours(23);
        }

        StringBuilder queryBuilder = new StringBuilder(
                "WITH cte_member_details AS ( " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, is_referral_done, created_on, created_by, 'MALARIA' AS refer_type " +
                        "    FROM malaria_details " +
                        "    WHERE is_referral_done IS NOT NULL AND referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, is_referral_done, created_on, created_by, 'TUBERCULOSIS' AS refer_type " +
                        "    FROM tuberculosis_screening_details " +
                        "    WHERE is_referral_done IS NOT NULL AND referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, is_referral_done, created_on, created_by, 'COVID' AS refer_type " +
                        "    FROM covid_screening_details " +
                        "    WHERE is_referral_done IS NOT NULL AND referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, 'YES' AS is_referral_done, created_on, created_by, 'ANC' AS refer_type " +
                        "    FROM rch_anc_master " +
                        "    WHERE referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, 'YES' AS is_referral_done, created_on, created_by, 'CHILD SERVICE' AS refer_type " +
                        "    FROM rch_child_service_master " +
                        "    WHERE referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, child_id AS member_id, referral_place, referral_reason, referral_for, child_referral_done AS is_referral_done, created_on, created_by, 'PNC CHILD' AS refer_type " +
                        "    FROM rch_pnc_child_master " +
                        "    WHERE child_referral_done IS NOT NULL AND referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, mother_id AS member_id, referral_place, referral_reason, referral_for, 'YES' AS is_referral_done, created_on, created_by, 'PNC MOTHER' AS refer_type " +
                        "    FROM rch_pnc_mother_master " +
                        "    WHERE referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, referral_done AS is_referral_done, created_on, created_by, 'WPD MOTHER' AS refer_type " +
                        "    FROM rch_wpd_mother_master " +
                        "    WHERE referral_done IS NOT NULL AND referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, referral_reason, referral_for, referral_done AS is_referral_done, created_on, created_by, 'WPD CHILD' AS refer_type " +
                        "    FROM rch_wpd_child_master " +
                        "    WHERE referral_done IS NOT NULL AND referral_place = :facilityCode " +
                        "    UNION ALL " +
                        "    SELECT id, member_id, referral_place, 'hiv' AS referral_reason, NULL AS referral_for, 'yes' AS is_referral_done, created_on, created_by, 'HIV' AS refer_type " +
                        "    FROM rch_hiv_screening_master " +
                        "    WHERE referral_place = :facilityCode " +
                        "), max_service_date AS ( " +
                        "    SELECT member_id, refer_type, MAX(created_on) AS created_on " +
                        "    FROM cte_member_details " +
                        "    GROUP BY member_id, refer_type " +
                        ") " +
                        "SELECT m.unique_health_id, m.first_name, m.middle_name, m.last_name, m.dob, m.gender, m.mobile_number," +
                        " (SELECT lvfvd.value FROM listvalue_field_value_detail lvfvd WHERE lvfvd.id = CAST(m.marital_status AS INT)) as marital_status, " +
                        "m.nrc_number, " +
                        "    CASE " +
                        "        WHEN cmd.is_referral_done = 'YES' THEN " +
                        "            CASE " +
                        "                WHEN cmd.referral_for IS NULL OR cmd.referral_for = 'OTHER' THEN 'OTHER : ' || cmd.referral_reason " +
                        "                ELSE cmd.referral_for || ' : ' || (SELECT lvfvd.value FROM listvalue_field_value_detail lvfvd WHERE lvfvd.id = CAST(cmd.referral_for AS INT)) " +
                        "            END " +
                        "        ELSE NULL " +
                        "    END AS reason, " +
                        "    cmd.refer_type, " +
                        "    DATE(TO_CHAR(cmd.created_on, 'YYYY-MM-DD HH24:MI:SS')), cmd.referral_place, cmd.created_by, m.religion, get_location_hierarchy(f.location_id), " +
                        "h.name,  u.user_name,  ul.loc_id, lm.name as loc_name, cmd.id " +
                        "FROM imt_member m " +
                        "INNER JOIN cte_member_details cmd ON m.id = cmd.member_id " +
                        "INNER JOIN max_service_date msd ON msd.member_id = cmd.member_id AND msd.created_on = cmd.created_on AND cmd.refer_type = msd.refer_type " +
                        "INNER JOIN health_infrastructure_details h on h.id = cmd.referral_place "+
                        "INNER JOIN imt_family f ON m.family_id = f.family_id " +
                        "INNER JOIN um_user u on u.id = cmd.created_by " +
                        "INNER JOIN um_user_location ul ON ul.user_id = u.id " +
                        "INNER JOIN location_master lm ON lm.id = ul.loc_id " +
                        "WHERE cmd.referral_place = :facilityCode "
        );

        if (startDateWithTime != null && endDateWithTime != null) {
            queryBuilder.append("AND cmd.created_on BETWEEN :serviceStartDate AND :serviceEndDate ");
        }

        if (cbvId != null) {
            queryBuilder.append("AND m.created_by = :cbvId ");
        }

        if (householdId != null) {
            queryBuilder.append("AND m.family_id = :householdId ");
        }

        if (zoneId != null) {
            queryBuilder.append("AND f.location_id = :zoneId ");
        }

        queryBuilder.append("ORDER BY m.created_on DESC");

        Session session = sessionFactory.openSession();
        NativeQuery<Object[]> nativeQuery = session.createNativeQuery(queryBuilder.toString())
                .setParameter("facilityCode", facilityCode);

        if (startDateWithTime != null && endDateWithTime != null) {
            nativeQuery.setParameter("serviceStartDate", startDateWithTime);
            nativeQuery.setParameter("serviceEndDate", endDateWithTime);
        }

        if (cbvId != null) {
            nativeQuery.setParameter("cbvId", cbvId);
        }

        if (householdId != null) {
            nativeQuery.setParameter("householdId", householdId);
        }

        if (zoneId != null) {
            nativeQuery.setParameter("zoneId", zoneId);
        }

        List<Object[]> resultList = nativeQuery.getResultList();
        List<ReferralDto> referrals = new ArrayList<>();

        for (Object[] row : resultList) {
            referrals.add(ReferralMapper.getReferralDto(row));
        }

        return referrals;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<MalariaDto> getMalariaDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT m.id AS member_id, md.active_malaria_symptoms, md.rdt_test_status, md.is_treatment_being_given, md.malaria_type " +
                "FROM malaria_details md " +
                "JOIN imt_member m ON md.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON md.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND md.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND md.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode)
                .setParameter("serviceStartDate", startDateWithTime)
                .setParameter("serviceEndDate", endDateWithTime);

        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<MalariaDto> malariaData = new ArrayList<>();

        for (Object[] row : results) {
            if (row[0] != null) {
                MalariaDto malariaDto = MalariaMapper.mapFromObjectArray(row);
                malariaData.add(malariaDto);
            }
        }

        return malariaData;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<TuberculosisDto> getTuberculosisDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT " +
                "m.id AS member_id, " +
                "td.tuberculosis_symptoms, " +
                "td.is_tb_cured " +
                "FROM tuberculosis_screening_details td " +
                "JOIN imt_member m ON td.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON td.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND td.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND td.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode)
                .setParameter("serviceStartDate", startDateWithTime)
                .setParameter("serviceEndDate", endDateWithTime);

        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<TuberculosisDto> tuberculosisDetails = new ArrayList<>();

        for (Object[] row : results) {
            if (row[0] != null) {
                TuberculosisDto tuberculosisDto = TBMapper.mapFromObjectArray(row);
                tuberculosisDetails.add(tuberculosisDto);
            }
        }

        return tuberculosisDetails;
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public List<CovidDto> getCovidDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT m.id AS member_id, cd.is_dose_one_taken, cd.dose_one_name, cd.is_dose_two_taken, cd.dose_two_name, " +
                "cd.willing_for_booster_vaccine, cd.is_booster_dose_given, cd.booster_name, cd.any_reactions " +
                "FROM covid_screening_details cd " +
                "JOIN imt_member m ON cd.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON cd.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND cd.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND cd.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<CovidDto> covidData = new ArrayList<>();

        for (Object[] row : results) {
            CovidDto covidDto = CovidMapper.mapFromObjectArray(row);
            covidData.add(covidDto);
        }

        return covidData;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<HivDto> getHivDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {

        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT i.* FROM rch_hiv_screening_master i " +
                        "JOIN imt_member m ON i.member_id = m.id " +
                        "JOIN imt_family f ON m.family_id = f.family_id " +
                        "JOIN um_user u ON i.created_by = u.id " +
                        "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                        "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                        "WHERE h.id = :facilityCode " +
                        "AND i.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";


        if (cbvId != null) {
            sqlQuery += "AND cd.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<HivDto> hivData = new ArrayList<>();

        for (Object[] row : results) {
            HivDto hivDto = HivDetailsMapper.getHivDto(row);
            hivData.add(hivDto);
        }

        return hivData;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<AncDto> getAncDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT m.id AS member_id, " +
                "a.lmp, a.last_delivery_outcome, a.other_previous_pregnancy_complication, " +
                "a.anc_place, a.weight, a.haemoglobin_count, a.systolic_bp, a.diastolic_bp, " +
                "a.member_height, a.foetal_movement, a.foetal_height, a.foetal_heart_sound, a.foetal_position, " +
                "a.ifa_tablets_given, a.fa_tablets_given, a.calcium_tablets_given, a.hbsag_test, a.blood_sugar_test, " +
                "a.sugar_test_after_food_val, a.sugar_test_before_food_val, a.urine_test_done, a.urine_albumin, " +
                "a.urine_sugar, a.vdrl_test, a.sickle_cell_test, a.hiv_test, a.albendazole_given, " +
                "a.mebendazole1_given, a.mebendazole1_date, a.mebendazole2_given, a.mebendazole2_date " +
                "FROM rch_anc_master a " +
                "JOIN imt_member m ON a.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON a.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND a.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND a.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<AncDto> ancData = new ArrayList<>();

        for (Object[] row : results) {
            AncDto ancDto = AncDetailsMapper.mapFromAncVisit(row);
            ancData.add(ancDto);
        }

        return ancData;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<ChildServiceDto> getChildServiceDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT m.id AS member_id, " +
                "cd.is_alive, cd.death_reason, cd.weight, cd.ifa_syrup_given, cd.complementary_feeding_started, " +
                "cd.complementary_feeding_start_period, cd.other_diseases, cd.is_treatement_done, " +
                "cd.height, cd.have_pedal_edema, cd.exclusively_breastfeded, cd.any_vaccination_pending, " +
                "cd.sd_score, cd.delivery_place, cd.delivery_done_by, cd.delivery_person, cd.delivery_person_name " +
                "FROM rch_child_service_master cd " +
                "JOIN imt_member m ON cd.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON cd.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND cd.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND cd.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<ChildServiceDto> childServiceData = new ArrayList<>();

        for (Object[] row : results) {
            ChildServiceDto childServiceDto = ChildServiceMapper.mapFromChildServiceMaster(row);
            childServiceData.add(childServiceDto);
        }

        return childServiceData;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<PncChildDetailsDto> getPncChildDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT m.id AS child_id, " +
                "pcd.is_alive, pcd.other_danger_sign, pcd.child_weight, pcd.member_status, pcd.death_date, " +
                "pcd.death_reason, pcd.place_of_death, pcd.referral_place, pcd.other_death_reason, " +
                "pcd.is_high_risk_case, pcd.child_referral_done " +
                "FROM rch_pnc_child_master pcd " +
                "JOIN imt_member m ON pcd.child_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON pcd.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND pcd.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND pcd.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<PncChildDetailsDto> pncChildDetails = new ArrayList<>();

        for (Object[] row : results) {
            PncChildDetailsDto pncChildDetailsDto = PncChildDetailMapper.mapFromPncChildMaster(row);
            pncChildDetails.add(pncChildDetailsDto);
        }

        return pncChildDetails;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<PncMotherDetailsDto> getPncMotherDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT pm.mother_id, pm.date_of_delivery, pm.service_date, " +
                "pm.is_alive, pm.ifa_tablets_given, pm.other_danger_sign, pm.death_reason, " +
                "pm.fp_insert_operate_date, pm.family_planning_method, pm.is_high_risk_case, " +
                "pm.blood_transfusion, pm.iron_def_anemia_inj, pm.iron_def_anemia_inj_due_date, " +
                "pm.received_mebendazole, pm.tetanus4_date, pm.tetanus5_date, pm.check_for_breastfeeding, " +
                "pm.payment_type " +
                "FROM rch_pnc_mother_master pm " +
                "JOIN imt_member m ON pm.mother_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON pm.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND pm.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND pm.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<PncMotherDetailsDto> pncMotherDetails = new ArrayList<>();

        for (Object[] row : results) {
            PncMotherDetailsDto pncMotherDetailsDto = PncMotherDetailsMapper.mapFromPncMotherMaster(row);
            pncMotherDetails.add(pncMotherDetailsDto);
        }

        return pncMotherDetails;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<WpdMotherDetailsDto> getWpdMotherDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT wpd.date_of_delivery, wpd.has_delivery_happened, wpd.cortico_steroid_given, " +
                "wpd.is_preterm_birth, wpd.delivery_place, wpd.institutional_delivery_place, " +
                "wpd.type_of_hospital, wpd.delivery_done_by, wpd.type_of_delivery, " +
                "wpd.mother_alive, wpd.other_danger_signs, wpd.is_discharged, " +
                "wpd.discharge_date, wpd.breast_feeding_in_one_hour, wpd.mtp_done_at, " +
                "wpd.mtp_performed_by, wpd.death_reason, wpd.is_high_risk_case, " +
                "wpd.pregnancy_reg_det_id, wpd.pregnancy_outcome, wpd.misoprostol_given, " +
                "wpd.free_drop_delivery, wpd.delivery_person, wpd.delivery_person_name, " +
                "wpd.was_art_given, wpd.hiv_during_delivery, wpd.is_art_given_delivery, " +
                "wpd.payment_type, wpd.member_id " +
                "FROM rch_wpd_mother_master wpd " +
                "JOIN imt_member m ON wpd.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON wpd.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND wpd.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND wpd.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<WpdMotherDetailsDto> wpdMotherDetails = new ArrayList<>();

        for (Object[] row : results) {
            WpdMotherDetailsDto wpdMotherDetailsDto = WpdMotherDetailsMapper.mapFromWpdMotherMaster(row);
            wpdMotherDetails.add(wpdMotherDetailsDto);
        }

        return wpdMotherDetails;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<WpdChildDetailsDto> getWpdChildDetails(Integer facilityCode, Date serviceStartDate, Date serviceEndDate, Integer cbvId, String householdId, Integer zoneId) {
        Timestamp startDateWithTime = serviceStartDate != null ? new Timestamp(serviceStartDate.getTime()) : null;
        Timestamp endDateWithTime = serviceEndDate != null ? new Timestamp(serviceEndDate.getTime()) : null;

        String sqlQuery = "SELECT wcd.member_id, wcd.wpd_mother_id, wcd.pregnancy_outcome, wcd.kangaroo_care, " +
                "wcd.breast_crawl, wcd.was_premature, wcd.name, wcd.type_of_delivery, wcd.death_reason, " +
                "wcd.is_high_risk_case, wcd.vitamin_k1_date, wcd.exclusive_breastfeeding_in_health_center, " +
                "wcd.baby_breathe_at_birth, wcd.skin_to_skin_care " +
                "FROM rch_wpd_child_master wcd " +
                "JOIN imt_member m ON wcd.member_id = m.id " +
                "JOIN imt_family f ON m.family_id = f.family_id " +
                "JOIN um_user u ON wcd.created_by = u.id " +
                "INNER JOIN user_health_infrastructure uh ON u.id = uh.user_id " +
                "INNER JOIN health_infrastructure_details h ON uh.health_infrastrucutre_id = h.id " +
                "WHERE h.id = :facilityCode " +
                "AND wcd.created_on BETWEEN :serviceStartDate AND :serviceEndDate ";

        if (cbvId != null) {
            sqlQuery += "AND wcd.created_by = :cbvId ";
        }
        if (householdId != null) {
            sqlQuery += "AND m.family_id = :householdId ";
        }
        if (zoneId != null) {
            sqlQuery += "AND f.location_id = :zoneId ";
        }

        Query query = entityManager.createNativeQuery(sqlQuery)
                .setParameter("facilityCode", facilityCode);
        if (startDateWithTime != null && endDateWithTime != null) {
            query.setParameter("serviceStartDate", startDateWithTime);
            query.setParameter("serviceEndDate", endDateWithTime);
        }
        if (cbvId != null) {
            query.setParameter("cbvId", cbvId);
        }
        if (householdId != null) {
            query.setParameter("householdId", householdId);
        }
        if (zoneId != null) {
            query.setParameter("zoneId", zoneId);
        }

        List<Object[]> results = query.getResultList();
        List<WpdChildDetailsDto> wpdChildDetails = new ArrayList<>();

        for (Object[] row : results) {
            WpdChildDetailsDto wpdChildDetailsDto = WpdChildMapper.mapFromWpdChildMaster(row);
            wpdChildDetails.add(wpdChildDetailsDto);
        }

        return wpdChildDetails;
    }
}

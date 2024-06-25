/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.rch.dao.AdolescentDao;
import com.argusoft.imtecho.rch.model.AdolescentScreeningEntity;
import org.hibernate.SQLQuery;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * @author utkarsh
 */
@Repository
@Transactional
public class AdolescentDaoImpl extends GenericDaoImpl<AdolescentScreeningEntity, Integer> implements AdolescentDao {
    public static final String ID_PROPERTY = "id";

    public static final String UNIQUE_HEALTH_ID_PROPERTY = "uniqueHealthId";

    @Override
    public AdolescentScreeningEntity retrieveMemberById(Integer id) {
        List<Criterion> criterions = new ArrayList<>();
        if (id == null) {
            return null;
        }
        criterions.add(Restrictions.eq(ID_PROPERTY, id));
        return super.findEntityByCriteriaList(criterions);
    }

    @Override
    public AdolescentScreeningEntity retrieveMemberByUniqueHealthId(String uniqueHealthId) {
        List<Criterion> criterions = new ArrayList<>();
        if (uniqueHealthId == null) {
            return null;
        }
        criterions.add(Restrictions.eq(UNIQUE_HEALTH_ID_PROPERTY, uniqueHealthId));
        return super.findEntityByCriteriaList(criterions);
    }

    @Override
    public AdolescentScreeningEntity updateMember(AdolescentScreeningEntity adolescentScreeningEntity) {
        super.update(adolescentScreeningEntity);
        return adolescentScreeningEntity;
    }

    @Override
    public AdolescentScreeningEntity createMember(AdolescentScreeningEntity adolescentScreeningEntity) {
        super.create(adolescentScreeningEntity);
        return adolescentScreeningEntity;
    }

    @Override
    public List<MemberDto> getMembersOfSchool(Long schoolActualId, Integer standard) {
        String query = " select \n" +
                    " a1.id,\n" +
                    " a1.unique_health_id as uniqueHealthId,\n" +
                    " a1.family_id as familyId, \n" +
                    " a1.first_name as firstName, \n" +
                    " a1.middle_name as middleName, \n" +
                    " a1.last_name as lastName,\n" +
                    " a1.dob as dob,\n" +
                    " a1.gender as gender,\n" +
                    " a1.state as state,\n" +
                    " idm.counselling_done as counsellingDone,\n" +
                    " idm.height as height,\n" +
                    " idm.weight as weight, \n" +
                    " idm.is_haemoglobin_measured as isHaemoglobinMeasured,\n" +
                    " idm.haemoglobin as haemoglobin,\n" +
                    " idm.ifa_tab_taken_last_month as ifaTabTakenLastMonth,\n" +
                    " idm.ifa_tab_taken_now as ifaTabTakenNow,\n" +
                    " idm.is_period_started as isPeriodStarted,\n" +
                    " idm.absorbent_material_used as absorbentMaterialUsed,\n" +
                    " idm.is_sanitary_pad_given as isSanitaryPadGiven,\n" +
                    " idm.no_of_sanitary_pads_given as noOfSanitaryPadsGiven,\n" +
                    " idm.is_having_menstrual_problem as isHavingMenstrualProblem,\n" +
                    " idm.issue_with_menstruation as issueWithMenstruation,\n" +
                    " idm.is_td_injection_given as isTdInjectionGiven,\n" +
                    " idm.td_injection_date as tdInjectionDate,\n" +
                    " idm.is_albandazole_given_in_last_six_months as isAlbandazoleGivenInLastSixMonths,\n" +
                    " idm.adolescent_screening_date as adolescentScreeningDate,\n" +
                    " a2.member_id as memberId, \n" +
                    " a2.current_studying_standard as currentStudyingStandard,\n" +
                    " a2.current_school as currentSchool,\n" +
                    " a3.religion as religion,\n" +
                    " a3.caste as caste,\n" +
//                    " a3.anganwadi_id as anganwadiId, \n" +
                    " a3.area_id as areaId,\n" +
                    " concat_ws(' ',string_agg(' ',m1.mobile_number),string_agg(' ',m1.unique_health_id), a1.first_name, a1.middle_name, a1.last_name, a1.dob) as concatWs\n" +
                    " from imt_member a1 \n" +
                    " inner join imt_family a3 on a3.family_id = a1.family_id \n" +
                    " inner join imt_member_cfhc_master a2 on a1.id = a2.member_id \n" +
                    " left join imt_adolescent_member idm on a1.id = idm.member_id \n" +
                    " and idm.adolescent_screening_date > CURRENT_DATE - interval '6' month \n" +
                    " inner join imt_member m1 on m1.family_id = a3.family_id\n" +
                    " where current_school = '" + schoolActualId + "' and a2.current_studying_standard = '" + standard + "' \n" +
                    " and a1.dob between CURRENT_DATE - interval '19' year and CURRENT_DATE - interval '10' year\n" +
                    " and idm.id is null\n" +
                    " group by a1.id,\n" +
                    " a1.unique_health_id,\n" +
                    " a1.family_id, \n" +
                    " a1.first_name, \n" +
                    " a1.middle_name, \n" +
                    " a1.last_name,\n" +
                    " a1.dob,\n" +
                    " a1.gender,\n" +
                    " a1.state,\n" +
                    " idm.counselling_done,\n" +
                    " idm.height,\n" +
                    " idm.weight, \n" +
                    " idm.is_haemoglobin_measured,\n" +
                    " idm.haemoglobin,\n" +
                    " idm.ifa_tab_taken_last_month,\n" +
                    " idm.ifa_tab_taken_now,\n" +
                    " idm.is_period_started,\n" +
                    " idm.absorbent_material_used,\n" +
                    " idm.is_sanitary_pad_given,\n" +
                    " idm.no_of_sanitary_pads_given,\n" +
                    " idm.is_having_menstrual_problem,\n" +
                    " idm.issue_with_menstruation,\n" +
                    " idm.is_td_injection_given,\n" +
                    " idm.td_injection_date,\n" +
                    " idm.is_albandazole_given_in_last_six_months,\n" +
                    " idm.adolescent_screening_date,\n" +
                    " a2.member_id, \n" +
                    " a2.current_studying_standard,\n" +
                    " a2.current_school,\n" +
                    " a3.religion,\n" +
                    " a3.caste,\n" +

                    " a3.area_id";

        SQLQuery q = getCurrentSession().createSQLQuery(query);
        List<MemberDto> result = q
                .addScalar("uniqueHealthId", StandardBasicTypes.STRING)
                .addScalar("familyId", StandardBasicTypes.STRING)
                .addScalar("firstName", StandardBasicTypes.STRING)
                .addScalar("middleName", StandardBasicTypes.STRING)
                .addScalar("lastName", StandardBasicTypes.STRING)
                .addScalar("dob", StandardBasicTypes.TIMESTAMP)
                .addScalar("gender", StandardBasicTypes.STRING)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("memberId", StandardBasicTypes.LONG)
                .addScalar("counsellingDone", StandardBasicTypes.STRING)
                .addScalar("height", StandardBasicTypes.FLOAT)
                .addScalar("weight", StandardBasicTypes.FLOAT)
                .addScalar("isHaemoglobinMeasured", StandardBasicTypes.BOOLEAN)
                .addScalar("haemoglobin", StandardBasicTypes.FLOAT)
                .addScalar("ifaTabTakenLastMonth", StandardBasicTypes.INTEGER)
                .addScalar("ifaTabTakenNow", StandardBasicTypes.INTEGER)
                .addScalar("isPeriodStarted", StandardBasicTypes.BOOLEAN)
                .addScalar("absorbentMaterialUsed", StandardBasicTypes.STRING)
                .addScalar("isSanitaryPadGiven", StandardBasicTypes.BOOLEAN)
                .addScalar("noOfSanitaryPadsGiven", StandardBasicTypes.INTEGER)
                .addScalar("isHavingMenstrualProblem", StandardBasicTypes.BOOLEAN)
                .addScalar("issueWithMenstruation", StandardBasicTypes.STRING)
                .addScalar("isTdInjectionGiven", StandardBasicTypes.BOOLEAN)
                .addScalar("tdInjectionDate", StandardBasicTypes.TIMESTAMP)
                .addScalar("isAlbandazoleGivenInLastSixMonths", StandardBasicTypes.BOOLEAN)
                .addScalar("adolescentScreeningDate", StandardBasicTypes.TIMESTAMP)
                .addScalar("currentStudyingStandard", StandardBasicTypes.INTEGER)
                .addScalar("currentSchool", StandardBasicTypes.LONG)
                .addScalar("religion", StandardBasicTypes.STRING)
                .addScalar("caste", StandardBasicTypes.STRING)
//                .addScalar("anganwadiId", StandardBasicTypes.LONG)
                .addScalar("areaId", StandardBasicTypes.STRING)
                .addScalar("concatWs", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(MemberDto.class)).list();
        return result;
    }

    @Override
    public List<MemberDto> getMembersByAdvanceSearch(Integer parentId, String searchText, Integer standard) {
        String query = " with search_member as (select acd.member_id from adolescent_child_det acd\n" +
                " inner join location_hierchy_closer_det lhc on acd.location_id = lhc.child_id\n" +
                " where lhc.parent_id = "+parentId+" and search_text @@to_tsquery('"+searchText+"') \n" +
                " and dob between current_date - interval '"+(standard+8)+" years' \n" +
                " and current_date - interval '"+(standard+5)+" years') \n" +
                " select \n" +
                " a1.id as memberId, \n" +
                " a1.unique_health_id as uniqueHealthId, \n" +
                " a1.family_id as familyId,  \n" +
                " a1.first_name as firstName,  \n" +
                " a1.middle_name as middleName,  \n" +
                " a1.last_name as lastName, \n" +
                " a1.dob as dob, \n" +
                " a1.gender as gender, \n" +
                " a1.mother_id as motherId,\n" +
                " a1.state as state, \n" +
                " idm.counselling_done as counsellingDone, \n" +
                " idm.height as height, \n" +
                " idm.weight as weight,  \n" +
                " idm.is_haemoglobin_measured as isHaemoglobinMeasured, \n" +
                " idm.haemoglobin as haemoglobin, \n" +
                " idm.ifa_tab_taken_last_month as ifaTabTakenLastMonth, \n" +
                " idm.ifa_tab_taken_now as ifaTabTakenNow, \n" +
                " idm.is_period_started as isPeriodStarted, \n" +
                " idm.absorbent_material_used as absorbentMaterialUsed, \n" +
                " idm.is_sanitary_pad_given as isSanitaryPadGiven, \n" +
                " idm.no_of_sanitary_pads_given as noOfSanitaryPadsGiven, \n" +
                " idm.is_having_menstrual_problem as isHavingMenstrualProblem, \n" +
                " idm.issue_with_menstruation as issueWithMenstruation, \n" +
                " idm.is_td_injection_given as isTdInjectionGiven, \n" +
                " idm.td_injection_date as tdInjectionDate, \n" +
                " idm.is_albandazole_given_in_last_six_months as isAlbandazoleGivenInLastSixMonths, \n" +
                " idm.adolescent_screening_date as adolescentScreeningDate, \n" +
                " a3.religion as religion, \n" +
                " a3.caste as caste, \n" +
//                " a3.anganwadi_id as anganwadiId,  \n" +
                " a3.area_id as areaId, \n" +
                " concat_ws(' ',string_agg(' ',m1.mobile_number),string_agg(' ',m1.unique_health_id), a1.first_name, a1.middle_name, a1.last_name) as concatWs \n" +
                " from imt_member a1  \n" +
                " inner join imt_family a3 on a3.family_id = a1.family_id  \n" +
                " left join imt_adolescent_member idm on a1.id = idm.member_id  \n" +
                " and idm.adolescent_screening_date > CURRENT_DATE - interval '6' month  \n" +
                " inner join imt_member m1 on m1.family_id = a3.family_id\n" +
                " inner join search_member sm on sm.member_id = a1.id\n" +
                " and idm.id is null \n" +
                " group by a1.id, \n" +
                " a1.unique_health_id, \n" +
                " a1.family_id,  \n" +
                " a1.first_name,  \n" +
                " a1.middle_name,  \n" +
                " a1.last_name, \n" +
                " a1.dob, \n" +
                " a1.gender, \n" +
                " a1.mother_id,\n" +
                " a1.state, \n" +
                " idm.counselling_done, \n" +
                " idm.height, \n" +
                " idm.weight,  \n" +
                " idm.is_haemoglobin_measured, \n" +
                " idm.haemoglobin, \n" +
                " idm.ifa_tab_taken_last_month, \n" +
                " idm.ifa_tab_taken_now, \n" +
                " idm.is_period_started, \n" +
                " idm.absorbent_material_used, \n" +
                " idm.is_sanitary_pad_given, \n" +
                " idm.no_of_sanitary_pads_given, \n" +
                " idm.is_having_menstrual_problem, \n" +
                " idm.issue_with_menstruation, \n" +
                " idm.is_td_injection_given, \n" +
                " idm.td_injection_date, \n" +
                " idm.is_albandazole_given_in_last_six_months, \n" +
                " idm.adolescent_screening_date, \n" +
                " a3.religion, \n" +
                " a3.caste, \n" +
//                " a3.anganwadi_id, \n" +
                " a3.area_id limit 200";

        SQLQuery q = getCurrentSession().createSQLQuery(query);
        List<MemberDto> result = q
                .addScalar("uniqueHealthId", StandardBasicTypes.STRING)
                .addScalar("familyId", StandardBasicTypes.STRING)
                .addScalar("firstName", StandardBasicTypes.STRING)
                .addScalar("middleName", StandardBasicTypes.STRING)
                .addScalar("lastName", StandardBasicTypes.STRING)
                .addScalar("dob", StandardBasicTypes.TIMESTAMP)
                .addScalar("gender", StandardBasicTypes.STRING)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("memberId", StandardBasicTypes.LONG)
                .addScalar("counsellingDone", StandardBasicTypes.STRING)
                .addScalar("height", StandardBasicTypes.FLOAT)
                .addScalar("weight", StandardBasicTypes.FLOAT)
                .addScalar("isHaemoglobinMeasured", StandardBasicTypes.BOOLEAN)
                .addScalar("haemoglobin", StandardBasicTypes.FLOAT)
                .addScalar("ifaTabTakenLastMonth", StandardBasicTypes.INTEGER)
                .addScalar("ifaTabTakenNow", StandardBasicTypes.INTEGER)
                .addScalar("isPeriodStarted", StandardBasicTypes.BOOLEAN)
                .addScalar("absorbentMaterialUsed", StandardBasicTypes.STRING)
                .addScalar("isSanitaryPadGiven", StandardBasicTypes.BOOLEAN)
                .addScalar("noOfSanitaryPadsGiven", StandardBasicTypes.INTEGER)
                .addScalar("isHavingMenstrualProblem", StandardBasicTypes.BOOLEAN)
                .addScalar("issueWithMenstruation", StandardBasicTypes.STRING)
                .addScalar("isTdInjectionGiven", StandardBasicTypes.BOOLEAN)
                .addScalar("tdInjectionDate", StandardBasicTypes.TIMESTAMP)
                .addScalar("isAlbandazoleGivenInLastSixMonths", StandardBasicTypes.BOOLEAN)
                .addScalar("adolescentScreeningDate", StandardBasicTypes.TIMESTAMP)
                //.addScalar("currentStudyingStandard", StandardBasicTypes.INTEGER)
                //.addScalar("currentSchool", StandardBasicTypes.LONG)
                .addScalar("religion", StandardBasicTypes.STRING)
                .addScalar("caste", StandardBasicTypes.STRING)
//                .addScalar("anganwadiId", StandardBasicTypes.LONG)
                .addScalar("areaId", StandardBasicTypes.STRING)
                .addScalar("concatWs", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(MemberDto.class)).list();
        return result;
    }
}

delete from query_master where code='cm_dashboard_ddo_kpi';


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cm_dashboard_ddo_kpi','monthyear','
with loc_det as (
    select
        case 
            when lm.type in (''D'', ''C'') then ''D''
            when lm.type in (''T'', ''B'', ''Z'') then ''T''
            when lm.type in (''P'', ''U'') then ''P''
            else lm.type end,
        lm.id as loc_id,
        lh.location_id,
        s.english_name as stateName,
        s.location_code as stateCode,
        d.english_name as districtName,
        case when lm.type = ''S'' then 0 else d.location_code end as districtCode,
        b.english_name as talukaName,
        lm.cm_dashboard_code as talukaCode,
        p.english_name as facilityName,
        case when lm.type = ''P'' then 1 when lm.type = ''U'' then 3 else null end as facilityCode
    from location_master lm
    left join location_level_hierarchy_master lh
    on lh.id = lm.location_hierarchy_id
    left join location_master s
    on lh.level1 = s.id and s.state = ''ACTIVE'' and s.name not ilike ''%delete%''
    left join location_master d
    on lh.level3 = d.id and d.state = ''ACTIVE'' and d.name not ilike ''%delete%''
    left join location_master b
    on lh.level4 = b.id and b.state = ''ACTIVE'' and b.name not ilike ''%delete%''
    left join location_master p
    on lh.level5 = p.id and p.state = ''ACTIVE'' and p.name not ilike ''%delete%''
    where lm.state = ''ACTIVE'' and lm.name not ilike ''%delete%'' and lm."type" in (''S'', ''C'', ''D'', ''B'', ''P'', ''U'', ''T'', ''Z'')
),
ddo_api_report_det as (
    select
        lh.parent_id as loc_id
        ,sum(fi_partial_numerator) as total_fi_partial_numerator
        ,sum(fi_total_denominator) as total_fi_total_denominator
        ,sum(early_registration_numerator) as total_early_registration_numerator
        ,sum(pregnant_women_registration_denominator) as total_pregnant_women_registration_denominator
        ,sum(pmsma_trimester_numerator) as total_pmsma_trimester_numerator
        ,sum(pmsma_total_denominator) as total_pmsma_total_denominator
        ,sum(sex_ratio_male) as total_sex_ration_male
        ,sum(sex_ratio_female) as total_sex_ration_female
        ,sum(sex_ratio_male + sex_ratio_female ) as child
        ,sum(anemia_treated_numerator) as total_anemia_treated_numerator
        ,sum(anemia_tested_denominator) as total_anemia_tested_denominator
        ,sum(infant_death_actual_numerator) as total_infant_death_actual_numerator
        ,round(sum(sex_ratio_male + sex_ratio_female ) * 30 / 1000,0) as total_infant_death_estimated_denominator
        ,sum(low_birth_baby_partial_numerator) as total_low_birth_baby_partial_numerator
        ,sum(low_birth_baby_total_denominator) as total_low_birth_baby_total_denominator
        ,sum(institutional_deliveries_numerator) as total_institutional_deliveries_numerator
        ,sum(estimated_deliveries_denominator) as total_estimated_deliveries_denominator
        ,sum(maternal_death_actual_numerator) as total_maternal_death_actual_numerator
        ,round(sum(sex_ratio_male + sex_ratio_female ) * 87 / 100000,0) as total_maternal_death_estimated_denominator
        ,sum(ppiucd_inserted_numerator) as total_ppiucd_inserted_numerator
        ,sum(ppiucd_institutional_denominator) as total_ppiuce_institutional_denominator
    from cm_dashboard_ddo_kpi_detail as cm , location_hierchy_closer_det lh
    where cm.month_year = to_date(''#monthyear#'', ''MM-DD-YYYY'')
    and cm.location_id = lh.child_id and lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id
)
select
    EXTRACT(YEAR FROM to_date(''#monthyear#'', ''MM-DD-YYYY'')) as year,
    EXTRACT(MONTH FROM to_date(''#monthyear#'', ''MM-DD-YYYY'')) as month,
    loc_det.type as "locationLevel",
    loc_det.districtCode as "districtCode",
    loc_det.districtName as "districtName",
    loc_det.talukaCode as "talukaCode",
    loc_det.talukaName as "talukaName",
    loc_det.facilityName as "facilityName",
    loc_det.facilityCode as "facilityCode",
    ddo_api_report_det.total_fi_partial_numerator as "totalFiPartialNumerator",
    ddo_api_report_det.total_fi_total_denominator as "totalFiTotalDenominator",
    round(((ddo_api_report_det.total_fi_partial_numerator * 100.0) / NULLIF(ddo_api_report_det.total_fi_total_denominator, 0)), 2) as "perFullyImmunization",

    ddo_api_report_det.total_early_registration_numerator as "totalEarlyRegistrationNumerator",
    ddo_api_report_det.total_pregnant_women_registration_denominator as "totalPregnantWomenRegistrationDenominator",
    round(((ddo_api_report_det.total_early_registration_numerator * 100.0) / NULLIF(ddo_api_report_det.total_pregnant_women_registration_denominator, 0)), 2) as "perEarlyRegistrationAgainstPregnanatWomenRegisterd",

     ddo_api_report_det.total_pmsma_trimester_numerator as "totalPmsmaTrimesterNumerator",
    ddo_api_report_det.total_pmsma_total_denominator as "totalEligibleHighRiskMotherDenominator",
    round(((ddo_api_report_det.total_pmsma_trimester_numerator * 100.0) / NULLIF(ddo_api_report_det.total_pmsma_total_denominator, 0)), 2) as "perOfSecondAndThirdTrimsterAntenatalAgainstUnderPmsma",

    ddo_api_report_det.total_sex_ration_male as "totalSexRatioMale",
    ddo_api_report_det.total_sex_ration_female as "totalSexRatioFemale",
    round(((ddo_api_report_det.total_sex_ration_female * 1000.0) / NULLIF(ddo_api_report_det.total_sex_ration_male, 0)), 2) as "sexRatioAtBirth",

    ddo_api_report_det.total_anemia_treated_numerator as "totalAnemiaTreatedNumerator",
    ddo_api_report_det.total_anemia_tested_denominator as "totalAnemiaTestedDenominator",
    round(((ddo_api_report_det.total_anemia_treated_numerator * 100.0) / NULLIF(ddo_api_report_det.total_anemia_tested_denominator, 0)), 2) as "perPregnantWomanHavingSereverAnemiaTreatedAgainstPwHavingSeeve",

    ddo_api_report_det.total_infant_death_actual_numerator as "totalInfantDeathActualNumerator",
    ddo_api_report_det.total_infant_death_estimated_denominator as "totalInfantDeathEstimatedDenominator",
    round(((ddo_api_report_det.total_infant_death_actual_numerator * 100.0) / NULLIF(ddo_api_report_det.total_infant_death_estimated_denominator, 0)), 2) as "perInfantDeathReportedAgainstEstimatedInfantDeaths",

    ddo_api_report_det.total_low_birth_baby_partial_numerator as "totalLowBirthBabyPartialNumerator",
    ddo_api_report_det.total_low_birth_baby_total_denominator as "totalLowBirthBabyDenominator",
    round(((ddo_api_report_det.total_low_birth_baby_partial_numerator * 100.0) / NULLIF(ddo_api_report_det.total_low_birth_baby_total_denominator, 0)), 2) as "perLowBirthBaby",

    ddo_api_report_det.total_institutional_deliveries_numerator as "totalInstitutionalDeliveriesNumerator",
    ddo_api_report_det.total_estimated_deliveries_denominator as "totalEstimatedDeliveriesDenominator",
    round(((ddo_api_report_det.total_institutional_deliveries_numerator * 100.0) / NULLIF(ddo_api_report_det.total_estimated_deliveries_denominator, 0)), 2) as "perInstitutionalDeliveriesAgainstEstimatedDelivery",

    ddo_api_report_det.total_maternal_death_actual_numerator as "totalMaternalDeathActualNumerator",
    ddo_api_report_det.total_maternal_death_estimated_denominator as "totalMaternalDeathEstimatedDenominator",
    round(((ddo_api_report_det.total_maternal_death_actual_numerator * 100.0) / NULLIF(ddo_api_report_det.total_maternal_death_estimated_denominator, 0)), 2) as "perMaternalDeathsReportedAgainstEstimated",

    ddo_api_report_det.total_ppiucd_inserted_numerator as "totalPpiucdInsertedNumerator",
    ddo_api_report_det.total_ppiuce_institutional_denominator as "totalPpiuceInstitutionalDeliveryDenominator",
    round(((ddo_api_report_det.total_ppiucd_inserted_numerator * 100.0) / NULLIF(ddo_api_report_det.total_ppiuce_institutional_denominator, 0)), 2) as "perPpiucdInsertedAgainstInstitutionalDeliveries",

    current_date as "asOnDate"

from loc_det
left join ddo_api_report_det on loc_det.loc_id = ddo_api_report_det.loc_id
order by loc_det.loc_id
',true,'ACTIVE');
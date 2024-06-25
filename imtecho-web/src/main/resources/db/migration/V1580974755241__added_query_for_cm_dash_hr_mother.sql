delete from query_master where code='cm_dashboard_hr_pregnancy_complication';


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cm_dashboard_hr_pregnancy_complication','finacial_year','
with dates as (
select to_date(case when ''#finacial_year#'' = ''null'' then null else concat(''03-31-'',substr(''#finacial_year#'',1,4)) end,''MM-DD-YYYY'') from_date
,to_date(case when ''#finacial_year#'' = ''null'' then null else concat(''04-01-'',substr(''#finacial_year#'',6,10)) end,''MM-DD-YYYY'') to_date
),w as(
	select
	lm.id as loc_id,
    coalesce(sum(anc_reg),0) as reg_preg_women,
    coalesce(sum(high_risk),0) as high_risk,
    coalesce(sum(severe_anemia),0) as severe_anemia,
    coalesce(sum(blood_pressure),0) as blood_pressure,
    coalesce(sum(diabetes),0) as diabetes,
    coalesce(sum(cur_mal_presentation_issue),0) as cur_mal_presentation_issue,
    coalesce(sum(cur_malaria_issue),0) as cur_malaria_issue,
    coalesce(sum(multipara),0) as multipara,
    coalesce(sum(extreme_age),0) as extreme_age,
    coalesce(sum(interval_bet_preg_less_18_months),0) as interval_bet_preg_less_18_months,
    coalesce(sum(height),0) as height,
    coalesce(sum(weight),0) as weight,
    coalesce(sum(urine_albumin),0) as urine_albumin
	from 
	location_master lm 
	inner join location_hierchy_closer_det on lm."type" in (''P'', ''U'') and lm.id = location_hierchy_closer_det.parent_id 
	cross join dates
	left join rch_service_provided_during_year lwrra on lwrra.location_id = location_hierchy_closer_det.child_id and lwrra.month_year between dates.from_date and dates.to_date
	group by lm.id
	order by lm.name
),
loc as (
	select distinct loc_id from w
),
loc_det as (
   select
        case 
            when lm.type in (''D'', ''C'') then ''D''
            when lm.type in (''T'', ''B'', ''Z'') then ''T''
            when lm.type in (''P'', ''U'') then ''P''
            when lm.type in (''V'', ''AA'') then ''V''
            when lm.type in (''A'') then ''A''
            else lm.type end,
        lm.id as loc_id,
        lh.location_id,
        s.english_name as stateName,
        s.location_code as stateCode,
        d.english_name as districtName,
        case when lm.type = ''S'' then 0 else d.location_code end as districtCode,
        b.english_name as talukaName,
        b.cm_dashboard_code as talukaCode,
        p.english_name as facilityName,
        case when p.type = ''P'' then 1 when p.type = ''U'' then 3 else null end as facilityCode,
        sc.english_name as subCenterName,
        v.english_name as villageName,
        a.english_name as areaName
    from loc 
    inner join location_master lm
    on lm.id = loc.loc_id
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
    left join location_master sc
    on lh.level6 = sc.id and sc.state = ''ACTIVE'' and sc.name not ilike ''%delete%''
    left join location_master v
    on lh.level7 = v.id and v.state = ''ACTIVE'' and v.name not ilike ''%delete%''
    left join location_master a
    on lh.level8 = a.id and a.state = ''ACTIVE'' and a.name not ilike ''%delete%''
    where lm.state = ''ACTIVE'' and lm.name not ilike ''%delete%''
),
 high_risk_mother as (
select
   cast(''#finacial_year#'' as text) as financialYear,
    loc_det.type as "locationLevel",
    loc_det.districtCode as "districtCode",
    loc_det.districtName as "districtName",
    loc_det.talukaCode as "talukaCode",
    loc_det.talukaName as "talukaName",
    loc_det.facilityName as "facilityName",
    loc_det.facilityCode as "facilityCode",
    loc_det.subCenterName as "subCenterName",
    loc_det.villageName as "villageName",
    loc_det.areaName as "areaName",
reg_preg_women as "totalNumberOfPwRegisteredDuringSelectedPeriod",
high_risk as "totalNoOfHighRiskMothers",
round(case when reg_preg_women = 0 then 0 else high_risk*100.0/reg_preg_women end,2) as "perHighRiskMother",
severe_anemia  as "severeAnemia(HbLessThan7gm%)",
round(case when high_risk = 0 then 0 else severe_anemia*100.0/high_risk end,2) as "perSevereAnemia(HbLessThan7gm%)",
blood_pressure  as "bloodPressure(MoreThan140/90)(EitherOrBoth)",
round(case when high_risk = 0 then 0 else blood_pressure*100.0/high_risk end,2) as "perBloodPressure(MoreThan140/90)(EitherOrBoth)",
diabetes  as "gestationalDiabetesMellitus",
round(case when high_risk = 0 then 0 else diabetes*100.0/high_risk end,2) as "perGestationalDiabetesMellitus",
cur_malaria_issue  as "malaria",
round(case when high_risk = 0 then 0 else cur_malaria_issue*100.0/high_risk end,2) as "perMalaria",
multipara  as "grandMultipara",
round(case when high_risk = 0 then 0 else multipara*100.0/high_risk end,2) as "perGrandMultipara",
cur_mal_presentation_issue  as "malPresentation",
round(case when high_risk = 0 then 0 else cur_mal_presentation_issue*100.0/high_risk end,2) as "perMalPresentation",
extreme_age  as "extremeAge(LessThan18AndMoreThan35Years)",
round(case when high_risk = 0 then 0 else extreme_age*100.0/high_risk end,2) as "perExtremeAge(LessThan18AndMoreThan35Years)",
interval_bet_preg_less_18_months  as "intervalLessThan18MonthsBetweenLastAndPresentPregnancy",
round(case when high_risk = 0 then 0 else interval_bet_preg_less_18_months*100.0/high_risk end,2) as "perIntervalLessThan18MonthsFromLastPregnancy", 
height  as "heightLessThan140Cm",
round(case when high_risk = 0 then 0 else height*100.0/high_risk end,2) as "perHeightLessThan140Cm",
weight  as "weightLessThan45kg",
round(case when high_risk = 0 then 0 else weight*100.0/high_risk end,2) as "perWeightLessThan45kg",
urine_albumin  as "urineAlbuminPresent",
round(case when high_risk = 0 then 0 else urine_albumin*100.0/high_risk end,2) as "perUrineAlbuminPresent",
current_date as "asOnDate"
from w
inner join loc_det on w.loc_id = loc_det.loc_id 
)

select * from high_risk_mother;
',true,'ACTIVE');
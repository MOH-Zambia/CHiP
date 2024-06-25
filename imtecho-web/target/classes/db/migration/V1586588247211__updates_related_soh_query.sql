DELETE FROM QUERY_MASTER WHERE CODE='soh_covid19_recover_member_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
66522,  current_date , 66522,  current_date , 'soh_covid19_recover_member_list',
 null,
'with marker_date as (
	select TO_TIMESTAMP(sc.key_value, ''YYYY-MM-DD HH24:MI:SS'') as last_marker_date from system_configuration sc where sc.system_key = ''COVID19_LAST_MARKET_DATE''
)
select
member_det as "name",
age as "age",
case when gender = ''F'' then ''Female'' else ''Male'' end as "gender",
case when hid.name_in_english is null then hid.name else hid.name_in_english end as "facility",
im.english_name as "area",
case when dob is null then ''-'' else to_char(dob,''DD-MM-YYYY'') end as "dob",
caad.address as address ,
case when caad.discharge_date is not null then to_char(caad.discharge_date,''DD/MM/YYYY'') else ''-'' end as "dod"
from covid19_admission_analytics_details caad
left join location_master im on im.id = caad.location_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where positive_member = 1 and cad_status = ''DISCHARGE''
and system_discharge_date > (select last_marker_date from marker_date)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='soh_covid19_infrastructure_wise_results';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'soh_covid19_infrastructure_wise_results',
 null,
'with member_details  as(
select
caad.health_infra_id,
sum( caad.no_of_test )"Tests",
sum( case when caad.positive_member = 1 then 1 else 0 end) "Positive",
sum(case when caad.cad_status = ''DEATH'' and caad.positive_member = 1 then 1 else 0 end ) "Death",
sum(case when caad.cad_status = ''SUSPECT'' then 1 else 0 end ) "Suspected",

sum(case when caad.cad_status = ''DISCHARGE'' and caad.positive_member = 1 then 1 else 0 end ) "Discharge",
sum( case when caad.health_state in (''Stable'',''Stable-Moderate'') and positive_member = 1 and discharge_date is null then 1 else 0 end ) "Stable",
sum( case when caad.health_state in (''Mild'',''Stable-Mild'') and positive_member = 1 and discharge_date is null then 1  else 0 end ) "Mild",
sum( case when caad.health_state = ''Critical'' and positive_member = 1 and discharge_date is null then 1 else 0 end ) "Critical",
sum( case when caad.health_state = ''Asymptomatic'' and positive_member = 1 and discharge_date is null then 1 else 0 end ) "Asymptomatic",
sum(case when caad.positive_member = 1 and caad.cad_status not in (''DISCHARGE'',''DEATH'') then 1 else 0 end ) as ActiveCases,
sum(case when caad.positive_member = 1 and caad.currently_on_ventilator =1 then 1 else 0 end ) as onVantiltorCases
from covid19_admission_analytics_details caad
group by caad.health_infra_id
),
infra_info as (
	select
	hid.id as infra_id,
	sum(case when hiwd.number_of_beds is not null then hiwd.number_of_beds else 0 end) as number_of_beds,
	sum(case when number_of_ventilators_type1 is not null then number_of_ventilators_type1 else 0 end) as number_of_ventilators
	from health_infrastructure_details  hid inner join member_details details on hid.id = details.health_infra_id
	left join health_infrastructure_ward_details hiwd on hiwd.health_infra_id = hid.id
	group by hid.id
),
infra_info_details as(
	select info.*,
	case when details.name_in_english is null then details.name else details.name_in_english end as name,
	details.is_covid_lab as isCovidLab,
	details.is_covid_hospital as isCovidHospital
	from health_infrastructure_details details inner join infra_info info  on info.infra_id = details.id

),
new_added_vantilatos_beds as (select
	infra_id,
	coalesce(sum(case when cast(hwd.modified_on as date) = cast(now() as date) then hwd.number_of_beds else 0 end),0) - coalesce(sum(
	case when cast(hwd.modified_on as date) = cast(now() as date) then
	(select hiwdh.number_of_beds   from health_infrastructure_ward_details_history hiwdh
	where cast(hiwdh.created_on as date) <= cast(now() - interval ''1 day'' as date)
	and hiwdh.health_infrastructure_ward_details_id = hwd.id order by hiwdh.created_by desc limit 1
	) else 0 end),0) as "new_beds",

coalesce(sum(case when cast(hwd.modified_on as date) = cast(now() as date) then hwd.number_of_ventilators_type1 else 0 end ),0) - coalesce(sum(
case when cast(hwd.modified_on as date) = cast(now() as date) then
(select hiwdh.number_of_ventilators_type1   from health_infrastructure_ward_details_history hiwdh
where cast(hiwdh.created_on as date) <= cast(now() - interval ''1 day'' as date)
and hiwdh.health_infrastructure_ward_details_id = hwd.id order by hiwdh.created_by desc limit 1
) else 0 end
),0) as "new_ventilator"
from infra_info hid
left join health_infrastructure_ward_details hwd on hid.infra_id = hwd.health_infra_id
group by hid.infra_id
),
final_details as (
select members.*,
(members."Positive" + members."Death"  + members."Discharge" + members."Suspected") as "InPatinets",
infa.name as "Name",
infa.isCovidLab as "IsCovid19Lab",
infa.isCovidHospital as "IsCovid19Hospital",

infa.number_of_beds as "TotalBeds",
case when infa.number_of_beds = 0 or infa.number_of_beds is null then 2 else  round(cast(((members.ActiveCases*100/cast(infa.number_of_beds as float))) as numeric),2) end as "BedsRatio",
members.ActiveCases as "OccupiedBed",
infa.number_of_beds - members.ActiveCases as "AvailableBed",
vantilatos_beds.new_beds as "NewAddedBed",
infa.number_of_ventilators as "TotalVentilator",
case when infa.number_of_ventilators = 0 or infa.number_of_ventilators is null then 2 else  round(cast(((members.onVantiltorCases*100/cast(infa.number_of_ventilators as float))) as numeric),2) end as "VentilatorRatio",

members.onVantiltorCases as "OccupiedVentilator",
infa.number_of_ventilators - members.onVantiltorCases as "AvailableVentilator",
vantilatos_beds.new_ventilator as "NewAddedVentilator"
from member_details members  left join infra_info_details infa on infa.infra_id = members.health_infra_id
left join new_added_vantilatos_beds  vantilatos_beds on vantilatos_beds.infra_id =infa.infra_id
)

select 0 as health_infra_id,
sum(det."Tests") "Tests",
sum(det."Positive") "Positive",
sum(det."Death") "Death",
sum(det."Suspected") as "Suspected",
sum(det."Discharge") "Discharge",
sum(det."Stable") "Stable",
sum(det."Mild") "Mild",
sum(det."Critical") "Critical",
sum(det."Asymptomatic") "Asymptomatic",
sum(det.activecases) activecases,
sum(det.onVantiltorCases) onVantiltorCases,
sum(det."InPatinets") as "InPatinets",
''Total'' as "Name",
null as "IsCovid19Lab",
null as "IsCovid19Hospital",
sum(det."TotalBeds") "TotalBeds",
case when sum(det."TotalBeds") = 0 then 0 else  round(cast(((sum(det.activecases)*100/cast(sum(det."TotalBeds") as float))) as numeric),2) end as "BedsRatio",
sum(det."OccupiedBed") "OccupiedBed",
sum(det."AvailableBed") "AvailableBed",
sum(det."NewAddedBed") "NewAddedBed",
sum(det."TotalVentilator") "TotalVentilator",
case when sum(det."TotalVentilator") = 0 then 0 else  round(cast(((sum(det.onVantiltorCases)*100/cast(sum(det."TotalVentilator") as float))) as numeric),2) end as "VentilatorRatio",
sum(det."OccupiedVentilator") "OccupiedVentilator",
sum(det."AvailableVentilator") "AvailableVentilator",
sum(det."NewAddedVentilator") "NewAddedVentilator"
from final_details det
union all
select * from final_details order by "InPatinets" desc',
null,
true, 'ACTIVE');
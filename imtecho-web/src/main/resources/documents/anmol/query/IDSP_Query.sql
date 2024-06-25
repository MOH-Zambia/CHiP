
-- COVID19 location wise analytics

begin;
drop table if exists covid19_location_wise_analytics_t;

CREATE TABLE public.covid19_location_wise_analytics_t (
	location_id integer NOT NULL,
	total_test integer,
	total_member_tested integer ,
	total_positive integer,
	total_negative integer,
	total_reject integer,
    total_case integer,
    positive_member integer,
    negative_member integer,
	suspected integer,
	in_treatment integer,
	in_recovery integer,
    in_critical integer,
    in_mild integer,
    in_asymptomatic integer,
	death integer,
    discharge integer,
    todays_discharge integer,
    todays_test integer,
    todays_positive integer,
    todays_death integer,
	PRIMARY KEY (location_id)
);

drop table if exists covid19_admission_analytics_details_t;

select * into covid19_admission_analytics_details_t from  (
    select
    cad.id as admission_id,
    max(cad.member_id) as member_id,
    max(hie.parent_id) as location_id,
    max(cad.health_infra_id) as health_infra_id,
    max(cad.current_ward_id) as current_ward_id,
    max(cad.current_bed_no) as current_bed_no,
    max(cad.status) as cad_status,
    max(case when im.id is not null then concat(im.first_name,' ',im.middle_name,' ',im.last_name)
    else concat(cad.first_name,' ',cad.middle_name,' ',cad.last_name) end) as member_det,
    max(case when im.id is not null then im.dob else cad.dob end) as dob,
    max(cad.age) as age,
    max(cad.gender) as gender,
    max(address) as address,
    max(case_no) as case_no,
    max(contact_number) as contact_number,
    count(distinct cltd.id) filter(where case when cltd.id is not null and (cltd.lab_result_entry_on is not null ) then true else false end ) as no_of_test,                -- total number of based
    count(distinct cltd.id) filter(where case when cltd.lab_result = 'POSITIVE' then true else false end) as positive,          -- total number of positive test
    count(distinct cltd.id) filter(where case when cltd.lab_result != 'POSITIVE' then true else false end) as negative,         -- total number of nagative test
    count(distinct cltd.id) filter(where case when cltd.lab_result != 'POSITIVE' then true else false end) as reject,           -- total number of rejected test
    max(case when cltd.lab_result = 'POSITIVE' then 1 else 0 end ) as positive_member,                                          -- total number of positive case
    min(case when cltd.lab_result = 'POSITIVE' then cltd.lab_result_entry_on else null end) as postive_date,                    -- positive test date (we will consider first that which is positive)
    min(case when cltd.lab_result = 'POSITIVE' then cltd.result_server_date else null end) as system_postive_date,
    max(case when cltd.lab_result != 'POSITIVE' then cltd.lab_result_entry_on else null end) as negative_date,                  -- nagative test date
    max(case when cad.member_id is not null then im.first_name || ' ' || im.last_name else
    cad.first_name || ' ' || cad.last_name end ) as meber_det,
    min(cad.admission_date) as admission_date,                                                                                  -- admission date
    max(cad.discharge_date) as discharge_date,                                                                                  -- discharge date
    max(cad.death_date) as death_date,                                                                                          -- death date
    max(case when cacds.clinically_clear then cacds.service_date else null end) as clinically_clear_date,                       -- clinining date
    min(case when cacds.on_ventilator then cacds.service_date else null end) as on_venti_date,
    max(case when cad.last_check_up_detail_id = cacds.id and cacds.on_ventilator then 1 else 0 end) as currently_on_ventilator,
    max(case when cad.last_check_up_detail_id = cacds.id then cacds.health_status else null end) as health_state,
    max(case when cad.last_lab_test_id = cltd.id and cltd.lab_result_entry_on is not null then cltd.lab_result_entry_on else null end) as last_lab_result_entry_on,
    min(case when cltd.lab_result = 'POSITIVE' then cltd.lab_result_entry_on else null end) as lab_test_system_entry_on,
    max(case when cad.last_lab_test_id = cltd.id then cltd.lab_result else null end) as latest_lab_test_result,
    max(cad.discharge_entry_on) as system_discharge_date,
    max(concat_ws(', ',
        case when is_hiv then 'HIV' else null end,
        case when is_heart_patient then 'Heart Patient' else null end,
        case when is_diabetes then 'Diabetes' else null end,
        case when is_copd then 'COPD' else null end,
        case when is_hypertension then 'Hypertension' else null end,
        case when is_renal_condition then 'Renal Condition' else null end,
        case when is_immunocompromized then 'Immunocompromized' else null end,
        case when is_malignancy then 'Malignancy' else null end,
        other_co_mobidity)
    ) as mobidity,
    max(cad.search_text) as search_text
    from covid19_admission_detail cad
    left join location_hierchy_closer_det hie on cad.location_id = hie.child_id and hie.parent_loc_type in ('D','C')
    left join imt_member im on im.id = cad.member_id
    left join covid19_lab_test_detail cltd on cltd.covid_admission_detail_id = cad.id
    left join covid19_admitted_case_daily_status cacds on cacds.admission_id = cad.id
    group by cad.id
) as t;

alter table covid19_admission_analytics_details_t
add column last_test_before_admission timestamp without time zone;

-- update the last lab test

with last_test_before_admission as (
select test_detail.covid_admission_detail_id, max(lab_result_entry_on) as last_test from
covid19_lab_test_detail test_detail inner join covid19_admission_analytics_details_t analytics_details on test_detail.covid_admission_detail_id = analytics_details.admission_id
where
(test_detail.lab_result_entry_on <= (analytics_details.postive_date) or test_detail.lab_result_entry_on <= (analytics_details.negative_date))
  group by test_detail.covid_admission_detail_id)
update covid19_admission_analytics_details_t
set last_test_before_admission = last_test.last_test
from last_test_before_admission last_test
where last_test.covid_admission_detail_id = covid19_admission_analytics_details_t.admission_id;

update covid19_admission_analytics_details_t
set currently_on_ventilator = case when currently_on_ventilator = 1 and cad_status not in ('DISCHARGE','DEATH','REFER') then 1 else 0 end;

ALTER TABLE covid19_admission_analytics_details_t ADD PRIMARY KEY (admission_id);



insert into covid19_location_wise_analytics_t(location_id, total_case, total_positive, total_negative, total_reject,
total_test, total_member_tested ,positive_member, negative_member, suspected, in_treatment,
in_recovery, in_critical, in_mild, in_asymptomatic, discharge, todays_discharge ,death, todays_positive, todays_death,todays_test)
select
location_id,
count(distinct admission_id) as total_case,
sum(positive) as total_positive,
sum(negative) as total_negative,
sum(reject) as total_reject,
sum(no_of_test) as total_test,
count(distinct admission_id) filter (where no_of_test > 0) total_member_tested,
count(distinct admission_id) filter(where positive_member = 1) as positive_member,                              -- count positive person
count(distinct admission_id) filter(where positive_member = 0) as negative_member,                              -- count nagative person
count(distinct admission_id) filter(where cad_status = 'SUSPECT') as suspected,                                 -- count suspcted person
count(distinct admission_id) filter(where positive_member = 1 and cad_status not in ('DISCHARGE','DEATH')) as in_treatment,      -- count number of discharge (consider only those who are positive)
count(distinct admission_id) filter(where positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') and health_state in('Stable','Stable-Moderate')) as in_recovery,     -- count number of stable based on last status
count(distinct admission_id) filter(where positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') and health_state = 'Critical') as in_critical,     -- count number of critical based on last status
count(distinct admission_id) filter(where positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') and health_state in ('Mild','Stable-Mild')) as in_mild,             -- count number of mild based on last status
count(distinct admission_id) filter(where positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') and health_state = 'Asymptomatic') as in_asymptomatic, -- count number of Asymptomatic based on last status
count(distinct admission_id) filter(where positive_member = 1 and cad_status = 'DISCHARGE' and discharge_date is not null) as discharge,                 -- count number of discharge (only count positive cases)
count(distinct admission_id) filter(where positive_member = 1 and cad_status = 'DISCHARGE' and cast(discharge_date as date) = cast(now() as date)) as todays_discharge,  -- count number of today discharge (only consider positive cases)
count(distinct admission_id) filter(where positive_member = 1 and cad_status = 'DEATH') as death,                                     -- count number of death
count(distinct admission_id) filter(where cast(postive_date as date) = cast(now() as date)) as todays_positive,                         -- count number of positive cases today only
count(distinct admission_id) filter(where positive_member = 1 and cad_status = 'DEATH' and cast( discharge_date  as date) = cast(now() as date)) as todays_death,                             -- count death, today only
count(distinct admission_id) filter(where cast( last_test_before_admission  as date) = cast(now() as date)) as todays_test              -- consider today test but based on before the admission
from
covid19_admission_analytics_details_t
where location_id is not null
group by location_id;


-- create healhinfra wise analytics details

drop table if exists healthinfra_wise_analytics_details_t;
with member_with_no_infra as (
    select sum( case when positive_member = 1 then 1 else 0 end) positive_with_no_health_infra from covid19_admission_analytics_details_t
    where health_infra_id is null
)
,member_details  as(
	select
	health.id as health_infra_id,
	sum( caad.no_of_test ) tests,
	sum(case when caad.no_of_test > 0 then 1 else 0 end ) as member_tested,
	sum( case when caad.positive_member = 1 then 1 else 0 end) positive,
	sum(case when caad.cad_status = 'DEATH' and caad.positive_member = 1 then 1 else 0 end ) death,
	sum(case when caad.cad_status = 'SUSPECT' then 1 else 0 end ) suspected,
	sum(case when caad.cad_status = 'DISCHARGE' and caad.positive_member = 1 then 1 else 0 end ) discharge,
	sum( case when caad.health_state in ('Stable','Stable-Moderate') and positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') then 1 else 0 end ) stable_moderate,
	sum( case when caad.health_state in ('Mild','Stable-Mild') and positive_member = 1 and cad_status not in ('DISCHARGE','DEATH')then 1  else 0 end ) mild,
	sum( case when caad.health_state = 'Critical' and positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') then 1 else 0 end ) critical,
	sum( case when caad.health_state = 'Asymptomatic' and positive_member = 1 and cad_status not in ('DISCHARGE','DEATH') then 1 else 0 end ) asymptomatic,
	sum(case when caad.positive_member = 1 and caad.cad_status not in ('DISCHARGE','DEATH') then 1 else 0 end ) as active_cases,
	sum(case when caad.positive_member = 1 and caad.currently_on_ventilator =1 then 1 else 0 end ) as on_vantiltor_cases
	from health_infrastructure_details health left join covid19_admission_analytics_details_t caad on health.id = caad.health_infra_id
	where (health.is_covid_lab or health.is_covid_hospital)
	group by health.id
),
lab_test_details as (
	select sample_health_infra_send_to as id,
	count(1) as total_sample_tested,
	count(1) filter (where cast(lab_result_entry_on as date) = current_date) as total_sample_tested_today
	--count(distinct covid_admission_detail_id) as total_member_tested
	from covid19_lab_test_detail where sample_health_infra_send_to is not null and lab_result_entry_on is not null
	group by sample_health_infra_send_to
),
lab_total_member_tested_unique as (
    select max(sample_health_infra_send_to) as sample_health_infra_send_to,covid_admission_detail_id  from covid19_lab_test_detail
    where sample_health_infra_send_to is not null and lab_result_entry_on is not null
	group by covid_admission_detail_id

),
lab_total_member_tested as (
    select count(distinct covid_admission_detail_id) as total_member_tested,
    sample_health_infra_send_to as id
    from lab_total_member_tested_unique
    group by sample_health_infra_send_to
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
    details.no_of_ppe as no_of_ppe,
	details.is_covid_hospital as isCovidHospital
	from health_infrastructure_details details inner join infra_info info  on info.infra_id = details.id

),new_added_ppe as (
    select
        infra_id,
        coalesce(sum(case when cast(hwd.modified_on as date) = cast(now() as date) then hwd.no_of_ppe else 0 end),0) - coalesce(sum(
        case when cast(hwd.modified_on as date) = cast(now() as date) then
        (select hiwdh.no_of_ppe   from health_infrastructure_details_history hiwdh
        where cast(hiwdh.created_on as date) <= cast(now() - interval '1 day' as date)
        and hiwdh.health_infrastructure_details_id = hwd.id order by hiwdh.created_by desc limit 1
        ) else 0 end),0) as new_added_ppe
    from infra_info hid
    left join health_infrastructure_details_history hwd on hid.infra_id = hwd.health_infrastructure_details_id
    group by hid.infra_id
),
new_added_vantilatos_beds as (select
	infra_id,
	coalesce(sum(case when cast(hwd.modified_on as date) = cast(now() as date) then hwd.number_of_beds else 0 end),0) - coalesce(sum(
	case when cast(hwd.modified_on as date) = cast(now() as date) then
	(select hiwdh.number_of_beds   from health_infrastructure_ward_details_history hiwdh
	where cast(hiwdh.created_on as date) <= cast(now() - interval '1 day' as date)
	and hiwdh.health_infrastructure_ward_details_id = hwd.id order by hiwdh.created_by desc limit 1
	) else 0 end),0) as new_beds,

	coalesce(sum(case when cast(hwd.modified_on as date) = cast(now() as date) then hwd.number_of_ventilators_type1 else 0 end ),0) - coalesce(sum(
	case when cast(hwd.modified_on as date) = cast(now() as date) then
	(select hiwdh.number_of_ventilators_type1   from health_infrastructure_ward_details_history hiwdh
	where cast(hiwdh.created_on as date) <= cast(now() - interval '1 day' as date)
	and hiwdh.health_infrastructure_ward_details_id = hwd.id order by hiwdh.created_by desc limit 1
	) else 0 end
	),0) as new_ventilator
	from infra_info hid
	left join health_infrastructure_ward_details hwd on hid.infra_id = hwd.health_infra_id
	group by hid.infra_id
),
final_details as (
	select members.*,
	(members.positive + members.death  + members.discharge + members.suspected) as in_patinets,
	infa.name as name,
	infa.isCovidLab as is_covid19_lab,
	infa.isCovidHospital as is_covid19_hospital,
	lab_infra_details.total_sample_tested as total_sample_tested,
	lab_infra_details.total_sample_tested_today as total_sample_tested_today,
 	total_member_tested.total_member_tested as total_member_tested,

	infa.number_of_beds as total_beds,
	case when infa.number_of_beds = 0 or infa.number_of_beds is null then 0 else  round(cast(((members.active_cases*100/cast(infa.number_of_beds as float))) as numeric),2) end as beds_ratio,
	members.active_cases as occupied_bed,
	infa.number_of_beds - members.active_cases as available_bed,
	vantilatos_beds.new_beds as new_added_bed,
	infa.number_of_ventilators as total_ventilator,
    infa.no_of_ppe as new_ppe,
    0 as consumed_ppe,
    ppe_detail.new_added_ppe,
	case when infa.number_of_ventilators = 0 or infa.number_of_ventilators is null then 0 else  round(cast(((members.on_vantiltor_cases*100/cast(infa.number_of_ventilators as float))) as numeric),2) end as ventilator_ratio,

	members.on_vantiltor_cases as occupied_ventilator,
	infa.number_of_ventilators - members.on_vantiltor_cases as available_ventilator,
	vantilatos_beds.new_ventilator as new_added_ventilator,
    member_with_no_infra.positive_with_no_health_infra as member_with_no_infra
	from member_details members  left join infra_info_details infa on infa.infra_id = members.health_infra_id
	left join new_added_vantilatos_beds  vantilatos_beds on vantilatos_beds.infra_id =infa.infra_id
	left join lab_test_details lab_infra_details on infa.infra_id = lab_infra_details.id
	left join lab_total_member_tested total_member_tested on infa.infra_id = total_member_tested.id
    left join new_added_ppe ppe_detail on ppe_detail.infra_id = infa.infra_id
    left join member_with_no_infra on true 
)
select * into healthinfra_wise_analytics_details_t from final_details det;

ALTER TABLE healthinfra_wise_analytics_details_t ADD PRIMARY KEY (health_infra_id);



-- create health infra wise analytics details end



-- value total case
-- male todays positive
-- female todays death
-- chart1 critical
-- chart2 stable
-- chart3 mild
-- chart4 asymptomatic
-- chart5 in treatment
-- chart6 discharged /recovered
-- chart7 dead
-- chart8 positive
-- chart9 suspected
-- chart10 hospital


drop table if exists soh_timeline_analytics_t4;

create TABLE public.soh_timeline_analytics_t4
(
	location_id integer NOT NULL,
	element_name text NOT NULL,
	target double precision,
	male integer,
	female integer,
	chart1 double precision,
	chart2 double precision,
	chart3 double precision,
	chart4 double precision,
    chart5 double precision,
    chart6 double precision,
    chart7 double precision,
    chart8 double precision,
    chart9 double precision,
    chart10 double precision,
    chart11 double precision,
    chart12 double precision,
    chart13 double precision,
    chart14 double precision,
    chart15 double precision,
	value double precision,
	timeline_type character varying(50) NOT NULL,
	created_on timestamp without time zone,
	reporting varchar(255),
	calculatedTarget NUMERIC(12,2),
	color varchar(255),
	percentage NUMERIC(12,2),
	displayValue text,
	days integer,
	sortPriority integer,
	PRIMARY KEY (location_id, element_name, timeline_type)
);

with covid19_result as (
select CAST(clwa.location_id as integer) as location_id,
    intervals.timeline_type,
	sum(total_case) as value1,
	sum(todays_positive) as male,       -- today positive
	sum(todays_death) as female,        -- today death

	sum(in_critical) as chart1,         -- in critical
	sum(in_recovery) as chart2,         -- in recovery, stable
    sum(in_mild) as chart3,             -- in mild
    sum(in_asymptomatic) as chart4,     -- in asymptomatic
    sum(in_treatment) as chart5,        -- in treatment

	sum(discharge) as chart6,           -- total discharge
	sum(death) as chart7,               -- total death
	sum(positive_member) as chart8,     -- total positive
	sum(suspected) as chart9,            -- suspected
	sum(todays_discharge) as chart11,    -- today discharge
	sum(todays_test) as chart12,         -- today tested (It will consider first time tested)
    sum(total_test) as chart13,           -- total tested (It will consider all the test)
    sum(total_member_tested) as chart15

from covid19_location_wise_analytics_t clwa
inner join intervals on true
group by clwa.location_id,intervals.timeline_type
), phc_wise_analytics as (
    select lch.parent_id as loc_id, sum(lwa.fhs_total_member) as fhs_total_member from 
    location_hierchy_closer_det lch 
    inner join location_wise_analytics lwa on lwa.loc_id = lch.child_id
    where lch.parent_id in (
    select lm.id from location_master lm 
    where lm.type in ('D', 'C'))
    group by lch.parent_id
),
total_covid19_final as (
    select analytics.loc_id as analytics_location_id ,
		intervals.timeline_type,
		max(details.value1) as value1,
		max(details.chart1) as chart1,
		max(details.chart2) as chart2,
        max(details.chart3) as chart3,
        max(details.chart4) as chart4,
        max(details.chart5) as chart5,
		max(details.chart6) as chart6,
		max(details.chart7) as chart7,
		max(details.chart8) as chart8,
		max(details.chart9) as chart9,
		max(details.chart1 + details.chart2 + details.chart3 + details.chart4) as chart10,
		max(details.chart11) as chart11,
		max(details.chart12) as chart12,
		max(details.chart13) as chart13,
		max(details.chart15) as chart15,

		max(details.male) as male,
		max(details.female) as female,
        max(analytics.fhs_total_member) as chart14
		from phc_wise_analytics analytics
		inner join location_master lm on analytics.loc_id = lm.id
    	inner join intervals on true
		left join covid19_result details on analytics.loc_id = details.location_id and intervals.timeline_type  = details.timeline_type
		where lm.type in ('D', 'C')
    	group by analytics.loc_id, intervals.timeline_type
)
insert into soh_timeline_analytics_t4(location_id,target,element_name,value,chart1,chart2,chart3,chart4,chart5,chart6,chart7, chart8, chart9, chart10, chart11,chart12, chart13, chart14, chart15, male, female, timeline_type,created_on)
select analytics_location_id,8,CAST('COVID19_RESPONSE' as text) as "elementName",value1,chart1,chart2,chart3,chart4,chart5, chart6, chart7, chart8, chart9, chart10,chart11,chart12,chart13, chart14, chart15 , male, female, timeline_type,now()
from total_covid19_final where analytics_location_id != -1 and  analytics_location_id is not null;



insert into soh_timeline_analytics_t4(location_id,element_name,timeline_type,value,target,male,female,chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8,chart9, chart10, chart11, chart12,chart13,chart14,chart15,created_on)
select l.id ,element_name, sh.timeline_type,
sum(value) as value,
target,sum(male) as male,
sum(female) as female,
sum(chart1) as chart1,
sum(chart2) as chart2,
sum(chart3) as chart3,
sum(chart4) as chart4,
sum(chart5) as chart5,
sum(chart6) as chart6,
sum(chart7) as chart7,
sum(chart8) as chart8,
sum(chart9) as chart9,
sum(chart10) as chart10,
sum(chart11) as chart11,
sum(chart12) as chart12,
sum(chart13) as chart13,
sum(chart14) as chart14,
sum(chart15) as chart15,
now()
from soh_timeline_analytics_t4 sh,location_master l,location_hierchy_closer_det lh where lh.child_id = sh.location_id and lh.parent_id in(
(select id from location_master  where type in (select type from location_type_master where level!=8)))
and lh.parent_id = l.id and not exists (select * from soh_timeline_analytics_t4 where location_id = l.id and element_name =  sh.element_name and timeline_type = sh.timeline_type)
group by
sh.target,l.id,sh.timeline_type ,l.english_name,sh.element_name;



update soh_timeline_analytics_t4 current
set color =
   CASE
      WHEN current.chart8 is null or current.chart8 = 0 then '#ffd1dc'
      WHEN ((current.chart8/(current.chart14/1000000.0))*1) > 50 then '#ff1493'
      WHEN ((current.chart8/(current.chart14/1000000.0))*1) > 40 and ((current.chart8/(current.chart14/1000000.0))*1) <= 50 then '#ff69b4'
      WHEN ((current.chart8/(current.chart14/1000000.0))*1) > 25 and ((current.chart8/(current.chart14/1000000.0))*1) <= 40 then '#fc8eac'
      WHEN ((current.chart8/(current.chart14/1000000.0))*1) > 10 and ((current.chart8/(current.chart14/1000000.0))*1) <= 25 then '#ffa6c9'
      WHEN ((current.chart8/(current.chart14/1000000.0))*1) > 0  and ((current.chart8/(current.chart14/1000000.0))*1) <= 10 then '#FFB6C1'
      ELSE '#ffd1dc'
   end;

delete from soh_timeline_analytics_temp where element_name = 'COVID19_RESPONSE' and location_id in (select id from location_master where type in ('S','D','C','P','U','Z','B','R'));

/*
delete from soh_timeline_analytics_temp where element_name = 'COVID19_RESPONSE' and
timeline_type = 'YESTERDAY' and location_id in (select id from location_master);

delete from soh_timeline_analytics_temp where element_name = 'COVID19_RESPONSE' and
timeline_type = 'LAST_7_DAYS' and location_id in (select id from location_master);

delete from soh_timeline_analytics_temp where element_name = 'COVID19_RESPONSE' and
timeline_type = 'LAST_30_DAYS' and location_id in (select id from location_master);

delete from soh_timeline_analytics_temp where element_name = 'COVID19_RESPONSE' and
timeline_type = 'LAST_365_DAYS' and location_id in (select id from location_master);
*/

with member_with_no_location as (
    select count(distinct cltd.id) filter(where case when cltd.id is not null and (cltd.lab_result_entry_on is not null ) then true else false end ) as no_of_test 
    from covid19_admission_detail cad left join covid19_lab_test_detail cltd 
    on cltd.covid_admission_detail_id = cad.id where cad.location_id is null
), total_member_tested_with_no_location_id as (
   select count(distinct admission_id) filter (where no_of_test > 0) total_member_tested
    from covid19_admission_analytics_details_t
    where location_id is null
)
update soh_timeline_analytics_t4 current
set chart13 = current.chart13 + (select no_of_test from member_with_no_location),
chart15 = current.chart15 + (select total_member_tested from total_member_tested_with_no_location_id)
where current.element_name = 'COVID19_RESPONSE' and current.location_id = 2;

insert into soh_timeline_analytics_temp (location_id,element_name,target,male,female,chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8, chart9,chart10,chart11,chart12,chart13,chart14,chart15,value,timeline_type,created_on,reporting,calculatedTarget,color,percentage,displayValue,days,sortPriority)
select location_id,element_name,target,male,female,chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8,chart9,chart10,chart11,chart12,chart13,chart14,chart15,value,timeline_type,created_on,reporting,calculatedTarget,color,percentage,displayValue,days,sortPriority from soh_timeline_analytics_t4;



-- create tables

drop table if exists zzz_soh_timeline_analytics_t3;
create TABLE public.zzz_soh_timeline_analytics_t3
(
    location_id integer NOT NULL,
    element_name text NOT NULL,
    target double precision,
    male integer,
    female integer,
    chart1 double precision,
    chart2 double precision,
    chart3 double precision,
    chart4 double precision,
    chart5 double precision,
    chart6 double precision,
    chart7 double precision,
    chart8 double precision,
    chart9 double precision,
    chart10 double precision,
    chart11 double precision,
    chart12 double precision,
    chart13 double precision,
    chart14 double precision,
    chart15 double precision,
    value double precision,
    timeline_type character varying(50) NOT NULL,
    timeline_sub_type  text,
    created_on timestamp without time zone,
    reporting varchar(255),
    calculatedTarget NUMERIC(12,2),
    color varchar(255),
    percentage NUMERIC(12,2),
    displayValue text,
    days integer,
    sortPriority integer,
    PRIMARY KEY (location_id, element_name, timeline_type,timeline_sub_type)
);

drop table if exists zzz_intervals_t;
select * into zzz_intervals_t from (
    with days_from_finacial_year as (
        select date(generate_series(cast('2020-03-19' as date), current_date, '1 day')) as from_to_date
    )
    select
    from_to_date as from_date,
    from_to_date as to_date,
    cast(from_to_date as text) as timeline_type,
    'DATE' as timeline_sub_type
    from days_from_finacial_year
) as t;
drop table if exists zzz_cumulative_intervals_t;
select * into zzz_cumulative_intervals_t from (
    with set_from_date as (
        select cast('2020-03-19' as date) as from_date
    ),
    dates_from_from_date as (
        select date(generate_series((select from_date from set_from_date), current_date, '1 day')) as to_date
    )
    select
    (select from_date from set_from_date) as from_date,
    to_date as to_date,
    cast(to_date as text) as timeline_type,
    'DATE' as timeline_sub_type
    from dates_from_from_date
) as t;

-- insert query

with covid19_result as (
    select
    CAST(analytics.location_id as integer) as analytics_location_id,
    sum(case when positive_member=1 and cad_status = 'DEATH' and cast(discharge_date as date) between intervals.from_date and intervals.to_date then 1 else 0 end) as number_of_death,
    sum(case when positive_member=1 and cad_status = 'DISCHARGE' and cast(discharge_date as date) between intervals.from_date and intervals.to_date then 1 else 0 end) as number_of_discharge,
    sum(case when positive_member=1 and cast(postive_date as date) between intervals.from_date and intervals.to_date then 1 else 0 end) as number_of_positive,
    sum(case when positive_member=1 and (cad_status not in ('DISCHARGE','DEATH') or intervals.from_date < cast(discharge_date as date)) and cast(postive_date as date) <= cast(intervals.from_date as date) then 1 else 0 end ) as active_cases,
    intervals.timeline_type
    from covid19_admission_analytics_details_t analytics
    inner join zzz_intervals_t intervals on true
    group by analytics.location_id,intervals.timeline_type
),
covid19_cumulative_result as (
    select
    CAST(analytics.location_id as integer) as analytics_location_id,
    sum(case when positive_member=1 and cad_status = 'DEATH' and cast(discharge_date as date) between intervals.from_date and intervals.to_date then 1 else 0 end) as number_of_death,
    sum(case when positive_member=1 and cad_status = 'DISCHARGE' and cast(discharge_date as date) between intervals.from_date and intervals.to_date then 1 else 0 end) as number_of_discharge,
    sum(case when positive_member=1 and cast(postive_date as date) between intervals.from_date and intervals.to_date then 1 else 0 end) as number_of_positive,
    ROUND(CAST((3 * POWER(CBRT(2), (intervals.to_date - intervals.from_date))) AS NUMERIC), 2) as formulated_number_of_positive,
    intervals.timeline_type
    from covid19_admission_analytics_details_t analytics
    inner join zzz_cumulative_intervals_t intervals on true
    group by analytics.location_id,intervals.timeline_type,intervals.to_date,intervals.from_date
),
covid19_test_people_tests as (

    select covid_admission_detail_id , max(lab_result_entry_on) as last_lab_date  from covid19_lab_test_detail
    where lab_result_entry_on is not null
    group by covid_admission_detail_id
),
covid19_tests as (

    select count(1) filter (where cast(tests.last_lab_date as date) between intervals.from_date and intervals.to_date) as sample_tested,
    intervals.timeline_type,
    detail.location_id
	from covid19_test_people_tests tests inner join covid19_admission_analytics_details_t detail on tests.covid_admission_detail_id = detail.admission_id
	inner join zzz_intervals_t intervals on true
	group by detail.location_id,intervals.timeline_type

),
covis19_status_result as (
    select
    details.location_id,
    intervals.timeline_type,
    count (distinct details.admission_id) filter (where details.positive_member=1 and daily_state.health_status = 'Stable' and daily_state.service_date between intervals.from_date and intervals.to_date) as Stable,
    count (distinct details.admission_id) filter (where details.positive_member=1 and daily_state.health_status = 'Critical' and daily_state.service_date between intervals.from_date and intervals.to_date) as Critical,
    count (distinct details.admission_id) filter (where details.positive_member=1 and daily_state.health_status = 'Mild' and daily_state.service_date between intervals.from_date and intervals.to_date) as Mild,
    count (distinct details.admission_id) filter (where details.positive_member=1 and daily_state.health_status = 'Asymptomatic' and daily_state.service_date between intervals.from_date and intervals.to_date) as Asymptomatic
    from covid19_admitted_case_daily_status daily_state inner join covid19_admission_analytics_details_t details on daily_state.admission_id = details.admission_id
    inner join zzz_intervals_t intervals on true
    group by details.location_id,intervals.timeline_type
),
total_covid19_final as (
    select
    cumulative_result.analytics_location_id as location_id,
    cumulative_result.timeline_type,
    to_char (cast(cumulative_result.timeline_type as date),'DD-MM-YYYY') as displayValue,
    result.number_of_discharge as chart6,
    result.number_of_death as chart7,
    result.number_of_positive as chart8,
    cumulative_result.number_of_discharge as chart9,
    cumulative_result.number_of_death as chart10,
    cumulative_result.number_of_positive as chart11,
    cumulative_result.formulated_number_of_positive as chart12,
    result.active_cases as chart14,
    tests.sample_tested as chart13,
    0 as chart1,
    0 as chart2,
    0 as chart3,
    0 as chart4
    from covid19_cumulative_result cumulative_result
    left join covid19_result result on cumulative_result.timeline_type = result.timeline_type and cumulative_result.analytics_location_id = result.analytics_location_id
    left join covid19_tests tests on tests.timeline_type = result.timeline_type and tests.location_id = cumulative_result.analytics_location_id
    --inner join covis19_status_result status on result.analytics_location_id = status.location_id
    --where result.timeline_type = status.timeline_type
)
insert into zzz_soh_timeline_analytics_t3(location_id,target,element_name,timeline_type,chart6,chart7,chart8,chart9,chart10,chart11,chart12,chart13,chart14,chart1,chart2,chart3,chart4,created_on,timeline_sub_type,displayValue)
select location_id,8,CAST('COVID19_RESPONSE' as text) as "elementName",timeline_type,chart6,chart7,chart8,chart9,chart10,chart11,chart12,chart13,chart14,chart1,chart2,chart3,chart4,now(),'DAY',displayValue

from total_covid19_final where location_id != -1 and location_id is not null;


drop table if exists zzz_intervals_t1;
select * into zzz_intervals_t1 from (
    with days_from_finacial_year as (
        select date(current_date - generate_series(1,23,1)) as from_to_date
    )
    select
    from_to_date as from_date,
    from_to_date as to_date,
    cast(from_to_date as text) as timeline_type,
    'DATE' as timeline_sub_type
    from days_from_finacial_year
) as t;
insert into zzz_intervals_t1(from_date,to_date,timeline_type,timeline_sub_type)
values ( now()-interval '3 month',now() - interval '24 days',cast(now()- interval '24 days' as date),'DATE');

-- insert query

with
covis19_status_result as (
    select
    details.location_id,
    intervals.timeline_type,
    count (distinct details.admission_id) filter (where details.positive_member=1 and details.cad_status not in ('DISCHARGE','DEATH') and  details.health_state in ('Stable','Stable-Moderate') and cast(details.admission_date as date) between intervals.from_date and intervals.to_date) as Stable,
    count (distinct details.admission_id) filter (where details.positive_member=1 and details.cad_status not in ('DISCHARGE','DEATH') and details.health_state = 'Critical' and cast(details.admission_date as date) between intervals.from_date and intervals.to_date) as Critical,
    count (distinct details.admission_id) filter (where details.positive_member=1 and details.cad_status not in ('DISCHARGE','DEATH') and details.health_state in ('Mild','Stable-Mild') and cast(details.admission_date as date) between intervals.from_date and intervals.to_date) as Mild,
    count (distinct details.admission_id) filter (where details.positive_member=1 and details.cad_status not in ('DISCHARGE','DEATH') and details.health_state = 'Asymptomatic' and cast(details.admission_date as date) between intervals.from_date and intervals.to_date) as Asymptomatic
    from covid19_admission_analytics_details_t details
    inner join zzz_intervals_t1 intervals on true
    group by details.location_id,intervals.timeline_type
),
total_covid19_final as (
    select
    status.location_id as location_id,
    status.timeline_type,
    status.Stable as chart1,
    status.Critical as chart2,
    status.Mild as chart3,
    status.Asymptomatic as chart4
    from covis19_status_result status
)
insert into zzz_soh_timeline_analytics_t3(location_id,target,element_name,timeline_type,chart1,chart2,chart3,chart4,created_on,timeline_sub_type)
select location_id,8,CAST('COVID19_RESPONSE_ACTIVE_CASE' as text) as "elementName",timeline_type,chart1,chart2,chart3,chart4,now(),'DAY_15'
from total_covid19_final where location_id != -1 and location_id is not null;

insert into zzz_soh_timeline_analytics_t3(location_id,element_name,timeline_type,timeline_sub_type,value,target,male,female,chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8,chart9, chart10, chart11, chart12,chart13,chart14,chart15,created_on,displayValue)
select l.id ,element_name, sh.timeline_type, sh.timeline_sub_type,
sum(value) as value,
target,sum(male) as male,
sum(female) as female,
sum(chart1) as chart1,
sum(chart2) as chart2,
sum(chart3) as chart3,
sum(chart4) as chart4,
sum(chart5) as chart5,
sum(chart6) as chart6,
sum(chart7) as chart7,
sum(chart8) as chart8,
sum(chart9) as chart9,
sum(chart10) as chart10,
sum(chart11) as chart11,
max(chart12) as chart12,      -- we will not sum this field
sum(chart13) as chart13,
sum(chart14) as chart14,
sum(chart15) as chart15,
now(),
max(displayValue) as displayValue
from zzz_soh_timeline_analytics_t3 sh,location_master l,location_hierchy_closer_det lh where lh.child_id = sh.location_id and lh.parent_id in(
(select id from location_master  where type in (select type from location_type_master where level!=8)))
and lh.parent_id = l.id and not exists (select * from zzz_soh_timeline_analytics_t3 where location_id = l.id and element_name =  sh.element_name and timeline_type = sh.timeline_type and  timeline_sub_type = sh.timeline_sub_type)
and location_id is not null
group by
sh.target,l.id,sh.timeline_type, sh.timeline_sub_type,l.english_name,sh.element_name;

delete from soh_timeline_analytics where element_name in('COVID19_RESPONSE','COVID19_RESPONSE_ACTIVE_CASE');

insert into soh_timeline_analytics (location_id,element_name,target,male,female,chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8, chart9,chart10,chart11,chart12,chart13,chart14,chart15,value,timeline_type,timeline_sub_type,created_on,reporting,calculatedTarget,color,percentage,displayValue,days,sortPriority)
select location_id,element_name,target,male,female,chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8,chart9,chart10,chart11,chart12,chart13,chart14,chart15,value,timeline_type,timeline_sub_type,created_on,reporting,calculatedTarget,color,percentage,displayValue,days,sortPriority from zzz_soh_timeline_analytics_t3;

-- drop tables

drop table if exists zzz_soh_timeline_analytics_t3;
drop table if exists zzz_intervals_t1;
drop table if exists zzz_intervals_t;
drop table if exists zzz_cumulative_intervals_t;

drop table if exists covid19_admission_analytics_details;
alter table covid19_admission_analytics_details_t
rename to covid19_admission_analytics_details;

drop table if exists covid19_location_wise_analytics;
alter table covid19_location_wise_analytics_t
rename to covid19_location_wise_analytics;

drop table if exists covid19_healthinfra_wise_analytics_details;
alter table healthinfra_wise_analytics_details_t
rename to covid19_healthinfra_wise_analytics_details;

commit;
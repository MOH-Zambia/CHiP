-- NEW QUERY

begin;
drop table if exists soh_timeline_analytics_chart_t;

create TABLE public.soh_timeline_analytics_chart_t
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
  timeline_sub_type character varying(50),
  PRIMARY KEY (location_id, timeline_type,element_name)
);

commit;

begin;
drop table if exists  intervals;
select * into  intervals from (
	with parameters as(
	select
	    to_date(concat('04-01-',CASE WHEN date_part('Month', current_date ) >= 4
	THEN date_part('year', current_date )
	    ELSE date_part('year', current_date ) - 1
	END),'MM-DD-YYYY') as finacial_year_start_date
	),
	last_11_months as (
		select date(generate_series(date_trunc('month', current_date) - interval '1 YEAR', date_trunc('month', current_date - interval '2 month'), '1 month')) as d_month
	)
	select cast(date(date_trunc('month', d_month)) as timestamp) as from_date,
	date(date_trunc('month', d_month) + interval '1 month' - interval '1 day') + interval '1 day' - interval '1 millisecond' as to_date,
	cast(date(date_trunc('month', d_month)) as text) as timeline_type, 'DATE' as timeline_sub_type
    from last_11_months m
	
    union all
	select cast(date(date_trunc('month', current_date - interval '1 month')) as timestamp) as from_date,
	date(date_trunc('month', current_date - interval '1 month') + interval '1 month' - interval '1 day') + interval '1 day' - interval '1 millisecond' as to_date,
    cast(date(date_trunc('month', current_date - interval '1 month')) as text) as timeline_type,
    'DATE' as timeline_sub_type
    
     union all
    select (current_date - interval '1 days') as from_date, current_date + interval '1 day' - interval '1 millisecond'  as to_date , 'YESTERDAY' as timeline_type, 'PERIOD' as timeline_sub_type
    union all
    select (current_date - interval '7 days') as from_date, current_date + interval '1 day' - interval '1 millisecond' as to_date, 'LAST_7_DAYS' as timeline_type, 'PERIOD' as timeline_sub_type
    union all
    select (current_date - interval '30 days') as from_date, current_date + interval '1 day' - interval '1 millisecond' as to_date, 'LAST_30_DAYS' as timeline_type, 'PERIOD' as timeline_sub_type
    union all
    select (current_date - interval '365 days') as from_date, current_date + interval '1 day' - interval '1 millisecond' as to_date, 'LAST_365_DAYS' as timeline_type, 'PERIOD' as timeline_sub_type
    union all
    select (current_date - (extract(day from now() -(select finacial_year_start_date from parameters))) * interval '1 day') as from_date, 
    current_date + interval '1 day' - interval '1 millisecond' as to_date,
    'YEAR_04_2019' as timeline_type, 'PERIOD' as timeline_sub_type
) as t;
commit;

--MMR
/*
    value - Total deaths
    chart1 - Total live birth
    target - target
*/
begin;
with total_deaths as (
	select CAST(location_master.id as integer) as member_current_location_id,
    intervals.timeline_type,
	sum(case when death_date between intervals.from_date and intervals.to_date and maternal_detah then 1 else 0 end) as yesterday,

	sum(case when date_of_delivery between intervals.from_date and intervals.to_date and delivery_outcome = 'LBIRTH' then total_out_come else 0 end) as yesterday_live_birth

    from location_master
    left join rch_pregnancy_analytics_details on death_location_id = location_master.id
    inner join intervals on true
    where location_master.type in ('AA','A','V','ANG')
    group by location_master.id,intervals.timeline_type
),
total_deaths_timeline as (
	select member_current_location_id,  yesterday as value,  yesterday_live_birth as chart1, timeline_type AS timeline_type from total_deaths
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,timeline_type, created_on)
select member_current_location_id,CAST('MMR' as text) as "elementName",60,value,chart1,timeline_type,now()
from total_deaths_timeline where member_current_location_id != -1;
commit;


-- LIVE BIRTH

begin;
with
total_deaths as (select CAST(delivery_location_id as integer) as loc_id,
intervals.timeline_type,
sum(case when dob between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday_birth

from rch_child_analytics_details
inner join intervals on true
where member_id is not null
group by delivery_location_id,intervals.timeline_type ),
total_deaths_timeline as (
	select loc_id, yesterday_birth as chart1, timeline_type AS timeline_type from total_deaths
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,chart1,timeline_type,created_on)
select loc_id,CAST('LIVE_BIRTH' as text) as "elementName",30,chart1,timeline_type,now()
from total_deaths_timeline where loc_id != -1;
commit;



--IMR

/*
    value - Total deaths
    chart1 - Total live birth
    target - target
*/

begin;
with
total_deaths as (select CAST(location_master.id as integer) as loc_id,
intervals.timeline_type,
sum(case when death_date between intervals.from_date and intervals.to_date and member_id is not null AND is_infant_death then 1 else 0 end) as yesterday,
sum(case when dob between intervals.from_date and intervals.to_date AND member_id is not null then 1 else 0 end) as yesterday_birth

from location_master
   left join rch_child_analytics_details on death_location_id = location_master.id
   inner join intervals on true
   where location_master.type in ('AA','A','V','ANG')
-- and member_id is not null
   group by location_master.id,intervals.timeline_type
),
total_deaths_timeline as (
	select loc_id,  yesterday as value, yesterday_birth as chart1, timeline_type AS timeline_type from total_deaths
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,timeline_type,created_on)
select loc_id,CAST('IMR' as text) as "elementName",20,value,chart1,timeline_type,now()
from total_deaths_timeline where loc_id != -1;
commit;



--SEX RATIO

/*
    value - Total live birth
    male - Total male
    female - Total female
    target - target
*/

begin;
with total_births as (select CAST(delivery_location_id as integer) as loc_id,
intervals.timeline_type,
sum(case when dob between intervals.from_date and intervals.to_date and gender in ('M','F') then 1 else 0 end) as yesterday,
sum(case when dob between intervals.from_date and intervals.to_date and gender = 'M' then 1 else 0 end) as yesterday_total_male,
sum(case when dob between intervals.from_date and intervals.to_date and gender = 'F' then 1 else 0 end) as yesterday_total_female

from rch_child_analytics_details analytics
inner join intervals on true
where member_id is not null group by delivery_location_id,intervals.timeline_type ),
total_births_timeline as (
	select loc_id, yesterday as value, yesterday_total_male as male, yesterday_total_female as female, timeline_type AS timeline_type from total_births
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,value,timeline_type,target,male,female,created_on)
select loc_id,CAST('SR' as text),value,timeline_type,854,male,female,now()
from total_births_timeline where loc_id != -1;
commit;

--ANEMIA

/*
    chart1 - HB less than 7
    chart2 -  HB between =7 and =8.9
    chart3 - HB between =9 and =10.9
    char4 - HB greater than =11
    target - target
*/

begin;
with total_pregnant_women as (select CAST(member_current_location_id as integer) as member_current_location_id,
    intervals.timeline_type,
	sum(case when haemoglobin_count < 7 and preg_reg_state in ('PENDING','PREGNANT') and anc.created_on between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday_chart1,
	sum(case when haemoglobin_count >= 7 and haemoglobin_count <=9.99 and preg_reg_state in ('PENDING','PREGNANT') and anc.created_on between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday_chart2,
	sum(case when haemoglobin_count >= 10 and haemoglobin_count <=10.99 and preg_reg_state in ('PENDING','PREGNANT') and anc.created_on between intervals.from_date and intervals.to_date then 1 else 0 end)  as yesterday_chart3,
	sum(case when haemoglobin_count >= 11 and preg_reg_state in ('PENDING','PREGNANT') and anc.created_on between intervals.from_date and intervals.to_date then 1 else 0 end)  as yesterday_chart4

from rch_pregnancy_analytics_details preg
inner join rch_anc_master anc on preg.member_id = anc.member_id
inner join intervals on true
 where
anc.created_on = (select max(created_on) from rch_anc_master  where member_id = preg.member_id) group by member_current_location_id,intervals.timeline_type ),
total_births_timeline as (
	select member_current_location_id, yesterday_chart1 as chart1, yesterday_chart2 as chart2, yesterday_chart3 as chart3, yesterday_chart4 as chart4, timeline_type AS timeline_type from total_pregnant_women
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,chart1,chart2,chart3,chart4,created_on,timeline_type)
select member_current_location_id,CAST('Anemia' as text) as "elementName",1.5 as "target",chart1,chart2,chart3,chart4,now(),timeline_type
from total_births_timeline where member_current_location_id != -1;
commit;

--SAM

/*
    value - Total SAM
    chart1 - Total services
    chart2 -  Total MAM
    chart3 - Normal Child
    target - target
*/
begin;
with
total_sams as (select CAST(loc_id as integer) as loc_id,
intervals.timeline_type,
sum(case when sam_child_date between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday,
sum(case when dob <= current_date - interval '6 months' and last_child_service_date between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday_chart1,
sum(case when mam_child_date between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday_chart2,
sum(case when sam_child_normal_date between intervals.from_date and intervals.to_date then 1 else 0 end) as yesterday_chart3

from rch_child_analytics_details analytics
inner join intervals on true
 group by loc_id, intervals.timeline_type),
total_sams_timeline as (
	select loc_id, yesterday as value, yesterday_chart1 as chart1, yesterday_chart2 as chart2, yesterday_chart3 as chart3 ,timeline_type AS timeline_type from total_sams
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1, chart2, chart3,timeline_type,created_on)
select loc_id,CAST('SAM' as text) as "elementName",9.5,value,chart1,chart2, chart3,timeline_type,now() from total_sams_timeline where loc_id != -1;
commit;

--LBW

/*
    value - Total weighted
    chart1 - Weight less than 2.5
    chart2 - Weight between less then =1.8
    chart3 - Weight between greater then =2.5
    target - target
*/

begin;
with
total_births as (select CAST(delivery_location_id as integer) as loc_id,
    intervals.timeline_type,

	sum(case when dob between intervals.from_date and intervals.to_date and birth_weight < 2.5 and birth_weight >= 1.8 then 1 else 0 end) as yesterday_chart1,
	sum(case when dob between intervals.from_date and intervals.to_date and birth_weight < 1.8 and birth_weight>0 then 1 else 0 end) as yesterday_chart2,
	sum(case when dob between intervals.from_date and intervals.to_date and birth_weight >= 2.5 then 1 else 0 end) as yesterday_chart3,
	sum(case when dob between intervals.from_date and intervals.to_date and birth_weight is not null and birth_weight>0 then 1 else 0 end) as yesterday_value

	from rch_child_analytics_details analytics
    inner join intervals on true
    group by delivery_location_id, intervals.timeline_type
),
total_births_timeline as (
	select loc_id, yesterday_chart1 as chart1, yesterday_chart2 as chart2, yesterday_chart3 as chart3, yesterday_value as value , timeline_type AS timeline_type from total_births
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,chart2,chart3,chart4,created_on,timeline_type)
select loc_id,CAST('LBW' as text) as "elementName",13.5 as "target",value,chart1,chart2,chart3,chart1+chart2,now(),timeline_type
from total_births_timeline where loc_id != -1;
commit;

--INSTITUTIONAL DELIVERY
/*
    value - Total ID birth
    chart1 - Total delivery
    chart2 - Home delivery
    target - target
*/

begin;
with
total_deliveries as (select CAST(delivery_location_id as integer) as loc_id,
intervals.timeline_type,

sum(case when preg.date_of_delivery between intervals.from_date and intervals.to_date and delivery_outcome in ('LBIRTH','SBIRTH') and (institutional_del or delivery_108) then 1 else 0 end) as yesterday,

sum(case when preg.date_of_delivery between intervals.from_date and intervals.to_date and delivery_outcome in ('LBIRTH','SBIRTH') then 1 else 0 end) as yesterday_chart1,

sum(case when preg.date_of_delivery between intervals.from_date and intervals.to_date and delivery_outcome in ('LBIRTH','SBIRTH') and home_del then 1 else 0 end) as yesterday_chart2

from rch_pregnancy_analytics_details preg
inner join intervals on true
WHERE (delivery_place NOT IN ('OUT_OF_STATE_GOVT','OUT_OF_STATE_PVT') or delivery_place is null) group by delivery_location_id, intervals.timeline_type ),
total_deliveries_timeline as (
	select loc_id, yesterday as value, yesterday_chart1 as chart1,yesterday_chart2 as chart2, timeline_type AS timeline_type from total_deliveries
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,value,target,chart1,chart2,created_on,timeline_type)
select loc_id,CAST('ID' as text) as "elementName",value,99.5 as "target",chart1,chart2,now(),timeline_type
from total_deliveries_timeline where loc_id != -1;
commit;

/*
    value - FI
    chart1 - Total
    chart2 - Non-FI
    target - target
*/
--FULL IMMUNISATION
/*begin;
with total_births as

(select CAST(native_loc_id as integer) as loc_id,
intervals.timeline_type,
sum(case when current_date - dob between 365 and extract(day from(interval '365 days' +  intervals.interval)) and analytics.member_state != 'DEAD' and member_id is not null and full_immunization_date is not null and fully_immunization_in_number_of_month <= 11 then 1 else 0 end) as yesterday,
sum(case when current_date - dob between 365 and extract(day from(interval '365 days' +  intervals.interval)) and analytics.member_state != 'DEAD' and member_id is not null then 1 else 0 end) as yesterday_chart1,
sum(case when current_date - dob between 365 and extract(day from(interval '365 days' +  intervals.interval)) and analytics.member_state != 'DEAD' and member_id is not null and (full_immunization_date is null or fully_immunization_in_number_of_month >= 12) then 1 else 0 end) as yesterday_chart2,
sum(case when current_date - dob <= 730 and overdue_immunisation is not null and analytics.member_state != 'DEAD' and member_id is not null then 1 else 0 end) as yesterday_chart4

from rch_child_analytics_details analytics
-- inner join parameters on true
inner join intervals on true
group by native_loc_id, intervals.timeline_type),
total_births_timeline as (
	select loc_id, yesterday as value, yesterday_chart1 as chart1, yesterday_chart2 as chart2, yesterday_chart4 as chart4, timeline_type AS timeline_type from total_births
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,value,chart1,chart2, chart4,target,created_on,timeline_type)
select loc_id,CAST('FI' as text) as "elementName",value,chart1,chart2,chart4, 98,now(),timeline_type from total_births_timeline where loc_id != -1;
commit;*/

/*
    value - FI within 10 Months
    chart1 - Total
    chart2 - Non FI between 10 months to 1 year
    chart3 - 1 year to 2 year
    chart4 - Overdue Immunisation child less then 10 months
    target - target
*/
--FULL IMMUNISATION
begin;
with total_births as

(select CAST(native_loc_id as integer) as loc_id,
intervals.timeline_type,

-- for children who completed 10 months and FI in last 365 days
sum(case when dob + interval '10 months' between intervals.from_date and intervals.to_date and analytics.member_state != 'DEAD' and member_id is not null and full_immunization_date is not null and fully_immunization_in_number_of_month <= 10 then 1 else 0 end) as yesterday,

-- No of Children who were fully immunized
--sum(case when complete_immunization_date between (current_date - intervals.interval) and (current_date) and analytics.member_state != 'DEAD' and member_id is not null and full_immunization_date is not null and fully_immunization_in_number_of_month <= 11 then 1 else 0 end) as yesterday,

-- for Children who completed 10 months of age in the last 365 days
sum(case when dob + interval '10 months' between intervals.from_date and intervals.to_date and analytics.member_state != 'DEAD' and member_id is not null then 1 else 0 end) as yesterday_chart1,

-- No of children who completed 10 months but not over 1 year who have not got all vaccines according to FI
sum(case when dob between (current_date - interval '1 year') and (current_date - interval '10 months') and analytics.member_state != 'DEAD' and member_id is not null and full_immunization_date is null then 1 else 0 end) as yesterday_chart2,

-- No of children who are between 1 year and 2 years but who have not got all vaccines according to FI
sum(case when dob between (current_date - interval '2 year') and (current_date - interval '1 years') and analytics.member_state != 'DEAD' and member_id is not null and full_immunization_date is null then 1 else 0 end) as yesterday_chart3,

-- No of Children less than 10 months as on date who have not got the specific vaccines
sum(case when dob between (current_date - interval '10 months') and current_date  and overdue_immunisation is not null and analytics.member_state != 'DEAD' and member_id is not null then 1 else 0 end) as yesterday_chart4

from rch_child_analytics_details analytics
-- inner join parameters on true
inner join intervals on true
where intervals.timeline_type ='LAST_365_DAYS'
group by native_loc_id, intervals.timeline_type),
total_births_timeline as (
	select loc_id, yesterday as value, yesterday_chart1 as chart1, yesterday_chart2 as chart2, yesterday_chart3 as chart3 , yesterday_chart4 as chart4, timeline_type AS timeline_type from total_births
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,value,chart1,chart2,chart3,chart4,target,created_on,timeline_type)
select loc_id,CAST('FI' as text) as "elementName",value,chart1,chart2,chart3,chart4, 98,now(),timeline_type from total_births_timeline where loc_id != -1;
commit;

-- patch, insert data from other timeline as we requires same data in all filters
begin;
INSERT INTO soh_timeline_analytics_chart_t (value,chart1,chart2,chart3,chart4,timeline_type,location_id,element_name)
select soh.value,soh.chart1,soh.chart2,soh.chart3,soh.chart4,intervals.timeline_type,location_id,soh.element_name from
soh_timeline_analytics_chart_t soh inner join intervals on true
where intervals.timeline_type != 'LAST_365_DAYS' and soh.timeline_type='LAST_365_DAYS' and soh.element_name='FI';
commit;
-- PREG REG
/*
    value - Total Reg.
    chart1 - Early Reg.
    target - target
*/

begin;

with total_deaths as (
	select CAST(pregnancy_reg_location_id as integer) as member_current_location_id,
    intervals.timeline_type,

	sum(case when reg_service_date between intervals.from_date and intervals.to_date  then 1 else 0 end) as yesterday,

	sum(case when reg_service_date between intervals.from_date and intervals.to_date and early_anc  then 1 else 0 end) as yesterday_live_birth

	from rch_pregnancy_analytics_details
    inner join intervals on true
    group by pregnancy_reg_location_id, intervals.timeline_type
),
total_deaths_timeline as (
	select member_current_location_id, yesterday as value,  yesterday_live_birth as chart1, timeline_type AS timeline_type  from total_deaths
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,timeline_type, created_on)
select member_current_location_id,CAST('PREG_REG' as text) as "elementName",80,value,chart1,timeline_type,now()
from total_deaths_timeline where member_current_location_id != -1;
commit;

-- SERVICE VERIFICATION
/*
    value - Total Service Verification
    chart1 - True Count
    chart2 - False Count
    target - target
*/
/*
begin;
with gvk_anm_verification_details as (
select gvk_anm_verification_response.location_id,
intervals.timeline_type,
sum(case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_info.service_type = 'FHW_DEL_VERI' then 3
when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_info.service_type = 'FHW_TT_VERI' then 1
when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_info.service_type = 'FHW_CH_SER_VERI' then 1
when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_info.service_type = 'FHW_CH_SER_PREG_VERI' then 4 else 0 end) as yesterday_total,
sum(
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.is_delivery_happened then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.delivery_place_verification then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.no_of_child_gender_verification then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.tt_injection_received_status in ('YES', 'CANNOT_DETERMINE') then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.child_service_vaccination_status then 1 else 0 end
) as yesterday_sucess,
sum(
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.is_delivery_happened is false then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.delivery_place_verification is false then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.no_of_child_gender_verification is false then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.tt_injection_received_status = 'NO' then 1 else 0 end +
case when gvk_anm_verification_info.service_date >= current_date - intervals.interval and gvk_anm_verification_response.child_service_vaccination_status is false then 1 else 0 end
) as yesterday_fail
from gvk_anm_verification_response
inner join intervals on true
inner join gvk_anm_verification_info on gvk_anm_verification_response.request_id = gvk_anm_verification_info.id
where gvk_anm_verification_response.is_verified is not null
group by gvk_anm_verification_response.location_id, intervals.timeline_type
),total_anm_verification_timeline as (
select location_id,yesterday_total as value,yesterday_sucess as chart1,yesterday_fail as chart2,timeline_type as timeline_type from gvk_anm_verification_details
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,chart2,timeline_type,created_on)
select location_id,CAST('VERIFICATION_SERVICE' as text) as "elementName",98,value,chart1,chart2,timeline_type,now()
from total_anm_verification_timeline where location_id != -1;
commit ;
*/


-- DATA_QUALITY

/*
    value - total service
    chart1 - success service
    chart2 - failed service
*/
begin;
with data_quality as (
	select CAST(location_id as integer) as location_id,
    intervals.timeline_type,

	sum(case when verified_on between intervals.from_date and intervals.to_date then total_service else 0 end) as yesterday,

	sum(case when verified_on between intervals.from_date and intervals.to_date then success_count else 0 end) as yesterday_success_count,

	sum(case when verified_on between intervals.from_date and intervals.to_date then failed_count else 0 end) as failed_success_count

	from rch_data_quality_analytics
	inner join intervals on true
	where verification_type in ('ANM_VERIFICATION_SERVICE','BENEFICIARY_WRONG_MOBILE_NUMBER')
	group by location_id, intervals.timeline_type
),
data_quality_timeline as (
	select location_id,  yesterday as value,  yesterday_success_count as chart1, failed_success_count as chart2, timeline_type AS timeline_type from data_quality
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,chart2,timeline_type, created_on)
select location_id,CAST('DATA_QUALITY' as text) as "elementName",80,value,chart1,chart2,timeline_type,now()
from data_quality_timeline where location_id != -1;
commit;


-- VERIFICATION_SERVICE

/*
    value - total service
    chart1 - success service
    chart2 - failed service
*/

begin;
with data_quality as (
	select CAST(location_id as integer) as location_id,
    intervals.timeline_type,

	sum(case when verified_on between intervals.from_date and intervals.to_date then total_service else 0 end) as yesterday,

	sum(case when verified_on between intervals.from_date and intervals.to_date  then success_count else 0 end) as yesterday_success_count,

	sum(case when verified_on between intervals.from_date and intervals.to_date  then failed_count else 0 end) as failed_success_count

	from rch_data_quality_analytics
	inner join intervals on true
    where verification_type='ANM_VERIFICATION_SERVICE'
	group by location_id, intervals.timeline_type
),
data_quality_timeline as (
	select location_id,  yesterday as value,  yesterday_success_count as chart1, failed_success_count as chart2, timeline_type AS timeline_type from data_quality
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,chart2,timeline_type, created_on)
select location_id,CAST('VERIFICATION_SERVICE' as text) as "elementName",80,value,chart1,chart2,timeline_type,now()
from data_quality_timeline where location_id != -1;
commit;

-- PREG_VERIFICATION_WRONG_MOBILE_NO

/*
    value - total service
    chart1 - success service
    chart2 - failed service
*/
begin;
with data_quality as (
	select CAST(location_id as integer) as location_id,
    intervals.timeline_type,

	sum(case when verified_on between intervals.from_date and intervals.to_date then total_service else 0 end) as yesterday,

	sum(case when verified_on between intervals.from_date and intervals.to_date  then success_count else 0 end) as yesterday_success_count,

	sum(case when verified_on between intervals.from_date and intervals.to_date  then failed_count else 0 end) as failed_success_count

	from rch_data_quality_analytics
	inner join intervals on true
	where verification_type='BENEFICIARY_WRONG_MOBILE_NUMBER'
	group by location_id, intervals.timeline_type
),
data_quality_timeline as (
	select location_id,  yesterday as value,  yesterday_success_count as chart1, failed_success_count as chart2, timeline_type AS timeline_type from data_quality
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,chart2,timeline_type, created_on)
select location_id,CAST('BENEFICIARY_WRONG_MOBILE_NUMBER' as text) as "elementName",80,value,chart1,chart2,timeline_type,now()
from data_quality_timeline where location_id != -1;
commit;



-- NCD_DIABETES
/*
    value - Total Screened
    male - Male Screened
    female - Female Screened
    target - target
*/


begin;
with diabetes_details as (
select ncd_member_diabetes_detail.location_id as location_id,
intervals.timeline_type,

count(1) filter (where screening_date between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'M') as yesterday_male_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'F') as yesterday_female_total


--max(analytics.member_30_plus) as chart1

from ncd_member_diabetes_detail
inner join intervals on true
inner join imt_member on ncd_member_diabetes_detail.member_id = imt_member.id

--inner join ncd_analytics_detail analytics on analytics.location_id = closer.parent_id

where done_by IN ('FHW','CHO','MPHW')
group by ncd_member_diabetes_detail.location_id,intervals.timeline_type
),
diabetes_details_final as (
    select max(analytics.total_member_over_thirty) as chart1,analytics.loc_id as analytics_location_id ,intervals.timeline_type,
	max(details.yesterday_total) as yesterday_total,  max(details.yesterday_male_total) as yesterday_male_total, max(details.yesterday_female_total) as yesterday_female_total
	from location_wise_analytics analytics
		inner join location_master lm on analytics.loc_id = lm.id
		inner join intervals on true
		left join diabetes_details details on analytics.loc_id = details.location_id and intervals.timeline_type  = details.timeline_type
		where lm.type in ('AA','A')
		group by analytics.loc_id, intervals.timeline_type
),
total_diabetes_timeline as (
select analytics_location_id,yesterday_total as value, chart1 , yesterday_male_total as male,yesterday_female_total as female,timeline_type as timeline_type from diabetes_details_final
)
insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,male,female,timeline_type,created_on)
select analytics_location_id,8,CAST('NCD_DIABETES' as text) as "elementName",value,chart1,male,female,timeline_type,now()
from total_diabetes_timeline where analytics_location_id != -1;
commit;


-- for NCD_HYPERTENSION
/*
    value - Total Screened
    male - Male Screened
    female - Female Screened
    target - target
*/


begin;

with diabetes_details as (
select
ncd_member_hypertension_detail.location_id as location_id,
intervals.timeline_type,

count(1) filter (where screening_date between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'M') as yesterday_male_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'F') as yesterday_female_total


-- max(analytics.member_30_plus) as chart1

from ncd_member_hypertension_detail
inner join intervals on true
inner join imt_member on ncd_member_hypertension_detail.member_id = imt_member.id

--inner join ncd_analytics_detail analytics on analytics.location_id = closer.parent_id
where done_by IN ('FHW','CHO','MPHW')
group by ncd_member_hypertension_detail.location_id,intervals.timeline_type
),
diabetes_details_final as (
    select max(analytics.total_member_over_thirty) as chart1, analytics.loc_id as analytics_location_id ,
		intervals.timeline_type, max(details.yesterday_total) as yesterday_total,
		max(details.yesterday_male_total) as yesterday_male_total,
		max(details.yesterday_female_total) as yesterday_female_total
		from location_wise_analytics analytics
		inner join location_master lm on analytics.loc_id = lm.id
    	inner join intervals on true
		left join diabetes_details details on analytics.loc_id = details.location_id and intervals.timeline_type  = details.timeline_type
		where lm.type in ('AA','A')
    	group by analytics.loc_id, intervals.timeline_type
),
total_diabetes_timeline as (
select analytics_location_id,yesterday_total as value, chart1, yesterday_male_total as male,yesterday_female_total as female,timeline_type as timeline_type from diabetes_details_final
)
insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,male,female,timeline_type,created_on)
select analytics_location_id,8,CAST('NCD_HYPERTENSION' as text) as "elementName",value,chart1,male,female,timeline_type,now()
from total_diabetes_timeline where analytics_location_id != -1;
commit;


-- for NCD_ORAL
/*
    value - Total Screened
    male - Male Screened
    female - Female Screened
    target - target
*/


begin;

with disease_details as (
select
disease_member_details.location_id as location_id,
intervals.timeline_type,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'M') as yesterday_male_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'F') as yesterday_female_total

-- max(analytics.member_30_plus) as chart1

from ncd_member_oral_detail disease_member_details
inner join intervals on true
inner join imt_member on disease_member_details.member_id = imt_member.id

--inner join ncd_analytics_detail analytics on analytics.location_id = closer.parent_id
where done_by IN ('FHW','CHO','MPHW')
group by disease_member_details.location_id,intervals.timeline_type
),
disease_details_final as (
    select max(analytics.total_member_over_thirty) as chart1, analytics.loc_id as analytics_location_id ,
		intervals.timeline_type, max(details.yesterday_total) as yesterday_total,
		max(details.yesterday_male_total) as yesterday_male_total,
		max(details.yesterday_female_total) as yesterday_female_total
		from location_wise_analytics analytics
		inner join location_master lm on analytics.loc_id = lm.id
		inner join intervals on true
		left join disease_details details on analytics.loc_id = details.location_id and intervals.timeline_type  = details.timeline_type
		where lm.type in ('AA','A')
		group by analytics.loc_id, intervals.timeline_type
),
total_disease_timeline as (
select analytics_location_id,yesterday_total as value, chart1, yesterday_male_total as male,yesterday_female_total as female,timeline_type as timeline_type from disease_details_final
)
insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,male,female,timeline_type,created_on)
select analytics_location_id,8,CAST('NCD_ORAL' as text) as "elementName",value,chart1,male,female,timeline_type,now()
from total_disease_timeline where analytics_location_id != -1;
commit;


-- for NCD_BREAST
/*
    value - Total Screened
    male - Male Screened
    female - Female Screened
    target - target
*/


begin;

with disease_details as (
select
disease_member_details.location_id as location_id,
intervals.timeline_type,
count(1) filter (where screening_date  between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where screening_date  between intervals.from_date and intervals.to_date and gender = 'M') as yesterday_male_total,
count(1) filter (where screening_date  between intervals.from_date and intervals.to_date and gender = 'F') as yesterday_female_total

from ncd_member_breast_detail disease_member_details
inner join intervals on true
inner join imt_member on disease_member_details.member_id = imt_member.id
where done_by IN ('FHW','CHO','MPHW')
group by disease_member_details.location_id,intervals.timeline_type
),
disease_details_final as (
    select max(analytics.total_female_over_thirty) as chart1, analytics.loc_id as analytics_location_id ,
		intervals.timeline_type, max(details.yesterday_total) as yesterday_total,
		max(details.yesterday_male_total) as yesterday_male_total,
		max(details.yesterday_female_total) as yesterday_female_total
		from location_wise_analytics analytics
		inner join location_master lm on analytics.loc_id = lm.id
		inner join intervals on true
		left join disease_details details on analytics.loc_id = details.location_id and intervals.timeline_type  = details.timeline_type
		where lm.type in ('AA','A')
		group by analytics.loc_id, intervals.timeline_type
),
total_disease_timeline as (
select analytics_location_id,yesterday_total as value, chart1, yesterday_male_total as male,yesterday_female_total as female,timeline_type as timeline_type from disease_details_final
)
insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,male,female,timeline_type,created_on)
select analytics_location_id,8,CAST('NCD_BREAST' as text) as "elementName",value,chart1,male,female,timeline_type,now()
from total_disease_timeline where analytics_location_id != -1;
commit;


-- for NCD_HYPERTENSION
/*
    value - Total Screened
    male - Male Screened
    female - Female Screened
    target - target
*/

begin;

with disease_details as (
select
disease_member_details.location_id as location_id,
intervals.timeline_type,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'M') as yesterday_male_total,
count(1) filter (where screening_date between intervals.from_date and intervals.to_date and gender = 'F') as yesterday_female_total

-- max(analytics.member_30_plus) as chart1

from ncd_member_cervical_detail disease_member_details
inner join intervals on true
inner join imt_member on disease_member_details.member_id = imt_member.id

--inner join ncd_analytics_detail analytics on analytics.location_id = closer.parent_id
where done_by IN ('FHW','CHO','MPHW')
group by disease_member_details.location_id,intervals.timeline_type
),
disease_details_final as (
    select max(analytics.total_member_over_thirty) as chart1, analytics.loc_id as analytics_location_id ,
		intervals.timeline_type, max(details.yesterday_total) as yesterday_total,
		max(details.yesterday_male_total) as yesterday_male_total,
		max(details.yesterday_female_total) as yesterday_female_total
		from location_wise_analytics analytics
		inner join location_master lm on analytics.loc_id = lm.id
		inner join intervals on true
		left join disease_details details on analytics.loc_id = details.location_id and intervals.timeline_type  = details.timeline_type
		where lm.type in ('AA','A')
		group by analytics.loc_id, intervals.timeline_type
),
total_disease_timeline as (
select analytics_location_id,yesterday_total as value, chart1, yesterday_male_total as male,yesterday_female_total as female,timeline_type as timeline_type from disease_details_final
)
insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,male,female,timeline_type,created_on)
select analytics_location_id,8,CAST('NCD_CERVICAL' as text) as "elementName",value,chart1,male,female,timeline_type,now()
from total_disease_timeline where analytics_location_id != -1;
commit;


-- for NCD_HYPERTENSION_CONFIRM
/*
    value - Total Diagnosed
    male - Male Confirmed
    female - Female Confirmed
    chart1 - Total male screened
    chart2 - Total female screened
    chart3 - Total Confirmed
    chart4 - Total Screen
*/

begin;
with diabetes_details_unique as (
	select max(id) as id from ncd_member_diseases_diagnosis diagnosis
	WHERE diagnosis.disease_code='HT' AND diagnosis.status !='DELETED'
	group by member_id
),
diabetes_details as (
select analytics.location_id,
intervals.timeline_type,

count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'M'
and diagnosis.status='CONFIRMED') as yesterday_male_total,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'F'
and diagnosis.status='CONFIRMED' ) as yesterday_female_total,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'M' ) AS yesterday_chart1,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'F' ) AS yesterday_chart2,
count(1) filter (where  diagnosed_on  between intervals.from_date and intervals.to_date and diagnosis.status='CONFIRMED') as yesterday_chart3

from ncd_member_diseases_diagnosis diagnosis
inner join intervals on true
inner join imt_member on diagnosis.member_id = imt_member.id
inner join location_hierchy_closer_det closer on closer.child_id = diagnosis.location_id
inner join diabetes_details_unique on diagnosis.id = diabetes_details_unique.id
inner join ncd_analytics_detail analytics on analytics.location_id = closer.parent_id
where diagnosis.disease_code='HT'
--done_by = 'FHW'
group by analytics.location_id, intervals.timeline_type
),total_diabetes_timeline as (
select lhcd.id as location_id,coalesce(yesterday_total, 0) as value, coalesce(yesterday_chart1,0) as chart1 ,coalesce(yesterday_chart2, 0) as chart2, coalesce(yesterday_chart3, 0) as chart3 ,coalesce(yesterday_male_total, 0) as male,coalesce(yesterday_female_total, 0) as female,intervals.timeline_type as timeline_type

from location_master lhcd inner join intervals on true left join diabetes_details on
diabetes_details.location_id = lhcd.id and intervals.timeline_type = diabetes_details.timeline_type
where lhcd.type in  ('V','ANG')
)insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,chart2,chart3,male,female,timeline_type,created_on)
select location_id,19.8,CAST('NCD_HYPERTENSION_CONFIRM' as text) as "elementName",value,chart1,chart2,chart3,male,female,timeline_type,now()
from total_diabetes_timeline where location_id != -1;
commit;



-- for NCD_DIABETES_CONFIRM

/*
    value - Total Screened
    male - Male Confirmed
    female - Female Confirmed
    chart1 - Total male screened
    chart2 - Total female screened
    chart3 - Total Confirmed
*/


begin;
with diabetes_details_unique as (
	select max(id) as id from ncd_member_diseases_diagnosis
	WHERE disease_code='D' and status !='DELETED'
	group by member_id
),
diabetes_details as (
select analytics.location_id,
intervals.timeline_type,

count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date) as yesterday_total,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'M'
and diagnosis.status='CONFIRMED') as yesterday_male_total,
count(1) filter (where diagnosed_on between intervals.from_date and intervals.to_date and gender = 'F'
and diagnosis.status='CONFIRMED' ) as yesterday_female_total,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'M' ) AS yesterday_chart1,
count(1) filter (where diagnosed_on  between intervals.from_date and intervals.to_date and gender = 'F' ) AS yesterday_chart2,
count(1) filter (where diagnosed_on between intervals.from_date and intervals.to_date and diagnosis.status='CONFIRMED') as yesterday_chart3

from ncd_member_diseases_diagnosis diagnosis
inner join intervals on true
inner join imt_member on diagnosis.member_id = imt_member.id
inner join location_hierchy_closer_det closer on closer.child_id = diagnosis.location_id
inner join diabetes_details_unique on diagnosis.id = diabetes_details_unique.id
inner join ncd_analytics_detail analytics on analytics.location_id = closer.parent_id
where diagnosis.disease_code='D'
--done_by = 'FHW'
group by analytics.location_id, intervals.timeline_type
),total_diabetes_timeline as (
select lhcd.id as location_id,coalesce(yesterday_total,0) as value, coalesce(yesterday_chart1, 0) as chart1 ,coalesce(yesterday_chart2, 0) as chart2, coalesce(yesterday_chart3, 0) as chart3 ,coalesce(yesterday_male_total, 0) as male,coalesce(yesterday_female_total, 0) as female,intervals.timeline_type as timeline_type
from location_master lhcd inner join intervals on true left join diabetes_details on diabetes_details.location_id = lhcd.id
and diabetes_details.timeline_type = intervals.timeline_type
where lhcd.type in  ('V','ANG')
)insert into soh_timeline_analytics_chart_t(location_id,target,element_name,value,chart1,chart2,chart3,male,female,timeline_type,created_on)
select location_id,11.7,CAST('NCD_DIABETES_CONFIRM' as text) as "elementName",value,chart1,chart2,chart3,male,female,timeline_type,now()
from total_diabetes_timeline where location_id != -1;
commit;

-- FOR average service duration
/*
    value - Total Services
    chart1 - Total days
    target - target
*/

begin;
with total_services as (
	select CAST(location_id as integer) as location_id,
    intervals.timeline_type,
	sum(case when server_date between intervals.from_date and intervals.to_date  then 1 else 0 end) as yesterday,
	sum(cast(server_date as date) - cast (service_date as date)) filter (where server_date between intervals.from_date and intervals.to_date) as yesterday_chart1


	from rch_member_services
    inner join intervals on true
	where service_type in ('FHW_ANC','FHW_PNC','FHW_CS','FHW_MOTHER_WPD')
	group by location_id, intervals.timeline_type

),
total_services_timeline as (
	select location_id,  yesterday as value, yesterday_chart1 as chart1 ,  timeline_type AS timeline_type from total_services
)
insert into soh_timeline_analytics_chart_t(location_id,element_name,target,value,chart1,timeline_type, created_on)
select location_id,CAST('AVG_SERVICE_DURATION' as text) as "elementName",1,chart1,value,timeline_type,now()
from total_services_timeline where location_id != -1;
commit;



--INSERT FOR ALL LOCATION LEVELS

begin;
insert into soh_timeline_analytics_chart_t(location_id,element_name,timeline_type,value,target,male,female,chart1,chart2,chart3,chart4,created_on)
select l.id ,element_name, sh.timeline_type,
sum(value) as value,
target,sum(male) as male,
sum(female) as female,
sum(chart1) as chart1,
sum(chart2) as chart2,
sum(chart3) as chart3,
sum(chart4) as chart4,
now()
from soh_timeline_analytics_chart_t sh,location_master l,location_hierchy_closer_det lh where lh.child_id = sh.location_id and lh.parent_id in(
(select id from location_master  where type in (select type from location_type_master where level!=8)))
and lh.parent_id = l.id and not exists (select * from soh_timeline_analytics_chart_t where location_id = l.id and element_name =  sh.element_name and timeline_type = sh.timeline_type)
group by
sh.target,l.id,sh.timeline_type ,l.english_name,sh.element_name ;
commit;

--UPDATING VILLAGE AND ANGANWADIS FOR AGGREGATE
begin;
with t1 as (select lh.parent_id as location_id,st.element_name,sum(value) as value,timeline_type,
max(target) as target,sum(male) as male,sum(female) as female,sum(chart1) as chart1,sum(chart2) as chart2,sum(chart3) as chart3,sum(chart4) as chart4,now()
from soh_timeline_analytics_chart_t st,location_hierchy_closer_det lh where st.location_id = lh.child_id and lh.parent_loc_type in ('V','ANG') and lh.child_id!=lh.parent_id
group by st.timeline_type,lh.parent_id,st.element_name
order by lh.parent_id,st.element_name)
update soh_timeline_analytics_chart_t stm set value = t1.value, male = t1.male, female = t1.female,
chart1 = t1.chart1, chart2 = t1.chart2, chart3 = t1.chart3, chart4 = t1.chart4, created_on = now() from t1 where stm.location_id = t1.location_id
and stm.element_name = t1.element_name AND stm.timeline_type = t1.timeline_type;
commit;


begin;
update soh_timeline_analytics_chart_t set days=1 where timeline_type = 'YESTERDAY';
update soh_timeline_analytics_chart_t set days=7 where timeline_type = 'LAST_7_DAYS';
update soh_timeline_analytics_chart_t set days=30 where timeline_type = 'LAST_30_DAYS';
update soh_timeline_analytics_chart_t set days=365 where timeline_type = 'LAST_365_DAYS';
update soh_timeline_analytics_chart_t set days=extract(day from now() -cast ('2019-04-01' as date)) where timeline_type = 'YEAR_04_2019';
commit;

-- update screen value

begin;
WITH ncd as(
select value, male,female,location_id,timeline_type from soh_timeline_analytics_chart_t where element_name ='NCD_DIABETES'
)
update soh_timeline_analytics_chart_t
SET chart4 = ncd.value,
chart1 = ncd.male,
chart2 = ncd.female
from ncd
where soh_timeline_analytics_chart_t.element_name = 'NCD_DIABETES_CONFIRM'
and soh_timeline_analytics_chart_t.location_id = ncd.location_id and soh_timeline_analytics_chart_t.timeline_type = ncd.timeline_type;
commit;


-- update screened values

begin;
WITH ncd as(
select value, male,female,location_id,timeline_type from soh_timeline_analytics_chart_t where element_name ='NCD_HYPERTENSION'
)
update soh_timeline_analytics_chart_t
SET chart4 = ncd.value,
chart1 = ncd.male,
chart2 = ncd.female
from ncd
where soh_timeline_analytics_chart_t.element_name = 'NCD_HYPERTENSION_CONFIRM'
and soh_timeline_analytics_chart_t.location_id = ncd.location_id and soh_timeline_analytics_chart_t.timeline_type = ncd.timeline_type;
commit;

/*-- update sex ratio in complete state
begin;
WITH sr as(
	select case when male = 0 then 854 else ((female*1000)/male) end  as target,timeline_type from soh_timeline_analytics_chart_t
	where   element_name ='SR'
	and location_id=2 and timeline_type='YEAR_04_2019'
)
update soh_element_configuration
SET target = sr.target,
    target_mid = round((sr.target*95)/100.0)
from sr
where element_name = 'SR';
commit;*/

-- update total child born in mmr
begin;
WITH imr as(
select chart1,location_id,timeline_type from soh_timeline_analytics_chart_t where element_name ='LIVE_BIRTH'
)
update soh_timeline_analytics_chart_t
SET chart1 = imr.chart1
from imr
where soh_timeline_analytics_chart_t.element_name IN ('MMR','IMR')
and soh_timeline_analytics_chart_t.location_id = imr.location_id and soh_timeline_analytics_chart_t.timeline_type = imr.timeline_type;
commit;

begin;

delete from soh_timeline_analytics_chart_t where element_name='LIVE_BIRTH';

commit;

-- Update location wise target in FI special case

-- update targets
/*

begin;
with targets as (
select
analytics.location_id,
analytics.element_name,
analytics.timeline_type ,
ela_dpt_opv_mes_vita_1dose,
(ela_dpt_opv_mes_vita_1dose*days)/365 as fiTarget
from soh_timeline_analytics_chart_t analytics
inner join location_wise_expected_target targets on analytics.location_id = targets.location_id
inner join location_master lm on lm.id = targets.location_id
where lm.type IN ('P','U') and analytics.element_name='FI'
and targets.financial_year ='2019-2020'
--and analytics.location_id in (select child_id from location_hierchy_closer_det where parent_id=26354)
)
update soh_timeline_analytics_chart_t
set chart3 = fiTarget
from targets
where targets.location_id = soh_timeline_analytics_chart_t.location_id
and targets.timeline_type = soh_timeline_analytics_chart_t.timeline_type
and targets.element_name = soh_timeline_analytics_chart_t.element_name;


-- updates targets at upper level

with details as(
SELECT sum(chart3) as chart3,
sh.element_name,
sh.timeline_type,
lh.parent_id
from soh_timeline_analytics_chart_t sh, location_hierchy_closer_det lh where lh.child_id = sh.location_id
and element_name='FI'
--and sh.location_id in (select child_id from location_hierchy_closer_det where parent_id=26354)
and parent_id != -1
group by lh.parent_id, sh.timeline_type ,sh.element_name )
update soh_timeline_analytics_chart_t set chart3 = details.chart3
from details
where soh_timeline_analytics_chart_t.location_id = details.parent_id
and soh_timeline_analytics_chart_t.element_name = details.element_name
and soh_timeline_analytics_chart_t.timeline_type = details.timeline_type;

*/


/*
create table soh_timeline_analytics_chart_t
as select * from   soh_timeline_analytics;
alter table soh_timeline_analytics_chart_t
add column reporting varchar(255),
add  column calculatedTarget NUMERIC(12,2),
add column color varchar(255),
add column percentage NUMERIC(12,2),
add column displayValue text,
add column sortPriority integer;
*/

-- update the percentages

begin;
with configurations as
(
	select * from soh_element_configuration
),
percentages as (
	select location_id,analytics.timeline_type ,config.*,

	-- for calculate the value
	case when (analytics.element_name ='IMR' and  analytics.chart1!=0) THEN ROUND(analytics.value * 1000 / analytics.chart1)
	when (analytics.element_name ='MMR' and  analytics.chart1!=0) THEN ROUND(analytics.value * 100000 / analytics.chart1)
	when (analytics.element_name ='ID' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='SR' and  analytics.male!=0) THEN (analytics.female * 1000 / analytics.male)
	when (analytics.element_name ='SAM' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='LBW' and  analytics.value!=0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value )
	when (analytics.element_name ='PREG_REG' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
	when (analytics.element_name ='FI' and  analytics.chart1!=0) THEN ((analytics.value) * 100 / analytics.chart1 )
	when (analytics.element_name ='Anemia' and  (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4)!=0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) )

	when (analytics.element_name ='VERIFICATION_SERVICE' and  analytics.value!=0) THEN ((analytics.chart1 * 100) / analytics.value )
    when (analytics.element_name ='BENEFICIARY_WRONG_MOBILE_NUMBER' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
    when (analytics.element_name ='DATA_QUALITY' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )

	when (analytics.element_name ='AVG_SERVICE_DURATION' and  analytics.value!=0) THEN ((analytics.chart1) / analytics.value )

	when (analytics.element_name ='NCD_HYPERTENSION' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1))
	when (analytics.element_name ='NCD_DIABETES' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1))
	when (analytics.element_name ='NCD_CERVICAL' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1))
	when (analytics.element_name ='NCD_BREAST' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1))
	when (analytics.element_name ='NCD_ORAL' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1))

	when (analytics.element_name ='NCD_HYPERTENSION_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4))
	when (analytics.element_name ='NCD_DIABETES_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4))
	else 0 end as calculatedTarget,

	-- for percentage calculation
	case when (analytics.element_name ='IMR' and  analytics.chart1!=0) THEN ((analytics.value * 1000 / analytics.chart1)*100)/ config.target
	when (analytics.element_name ='MMR' and  analytics.chart1!=0) THEN ((analytics.value * 100000 / analytics.chart1)*100)/ config.target
	when (analytics.element_name ='ID' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='SR' and  analytics.male!=0) THEN (analytics.female * 1000 / analytics.male)
	when (analytics.element_name ='SAM' and  analytics.chart1!=0) THEN (analytics.value * 100 / analytics.chart1)
	when (analytics.element_name ='LBW' and  analytics.value!=0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value )
	when (analytics.element_name ='PREG_REG' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
	when (analytics.element_name ='FI' and  analytics.chart1!=0) THEN ((analytics.value) * 100 / analytics.chart1 )
	when (analytics.element_name ='Anemia' and  (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4)!=0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) )

	when (analytics.element_name ='VERIFICATION_SERVICE' and  analytics.value!=0) THEN ((analytics.chart1 * 100) / analytics.value )
	when (analytics.element_name ='BENEFICIARY_WRONG_MOBILE_NUMBER' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )
	when (analytics.element_name ='DATA_QUALITY' and  analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value )

	when (analytics.element_name ='AVG_SERVICE_DURATION' and  analytics.value!=0) THEN ((analytics.chart1) / analytics.value )

	when (analytics.element_name ='NCD_HYPERTENSION' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_DIABETES' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_CERVICAL' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_BREAST' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1)*100)/config.target
	when (analytics.element_name ='NCD_ORAL' and  analytics.chart1!=0) THEN (((((30 * value)/case when days is null then 30 else days end)*100)/chart1)*100)/config.target

	when (analytics.element_name ='NCD_HYPERTENSION_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4)*100)/ config.target
	when (analytics.element_name ='NCD_DIABETES_CONFIRM' and  analytics.chart4!=0) THEN ((analytics.chart3 * 100 / analytics.chart4)*100)/ config.target
	end as percentage,

	case when location.type in ('C','Z','U','ANM','ANG','AA')
			then case when (target_for_rural is null or target_for_rural = 0) then config.target  else target_for_rural end
	     when location.type in ('D','B','P','SC','V','A')
			then case when (target_for_urban is null or target_for_urban = 0) then config.target  else target_for_urban  end
	     when location.type in ('S')
			then config.target
	     else config.target
	end
	as target_1,

	case when location.type in ('C','Z','U','ANM','ANG','AA')
			then case when (lower_bound is null or lower_bound = 0) then config.lower_bound  else lower_bound end
	     when location.type in ('D','B','P','SC','V','A')
			then case when (lower_bound_for_rural is null or lower_bound_for_rural = 0) then lower_bound   else config.lower_bound_for_rural  end
	     when location.type in ('S')
			then config.lower_bound
	     else config.lower_bound
	end
	as lower_bound_1,

	case when location.type in ('C','Z','U','ANM','ANG','AA')
			then case when (upper_bound is null or upper_bound = 0) then config.upper_bound  else upper_bound end
	     when location.type in ('D','B','P','SC','V','A')
			then case when (upper_bound_for_rural is null or upper_bound_for_rural = 0) then upper_bound   else config.upper_bound_for_rural  end
	     when location.type in ('S')
			then config.upper_bound
	     else config.upper_bound
	end
	as upper_bound_1
	from
	soh_timeline_analytics_chart_t analytics inner join location_master location on location.id = analytics.location_id
	inner join configurations config on analytics.element_name = config.element_name
	--where location_id=26184

),
calculations as(
select
calculatedTarget,
case when calculatedTarget < lower_bound_1 then 'UNDER_REPORTING'
     when calculatedTarget > upper_bound_1  then 'OVER_REPORTING'
     when calculatedTarget >= lower_bound_1 AND calculatedTarget<=upper_bound_1   then 'AS_EXPECTED_REPORTING' end as reporting,

case when
	is_small_value_positive  then
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 'YELLOW'
		when percentages.target_1 > calculatedTarget  then 'GREEN'
		else 'RED' end
	else
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 'YELLOW'
		when percentages.target_1 <= calculatedTarget  then 'GREEN'
		else 'RED' end
	end as color,

case when
	is_small_value_positive  then
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 2
		when percentages.target_1 > calculatedTarget  then 1
		else 3 end
	else
		case when percentages.target_1 >= calculatedTarget and target_mid <=calculatedTarget and target_mid_enable then 2
		when percentages.target_1 <= calculatedTarget  then 1
		else 3 end
	end as sortPriority,

element_name,
percentage,
location_id,
percentages.timeline_type
from percentages
)
update soh_timeline_analytics_chart_t
set
reporting = calculations.reporting,
calculatedTarget= calculations.calculatedTarget,
color = calculations.color,
percentage = calculations.percentage,
sortPriority = calculations.sortPriority
from calculations
where  soh_timeline_analytics_chart_t.location_id = calculations.location_id
and soh_timeline_analytics_chart_t.timeline_type = calculations.timeline_type
and soh_timeline_analytics_chart_t.element_name = calculations.element_name;

commit;



-- update sex ratio special case

/*begin;
with  sexratio as (
	select male,female,analytics.location_id,analytics.timeline_type,locations.type
	from soh_timeline_analytics_chart_t analytics inner join location_master locations on analytics.location_id = locations.id
	where analytics.element_name = 'SR'
)
update soh_timeline_analytics_chart_t
set displayValue = case when type in ('S','D','B','Z','C')
then case when soh_timeline_analytics_chart_t.male != 0
	then cast((ROUND(soh_timeline_analytics_chart_t.female * 1000 / cast(soh_timeline_analytics_chart_t.male as float))) as text)

end else CONCAT('(',soh_timeline_analytics_chart_t.male,'-M)','/','(',soh_timeline_analytics_chart_t.female,'-F)') end
from sexratio where soh_timeline_analytics_chart_t.location_id = sexratio.location_id and soh_timeline_analytics_chart_t.element_name = 'SR'
and soh_timeline_analytics_chart_t.timeline_type = sexratio.timeline_type;
commit;*/

begin;
with elements as (
	select male,female,analytics.location_id,analytics.timeline_type,locations.type,element_name,value,calculatedTarget,percentage
	from soh_timeline_analytics_chart_t analytics inner join location_master locations on analytics.location_id = locations.id
	where analytics.element_name in ('SR','IMR','MMR')
),
element_display_values as (
	select case when element_name='SR' THEN case when type in ('S','D','B','Z','C') then case when male != 0 then cast((ROUND(female * 1000 / cast(male as float))) as text)
			end else CONCAT('(',male,'-M)','/','(',female,'-F)') end
	     when element_name='IMR' THEN case when type in ('S','D','C','Z','B') then cast (round(calculatedtarget) as text) else cast(concat(value,'(Death)') as text) end
	     when element_name='MMR' THEN case when type in ('S','D','C') then cast (round(calculatedtarget) as text) else cast(concat(value,'(Death)') as text) end
	END as displayValue,
	location_id,
	elements.element_name,
	timeline_type
	from elements

)
update soh_timeline_analytics_chart_t
set displayValue = element_display_values.displayValue
from element_display_values where soh_timeline_analytics_chart_t.location_id = element_display_values.location_id
and soh_timeline_analytics_chart_t.element_name = element_display_values.element_name
and soh_timeline_analytics_chart_t.timeline_type = element_display_values.timeline_type;
commit;

begin;
    update soh_timeline_analytics_chart_t
    set timeline_sub_type = case when timeline_type in ('YESTERDAY','YEAR_04_2019','LAST_7_DAYS','LAST_30_DAYS','LAST_365_DAYS') then 'PERIOD' else 'DATE' end;
commit;

begin;

drop table if exists soh_timeline_analytics_t1;

CREATE TABLE public.soh_timeline_analytics_t1 as select * from soh_timeline_analytics_chart_t;

drop table if exists soh_timeline_analytics_chart_t;
commit;

begin;

drop table if exists soh_timeline_intervals;

alter table if exists intervals rename to soh_timeline_intervals;

drop table if exists soh_timeline_analytics;

alter table soh_timeline_analytics_t1 rename to soh_timeline_analytics;

create index soh_timeline_analytics_1_timeline_idx on soh_timeline_analytics(location_id,timeline_sub_type,timeline_type,element_name);

drop table if exists soh_timeline_analytics_t1;
commit;
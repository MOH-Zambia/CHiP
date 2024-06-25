begin;

drop table if exists child_screening_analytics_t;

create table child_screening_analytics_t (
    reference_id integer,
    child_id integer,
    screened_from text,
    screened_on date,
    screened_by integer,
    location_id integer,
    weight numeric(7,3),
    height numeric(7,3),
    oedema boolean,
    muac numeric(6,2),
    sd_score text,
    appetite_test boolean,
    medical_complication boolean,
    breast_sucking_problems boolean,
    muw boolean,
    suw boolean,
    stunted boolean
);

with rch_screening_details as (
    select rch_child_service_master.id as reference_id,
    rch_child_service_master.member_id as child_id,
    cast('RCH' as text) as screened_from,
    cast(case when rch_child_service_master.service_date is not null then rch_child_service_master.service_date else rch_child_service_master.created_on end as date) as screened_on,
    rch_child_service_master.created_by as screened_by,
    rch_child_service_master.location_id as location_id,
    rch_child_service_master.weight as weight,
    rch_child_service_master.height as height,
    rch_child_service_master.have_pedal_edema as oedema,
    rch_child_service_master.mid_arm_circumference as muac,
    rch_child_service_master.sd_score as sd_score,
    cast(null as boolean) as appetite_test,
    cast(null as boolean) as medical_complication,
    cast(null as boolean) as breast_sucking_problems
    from rch_child_service_master
    left join child_nutrition_sam_screening_master on rch_child_service_master.id = child_nutrition_sam_screening_master.reference_id
    and child_nutrition_sam_screening_master.done_from = 'FHW_CS'
    where (
        rch_child_service_master.sd_score is not null
        or rch_child_service_master.mid_arm_circumference is not null
        or rch_child_service_master.have_pedal_edema is not null
    ) and child_nutrition_sam_screening_master.reference_id is null
)
insert into child_screening_analytics_t (
reference_id,child_id,screened_from,screened_on,
screened_by,location_id,weight,height,oedema,muac,
sd_score,appetite_test,medical_complication,breast_sucking_problems
)
select reference_id,child_id,screened_from,screened_on,
screened_by,location_id,weight,height,oedema,muac,sd_score,
appetite_test,medical_complication,breast_sucking_problems
from rch_screening_details;

with nutrition_sam_screening_details as (
    select child_nutrition_sam_screening_master.id as reference_id,
    child_nutrition_sam_screening_master.member_id as child_id,
    cast('SAM_SCREENING' as text) as screened_from,
    cast(child_nutrition_sam_screening_master.service_date as date) as screened_on,
    child_nutrition_sam_screening_master.done_by as screened_by,
    child_nutrition_sam_screening_master.location_id as location_id,
    child_nutrition_sam_screening_master.weight as weight,
    child_nutrition_sam_screening_master.height as height,
    child_nutrition_sam_screening_master.have_pedal_edema as oedema,
    child_nutrition_sam_screening_master.muac as muac,
    child_nutrition_sam_screening_master.sd_score as sd_score,
    child_nutrition_sam_screening_master.appetite_test as appetite_test,
    child_nutrition_sam_screening_master.medical_complications_present as medical_complication,
    child_nutrition_sam_screening_master.breast_sucking_problems as breast_sucking_problems
    from child_nutrition_sam_screening_master
)
insert into child_screening_analytics_t (
reference_id,child_id,screened_from,screened_on,
screened_by,location_id,weight,height,oedema,muac,
sd_score,appetite_test,medical_complication,breast_sucking_problems
)
select reference_id,child_id,screened_from,screened_on,
screened_by,location_id,weight,height,oedema,muac,sd_score,
appetite_test,medical_complication,breast_sucking_problems
from nutrition_sam_screening_details;

commit;

begin;

drop table if exists child_screening_analytics_details_t;

create table child_screening_analytics_details_t (
    financial_year date,
    reference_id integer,
    child_id integer,
    gender text,
    dob date,
    screened_from text,
    screened_on date,
    screened_by integer,
    sam_screening_is_sam boolean,
    location_id integer,
    weight numeric(7,3),
    height numeric(7,3),
    oedema boolean,
    muac numeric(6,2),
    sd_score text,
    appetite_test boolean,
    medical_complication boolean,
    breast_sucking_problems boolean,
    muw boolean,
    suw boolean,
    stunted boolean
);

with dates as (
    select cast(dates as date) as from_date,
    cast(dates + interval '1 year' - interval '1 millisecond' as date) as to_date
    from generate_series(date '2009-04-01', current_date, '1 year') as dates
),max_records_per_year as (
    select dates.from_date,
    child_id,
    max(screened_on) as screened_on
    from child_screening_analytics_t
    inner join dates on screened_on between cast(dates.from_date as date) and cast(dates.to_date as date)
    group by child_id,dates.from_date
),details as (
    select max_records_per_year.from_date as financial_year,
    child_screening_analytics_t.*
    from max_records_per_year
    inner join child_screening_analytics_t on max_records_per_year.child_id = child_screening_analytics_t.child_id
    and max_records_per_year.screened_on = child_screening_analytics_t.screened_on
)
insert into child_screening_analytics_details_t (
financial_year,reference_id,child_id,gender,dob,screened_from,screened_on,
screened_by,sam_screening_is_sam,location_id,weight,height,oedema,muac,sd_score,
appetite_test,medical_complication,breast_sucking_problems
)
select details.financial_year,details.reference_id,details.child_id,rch_child_analytics_details.gender,
rch_child_analytics_details.dob,details.screened_from,details.screened_on,um_user.role_id,
case when (cast(details.screened_on as date) - cast(rch_child_analytics_details.dob as timestamp)) < interval '6 months'
	     then (
	            details.breast_sucking_problems
	            or details.sd_score in ('SD3','SD4')
	            or details.medical_complication
	          )
	     else (
	            details.muac < 11.5
	            or details.oedema
	            or details.sd_score in ('SD3','SD4')
	            or details.medical_complication
	          )
	end,
details.location_id,details.weight,details.height,details.oedema,details.muac,
details.sd_score,details.appetite_test,details.medical_complication,details.breast_sucking_problems
from details
inner join rch_child_analytics_details on details.child_id = rch_child_analytics_details.member_id
inner join um_user on details.screened_by = um_user.id;

commit;

begin;

drop table if exists child_cmtc_nrc_analytics_details_t;

create table child_cmtc_nrc_analytics_details_t(
    child_id integer,
    gender text,
    dob date,
    screened_by integer,
    fsam_screening_id integer,
    fsam_admission_id integer,
    fsam_admission_location_id integer,
    fsam_admission_date timestamp without time zone,
    fsam_admission_apetite_test text,
    fsam_admission_bilateral_pitting_oedema text,
    fsam_admission_type text,
    fsam_admission_weight numeric(7,3),
    fsam_admission_height numeric(7,3),
    fsam_admission_muac numeric(6,2),
    fsam_admission_sd_score text,
    fsam_admission_complementary_feeding boolean,
    fsam_admission_death_date timestamp without time zone,
    fsam_admission_death_reason text,
    fsam_admission_other_death_reason text,
    fsam_admission_death_place text,
    fsam_admission_defaulter_date timestamp without time zone,
    fsam_admission_screening_center integer,
    fsam_admission_breast_feeding boolean,
    fsam_admission_problem_in_breast_feeding boolean,
    fsam_pediatrician_visit boolean,


    fsam_discharge_id integer,
    fsam_discharge_date timestamp without time zone,
    fsam_discharge_bilateral_pitting_oedema text,
    fsam_discharge_weight numeric(7,3),
    fsam_discharge_height numeric(7,3),
    fsam_discharge_muac numeric(6,2),
    fsam_discharge_sd_score text,
    fsam_discharge_status text,
    fsam_discharge_15_weight_gain boolean,
    fsam_discharge_15_weight_gain_at_end_of_program boolean,
    fsam_discharge_not_15_weight_gain boolean,
    fsam_discharge_8gm_kg_day_gain boolean,
    fsam_discharge_5gm_kg_day_gain boolean,
    fsam_location_id integer,
    fsam_inpatient_days integer,


    sam_screening_id integer,
    sam_screening_height numeric(7,3),
    sam_screening_weight numeric(7,3),
    sam_screening_sd_score text,
    sam_screening_muac numeric(6,2),
    sam_screening_oedema boolean,
    sam_screening_is_sam boolean,
    sam_screening_appetite_test boolean,
    sam_screening_location_id integer,
    sam_screening_service_date timestamp without time zone,
    sam_breast_sucking_problems boolean,
    sam_screening_referral_done boolean,
    sam_screening_referral_place integer,
    sam_screening_medical_complication boolean,
    sam_screening_mam boolean,
    sam_screening_muw boolean,
    sam_screening_suw boolean,
    sam_screening_stunted boolean,


    cmam_master_id integer,
    cmam_identified_from text,
    cmam_cured_on timestamp without time zone,
    cmam_cured_muac numeric(6,2),
    cmam_service_date timestamp without time zone,
    cmam_location_id integer,


    fsam_follow_up_visit_1 timestamp without time zone,
    fsam_follow_up_visit_1_weight numeric(7,3),
    fsam_follow_up_visit_2 timestamp without time zone,
    fsam_follow_up_visit_2_weight numeric(7,3),
    fsam_follow_up_visit_3 timestamp without time zone,
    fsam_follow_up_visit_3_weight numeric(7,3),


    cmam_visit_1 timestamp without time zone,
    cmam_visit_2 timestamp without time zone,
    cmam_visit_3 timestamp without time zone,
    cmam_visit_4 timestamp without time zone,
    cmam_visit_5 timestamp without time zone,
    cmam_visit_6 timestamp without time zone,
    cmam_visit_7 timestamp without time zone,
    cmam_visit_8 timestamp without time zone,
    cmam_follow_up_count integer,


    sam_follow_up_month_1 timestamp without time zone,
    sam_follow_up_month_2 timestamp without time zone,
    sam_follow_up_month_3 timestamp without time zone,
    sam_follow_up_month_6 timestamp without time zone,
    sam_follow_up_month_12 timestamp without time zone,
    sam_follow_up_month_18 timestamp without time zone,
    sam_follow_up_month_24 timestamp without time zone
);

-- Insert record which are come from FHW Screening

with member_screening_details as (		-- get screening details
select
	admission_detail.id as fsam_admission_id,
	hid.location_id as fsam_admission_location_id,
	admission_detail.admission_date as fsam_admission_date,
	admission_detail.apetite_test as fsam_admission_apetite_test,
	admission_detail.bilateral_pitting_oedema as fsam_admission_bilateral_pitting_oedema,
	admission_detail.type_of_admission as fsam_admission_type,
	admission_detail.weight_at_admission as fsam_admission_weight,
	admission_detail.height as fsam_admission_height,
	admission_detail.mid_upper_arm_circumference as fsam_admission_muac,
	admission_detail.sd_score as fsam_admission_sd_score,
	admission_detail.complementary_feeding as fsam_admission_complementary_feeding,
	admission_detail.breast_feeding as fsam_admission_breast_feeding,
	admission_detail.death_date as fsam_admission_death_date,
	admission_detail.death_reason as fsam_admission_death_reason,
	admission_detail.other_death_reason as fsam_admission_other_death_reason,
	admission_detail.death_place as fsam_admission_death_place,
	admission_detail.defaulter_date as fsam_admission_defaulter_date,
	admission_detail.screening_center as fsam_admission_screening_center,
	admission_detail.problem_in_breast_feeding as fsam_admission_problem_in_breast_feeding,
	admission_detail.specialist_pediatrician_visit_flag as fsam_pediatrician_visit,
	case when discharge_detail.discharge_date is not null then cast(discharge_detail.discharge_date as date) - cast(admission_detail.admission_date as date)
	     when admission_detail.defaulter_date is not null then cast(admission_detail.defaulter_date as date) - cast(admission_detail.admission_date as date)
	     else cast(now() as date) - cast(admission_detail.admission_date as date) end as fsam_inpatient_days,



	discharge_detail.id as fsam_discharge_id,
	discharge_detail.discharge_date as fsam_discharge_date,
	discharge_detail.bilateral_pitting_oedema as fsam_discharge_bilateral_pitting_oedema,
	discharge_detail.weight as fsam_discharge_weight,
	discharge_detail.height as fsam_discharge_height,
	discharge_detail.mid_upper_arm_circumference as fsam_discharge_muac,
	discharge_detail.sd_score as fsam_discharge_sd_score,
	discharge_detail.discharge_status as fsam_discharge_status,
	case when (admission_detail.weight_at_admission + (admission_detail.weight_at_admission*0.15)) <= discharge_detail.weight then true else false end as fsam_discharge_15_weight_gain,
	case when (admission_detail.weight_at_admission + (admission_detail.weight_at_admission*0.15)) > discharge_detail.weight then true else false end as fsam_discharge_not_15_weight_gain,

	--8gm/kg/day calculation
	--(6.5*0.008)+6.5 = 6.552 - 6.5 = 0.052 (assuming 6.5 kg weight at admission)
	--discharge_weight >= (0.052 * no_of_days admitted) + admission_weight
	case when discharge_detail.weight >= (((admission_detail.weight_at_admission*0.008) * (date_part('day',cast(discharge_detail.discharge_date as timestamp)-cast(admission_detail.admission_date as timestamp)))) + admission_detail.weight_at_admission) then true else false end as fsam_discharge_8gm_kg_day_gain,
	case when discharge_detail.weight >= (((admission_detail.weight_at_admission*0.005) * (date_part('day',cast(discharge_detail.discharge_date as timestamp)-cast(admission_detail.admission_date as timestamp)))) + admission_detail.weight_at_admission) then true else false end as fsam_discharge_5gm_kg_day_gain,


	screening_detail.location_id as fsam_location_id,
	screening_detail.id as fsam_screening_id,

	screening_master.id as sam_screening_id,
	screening_master.height as sam_screening_height,
	screening_master.weight as sam_screening_weight,
	screening_master.sd_score as sam_screening_sd_score,
	screening_master.muac as sam_screening_muac,
	screening_master.have_pedal_edema as sam_screening_oedema,
	--true as sam_screening_is_sam,
	screening_master.appetite_test as sam_screening_appetite_test,

	screened_by_master.role_id as screened_by,

    cmam_master.id as cmam_master_id,
    cmam_master.identified_from as cmam_identified_from,
    cmam_master.cured_on as cmam_cured_on,
    cmam_master.cured_muac as cmam_cured_muac,
    cmam_master.service_date as cmam_service_date,
    cmam_master.location_id as cmam_location_id,

	screening_master.location_id as sam_screening_location_id,
	screening_master.service_date as sam_screening_service_date,
	screening_master.breast_sucking_problems as sam_breast_sucking_problems,
	screening_master.referral_done as sam_screening_referral_done,
	screening_master.referral_place as sam_screening_referral_place,
    screening_master.medical_complications_present as sam_screening_medical_complication,
	screening_master.member_id as child_id


from child_nutrition_sam_screening_master screening_master
left join child_cmtc_nrc_screening_detail screening_detail on screening_detail.reference_id = screening_master.id and screening_detail.identified_from ='FHW'
left join child_nutrition_cmam_master cmam_master on cmam_master.reference_id = screening_master.id and cmam_master.identified_from ='FHW'
left join child_cmtc_nrc_admission_detail admission_detail on admission_detail.case_id = screening_detail.id
left join child_cmtc_nrc_discharge_detail discharge_detail on admission_detail.id = discharge_detail.admission_id
left join health_infrastructure_details hid on admission_detail.screening_center = hid.id
left join um_user screened_by_master on screening_master.done_by = screened_by_master.id
--where screening_master.member_id = 96502151
),
member_screening_details_direct as (

	select

	admission_detail.id as fsam_admission_id,
	hid.location_id as fsam_admission_location_id,
	admission_detail.admission_date as fsam_admission_date,
	admission_detail.apetite_test as fsam_admission_apetite_test,
	admission_detail.bilateral_pitting_oedema as fsam_admission_bilateral_pitting_oedema,
	admission_detail.type_of_admission as fsam_admission_type,
	admission_detail.weight_at_admission as fsam_admission_weight,
	admission_detail.height as fsam_admission_height,
	admission_detail.mid_upper_arm_circumference as fsam_admission_muac,
	admission_detail.sd_score as fsam_admission_sd_score,
	admission_detail.complementary_feeding as fsam_admission_complementary_feeding,
	admission_detail.breast_feeding as fsam_admission_breast_feeding,
	admission_detail.death_date as fsam_admission_death_date,
	admission_detail.death_reason as fsam_admission_death_reason,
	admission_detail.other_death_reason as fsam_admission_other_death_reason,
	admission_detail.death_place as fsam_admission_death_place,
	admission_detail.defaulter_date as fsam_admission_defaulter_date,
	admission_detail.screening_center as fsam_admission_screening_center,
	admission_detail.problem_in_breast_feeding as fsam_admission_problem_in_breast_feeding,
	admission_detail.specialist_pediatrician_visit_flag as fsam_pediatrician_visit,
	case when discharge_detail.discharge_date is not null then cast(discharge_detail.discharge_date as date) - cast(admission_detail.admission_date as date)
	     when admission_detail.defaulter_date is not null then cast(admission_detail.defaulter_date as date) - cast(admission_detail.admission_date as date)
	     else cast(now() as date) - cast(admission_detail.admission_date as date) end as fsam_inpatient_days,

	discharge_detail.id as fsam_discharge_id,
	discharge_detail.discharge_date as fsam_discharge_date,
	discharge_detail.bilateral_pitting_oedema as fsam_discharge_bilateral_pitting_oedema,
	discharge_detail.weight as fsam_discharge_weight,
	discharge_detail.height as fsam_discharge_height,
	discharge_detail.mid_upper_arm_circumference as fsam_discharge_muac,
	discharge_detail.sd_score as fsam_discharge_sd_score,
	discharge_detail.discharge_status as fsam_discharge_status,
	case when (admission_detail.weight_at_admission + (admission_detail.weight_at_admission*0.15)) <= discharge_detail.weight then true else false end as fsam_discharge_15_weight_gain,
	case when (admission_detail.weight_at_admission + (admission_detail.weight_at_admission*0.15)) > discharge_detail.weight then true else false end as fsam_discharge_not_15_weight_gain,

	--8gm/kg/day calculation
	--(6.5*0.008)+6.5 = 6.552 - 6.5 = 0.052 (assuming 6.5 kg weight at admission)
	--discharge_weight >= (0.052 * no_of_days admitted) + admission_weight
	case when discharge_detail.weight >= (((admission_detail.weight_at_admission*0.008) * (date_part('day',cast(discharge_detail.discharge_date as timestamp)-cast(admission_detail.admission_date as timestamp)))) + admission_detail.weight_at_admission) then true else false end as fsam_discharge_8gm_kg_day_gain,
	case when discharge_detail.weight >= (((admission_detail.weight_at_admission*0.005) * (date_part('day',cast(discharge_detail.discharge_date as timestamp)-cast(admission_detail.admission_date as timestamp)))) + admission_detail.weight_at_admission) then true else false end as fsam_discharge_5gm_kg_day_gain,


	screening_detail.location_id as fsam_location_id,
	screening_detail.id as fsam_screening_id,

	cast(null as integer) as sam_screening_id,
	cast(null as numeric) as sam_screening_height,
	cast(null as numeric) as sam_screening_weight,
	cast(null as text) as sam_screening_sd_score,
	cast(null as numeric) as sam_screening_muac,
	cast(null as boolean) as sam_screening_oedema,
	--cast(null as boolean) as sam_screening_is_sam,
	cast(null as boolean) as sam_screening_appetite_test,

	cast(null as integer) as screened_by,

	cmam_master.id as cmam_master_id,
	cmam_master.identified_from as cmam_identified_from,
	cmam_master.cured_on as cmam_cured_on,
	cmam_master.cured_muac as cmam_cured_muac,
	cmam_master.service_date as cmam_service_date,
	cmam_master.location_id as cmam_location_id,

	cast(null as integer) as sam_screening_location_id,
	cast(null as date) as sam_screening_service_date,
	cast(null as boolean) as sam_breast_sucking_problems,
	cast(null as boolean) as sam_screening_referral_done,
	cast(null as integer) as sam_screening_referral_place,
	cast(null as boolean) as sam_screening_medical_complication,
	screening_detail.child_id as child_id

	from child_cmtc_nrc_screening_detail screening_detail
	inner join
	child_cmtc_nrc_admission_detail admission_detail on screening_detail.id = admission_detail.case_id
	left join child_cmtc_nrc_discharge_detail discharge_detail on admission_detail.id = discharge_detail.admission_id
	left join child_nutrition_cmam_master cmam_master on cmam_master.reference_id = screening_detail.id and cmam_master.identified_from = 'FSAM'
	left join health_infrastructure_details hid on admission_detail.screening_center = hid.id


	where screening_detail.identified_from='DIRECT'

),member_screening_details_cmam_to_fsam as (
    select

	admission_detail.id as fsam_admission_id,
	hid.location_id as fsam_admission_location_id,
	admission_detail.admission_date as fsam_admission_date,
	admission_detail.apetite_test as fsam_admission_apetite_test,
	admission_detail.bilateral_pitting_oedema as fsam_admission_bilateral_pitting_oedema,
	admission_detail.type_of_admission as fsam_admission_type,
	admission_detail.weight_at_admission as fsam_admission_weight,
	admission_detail.height as fsam_admission_height,
	admission_detail.mid_upper_arm_circumference as fsam_admission_muac,
	admission_detail.sd_score as fsam_admission_sd_score,
	admission_detail.complementary_feeding as fsam_admission_complementary_feeding,
	admission_detail.breast_feeding as fsam_admission_breast_feeding,
	admission_detail.death_date as fsam_admission_death_date,
	admission_detail.death_reason as fsam_admission_death_reason,
	admission_detail.other_death_reason as fsam_admission_other_death_reason,
	admission_detail.death_place as fsam_admission_death_place,
	admission_detail.defaulter_date as fsam_admission_defaulter_date,
	admission_detail.screening_center as fsam_admission_screening_center,
	admission_detail.problem_in_breast_feeding as fsam_admission_problem_in_breast_feeding,
	admission_detail.specialist_pediatrician_visit_flag as fsam_pediatrician_visit,
	case when discharge_detail.discharge_date is not null then cast(discharge_detail.discharge_date as date) - cast(admission_detail.admission_date as date)
	     when admission_detail.defaulter_date is not null then cast(admission_detail.defaulter_date as date) - cast(admission_detail.admission_date as date)
	     else cast(now() as date) - cast(admission_detail.admission_date as date) end as fsam_inpatient_days,

	discharge_detail.id as fsam_discharge_id,
	discharge_detail.discharge_date as fsam_discharge_date,
	discharge_detail.bilateral_pitting_oedema as fsam_discharge_bilateral_pitting_oedema,
	discharge_detail.weight as fsam_discharge_weight,
	discharge_detail.height as fsam_discharge_height,
	discharge_detail.mid_upper_arm_circumference as fsam_discharge_muac,
	discharge_detail.sd_score as fsam_discharge_sd_score,
	discharge_detail.discharge_status as fsam_discharge_status,
	case when (admission_detail.weight_at_admission + (admission_detail.weight_at_admission*0.15)) <= discharge_detail.weight then true else false end as fsam_discharge_15_weight_gain,
	case when (admission_detail.weight_at_admission + (admission_detail.weight_at_admission*0.15)) > discharge_detail.weight then true else false end as fsam_discharge_not_15_weight_gain,

	--8gm/kg/day calculation
	--(6.5*0.008)+6.5 = 6.552 - 6.5 = 0.052 (assuming 6.5 kg weight at admission)
	--discharge_weight >= (0.052 * no_of_days admitted) + admission_weight
	case when discharge_detail.weight >= (((admission_detail.weight_at_admission*0.008) * (date_part('day',cast(discharge_detail.discharge_date as timestamp)-cast(admission_detail.admission_date as timestamp)))) + admission_detail.weight_at_admission) then true else false end as fsam_discharge_8gm_kg_day_gain,
	case when discharge_detail.weight >= (((admission_detail.weight_at_admission*0.005) * (date_part('day',cast(discharge_detail.discharge_date as timestamp)-cast(admission_detail.admission_date as timestamp)))) + admission_detail.weight_at_admission) then true else false end as fsam_discharge_5gm_kg_day_gain,


	screening_detail.location_id as fsam_location_id,
	screening_detail.id as fsam_screening_id,

	cast(null as integer) as sam_screening_id,
	cast(null as numeric) as sam_screening_height,
	cast(null as numeric) as sam_screening_weight,
	cast(null as text) as sam_screening_sd_score,
	cast(null as numeric) as sam_screening_muac,
	cast(null as boolean) as sam_screening_oedema,
	--cast(null as boolean) as sam_screening_is_sam,
	cast(null as boolean) as sam_screening_appetite_test,

	cast(null as integer) as screened_by,

	cmam_master.id as cmam_master_id,
	cmam_master.identified_from as cmam_identified_from,
	cmam_master.cured_on as cmam_cured_on,
	cmam_master.cured_muac as cmam_cured_muac,
	cmam_master.service_date as cmam_service_date,
	cmam_master.location_id as cmam_location_id,

	cast(null as integer) as sam_screening_location_id,
	cast(null as date) as sam_screening_service_date,
	cast(null as boolean) as sam_breast_sucking_problems,
	cast(null as boolean) as sam_screening_referral_done,
	cast(null as integer) as sam_screening_referral_place,
	cast(null as boolean) as sam_screening_medical_complication,
	screening_detail.child_id as child_id

	from child_cmtc_nrc_screening_detail screening_detail
	inner join
	child_cmtc_nrc_admission_detail admission_detail on screening_detail.id = admission_detail.case_id
	left join child_cmtc_nrc_discharge_detail discharge_detail on admission_detail.id = discharge_detail.admission_id
	left join child_nutrition_cmam_master cmam_master on cmam_master.reference_id = screening_detail.id and cmam_master.identified_from = 'FSAM'
	left join health_infrastructure_details hid on admission_detail.screening_center = hid.id

	where screening_detail.identified_from = 'CMAM'
),
admission_details as (				-- get admission and dischage details
	select * from member_screening_details
	union all
	select * from member_screening_details_direct
	union all
	select * from member_screening_details_cmam_to_fsam
),
admission_details_member_details as (
	select rch_child_analytics_details.gender as gender,
	rch_child_analytics_details.dob,
	case when (cast(details.sam_screening_service_date as date)- cast( rch_child_analytics_details.dob as timestamp)) < interval '6 months'
	then (sam_breast_sucking_problems is true or sam_screening_sd_score = 'SD3' OR sam_screening_sd_score ='SD4' or sam_screening_medical_complication)	-- for less then 6 months
	else  (sam_screening_muac < 11.5 or sam_screening_oedema is true or sam_screening_sd_score = 'SD3' OR sam_screening_sd_score ='SD4' or sam_screening_medical_complication)-- for more then 6 months
	end as sam_screening_is_sam
	,details.* from admission_details details
	inner join rch_child_analytics_details on details.child_id = rch_child_analytics_details.member_id
)

insert into child_cmtc_nrc_analytics_details_t
(gender,dob,screened_by,fsam_screening_id,fsam_admission_id,fsam_admission_location_id,fsam_admission_date,fsam_admission_apetite_test,fsam_admission_bilateral_pitting_oedema,fsam_admission_type,fsam_admission_weight,
fsam_admission_height,fsam_admission_muac,fsam_admission_sd_score,fsam_admission_complementary_feeding,fsam_admission_breast_feeding,fsam_discharge_id,
fsam_discharge_bilateral_pitting_oedema,fsam_discharge_weight,fsam_discharge_height,fsam_discharge_muac,fsam_discharge_sd_score,fsam_discharge_status,
fsam_discharge_15_weight_gain,fsam_discharge_not_15_weight_gain,fsam_location_id,fsam_admission_death_date,fsam_admission_death_reason,fsam_admission_other_death_reason,fsam_admission_death_place,
fsam_admission_defaulter_date,fsam_admission_screening_center,fsam_admission_problem_in_breast_feeding,fsam_pediatrician_visit,fsam_inpatient_days,sam_screening_id,sam_screening_height,
sam_screening_weight,sam_screening_sd_score,sam_screening_muac,sam_screening_location_id,sam_screening_service_date,sam_screening_referral_done,sam_screening_referral_place,
sam_screening_medical_complication,sam_screening_oedema,sam_screening_is_sam,sam_screening_appetite_test,child_id,cmam_master_id,cmam_identified_from,cmam_cured_on,
cmam_cured_muac,cmam_service_date,cmam_location_id,fsam_discharge_date,fsam_discharge_8gm_kg_day_gain,fsam_discharge_5gm_kg_day_gain,sam_breast_sucking_problems
)
select
gender,dob,screened_by,fsam_screening_id,fsam_admission_id,fsam_admission_location_id,fsam_admission_date,fsam_admission_apetite_test,fsam_admission_bilateral_pitting_oedema,fsam_admission_type,fsam_admission_weight,
fsam_admission_height,fsam_admission_muac,fsam_admission_sd_score,fsam_admission_complementary_feeding,fsam_admission_breast_feeding,fsam_discharge_id,
fsam_discharge_bilateral_pitting_oedema,fsam_discharge_weight,fsam_discharge_height,fsam_discharge_muac,fsam_discharge_sd_score,fsam_discharge_status,
fsam_discharge_15_weight_gain,fsam_discharge_not_15_weight_gain,fsam_location_id,fsam_admission_death_date,fsam_admission_death_reason,fsam_admission_other_death_reason,fsam_admission_death_place,
fsam_admission_defaulter_date,fsam_admission_screening_center,fsam_admission_problem_in_breast_feeding,fsam_pediatrician_visit,fsam_inpatient_days,sam_screening_id,sam_screening_height,
sam_screening_weight,sam_screening_sd_score,sam_screening_muac,sam_screening_location_id,sam_screening_service_date,sam_screening_referral_done,sam_screening_referral_place,
sam_screening_medical_complication,sam_screening_oedema,sam_screening_is_sam,sam_screening_appetite_test,child_id,cmam_master_id,cmam_identified_from,cmam_cured_on,
cmam_cured_muac,cmam_service_date,cmam_location_id,fsam_discharge_date,fsam_discharge_8gm_kg_day_gain,fsam_discharge_5gm_kg_day_gain,sam_breast_sucking_problems
from admission_details_member_details;

--FSAM to CMAM - update data

with details as (
    select screening_detail.id as fsam_screening_id,
    cmam_master.id as cmam_master_id,
    cmam_master.identified_from as cmam_identified_from,
    cmam_master.cured_on as cmam_cured_on,
    cmam_master.cured_muac as cmam_cured_muac,
    cmam_master.service_date as cmam_service_date
    from child_cmtc_nrc_screening_detail screening_detail
    inner join child_nutrition_cmam_master cmam_master on screening_detail.id = cmam_master.reference_id
    and cmam_master.identified_from = 'FSAM'
)update child_cmtc_nrc_analytics_details_t
set cmam_master_id = details.cmam_master_id,
cmam_identified_from = details.cmam_identified_from,
cmam_cured_on = details.cmam_cured_on,
cmam_cured_muac = details.cmam_cured_muac,
cmam_service_date = details.cmam_service_date
from details
where child_cmtc_nrc_analytics_details_t.fsam_screening_id = details.fsam_screening_id;

-- update the visits

with followup_with_visit_id as (
    select member_id, cmam_master_id ,service_date,id, row_number() over(partition by cmam_master_id order by id) as visit_no from child_nutrition_cmam_followup
),
followup_visits as (
select
	case when  visit_no = 1 then max(service_date) end as visit_1,
	case when  visit_no = 2 then max(service_date) end as visit_2,
	case when  visit_no = 3 then max(service_date) end as visit_3,
	case when  visit_no = 4 then max(service_date) end as visit_4,
	case when  visit_no = 5 then max(service_date) end as visit_5,
	case when  visit_no = 6 then max(service_date) end as visit_6,
	case when  visit_no = 7 then max(service_date) end as visit_7,
	case when  visit_no = 8 then max(service_date) end as visit_8,
	max(visit_no) as cmam_follow_up_count,
	cmam_master_id

from followup_with_visit_id
group by cmam_master_id,visit_no),
cmam_visits as (
select
	max(visit_1) as visit_1,
	max(visit_2) as visit_2,
	max(visit_3) as visit_3,
	max(visit_4) as visit_4,
	max(visit_5) as visit_5,
	max(visit_6) as visit_6,
	max(visit_7) as visit_7,
	max(visit_8) as visit_8,
	max(cmam_follow_up_count) as cmam_follow_up_count,
	cmam_master_id
from followup_visits
group by cmam_master_id
)
update child_cmtc_nrc_analytics_details_t
set
    cmam_visit_1 = cmam_visits.visit_1,
    cmam_visit_2 = cmam_visits.visit_2,
    cmam_visit_3 = cmam_visits.visit_3,
    cmam_visit_4 = cmam_visits.visit_4,
    cmam_visit_5 = cmam_visits.visit_5,
    cmam_visit_6 = cmam_visits.visit_6,
    cmam_visit_7 = cmam_visits.visit_7,
    cmam_visit_8 = cmam_visits.visit_8,
    cmam_follow_up_count = cmam_visits.cmam_follow_up_count
from cmam_visits
where child_cmtc_nrc_analytics_details_t.cmam_master_id = cmam_visits.cmam_master_id;


with followup_with_visit_id as (
    select row_number() over(partition by admission_id order by id) as visit_no,
    id,
    child_id,
    admission_id,
    follow_up_date,
    weight
    from child_cmtc_nrc_follow_up
), followup_visits as (
    select admission_id,
	case when visit_no = 1 then max(follow_up_date) end as visit_1,
	case when visit_no = 1 then max(weight) end as visit_1_weight,
	case when visit_no = 2 then max(follow_up_date) end as visit_2,
	case when visit_no = 2 then max(weight) end as visit_2_weight,
	case when visit_no = 3 then max(follow_up_date) end as visit_3,
	case when visit_no = 3 then max(weight) end as visit_3_weight
    from followup_with_visit_id
    group by admission_id,visit_no
), fsam_visits as (
    select admission_id,
	max(visit_1) as visit_1,
	max(visit_1_weight) as visit_1_weight,
	max(visit_2) as visit_2,
	max(visit_2_weight) as visit_2_weight,
	max(visit_3) as visit_3,
	max(visit_3_weight) as visit_3_weight
    from followup_visits
    group by admission_id
)
update child_cmtc_nrc_analytics_details_t
set fsam_follow_up_visit_1 = fsam_visits.visit_1,
    fsam_follow_up_visit_1_weight = fsam_visits.visit_1_weight,
    fsam_follow_up_visit_2 = fsam_visits.visit_2,
    fsam_follow_up_visit_2_weight = fsam_visits.visit_2_weight,
    fsam_follow_up_visit_3 = fsam_visits.visit_3,
    fsam_follow_up_visit_3_weight = fsam_visits.visit_3_weight
from fsam_visits
where child_cmtc_nrc_analytics_details_t.fsam_admission_id = fsam_visits.admission_id;

update child_cmtc_nrc_analytics_details_t
set fsam_discharge_15_weight_gain_at_end_of_program = case when (fsam_admission_weight + (fsam_admission_weight*0.15)) <= fsam_follow_up_visit_3_weight then true else false end;

with followup_with_visit_id as (
    select id,member_id,reference_id,service_date,
    row_number() over(partition by reference_id order by id) as visit_no
    from child_nutrition_sam_screening_master
    where notification_id = (select id from notification_type_master where code = 'FHW_SAM_AFTER_CMAM')
),
followup_visits as (
select
	case when  visit_no = 1 then max(service_date) end as visit_1,
	case when  visit_no = 2 then max(service_date) end as visit_2,
	case when  visit_no = 3 then max(service_date) end as visit_3,
	case when  visit_no = 6 then max(service_date) end as visit_6,
	case when  visit_no = 12 then max(service_date) end as visit_12,
	case when  visit_no = 18 then max(service_date) end as visit_18,
	case when  visit_no = 24 then max(service_date) end as visit_24,
	reference_id
    from followup_with_visit_id
    group by reference_id,visit_no
),after_sam_visits as (
select
	max(visit_1) as visit_1,
	max(visit_2) as visit_2,
	max(visit_3) as visit_3,
	max(visit_6) as visit_6,
	max(visit_12) as visit_12,
	max(visit_18) as visit_18,
	max(visit_24) as visit_24,
	reference_id
from followup_visits
group by reference_id
)
update child_cmtc_nrc_analytics_details_t
set
    sam_follow_up_month_1 = after_sam_visits.visit_1,
    sam_follow_up_month_2 = after_sam_visits.visit_2,
    sam_follow_up_month_3 = after_sam_visits.visit_3,
    sam_follow_up_month_6 = after_sam_visits.visit_6,
    sam_follow_up_month_12 = after_sam_visits.visit_12,
    sam_follow_up_month_18 = after_sam_visits.visit_18,
    sam_follow_up_month_24 = after_sam_visits.visit_24
from after_sam_visits
where child_cmtc_nrc_analytics_details_t.cmam_master_id = after_sam_visits.reference_id;


drop table if exists child_cmtc_nrc_health_facility_wise_analytics_wise_details_t;

create table child_cmtc_nrc_health_facility_wise_analytics_wise_details_t
(
	health_infra_id integer,
	month_year date,
	less_than_6_months_admitted integer,
	above_6_months_admitted integer,
	less_than_3_sd integer,
	muac_less_than_11_5 integer,
	sd_and_muac integer,
	oedema integer,
	height_less_than_45 integer,
	visited_by_pediatrician integer,
	discharge_from_facility integer,
	fsam_follow_up_visit_1 integer,
	fsam_follow_up_visit_2 integer,
	fsam_follow_up_visit_3 integer,
	cured integer,
	sam_to_mam integer,
	sam_to_sam integer,
	defaulters integer,
	death integer,
	referred_for_cmam integer,
	weight_gain_15 integer,
	weight_gain_15_at_end_of_program integer,
	weight_gain_not_15 integer,
	weight_gain_8gm_kg_day integer,
	weight_gain_5gm_kg_day integer,
	inpatient_days integer
);

with dates as (
    select cast(dates as date) as from_date,
    cast(dates + interval '1 month' - interval '1 millisecond' as date) as to_date
    from generate_series(date '2009-01-01', current_date, '1 month') as dates
),cmtc_nrc_count as (
	select fsam_admission_screening_center,
	dates.from_date as month_year,
	count(1) filter (where dob <= fsam_admission_date - interval '6 month') as above_6_months_admitted,
	count(1) filter (where dob > fsam_admission_date - interval '6 month') as less_than_6_months_admitted,
	count(1) filter (where fsam_admission_sd_score in ('SD4','SD3')) as less_than_3_sd,
	count(1) filter (where fsam_admission_muac < 11.5) as muac_less_than_11_5,
	count(1) filter (where fsam_admission_sd_score in ('SD4','SD3') and fsam_admission_muac < 11.5) as sd_and_muac,
	count(1) filter (where fsam_admission_bilateral_pitting_oedema in ('+','++','+++')) as oedema,
	count(1) filter (where fsam_admission_height < 45) as height_less_than_45,
	count(1) filter (where fsam_pediatrician_visit) as visited_by_pediatrician,
	count(1) filter (where fsam_discharge_id is not null) as discharge_from_facility,
	count(1) filter (where fsam_follow_up_visit_1 is not null) as fsam_follow_up_visit_1,
	count(1) filter (where fsam_follow_up_visit_2 is not null) as fsam_follow_up_visit_2,
	count(1) filter (where fsam_follow_up_visit_3 is not null) as fsam_follow_up_visit_3,
	count(1) filter (where fsam_discharge_status = 'SAM_TO_NORMAL') as cured,
	count(1) filter (where fsam_discharge_status = 'SAM_TO_MAM') as sam_to_mam,
	count(1) filter (where fsam_discharge_status = 'SAM_TO_SAM') as sam_to_sam,
	count(1) filter (where fsam_admission_defaulter_date is not null) as defaulters,
	count(1) filter (where fsam_admission_death_date is not null) as death,
	count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FSAM') as referred_for_cmam,
	count(1) filter (where fsam_discharge_15_weight_gain) as weight_gain_15,
	count(1) filter (where fsam_discharge_15_weight_gain_at_end_of_program) as weight_gain_15_at_end_of_program,
	count(1) filter (where fsam_discharge_not_15_weight_gain) as weight_gain_not_15,
	count(1) filter (where fsam_discharge_8gm_kg_day_gain) as weight_gain_8gm_kg_day,
	count(1) filter (where fsam_discharge_5gm_kg_day_gain) as weight_gain_5gm_kg_day,
	sum(fsam_inpatient_days) as inpatient_days
	from child_cmtc_nrc_analytics_details_t
	inner join dates on child_cmtc_nrc_analytics_details_t.fsam_admission_date between cast(dates.from_date as date) and cast(dates.to_date as date)
	group by fsam_admission_screening_center,dates.from_date
)
insert into child_cmtc_nrc_health_facility_wise_analytics_wise_details_t
(health_infra_id,month_year,less_than_6_months_admitted,above_6_months_admitted,
less_than_3_sd,muac_less_than_11_5,sd_and_muac,oedema,height_less_than_45,visited_by_pediatrician,
discharge_from_facility,fsam_follow_up_visit_1,fsam_follow_up_visit_2,fsam_follow_up_visit_3,
cured,sam_to_mam,sam_to_sam,defaulters,death,referred_for_cmam,weight_gain_15,weight_gain_15_at_end_of_program,
weight_gain_not_15,weight_gain_8gm_kg_day,weight_gain_5gm_kg_day,inpatient_days)
select fsam_admission_screening_center,month_year,less_than_6_months_admitted,above_6_months_admitted,
less_than_3_sd,muac_less_than_11_5,sd_and_muac,oedema,height_less_than_45,visited_by_pediatrician,
discharge_from_facility,fsam_follow_up_visit_1,fsam_follow_up_visit_2,fsam_follow_up_visit_3,
cured,sam_to_mam,sam_to_sam,defaulters,death,referred_for_cmam,weight_gain_15,weight_gain_15_at_end_of_program,
weight_gain_not_15,weight_gain_8gm_kg_day,weight_gain_5gm_kg_day,inpatient_days
from cmtc_nrc_count;

drop table if exists child_cmtc_nrc_analytics_location_wise_details_t;

create TABLE child_cmtc_nrc_analytics_location_wise_details_t (
	location_id integer,
	month_year date,
	total_children_under_5_years integer,
	childer_screen_by_anm integer,
	sam_child integer,
	sam_child_male integer,
	sam_child_female integer,
	sam_child_0_to_6_months_male integer,
	sam_child_0_to_6_months_female integer,
	sam_child_6_months_to_3_years_male integer,
	sam_child_6_months_to_3_years_female integer,
	sam_child_3_years_to_5_years_male integer,
	sam_child_3_years_to_5_years_female integer,
	sam_no_appetite integer,
	sam_less_than_3sd_m integer,
	sam_less_than_3sd_f integer,
	sam_less_than_11_5_muac_m integer,
	sam_less_than_11_5_muac_f integer,
	sam_less_3sd_11_5_muac_m integer,
	sam_less_3sd_11_5_muac_f integer,
	sam_oedema_m integer,
	sam_oedema_f integer,
	sam_45_cm_lenth_child_m integer,
	sam_45_cm_lenth_child_f integer,
	cmam_sam_children_m integer,
	cmam_sam_children_f integer,
	cmtc_sam_children_m integer,
	cmtc_sam_children_f integer,
	mam_children integer,
	muw_children integer,
	suw_children integer,
	stunted_children integer,
	sam_boys_less_than_6_month integer,
	sam_girls_less_than_6_month integer,
	sam_boys_greater_than_6_month integer,
	sam_girls_greater_than_6_month integer,
	apetite_pass_no_medical_complication_boys integer,
	apetite_pass_no_medical_complication_girls integer,
	apetite_fail_medical_complication_boys integer,
	apetite_fail_medical_complication_girls integer,
	apetite_pass_medical_complication_boys integer,
	apetite_pass_medical_complication_girls integer,
	apetite_fail_no_medical_complication_boys integer,
	apetite_fail_no_medical_complication_girls integer
);

with dates as (
    select cast(dates as date) as from_date,
    cast(dates + interval '1 month' - interval '1 millisecond' as date) as to_date
    from generate_series(date '2009-01-01', current_date, '1 month') as dates
),children_under_5_years as (
     select loc_id as location_id,
     dates.from_date as month_year,
     count(1) filter (where cast(dob as date) >= cast((dates.from_date - interval '5 years') as date)) as total_children_under_5_years
     from rch_child_analytics_details
     inner join dates on true
     where member_state != 'DEAD'
     and death_date is null
     and member_id is not null
     group by loc_id,dates.from_date
 ),sam_screening_list as (
	select location_id as location_id,
	dates.from_date as month_year,
	count(1) filter (where screened_by = 30) as childern_screen_by_anm,
	count(1) filter (where screened_by = 24) as childern_screened_by_asha,
    count(1) filter (where sam_screening_is_sam) as sam_child,
    count(1) filter (where gender = 'M' and sam_screening_is_sam) as sam_child_male,
    count(1) filter (where gender = 'F' and sam_screening_is_sam) as sam_child_female,
    count(1) filter (where gender = 'M' and sam_screening_is_sam and cast(screened_on as date) - cast(dob as timestamp) < interval '6 months') as sam_child_0_to_6_months_male,
    count(1) filter (where gender = 'F' and sam_screening_is_sam and cast(screened_on as date) - cast(dob as timestamp) < interval '6 months') as sam_child_0_to_6_months_female,
    count(1) filter (where gender = 'M' and sam_screening_is_sam and cast(screened_on as date) - cast(dob as timestamp) >= interval '6 months' and cast(screened_on as date) - cast(dob as timestamp) < interval '3 years') as sam_child_6_months_to_3_years_male,
    count(1) filter (where gender = 'F' and sam_screening_is_sam and cast(screened_on as date) - cast(dob as timestamp) >= interval '6 months' and cast(screened_on as date) - cast(dob as timestamp) < interval '3 years') as sam_child_6_months_to_3_years_female,
    count(1) filter (where gender = 'M' and sam_screening_is_sam and cast(screened_on as date) - cast(dob as timestamp) >= interval '3 years') as sam_child_3_years_to_5_years_male,
    count(1) filter (where gender = 'F' and sam_screening_is_sam and cast(screened_on as date) - cast(dob as timestamp) >= interval '3 years') as sam_child_3_years_to_5_years_female,
    count(1) filter (where sam_screening_is_sam and appetite_test is null) as sam_no_appetite,
    count(1) filter (where gender = 'M' and sd_score in ('SD4','SD3')) as sam_less_than_3sd_m,
    count(1) filter (where gender = 'F' and sd_score in ('SD4','SD3')) as sam_less_than_3sd_f,
    count(1) filter (where gender = 'M' and muac < 11.5) as sam_less_than_11_5_muac_m,
    count(1) filter (where gender = 'F' and muac < 11.5 ) as sam_less_than_11_5_muac_f,
    count(1) filter (where gender = 'M' and sd_score in ('SD4','SD3') and muac < 11.5 ) as sam_less_3sd_11_5_muac_m,
    count(1) filter (where gender = 'F' and sd_score in ('SD4','SD3') and muac < 11.5 ) as sam_less_3sd_11_5_muac_f,
    count(1) filter (where gender = 'M' and oedema) as sam_oedema_m,
    count(1) filter (where gender = 'F' and oedema) as sam_oedema_f,
    count(1) filter (where gender = 'M' and height < 45) as sam_45_cm_lenth_child_m,
    count(1) filter (where gender = 'F' and height < 45 ) as sam_45_cm_lenth_child_f,
    count(1) filter (where gender = 'M' and appetite_test ) as cmam_sam_children_m,
    count(1) filter (where gender = 'F' and appetite_test ) as cmam_sam_children_f,
    count(1) filter (where gender = 'M' and (
        case when (cast(screened_on as date) - cast(dob as timestamp)) < interval '6 months'
             then (breast_sucking_problems or sd_score in ('SD3','SD4') or medical_complication)
             when (cast(screened_on as date) - cast(dob as timestamp)) >= interval '6 months'
             then appetite_test is not null and (appetite_test is false or medical_complication or oedema) end)) as cmtc_sam_children_m,
    count(1) filter (where gender = 'F' and (
        case when (cast(screened_on as date) - cast(dob as timestamp)) < interval '6 months'
             then (breast_sucking_problems or sd_score in ('SD3','SD4') or medical_complication)
             when (cast(screened_on as date) - cast(dob as timestamp)) >= interval '6 months'
             then appetite_test is not null and (appetite_test is false or medical_complication or oedema) end)) as cmtc_sam_children_f,
    count(1) filter (where appetite_test) as mam_children,
    count(1) filter (where muw) as muw_children,
    count(1) filter (where suw) as suw_children,
    count(1) filter (where stunted) as stunted_children,
    count(1) filter (where gender = 'M' and  (cast(screened_on as date) - cast(dob as timestamp)) < interval '6 months' and sam_screening_is_sam) as sam_boys_less_than_6_month,
    count(1) filter (where gender = 'F' and  (cast(screened_on as date) - cast(dob as timestamp)) < interval '6 months' and sam_screening_is_sam) as sam_girls_less_than_6_month,
    count(1) filter (where gender = 'M' and  (cast(screened_on as date) - cast(dob as timestamp)) >= interval '6 months' and sam_screening_is_sam) as sam_boys_greater_than_6_month,
    count(1) filter (where gender = 'F' and  (cast(screened_on as date) - cast(dob as timestamp)) >= interval '6 months' and sam_screening_is_sam) as sam_girls_greater_than_6_month,
    count(1) filter (where appetite_test and medical_complication is false and gender = 'M') as apetite_pass_no_medical_complication_boys,
    count(1) filter (where appetite_test and medical_complication is false and gender = 'F') as apetite_pass_no_medical_complication_girls,
    count(1) filter (where appetite_test is false and medical_complication is true and gender = 'M') as apetite_fail_medical_complication_boys,
    count(1) filter (where appetite_test is false and medical_complication is true and gender = 'F') as apetite_fail_medical_complication_girls,
    count(1) filter (where appetite_test and medical_complication is true and gender = 'M') as apetite_pass_medical_complication_boys,
    count(1) filter (where appetite_test and medical_complication is true and gender = 'F') as apetite_pass_medical_complication_girls,
    count(1) filter (where appetite_test is false and medical_complication is false and gender = 'M') as apetite_fail_no_medical_complication_boys,
    count(1) filter (where appetite_test is false and medical_complication is false and gender = 'F') as apetite_fail_no_medical_complication_girls
    from child_screening_analytics_details_t
    inner join dates on screened_on between cast(dates.from_date as date) and cast(dates.to_date as date)
	group by location_id,dates.from_date
)
insert into child_cmtc_nrc_analytics_location_wise_details_t
(location_id,month_year,total_children_under_5_years,childer_screen_by_anm,sam_child,sam_child_male,sam_child_female,
sam_child_0_to_6_months_male,sam_child_0_to_6_months_female,
sam_child_6_months_to_3_years_male,sam_child_6_months_to_3_years_female,
sam_child_3_years_to_5_years_male,sam_child_3_years_to_5_years_female,
sam_no_appetite,sam_less_than_3sd_m, sam_less_than_3sd_f, sam_less_than_11_5_muac_m,
sam_less_than_11_5_muac_f, sam_less_3sd_11_5_muac_m, sam_less_3sd_11_5_muac_f,
sam_oedema_m, sam_oedema_f, sam_45_cm_lenth_child_m, sam_45_cm_lenth_child_f,
cmam_sam_children_m, cmam_sam_children_f, cmtc_sam_children_m, cmtc_sam_children_f,
mam_children, muw_children, suw_children, stunted_children, sam_boys_less_than_6_month,
sam_girls_less_than_6_month, sam_boys_greater_than_6_month,sam_girls_greater_than_6_month,
apetite_pass_no_medical_complication_boys,apetite_pass_no_medical_complication_girls,
apetite_fail_medical_complication_boys,apetite_fail_medical_complication_girls,
apetite_pass_medical_complication_boys,apetite_pass_medical_complication_girls,
apetite_fail_no_medical_complication_boys,apetite_fail_no_medical_complication_girls
)
select children_under_5_years.location_id,children_under_5_years.month_year,
total_children_under_5_years,childern_screen_by_anm,sam_child,sam_child_male,sam_child_female,
sam_child_0_to_6_months_male,sam_child_0_to_6_months_female,
sam_child_6_months_to_3_years_male,sam_child_6_months_to_3_years_female,
sam_child_3_years_to_5_years_male,sam_child_3_years_to_5_years_female,
sam_no_appetite,sam_less_than_3sd_m, sam_less_than_3sd_f,sam_less_than_11_5_muac_m,
sam_less_than_11_5_muac_f,sam_less_3sd_11_5_muac_m,sam_less_3sd_11_5_muac_f,
sam_oedema_m, sam_oedema_f, sam_45_cm_lenth_child_m, sam_45_cm_lenth_child_f,
cmam_sam_children_m,cmam_sam_children_f, cmtc_sam_children_m, cmtc_sam_children_f,
mam_children, muw_children, suw_children, stunted_children, sam_boys_less_than_6_month,
sam_girls_less_than_6_month, sam_boys_greater_than_6_month, sam_girls_greater_than_6_month,
apetite_pass_no_medical_complication_boys,apetite_pass_no_medical_complication_girls,
apetite_fail_medical_complication_boys,apetite_fail_medical_complication_girls,
apetite_pass_medical_complication_boys,apetite_pass_medical_complication_girls,
apetite_fail_no_medical_complication_boys,apetite_fail_no_medical_complication_girls
from children_under_5_years
left join sam_screening_list on children_under_5_years.location_id = sam_screening_list.location_id
and children_under_5_years.month_year = sam_screening_list.month_year;

drop table if exists child_cmtc_nrc_admited_analytics_location_wise_details_t;

create TABLE child_cmtc_nrc_admited_analytics_location_wise_details_t (
	location_id integer,
	month_year date,
	less_than_6_month_boys integer,
	less_than_6_month_girls integer,
	more_than_6_month_boys integer,
	more_than_6_month_girls integer,
	less_than_3_sd integer,
	muac_less_than_11_5 integer,
	sd_and_muac integer,
	oedema integer,
	height_less_than_45 integer,
	visited_by_pediatrician integer,
	discharge_from_facility integer,
	cured integer,
	sam_to_mam integer,
	sam_to_sam integer,
	defaulters integer,
	death integer,
	fsam_follow_up_visit_1 integer,
	fsam_follow_up_visit_2 integer,
	fsam_follow_up_visit_3 integer,
	referred_for_cmam integer,
	weight_gain_not_15 integer,
	weight_gain_15 integer,
	weight_gain_8gm_kg_day integer,
	fsam_discharge_5gm_kg_day_gain integer,
	inpatient_days integer
);

with dates as (
    select cast(dates as date) as from_date,
    cast(dates + interval '1 month' - interval '1 millisecond' as date) as to_date
    from generate_series(date '2009-01-01', current_date, '1 month') as dates
),child_admitted_cmtc as (
    select fsam_admission_location_id as location_id,
    dates.from_date as month_year,
    count(1) filter (where gender = 'M' and dob > fsam_admission_date - interval '6 month') as less_than_6_month_boys,
    count(1) filter (where gender = 'F' and dob > fsam_admission_date - interval '6 month' ) as less_than_6_month_girls,
    count(1) filter (where gender = 'M' and dob <= fsam_admission_date - interval '6 month' ) as more_than_6_month_boys,
    count(1) filter (where gender = 'F' and dob <= fsam_admission_date - interval '6 month' ) as more_than_6_month_girls,
    count(1) filter (where fsam_admission_sd_score in ('SD4','SD3')) as less_than_3_sd,
	count(1) filter (where fsam_admission_muac < 11.5) as muac_less_than_11_5,
	count(1) filter (where fsam_admission_sd_score in ('SD4','SD3') and fsam_admission_muac < 11.5) as sd_and_muac,
	count(1) filter (where fsam_admission_bilateral_pitting_oedema in ('+','++','+++')) as oedema,
    count(1) filter (where fsam_admission_height < 45) as height_less_than_45,
    count(1) filter (where fsam_pediatrician_visit) as visited_by_pediatrician,
    count(1) filter (where fsam_discharge_id is not null) as discharge_from_facility,
    count(1) filter (where fsam_discharge_status = 'SAM_TO_NORMAL') as cured,
    count(1) filter (where fsam_discharge_status = 'SAM_TO_MAM') as sam_to_mam,
	count(1) filter (where fsam_discharge_status = 'SAM_TO_SAM') as sam_to_sam,
    count(1) filter (where fsam_admission_defaulter_date is not null) as defaulters,
    count(1) filter (where fsam_admission_death_date is not null) as death,
    count(1) filter (where fsam_follow_up_visit_1 is not null) as fsam_follow_up_visit_1,
	count(1) filter (where fsam_follow_up_visit_2 is not null) as fsam_follow_up_visit_2,
	count(1) filter (where fsam_follow_up_visit_3 is not null) as fsam_follow_up_visit_3,
    count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FSAM') as referred_for_cmam,
    count(1) filter (where fsam_discharge_15_weight_gain) as weight_gain_15,
    count(1) filter (where fsam_discharge_not_15_weight_gain) as weight_gain_not_15,
    count(1) filter (where fsam_discharge_8gm_kg_day_gain) as weight_gain_8gm_kg_day,
    count(1) filter (where fsam_discharge_5gm_kg_day_gain) as fsam_discharge_5gm_kg_day_gain,
    sum(fsam_inpatient_days) as inpatient_days
    from child_cmtc_nrc_analytics_details_t cmad
    inner join dates on cmad.fsam_admission_date between cast(dates.from_date as date) and cast(dates.to_date as date)
	group by fsam_admission_location_id,dates.from_date
)
insert into child_cmtc_nrc_admited_analytics_location_wise_details_t
(location_id,month_year,less_than_6_month_boys,less_than_6_month_girls,more_than_6_month_boys,more_than_6_month_girls,
less_than_3_sd,muac_less_than_11_5,sd_and_muac,oedema,height_less_than_45,visited_by_pediatrician,discharge_from_facility,
cured,sam_to_mam,sam_to_sam,defaulters,death,fsam_follow_up_visit_1,fsam_follow_up_visit_2,fsam_follow_up_visit_3,
referred_for_cmam,weight_gain_15,weight_gain_not_15,weight_gain_8gm_kg_day,fsam_discharge_5gm_kg_day_gain,inpatient_days
)
select location_id,month_year,less_than_6_month_boys,less_than_6_month_girls,more_than_6_month_boys,more_than_6_month_girls,
less_than_3_sd,muac_less_than_11_5,sd_and_muac,oedema,height_less_than_45,visited_by_pediatrician,discharge_from_facility,
cured,sam_to_mam,sam_to_sam,defaulters,death,fsam_follow_up_visit_1,fsam_follow_up_visit_2,fsam_follow_up_visit_3,
referred_for_cmam,weight_gain_15,weight_gain_not_15,weight_gain_8gm_kg_day,fsam_discharge_5gm_kg_day_gain,inpatient_days
from child_admitted_cmtc;

drop table if exists child_cmam_analytics_location_wise_details_t;

create table child_cmam_analytics_location_wise_details_t
(
    location_id integer,
    month_year date,
    cmam_directly_enrolled_boys integer,
    cmam_directly_enrolled_girls integer,
    fsam_enrolled_boys integer,
    fsam_enrolled_girls integer,
    less_than_3_sd_score_boys integer,
    less_than_3_sd_score_girls integer,
    less_than_11_5_muac_boys integer,
    less_than_11_5_muac_girls integer,
    both_boys integer,
    both_girls integer,
    mam_discharged_from_cmtc_boys integer,
    mam_discharged_from_cmtc_girls integer,
    discharged_boys integer,
    discharged_girls integer,
    cured_sd_score_boys integer,
    cured_sd_score_girls integer,
    cured_muac_boys integer,
    cured_muac_girls integer,
    cured_from_cmam_boys integer,
    cured_from_cmam_girls integer,
    cured_from_fsam_boys integer,
    cured_from_fsam_girls integer,
    cmam_total_admission integer,
    cmam_visit_1 integer,
    cmam_visit_2 integer,
    cmam_visit_3 integer,
    cmam_visit_4 integer,
    cmam_visit_5 integer,
    cmam_visit_6 integer,
    cmam_visit_7 integer,
    cmam_visit_8 integer
);

with dates as (
    select cast(dates as date) as from_date,
    cast(dates + interval '1 month' - interval '1 millisecond' as date) as to_date
    from generate_series(date '2009-01-01', current_date, '1 month') as dates
),analytics as (
    select cmam_location_id as location_id,
    dates.from_date as month_year,
    count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FHW' and gender = 'M') as cmam_directly_enrolled_boys,
	count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FHW' and gender = 'F') as cmam_directly_enrolled_girls,
	count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FSAM' and gender = 'M') as fsam_enrolled_boys,
	count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FSAM' and gender = 'F') as fsam_enrolled_girls,
	count(1) filter (where cmam_master_id is not null and sam_screening_sd_score in ('SD3','SD4') and gender = 'M') as less_than_3_sd_score_boys,
	count(1) filter (where cmam_master_id is not null and sam_screening_sd_score in ('SD3','SD4') and gender = 'F') as less_than_3_sd_score_girls,
	count(1) filter (where cmam_master_id is not null and sam_screening_muac < 11.5 and gender = 'M') as less_than_11_5_muac_boys,
	count(1) filter (where cmam_master_id is not null and sam_screening_muac < 11.5 and gender = 'F') as less_than_11_5_muac_girls,
	count(1) filter (where cmam_master_id is not null and sam_screening_sd_score in ('SD3','SD4') and sam_screening_muac < 11.5 and gender = 'M') as both_boys,
	count(1) filter (where cmam_master_id is not null and sam_screening_sd_score in ('SD3','SD4') and sam_screening_muac < 11.5 and gender = 'F') as both_girls,
	count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FSAM' and fsam_discharge_status = 'SAM_TO_MAM' and gender = 'M') as mam_discharged_from_cmtc_boys,
	count(1) filter (where cmam_master_id is not null and cmam_identified_from = 'FSAM' and fsam_discharge_status = 'SAM_TO_MAM' and gender = 'F') as mam_discharged_from_cmtc_girls,
	count(1) filter (where cmam_follow_up_count = 8 and gender = 'M') as discharged_boys,
	count(1) filter (where cmam_follow_up_count = 8 and gender = 'F') as discharged_girls,
	cast(null as integer) as cured_sd_score_boys,
	cast(null as integer) as cured_sd_score_girls,
	count(1) filter (where cmam_cured_muac > 12.5 and gender = 'M') as cured_muac_boys,
	count(1) filter (where cmam_cured_muac > 12.5 and gender = 'F') as cured_muac_girls,
	count(1) filter (where cmam_cured_on is not null and cmam_identified_from = 'FHW' and gender = 'M') as cured_from_cmam_boys,
	count(1) filter (where cmam_cured_on is not null and cmam_identified_from = 'FHW' and gender = 'F') as cured_from_cmam_girls,
	count(1) filter (where cmam_cured_on is not null and cmam_identified_from = 'FSAM' and gender = 'M') as cured_from_fsam_boys,
	count(1) filter (where cmam_cured_on is not null and cmam_identified_from = 'FSAM' and gender = 'F') as cured_from_fsam_girls,
	count(1) filter (where cmam_master_id is not null) as cmam_total_admission,
	count(1) filter (where cmam_visit_1 is not null) as cmam_visit_1,
	count(1) filter (where cmam_visit_2 is not null) as cmam_visit_2,
	count(1) filter (where cmam_visit_3 is not null) as cmam_visit_3,
	count(1) filter (where cmam_visit_4 is not null) as cmam_visit_4,
	count(1) filter (where cmam_visit_5 is not null) as cmam_visit_5,
	count(1) filter (where cmam_visit_6 is not null) as cmam_visit_6,
	count(1) filter (where cmam_visit_7 is not null) as cmam_visit_7,
	count(1) filter (where cmam_visit_8 is not null) as cmam_visit_8
    from child_cmtc_nrc_analytics_details_t
    inner join dates on cmam_service_date between cast(dates.from_date as date) and cast(dates.to_date as date)
    group by cmam_location_id,dates.from_date
)
insert into child_cmam_analytics_location_wise_details_t
(location_id,month_year,cmam_directly_enrolled_boys,cmam_directly_enrolled_girls,fsam_enrolled_boys,
fsam_enrolled_girls,less_than_3_sd_score_boys,less_than_3_sd_score_girls,less_than_11_5_muac_boys,
less_than_11_5_muac_girls,both_boys,both_girls,mam_discharged_from_cmtc_boys,mam_discharged_from_cmtc_girls,
discharged_boys,discharged_girls,cured_sd_score_boys,cured_sd_score_girls,cured_muac_boys,cured_muac_girls,
cured_from_cmam_boys,cured_from_cmam_girls,cured_from_fsam_boys,cured_from_fsam_girls,
cmam_total_admission,cmam_visit_1,cmam_visit_2,cmam_visit_3,cmam_visit_4,
cmam_visit_5,cmam_visit_6,cmam_visit_7,cmam_visit_8
)
select location_id,month_year,cmam_directly_enrolled_boys,cmam_directly_enrolled_girls,fsam_enrolled_boys,
fsam_enrolled_girls,less_than_3_sd_score_boys,less_than_3_sd_score_girls,less_than_11_5_muac_boys,
less_than_11_5_muac_girls,both_boys,both_girls,mam_discharged_from_cmtc_boys,mam_discharged_from_cmtc_girls,
discharged_boys,discharged_girls,cured_sd_score_boys,cured_sd_score_girls,cured_muac_boys,cured_muac_girls,
cured_from_cmam_boys,cured_from_cmam_girls,cured_from_fsam_boys,cured_from_fsam_girls,
cmam_total_admission,cmam_visit_1,cmam_visit_2,cmam_visit_3,cmam_visit_4,
cmam_visit_5,cmam_visit_6,cmam_visit_7,cmam_visit_8
from analytics;

drop table if exists child_cmam_analytics_cure_location_wise_details_t;

create table child_cmam_analytics_cure_location_wise_details_t
(
    location_id integer,
    month_year date,
    sam_follow_up_month_1 integer,
    sam_follow_up_month_2 integer,
    sam_follow_up_month_3 integer,
    sam_follow_up_month_6 integer,
    sam_follow_up_month_12 integer,
    sam_follow_up_month_18 integer,
    sam_follow_up_month_24 integer
);

with dates as (
    select cast(dates as date) as from_date,
    cast(dates + interval '1 month' - interval '1 millisecond' as date) as to_date
    from generate_series(date '2009-01-01', current_date, '1 month') as dates
),analytics as (
    select cmam_location_id as location_id,
    dates.from_date as month_year,
    count(1) filter (where sam_follow_up_month_1 is not null) as sam_follow_up_month_1,
    count(1) filter (where sam_follow_up_month_2 is not null) as sam_follow_up_month_2,
    count(1) filter (where sam_follow_up_month_3 is not null) as sam_follow_up_month_3,
    count(1) filter (where sam_follow_up_month_6 is not null) as sam_follow_up_month_6,
    count(1) filter (where sam_follow_up_month_12 is not null) as sam_follow_up_month_12,
    count(1) filter (where sam_follow_up_month_18 is not null) as sam_follow_up_month_18,
    count(1) filter (where sam_follow_up_month_24 is not null) as sam_follow_up_month_24
    from child_cmtc_nrc_analytics_details_t
    inner join dates on cmam_cured_on between cast(dates.from_date as date) and cast(dates.to_date as date)
    group by cmam_location_id,dates.from_date
)
insert into child_cmam_analytics_cure_location_wise_details_t
(location_id,month_year,sam_follow_up_month_1,sam_follow_up_month_2,
sam_follow_up_month_3,sam_follow_up_month_6,sam_follow_up_month_12,
sam_follow_up_month_18,sam_follow_up_month_24)
select location_id,month_year,sam_follow_up_month_1,sam_follow_up_month_2,
sam_follow_up_month_3,sam_follow_up_month_6,sam_follow_up_month_12,
sam_follow_up_month_18,sam_follow_up_month_24
from analytics;

commit;

begin;

    drop table if exists child_screening_analytics_t;

    drop table if exists child_screening_analytics_details;
    alter table child_screening_analytics_details_t rename to child_screening_analytics_details;

    drop table if exists child_cmtc_nrc_analytics_details;
    alter table child_cmtc_nrc_analytics_details_t rename to child_cmtc_nrc_analytics_details;

    drop table if exists child_cmtc_nrc_health_facility_wise_analytics_wise_details;
    alter table child_cmtc_nrc_health_facility_wise_analytics_wise_details_t rename to child_cmtc_nrc_health_facility_wise_analytics_wise_details;

    drop table if exists child_cmam_analytics_cure_location_wise_details;
    alter table child_cmam_analytics_cure_location_wise_details_t rename to child_cmam_analytics_cure_location_wise_details;

    drop table if exists child_cmam_analytics_location_wise_details;
    alter table child_cmam_analytics_location_wise_details_t rename to child_cmam_analytics_location_wise_details;

    drop table if exists child_cmtc_nrc_analytics_location_wise_details;
    alter table child_cmtc_nrc_analytics_location_wise_details_t rename to child_cmtc_nrc_analytics_location_wise_details;

    drop table if exists child_cmtc_nrc_admited_analytics_location_wise_details;
    alter table child_cmtc_nrc_admited_analytics_location_wise_details_t rename to child_cmtc_nrc_admited_analytics_location_wise_details;
commit;

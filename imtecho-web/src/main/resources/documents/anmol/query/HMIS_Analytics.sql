begin;

drop table if exists ncd_service_provided_during_year_t;

create table ncd_service_provided_during_year_t (
   health_infra_id bigint,
   month_year date,
   no_of_hypertension_cases_screened integer,
   no_of_hypertension_cases integer,
   no_of_hypertension_cases_in_treatment integer,
   no_of_diabetes_cases_screened integer,
   no_of_diabetes_cases integer,
   no_of_diabetes_cases_in_treatment integer,
   no_of_hypertension_and_diabetes_cases_screened integer,
   no_of_hypertension_and_diabetes_cases integer,
   no_of_hypertension_and_diabetes_cases_in_treatment integer,
   no_of_oral_cancer_cases_screened integer,
   no_of_oral_cancer_cases integer,
   no_of_oral_cancer_cases_in_followup integer,
   no_of_breast_cancer_cases_screened integer,
   no_of_breast_cancer_cases integer,
   no_of_breast_cancer_cases_in_treatment integer,
   no_of_cervical_cases_screened integer,
   no_of_cervical_cases integer,
   no_of_cervical_cases_in_treatment integer,
   no_of_hypertension_and_diabetes_outpatients integer,
   no_of_nsv_or_cvc integer,
   no_of_laparoscopic_sterilizations_conducted integer,
   no_of_mini_lap_sterilization_conducted integer,
   no_of_outpatient_diabetes integer,
   no_of_outpatient_hypertension integer,
   no_of_allopathic_outpatient_attendance integer,
   no_of_operation_major integer,
   no_of_operation_minor integer,
   no_of_lab_test_done integer,
   no_of_child_admitted_at_nrc integer,
   no_of_child_discharge_after_weight_gain_nrc integer
);

with from_series as (
    select date(generate_series(date_trunc('month', cast('2018-01-01' as date)), date_trunc('month', current_date), '1 month')) as from_month
),dates as (
    select date(date_trunc('month', from_month)) as from_date,
    date(date_trunc('month', from_month) + interval '1 month' - interval '1 day') as to_date
    from from_series
),hypertension_det as (
     select hmis_health_infra_id,
     dates.from_date,
     count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW')) as no_of_hypertension_cases_screened
     from ncd_member_hypertension_detail ncdb
     inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
     group by hmis_health_infra_id,dates.from_date
),diabetes_det as (
    select hmis_health_infra_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW')) as no_of_diabetes_cases_screened
    from ncd_member_diabetes_detail ncdb
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    group by hmis_health_infra_id,dates.from_date
),oral_cancer_det as (
    select hmis_health_infra_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW')) as no_of_oral_cancer_cases_screened
    from ncd_member_oral_detail ncdb
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    group by hmis_health_infra_id,dates.from_date
),breast_cancer_det as (
    select hmis_health_infra_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW')) as no_of_breast_cancer_cases_screened
    from ncd_member_breast_detail ncdb
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    group by hmis_health_infra_id,dates.from_date
),cervical_cancer_det as (
    select hmis_health_infra_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW')) as no_of_cervical_cases_screened
    from ncd_member_cervical_detail ncdb
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    group by hmis_health_infra_id,dates.from_date
),diagnosed_member_det as (
    select hmis_health_infra_id,
    dates.from_date,
    count(1) filter (where nmdd.disease_code = 'HT' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as no_of_hypertension_cases,
    count(1) filter (where nmdd.disease_code = 'D' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as no_of_diabetes_cases,
    count(1) filter (where nmdd.disease_code = 'O' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as no_of_oral_cancer_cases,
    count(1) filter (where nmdd.disease_code = 'B' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as no_of_breast_cancer_cases,
    count(1) filter (where nmdd.disease_code = 'C' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as no_of_cervical_cases,
    count(1) filter (where nmdd.disease_code = 'HT' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as no_of_hypertension_cases_in_treatment,
    count(1) filter (where nmdd.disease_code = 'D' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as no_of_diabetes_cases_in_treatment,
    count(1) filter (where nmdd.disease_code = 'O' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as no_of_oral_cancer_cases_in_followup,
    count(1) filter (where nmdd.disease_code = 'B' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as no_of_breast_cancer_cases_in_treatment,
    count(1) filter (where nmdd.disease_code = 'C' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as no_of_cervical_cases_in_treatment
    from ncd_member_diseases_diagnosis nmdd
    inner join dates on nmdd.diagnosed_on between dates.from_date and dates.to_date
    group by hmis_health_infra_id,dates.from_date
),opd_register_details as (
    select health_infra_id,
    dates.from_date,
    count(1) filter (where um_role_master.id is not null) as no_of_allopathic_outpatient_attendance
    from rch_opd_member_master
    left join um_user on rch_opd_member_master.created_by = um_user.id
    left join um_role_master on um_user.role_id = um_role_master.id and um_role_master.code in ('mo_ayush','mo_uphc')
    inner join dates on rch_opd_member_master.created_on between dates.from_date and dates.to_date
    group by health_infra_id,dates.from_date
),opd_lab_test_details as (
    select health_infra_id,
    dates.from_date,
    count(*) filter (where rch_opd_lab_test_details.id is not null) as no_of_lab_test_done
    from rch_opd_member_master
    left join rch_opd_lab_test_details on rch_opd_member_master.id = rch_opd_lab_test_details.opd_member_master_id
    inner join dates on rch_opd_lab_test_details.completed_on between dates.from_date and dates.to_date
    group by health_infra_id,dates.from_date
),nutrition_details as (
    select health_infra_id,
    month_year,
    less_than_6_months_admitted+above_6_months_admitted as no_of_child_admitted_at_nrc,
    discharge_from_facility as no_of_child_discharge_after_weight_gain_nrc
    from child_cmtc_nrc_health_facility_wise_analytics_wise_details
)
insert into ncd_service_provided_during_year_t (
health_infra_id,month_year,
no_of_hypertension_cases_screened,no_of_hypertension_cases,no_of_hypertension_cases_in_treatment,
no_of_diabetes_cases_screened,no_of_diabetes_cases,no_of_diabetes_cases_in_treatment,
no_of_oral_cancer_cases_screened,no_of_oral_cancer_cases,no_of_oral_cancer_cases_in_followup,
no_of_breast_cancer_cases_screened,no_of_breast_cancer_cases,no_of_breast_cancer_cases_in_treatment,
no_of_cervical_cases_screened,no_of_cervical_cases,no_of_cervical_cases_in_treatment,
no_of_hypertension_and_diabetes_cases_screened,no_of_hypertension_and_diabetes_cases,no_of_hypertension_and_diabetes_cases_in_treatment,
no_of_allopathic_outpatient_attendance,no_of_lab_test_done,
no_of_child_admitted_at_nrc,no_of_child_discharge_after_weight_gain_nrc
)
select
id,dates.from_date,
no_of_hypertension_cases_screened,no_of_hypertension_cases,no_of_hypertension_cases_in_treatment,
no_of_diabetes_cases_screened,no_of_diabetes_cases,no_of_diabetes_cases_in_treatment,
no_of_oral_cancer_cases_screened,no_of_oral_cancer_cases,no_of_oral_cancer_cases_in_followup,
no_of_breast_cancer_cases_screened,no_of_breast_cancer_cases,no_of_breast_cancer_cases_in_treatment,
no_of_cervical_cases_screened,no_of_cervical_cases,no_of_cervical_cases_in_treatment,
no_of_hypertension_cases_screened+no_of_diabetes_cases_screened,no_of_hypertension_cases+no_of_diabetes_cases,no_of_hypertension_cases_in_treatment+no_of_diabetes_cases_in_treatment,
no_of_allopathic_outpatient_attendance,no_of_lab_test_done,
no_of_child_admitted_at_nrc,no_of_child_discharge_after_weight_gain_nrc
from health_infrastructure_details
inner join dates on true
left join hypertension_det on health_infrastructure_details.id = hypertension_det.hmis_health_infra_id and dates.from_date = hypertension_det.from_date
left join diabetes_det on health_infrastructure_details.id = diabetes_det.hmis_health_infra_id and dates.from_date = diabetes_det.from_date
left join oral_cancer_det on health_infrastructure_details.id = oral_cancer_det.hmis_health_infra_id and dates.from_date = oral_cancer_det.from_date
left join breast_cancer_det on health_infrastructure_details.id = breast_cancer_det.hmis_health_infra_id and dates.from_date = breast_cancer_det.from_date
left join cervical_cancer_det on health_infrastructure_details.id = cervical_cancer_det.hmis_health_infra_id and dates.from_date = cervical_cancer_det.from_date
left join diagnosed_member_det on health_infrastructure_details.id = diagnosed_member_det.hmis_health_infra_id and dates.from_date = diagnosed_member_det.from_date
left join opd_register_details on health_infrastructure_details.id = opd_register_details.health_infra_id and dates.from_date = opd_register_details.from_date
left join opd_lab_test_details on health_infrastructure_details.id = opd_lab_test_details.health_infra_id and dates.from_date = opd_lab_test_details.from_date
left join nutrition_details on health_infrastructure_details.id = nutrition_details.health_infra_id and dates.from_date = nutrition_details.month_year;

commit;
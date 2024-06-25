begin;

drop table if exists ncd_analytics_detail_t;

create table ncd_analytics_detail_t (
	location_id integer,
	month_year date,
	member_enrolled integer,
	member_30_plus integer,
	number_of_asha integer,
	number_of_inactive_asha integer,
	number_of_fhw integer,
	number_of_inactive_fhw integer,
	number_of_mo integer,
	number_of_active_mo integer,
	number_of_cbac_form_filled integer,
	number_of_member_at_risk integer,
	fhw_screened_diabetes_male integer,
	fhw_screened_diabetes_female integer,
	fhw_screened_hypertension_male integer,
	fhw_screened_hypertension_female integer,
	fhw_screened_oral_male integer,
	fhw_screened_oral_female integer,
	fhw_screened_breast_female integer,
	fhw_screened_cervical_female integer,
	no_abnormally_detected_male integer,
	no_abnormally_detected_female integer,
	fhw_referred_diabetes_male integer,
	fhw_referred_diabetes_female integer,
	fhw_referred_hypertension_male integer,
	fhw_referred_hypertension_female integer,
	fhw_referred_oral_male integer,
	fhw_referred_oral_female integer,
	fhw_referred_breast_female integer,
	fhw_referred_cervical_female integer,
	mo_examined_diabetes_male integer,
	mo_examined_diabetes_female integer,
	mo_examined_hypertension_male integer,
	mo_examined_hypertension_female integer,
	mo_examined_oral_male integer,
	mo_examined_oral_female integer,
	mo_examined_breast_female integer,
	mo_examined_cervical_female integer,
	mo_diagnosed_diabetes_male integer,
	mo_diagnosed_diabetes_female integer,
	mo_diagnosed_hypertension_male integer,
	mo_diagnosed_hypertension_female integer,
	mo_diagnosed_oral_male integer,
	mo_diagnosed_oral_female integer,
	mo_diagnosed_breast_female integer,
	mo_diagnosed_cervical_female integer,
	under_treatment_diabetes_male integer,
	under_treatment_diabetes_female integer,
	under_treatment_hypertension_male integer,
	under_treatment_hypertension_female integer,
	under_treatment_oral_male integer,
	under_treatment_oral_female integer,
	under_treatment_breast_female integer,
	under_treatment_cervical_female integer,
	secondary_referred_diabetes_male integer,
	secondary_referred_diabetes_female integer,
	secondary_referred_hypertension_male integer,
	secondary_referred_hypertension_female integer,
	secondary_referred_oral_male integer,
	secondary_referred_oral_female integer,
	secondary_referred_breast_female integer,
	secondary_referred_cervical_female integer,
	primary key(location_id,month_year)
);

with from_series as (
    select date(generate_series(date_trunc('month', cast('2018-01-01' as date)), date_trunc('month', current_date), '1 month')) as from_month
),dates as (
    select date(date_trunc('month', from_month)) as from_date,
    date(date_trunc('month', from_month) + interval '1 month' - interval '1 day') as to_date
    from from_series
),loc_det as (
    select child_id as loc_id
    from location_hierchy_closer_det
    where parent_id = 2
    and depth = 7
),member_det as (
    select lh1.parent_id as loc_id,
    sum(fhs_total_member) as member_enrolled,
    sum(total_member_over_thirty) as member_30_plus
    from location_wise_analytics lwa
    inner join location_hierchy_closer_det lh1 on lh1.child_id = lwa.loc_id
    where lh1.parent_id in (select loc_id from loc_det)
    group by lh1.parent_id
),asha_fhw_det as (
    select distinct u.id as user_id,
    u.role_id,
    uld.parent_id as loc_id
    from um_user u
    inner join um_user_location ul on u.id = ul.user_id
    inner join location_hierchy_closer_det uld on ul.loc_id = uld.child_id
    where u.role_id in (select id from um_role_master ur where ur.code in ('FHW', 'ASHA'))
    and uld.parent_id in (select loc_id from loc_det)
    and u.state = 'ACTIVE'
    and ul.state = 'ACTIVE'
),asha_fhw_count as (
    select asha_fhw_det.loc_id,
    count(distinct uul.user_id) filter (where role_id = 24 and uul.user_id is not null) as number_of_asha,
    count(distinct asha_fhw_det.user_id) filter (where role_id = 24 and uul.user_id is null) as number_of_inactive_asha,
    count(distinct uul.user_id) filter (where role_id = 30 and uul.user_id is not null) as number_of_fhw,
    count(distinct asha_fhw_det.user_id) filter (where role_id = 30 and uul.user_id is null) as number_of_inactive_fhw
    from asha_fhw_det
    left join user_form_access uul on asha_fhw_det.user_id = uul.user_id and uul.state = 'MOVE_TO_PRODUCTION'
    group by asha_fhw_det.loc_id
),mo_det as (
    select distinct u.id as user_id,
    u.role_id,
    uld.parent_id as loc_id
    from um_user u
    inner join um_user_location ul on u.id = ul.user_id
    inner join location_hierchy_closer_det uld on ul.loc_id = uld.child_id
    where u.role_id in (select id from um_role_master ur where ur.code in ('mo_phc', 'mo_uphc'))
    and uld.parent_id in (select loc_id from loc_det)
    and u.state = 'ACTIVE'
    and ul.state = 'ACTIVE'
),mo_count as (
    select mo_det.loc_id,
    sum(1) as number_of_mo,
    sum(case when uul.id is not null then 1 else 0 end) as number_of_active_mo
    from mo_det
    left join um_user_login_det uul on mo_det.user_id = uul.user_id
    where uul.created_on between current_date - interval '7 days' and now()
    group by mo_det.loc_id
),cbac_det as (
    select lh.parent_id as loc_id,
    dates.from_date as month_year,
    count(1) filter (where nmcd.score >= 5) as number_of_member_at_risk,
    count(1) as number_of_cbac_form_filled
    from ncd_member_cbac_detail nmcd
    inner join location_hierchy_closer_det lh on nmcd.location_id = lh.child_id
    inner join dates on nmcd.done_on between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
),diabetes_det as (
    select lh.parent_id as loc_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'M') as fhw_screened_diabetes_male,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F') as fhw_screened_diabetes_female,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'M' and ncdb.refferal_done) as fhw_referred_diabetes_male,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F' and ncdb.refferal_done) as fhw_referred_diabetes_female,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'M') as mo_examined_diabetes_male,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'F') as mo_examined_diabetes_female
    from ncd_member_diabetes_detail ncdb
    inner join imt_member m on m.id = ncdb.member_id
    inner join location_hierchy_closer_det lh on ncdb.location_id = lh.child_id
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
),hypertension_det as (
    select lh.parent_id as loc_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'M') as fhw_screened_hypertension_male,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F') as fhw_screened_hypertension_female,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'M' and ncdb.refferal_done) as fhw_referred_hypertension_male,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F' and ncdb.refferal_done) as fhw_referred_hypertension_female,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'M') as mo_examined_hypertension_male,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'F') as mo_examined_hypertension_female
    from ncd_member_hypertension_detail ncdb
    inner join imt_member m on m.id = ncdb.member_id
    inner join location_hierchy_closer_det lh on ncdb.location_id = lh.child_id
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
),oral_cancer_det as (
    select lh.parent_id as loc_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'M') as fhw_screened_oral_male,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F') as fhw_screened_oral_female,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'M' and ncdb.refferal_done) as fhw_referred_oral_male,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F' and ncdb.refferal_done) as fhw_referred_oral_female,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'M') as mo_examined_oral_male,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'F') as mo_examined_oral_female
    from ncd_member_oral_detail ncdb
    inner join imt_member m on m.id = ncdb.member_id
    inner join location_hierchy_closer_det lh on ncdb.location_id = lh.child_id
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
),breast_cancer_det as (
    select lh.parent_id as loc_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F') as fhw_screened_breast_female,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F' and ncdb.refferal_done) as fhw_referred_breast_female,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'M') as mo_examined_breast_male,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'F') as mo_examined_breast_female
    from ncd_member_breast_detail ncdb
    inner join imt_member m on m.id = ncdb.member_id
    inner join location_hierchy_closer_det lh on ncdb.location_id = lh.child_id
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
),cervical_cancer_det as (
    select lh.parent_id as loc_id,
    dates.from_date,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F') as fhw_screened_cervical_female,
    count(1) filter (where ncdb.done_by in ('FHW','CHO','MPHW') and m.gender = 'F' and ncdb.refferal_done) as fhw_referred_cervical_female,
    count(1) filter (where ncdb.done_by = 'MO' and m.gender = 'F') as mo_examined_cervical_female
    from ncd_member_cervical_detail ncdb
    inner join imt_member m on m.id = ncdb.member_id
    inner join location_hierchy_closer_det lh on ncdb.location_id = lh.child_id
    inner join dates on ncdb.screening_date between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
),diagnosed_member_det as (
    select lh.parent_id as loc_id,
    dates.from_date,
    count(1) filter (where nmdd.disease_code = 'D' and m.gender = 'M' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as mo_diagnosed_diabetes_male,
    count(1) filter (where nmdd.disease_code = 'D' and m.gender = 'F' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as mo_diagnosed_diabetes_female,
    count(1) filter (where nmdd.disease_code = 'HT' and m.gender = 'M' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as mo_diagnosed_hypertension_male,
    count(1) filter (where nmdd.disease_code = 'HT' and m.gender = 'F' and nmdd.status in ('CONFIRMED','REFERRED','TREATMENT_STARTED')) as mo_diagnosed_hypertension_female,
    count(1) filter (where nmdd.disease_code = 'O' and m.gender = 'M' and nmdd.status in ('CONFIRMED','REFERRED')) as mo_diagnosed_oral_male,
    count(1) filter (where nmdd.disease_code = 'O' and m.gender = 'F' and nmdd.status in ('CONFIRMED','REFERRED')) as mo_diagnosed_oral_female,
    count(1) filter (where nmdd.disease_code = 'B' and m.gender = 'F' and nmdd.status in ('CONFIRMED','REFERRED')) as mo_diagnosed_breast_female,
    count(1) filter (where nmdd.disease_code = 'C' and m.gender = 'F' and nmdd.status in ('CONFIRMED','REFERRED')) as mo_diagnosed_cervical_female,
    count(1) filter (where m.gender = 'M' and nmdd.status = 'NO_ABNORMALITY') as no_abnormally_detected_male,
    count(1) filter (where m.gender = 'F' and nmdd.status = 'NO_ABNORMALITY') as no_abnormally_detected_female,
    count(1) filter (where nmdd.disease_code = 'D' and m.gender = 'M' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as under_treatment_diabetes_male,
    count(1) filter (where nmdd.disease_code = 'D' and m.gender = 'F' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as under_treatment_diabetes_female,
    count(1) filter (where nmdd.disease_code = 'HT' and m.gender = 'M' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as under_treatment_hypertension_male,
    count(1) filter (where nmdd.disease_code = 'HT' and m.gender = 'F' and nmdd.status in ('REFERRED','TREATMENT_STARTED')) as under_treatment_hypertension_female,
    sum(0) as under_treatment_oral_male,
    sum(0) as under_treatment_oral_female,
    sum(0) as under_treatment_breast_female,
    sum(0) as under_treatment_cervical_female,
    count(1) filter (where nmdd.disease_code = 'D' and m.gender = 'M' and nmdd.status in ('REFERRED')) as secondary_referred_diabetes_male,
    count(1) filter (where nmdd.disease_code = 'D' and m.gender = 'F' and nmdd.status in ('REFERRED')) as secondary_referred_diabetes_female,
    count(1) filter (where nmdd.disease_code = 'HT' and m.gender = 'M' and nmdd.status in ('REFERRED')) as secondary_referred_hypertension_male,
    count(1) filter (where nmdd.disease_code = 'HT' and m.gender = 'F' and nmdd.status in ('REFERRED')) as secondary_referred_hypertension_female,
    count(1) filter (where nmdd.disease_code = 'O' and m.gender = 'M' and nmdd.status in ('REFERRED')) as secondary_referred_oral_male,
    count(1) filter (where nmdd.disease_code = 'O' and m.gender = 'F' and nmdd.status in ('REFERRED')) as secondary_referred_oral_female,
    count(1) filter (where nmdd.disease_code = 'B' and m.gender = 'F' and nmdd.status in ('REFERRED')) as secondary_referred_breast_female,
    count(1) filter (where nmdd.disease_code = 'C' and m.gender = 'F' and nmdd.status in ('REFERRED')) as secondary_referred_cervical_female
    from ncd_member_diseases_diagnosis nmdd
    inner join imt_member m on nmdd.member_id = m.id
    inner join location_hierchy_closer_det lh on nmdd.location_id = lh.child_id
    inner join dates on nmdd.diagnosed_on between dates.from_date and dates.to_date
    where lh.parent_id in (select loc_id from loc_det)
    group by lh.parent_id,dates.from_date
)
insert into ncd_analytics_detail_t (
location_id,month_year,member_enrolled,member_30_plus,
number_of_asha,number_of_inactive_asha,number_of_fhw,number_of_inactive_fhw,number_of_mo,number_of_active_mo,
number_of_cbac_form_filled,number_of_member_at_risk,
fhw_screened_diabetes_male,fhw_screened_diabetes_female,
fhw_screened_hypertension_male,fhw_screened_hypertension_female,
fhw_screened_oral_male,fhw_screened_oral_female,
fhw_screened_breast_female,
fhw_screened_cervical_female,
no_abnormally_detected_male,no_abnormally_detected_female,
fhw_referred_diabetes_male,fhw_referred_diabetes_female,
fhw_referred_hypertension_male,fhw_referred_hypertension_female,
fhw_referred_oral_male,fhw_referred_oral_female,
fhw_referred_breast_female,
fhw_referred_cervical_female,
mo_examined_diabetes_male,mo_examined_diabetes_female,
mo_examined_hypertension_male,mo_examined_hypertension_female,
mo_examined_oral_male,mo_examined_oral_female,
mo_examined_breast_female,
mo_examined_cervical_female,
mo_diagnosed_diabetes_male,mo_diagnosed_diabetes_female,
mo_diagnosed_hypertension_male,mo_diagnosed_hypertension_female,
mo_diagnosed_oral_male,mo_diagnosed_oral_female,
mo_diagnosed_breast_female,
mo_diagnosed_cervical_female,
under_treatment_diabetes_male,under_treatment_diabetes_female,
under_treatment_hypertension_male,under_treatment_hypertension_female,
under_treatment_oral_male,under_treatment_oral_female,
under_treatment_breast_female,
under_treatment_cervical_female,
secondary_referred_diabetes_male,secondary_referred_diabetes_female,
secondary_referred_hypertension_male,secondary_referred_hypertension_female,
secondary_referred_oral_male,secondary_referred_oral_female,
secondary_referred_breast_female,
secondary_referred_cervical_female
)
select loc_det.loc_id,dates.from_date,member_det.member_enrolled,member_det.member_30_plus,
asha_fhw_count.number_of_asha,asha_fhw_count.number_of_inactive_asha,asha_fhw_count.number_of_fhw,asha_fhw_count.number_of_inactive_fhw,mo_count.number_of_mo,mo_count.number_of_active_mo,
cbac_det.number_of_cbac_form_filled,cbac_det.number_of_member_at_risk,
diabetes_det.fhw_screened_diabetes_male,diabetes_det.fhw_screened_diabetes_female,
hypertension_det.fhw_screened_hypertension_male,hypertension_det.fhw_screened_hypertension_female,
oral_cancer_det.fhw_screened_oral_male,oral_cancer_det.fhw_screened_oral_female,
breast_cancer_det.fhw_screened_breast_female,
cervical_cancer_det.fhw_screened_cervical_female,
diagnosed_member_det.no_abnormally_detected_male,diagnosed_member_det.no_abnormally_detected_female,
diabetes_det.fhw_referred_diabetes_male,diabetes_det.fhw_referred_diabetes_female,
hypertension_det.fhw_referred_hypertension_male,hypertension_det.fhw_referred_hypertension_female,
oral_cancer_det.fhw_referred_oral_male,oral_cancer_det.fhw_referred_oral_female,
breast_cancer_det.fhw_referred_breast_female,
cervical_cancer_det.fhw_referred_cervical_female,
diabetes_det.mo_examined_diabetes_male,diabetes_det.mo_examined_diabetes_female,
hypertension_det.mo_examined_hypertension_male,hypertension_det.mo_examined_hypertension_female,
oral_cancer_det.mo_examined_oral_male,oral_cancer_det.mo_examined_oral_female,
breast_cancer_det.mo_examined_breast_female,
cervical_cancer_det.mo_examined_cervical_female,
diagnosed_member_det.mo_diagnosed_diabetes_male,diagnosed_member_det.mo_diagnosed_diabetes_female,
diagnosed_member_det.mo_diagnosed_hypertension_male,diagnosed_member_det.mo_diagnosed_hypertension_female,
diagnosed_member_det.mo_diagnosed_oral_male,diagnosed_member_det.mo_diagnosed_oral_female,
diagnosed_member_det.mo_diagnosed_breast_female,
diagnosed_member_det.mo_diagnosed_cervical_female,
diagnosed_member_det.under_treatment_diabetes_male,diagnosed_member_det.under_treatment_diabetes_female,
diagnosed_member_det.under_treatment_hypertension_male,diagnosed_member_det.under_treatment_hypertension_female,
diagnosed_member_det.under_treatment_oral_male,diagnosed_member_det.under_treatment_oral_female,
diagnosed_member_det.under_treatment_breast_female,
diagnosed_member_det.under_treatment_cervical_female,
diagnosed_member_det.secondary_referred_diabetes_male,diagnosed_member_det.secondary_referred_diabetes_female,
diagnosed_member_det.secondary_referred_hypertension_male,diagnosed_member_det.secondary_referred_hypertension_female,
diagnosed_member_det.secondary_referred_oral_male,diagnosed_member_det.secondary_referred_oral_female,
diagnosed_member_det.secondary_referred_breast_female,
diagnosed_member_det.secondary_referred_cervical_female
from loc_det
inner join dates on true
left join member_det on loc_det.loc_id = member_det.loc_id
left join asha_fhw_count on loc_det.loc_id = asha_fhw_count.loc_id
left join mo_count on loc_det.loc_id = mo_count.loc_id
left join cbac_det on loc_det.loc_id = cbac_det.loc_id and dates.from_date = cbac_det.month_year
left join diabetes_det on loc_det.loc_id = diabetes_det.loc_id and dates.from_date = diabetes_det.from_date
left join hypertension_det on loc_det.loc_id = hypertension_det.loc_id and dates.from_date = hypertension_det.from_date
left join oral_cancer_det on loc_det.loc_id = oral_cancer_det.loc_id and dates.from_date = oral_cancer_det.from_date
left join breast_cancer_det on loc_det.loc_id = breast_cancer_det.loc_id and dates.from_date = breast_cancer_det.from_date
left join cervical_cancer_det on loc_det.loc_id = cervical_cancer_det.loc_id and dates.from_date = cervical_cancer_det.from_date
left join diagnosed_member_det on loc_det.loc_id = diagnosed_member_det.loc_id and dates.from_date = diagnosed_member_det.from_date;

commit;

begin;

drop table if exists ncd_analytics_detail;
alter table ncd_analytics_detail_t rename to ncd_analytics_detail;

commit;
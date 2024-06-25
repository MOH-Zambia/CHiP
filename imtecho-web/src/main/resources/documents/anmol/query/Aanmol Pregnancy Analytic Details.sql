begin;

truncate
	anmol_pregnancy_analytic_details;

with financial_year as (
    select
        cast('04-01-2020' as date) as from_date,
        cast('03-31-2021' as date) as to_date 
),
preg_det as (
    select
        rprd.pregnancy_reg_location_id as location_id,
        cast(date_trunc('month', rprd.reg_service_date_month_year) as date) as month_year,
        rprd.pregnancy_reg_id,
        rprd.member_id
    from
        rch_pregnancy_analytics_details rprd
    inner join anmol_location_mapping mapping on
        rprd.pregnancy_reg_location_id = mapping.location_id
    inner join location_hierchy_closer_det lm on
        lm.child_id = mapping.location_id
        and parent_loc_type = 'V'
    left join financial_year fy on
        true
    where
        parent_loc_type = 'V'
        and cast(rprd.reg_service_date_month_year as date) between fy.from_date and fy.to_date
        and rprd.preg_reg_state in ('DELIVERY_DONE', 'PENDING', 'PREGNANT') 
),
pregnancy_reg as (
    select
        pd.location_id,
        pd.month_year,
        count(1) as rch_pregnancy_registration,
        count(1) filter(
        where am.mother_registration_status = 'SUCCESS') as anmol_pregnancy_registration,
        count(1) filter(
        where (am.mother_registration_status is null
        or am.mother_registration_status = 'FAIL')) as anmol_preg_not_registered
    from
        preg_det pd
    left join anmol_master am on
        am.pregnancy_reg_det_id = pd.pregnancy_reg_id
    group by
        pd.location_id,
        pd.month_year 
),
ec_det as (
    select
        pd.location_id,
        pd.month_year,
        count(1) filter(
        where am.id is null) as anmol_ec_not_registered
    from
        preg_det pd
    left join anmol_master am on
        pd.member_id = am.member_id
    group by
        pd.location_id,
        pd.month_year 
), delivery_det as (
    select
     pd.location_id,
     pd.month_year,
     count(1) as delivery_not_registered 
     from
        preg_det pd
    inner join rch_wpd_mother_master rwmm on rwmm.pregnancy_reg_det_id = pd.pregnancy_reg_id
    left join anmol_master am on am.pregnancy_reg_det_id = pd.pregnancy_reg_id
    where rwmm.has_delivery_happened is true
    and rwmm.state is null and am.id is null
    group by 
     pd.location_id,
        pd.month_year 
),
loc_det as (
    select
        distinct location_id,
        month_year
    from
        preg_det 
)
insert into anmol_pregnancy_analytic_details
select
    ld.location_id,
    ld.month_year,
    pr.rch_pregnancy_registration,
    pr.anmol_pregnancy_registration,
    ed.anmol_ec_not_registered,
    pr.anmol_preg_not_registered,
    dd.delivery_not_registered
from
    loc_det ld
left join ec_det ed on
    ld.location_id = ed.location_id
    and ed.month_year = ld.month_year
left join pregnancy_reg pr on
    ld.location_id = pr.location_id
    and pr.month_year = ld.month_year
left join delivery_det dd on
    ld.location_id = dd.location_id
    and pr.month_year = dd.month_year;

commit;
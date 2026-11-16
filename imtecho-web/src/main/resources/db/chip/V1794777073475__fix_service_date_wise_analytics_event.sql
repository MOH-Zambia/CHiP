-- Fix the "Service Date Wise Analytics" timer event (event_configuration 178).
--
-- The event rebuilds service_date_wise_analytics nightly; it feeds the All Services
-- Detailed Report and 19 other reports. Since 2025-01-28 every run has failed with
--   null value in column "service_date" of relation "service_date_wise_analytics_t"
-- because rch_child_service_master gained rows with no service_date on 2025-01-27
-- (and rch_lmp_follow_up one on 2026-07-09). The transaction rolled back each night,
-- so the table, and every report on it, stopped at 2025-01-26.
--
-- Changes to the template:
--   * service-dated sources fall back to created_on when service_date is null
--     (WPD: date_of_delivery, then modified_on, then created_on);
--   * every insert skips rows whose date or location is still null;
--   * select is re-granted to edw_reader after the nightly drop-and-rename, which
--     otherwise removes the warehouse's access.
--
-- The template is stored twice: event_configuration_type.template (what the timer
-- handler executes) and inside event_configuration.config_json. Both are updated.
-- Idempotent. Flyway is disabled; apply by hand.

update event_configuration_type
   set template = $tpl$begin;

create table if not exists service_date_wise_analytics (
    location_id integer not null,
    service_date date not null,
    family integer,
    member integer,
    fp integer,
    lmp integer,
    anc integer,
    wpd integer,
    pnc integer,
    csv integer,
    covid integer,
    tb integer,
    malaria integer,
    hiv integer,
    unique(location_id, service_date)
);

create table if not exists service_date_wise_analytics_t (
    location_id integer not null,
    service_date date not null,
    family integer,
    member integer,
    fp integer,
    lmp integer,
    anc integer,
    wpd integer,
    pnc integer,
    csv integer,
    covid integer,
    tb integer,
    malaria integer,
    hiv integer,
    unique(location_id, service_date)
);

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    family
)
select
    case when if.area_id is null then if.location_id else if.area_id end,
    date(if.created_on),
    count(*)
from imt_family if
where basic_state in ('NEW','VERIFIED','REVERIFICATION','TEMPORARY')
and if.created_on is not null and coalesce(if.area_id, if.location_id) is not null
group by 1,2;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    member,
    fp
)
select
    case when if.area_id is null then if.location_id else if.area_id end,
    date(im.created_on),
    count(*),
    count(*) filter (where im.last_method_of_contraception is not null and im.not_using_fp_reason is not null)
from imt_member im
inner join imt_family if on im.family_id = if.family_id 
where im.basic_state in ('NEW','VERIFIED','REVERIFICATION','TEMPORARY')
and im.created_on is not null and coalesce(if.area_id, if.location_id) is not null
group by 1,2
on conflict (location_id, service_date) do update
set member = excluded.member,
    fp = excluded.fp;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    member
)
select
    case when if.area_id is null then if.location_id else if.area_id end,
    date(im.created_on),
    count(*)
from imt_member im
inner join imt_family if on im.family_id = if.family_id 
where im.basic_state in ('NEW','VERIFIED','REVERIFICATION','TEMPORARY')
and im.created_on is not null and coalesce(if.area_id, if.location_id) is not null
group by 1,2
on conflict (location_id, service_date) do update
set member = excluded.member;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    lmp
)
select
    rlfu.location_id,
    date(coalesce(rlfu.service_date, rlfu.created_on)),
    count(*)
from rch_lmp_follow_up rlfu
where rlfu.location_id is not null and coalesce(rlfu.service_date, rlfu.created_on) is not null
group by 1,2
on conflict (location_id, service_date) do update
set lmp = excluded.lmp;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    anc
)
select
    ram.location_id,
    date(coalesce(ram.service_date, ram.created_on)),
    count(*)
from rch_anc_master ram
where ram.location_id is not null and coalesce(ram.service_date, ram.created_on) is not null
group by 1,2
on conflict (location_id, service_date) do update
set anc = excluded.anc;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    wpd
)
select
    rwmm.location_id,
    date(coalesce(rwmm.date_of_delivery, rwmm.modified_on, rwmm.created_on)),
    count(*)
from rch_wpd_mother_master rwmm
where rwmm.location_id is not null and coalesce(rwmm.date_of_delivery, rwmm.modified_on, rwmm.created_on) is not null
group by 1,2
on conflict (location_id, service_date) do update
set wpd = excluded.wpd;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    pnc
)
select
    rpm.location_id,
    date(coalesce(rpm.service_date, rpm.created_on)),
    count(*)
from rch_pnc_master rpm
where rpm.location_id is not null and coalesce(rpm.service_date, rpm.created_on) is not null
group by 1,2
on conflict (location_id, service_date) do update
set pnc = excluded.pnc;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    csv
)
select
    rcsm.location_id,
    date(coalesce(rcsm.service_date, rcsm.created_on)),
    count(*)
from rch_child_service_master rcsm
where rcsm.location_id is not null and coalesce(rcsm.service_date, rcsm.created_on) is not null
group by 1,2
on conflict (location_id, service_date) do update
set csv = excluded.csv;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    covid
)
select
    csd.location_id,
    date(csd.created_on),
    count(*)
from covid_screening_details csd
where csd.location_id is not null and csd.created_on is not null
group by 1,2
on conflict (location_id, service_date) do update
set covid = excluded.covid;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    tb
)
select
    tsd.location_id,
    date(tsd.created_on),
    count(*)
from tuberculosis_screening_details tsd
where tsd.location_id is not null and tsd.created_on is not null
group by 1,2
on conflict (location_id, service_date) do update
set tb = excluded.tb;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    malaria
)
select
    md.location_id,
    date(md.created_on),
    count(*)
from malaria_details md
where md.location_id is not null and md.created_on is not null
group by 1,2
on conflict (location_id, service_date) do update
set malaria = excluded.malaria;

insert into service_date_wise_analytics_t (
    location_id,
    service_date,
    hiv
)
select
    rhsm.location_id,
    date(rhsm.created_on),
    count(*)
from rch_hiv_screening_master rhsm
where rhsm.location_id is not null and rhsm.created_on is not null
group by 1,2
on conflict (location_id, service_date) do update
set hiv = excluded.hiv;

drop table if exists service_date_wise_analytics;

alter table service_date_wise_analytics_t
rename to service_date_wise_analytics;

grant select on service_date_wise_analytics to edw_reader;

commit;$tpl$
 where id = '42c15321-337a-4191-9b63-9f4c4a7fb02b';

update event_configuration
   set config_json = jsonb_set(config_json::jsonb,
                               '{0,conditions,0,notificaitonConfigsType,0,template}',
                               to_jsonb((select template from event_configuration_type
                                          where id = '42c15321-337a-4191-9b63-9f4c4a7fb02b')))::text
 where id = 178
   and config_json::jsonb #>> '{0,conditions,0,notificaitonConfigsType,0,id}' = '42c15321-337a-4191-9b63-9f4c4a7fb02b';

alter table location_wise_month_year_analytics
add column wpd_mtp integer,add column wpd_live_birth integer,
add column wpd_still_birth integer,add column wpd_abortion integer;


alter table location_wise_month_year_analytics
drop column still_birth ,drop column live_birth;


insert into system_configuration (system_key,is_active,key_value)
values ('LAST_RCH_REPORT_DATE',true,'');


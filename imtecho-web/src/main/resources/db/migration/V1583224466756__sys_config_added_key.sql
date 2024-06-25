insert into system_configuration (system_key,is_active,key_value) values ('IS_USER_USAGE_ANALYTICS_ACTIVE','true','true')
on conflict on constraint system_configuration_pkey do nothing;

alter table request_response_page_wise_time_details DROP COLUMN if exists page_title;


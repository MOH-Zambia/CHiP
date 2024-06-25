alter table ndhm_care_context_info
drop column if exists service_ids,
add column service_ids varchar(250),
drop column if exists service_type,
add column service_type varchar(250);
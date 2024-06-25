alter table ndhm_care_context_service_info
drop column if exists request_id,
add column request_id varchar(250);
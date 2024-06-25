alter table ndhm_care_context_info
drop column if exists consent_id,
add column consent_id varchar(250);
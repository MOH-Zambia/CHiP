alter table ndhm_care_context_info
drop column if exists member_id,
add column member_id integer;
ALTER TABLE ndhm_health_id_user_details
drop column if exists is_new_abha_generated,
drop column if exists response_json,
add column is_new_abha_generated boolean,
add column response_json text;

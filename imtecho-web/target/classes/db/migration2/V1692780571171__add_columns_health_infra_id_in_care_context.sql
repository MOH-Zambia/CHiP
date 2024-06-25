alter table ndhm_care_context_info
add column if not exists health_infra_id integer;

alter table ndhm_care_context_service_info
add column if not exists health_infra_id integer;
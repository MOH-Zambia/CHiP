alter table gvk_manage_call_master 
add column family_id varchar(128),
add column location_id bigint;

alter table gvk_verification
add column manage_call_master_id bigint;

alter table gvk_immunisation_verification_response
add column manage_call_master_id bigint;

alter table gvk_high_risk_follow_up_responce
add column manage_call_master_id bigint;

alter table gvk_emri_pregnant_member_mobile_number_verification_response
add column manage_call_master_id bigint;

alter table gvk_emri_pregnant_member_responce
add column manage_call_master_id bigint;

alter table gvk_member_migration_call_response
add column manage_call_master_id bigint;

alter table gvk_duplicate_member_verification_response
add column manage_call_master_id bigint;


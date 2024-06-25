alter table migration_master
add column if not exists migrated_to_state_name text;

alter table rch_wpd_mother_master
add column if not exists breast_feeding_reason text;

alter table rch_lmp_follow_up
add column if not exists late_reg_reason text;

alter table rch_vaccine_adverse_effect
add column if not exists adverse_effect_type character varying(10);
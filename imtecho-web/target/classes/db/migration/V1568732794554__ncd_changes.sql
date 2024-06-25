alter table ncd_member_oral_detail
drop column if exists growth_of_recent_origin_flag,
drop column if exists health_infra_id,
add column health_infra_id bigint,
add column growth_of_recent_origin_flag boolean;

alter table ncd_member_diabetes_detail
drop column if exists gluco_strips_available,
drop column if exists health_infra_id,
add column health_infra_id bigint,
add column gluco_strips_available boolean;

alter table ncd_member_hypertension_detail
drop column if exists bp_machine_available,
drop column if exists health_infra_id,
add column bp_machine_available boolean,
add column health_infra_id bigint;

alter table ncd_member_cervical_detail
drop column if exists health_infra_id,
add column health_infra_id bigint;

alter table ncd_member_breast_detail
drop column if exists health_infra_id,
add column health_infra_id bigint;
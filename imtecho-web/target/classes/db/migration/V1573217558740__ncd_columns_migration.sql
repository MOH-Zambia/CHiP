alter table ncd_member_referral
drop column if exists status,
drop column if exists follow_up_date,
drop column if exists member_location,
add column status character varying(50),
add column follow_up_date timestamp without time zone,
add column member_location bigint;

alter table ncd_member_diseases_diagnosis
drop column if exists is_case_completed,
drop column if exists sub_type,
add column is_case_completed boolean,
add column sub_type character varying(50);


alter table ncd_member_diabetes_detail
drop column if exists dka,
add column dka boolean;

alter table ncd_member_oral_detail
alter column restricted_mouth_opening
set data type boolean
using case when restricted_mouth_opening is not null then true
else null end;

alter table ncd_member_cervical_detail
drop column if exists via_test,
add column via_test boolean;

alter table ncd_member_disesase_medicine
drop column if exists reference_id,
add column reference_id bigint;
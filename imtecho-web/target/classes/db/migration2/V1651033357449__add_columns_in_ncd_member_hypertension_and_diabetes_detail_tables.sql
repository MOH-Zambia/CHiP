alter table ncd_member_hypertension_detail
drop column if exists current_treatment_place,
drop column if exists is_continue_treatment_from_current_place,
drop column if exists systolic_bp2,
drop column if exists diastolic_bp2,
drop column if exists pulse_rate2,
drop column if exists is_suspected,
drop column if exists flag,
add column current_treatment_place character varying(20),
add column is_continue_treatment_from_current_place boolean,
add column systolic_bp2 integer,
add column diastolic_bp2 integer,
add column pulse_rate2 integer,
add column is_suspected boolean,
add column flag boolean;

alter table ncd_member_diabetes_detail
drop column if exists current_treatment_place,
drop column if exists is_continue_treatment_from_current_place,
drop column if exists measurement_type,
drop column if exists is_suspected,
drop column if exists flag,
add column current_treatment_place character varying(20),
add column is_continue_treatment_from_current_place boolean,
add column measurement_type character varying(20),
add column is_suspected boolean,
add column flag boolean;

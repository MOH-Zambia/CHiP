update system_configuration set key_value = '40' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE ncd_member_hypertension_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;

ALTER TABLE ncd_member_mental_health_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;

ALTER TABLE ncd_member_diabetes_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;


ALTER TABLE ncd_member_clinic_visit_detail
	ADD COLUMN IF NOT EXISTS death_date date,
	ADD COLUMN IF NOT EXISTS death_place text,
    ADD COLUMN IF NOT EXISTS death_reason text,
	ADD COLUMN IF NOT EXISTS health_infra_id integer;

ALTER TABLE ncd_member_home_visit_detail
	ADD COLUMN IF NOT EXISTS death_date date,
	ADD COLUMN IF NOT EXISTS death_place text,
    ADD COLUMN IF NOT EXISTS death_reason text,
	ADD COLUMN IF NOT EXISTS health_infra_id integer;
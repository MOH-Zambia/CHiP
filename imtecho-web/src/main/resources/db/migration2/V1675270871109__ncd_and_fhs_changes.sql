ALTER TABLE imt_member
	ADD COLUMN IF NOT EXISTS pmjay_availability varchar(30),
	ADD COLUMN IF NOT EXISTS alcohol_addiction varchar(30),
	ADD COLUMN IF NOT EXISTS smoking_addiction varchar(30),
	ADD COLUMN IF NOT EXISTS tobacco_addiction varchar(30),
	ADD COLUMN IF NOT EXISTS rch_id text;

INSERT INTO public.mobile_form_feature_rel(
	form_id, mobile_constant)
	VALUES ((select id from mobile_form_details where form_name = 'NCD_PERSONAL_HISTORY'),'ASHA_CBAC_ENTRY' );


ALTER TABLE ncd_member_hypertension_detail
	ADD COLUMN IF NOT EXISTS visit_type varchar(30);

ALTER TABLE ncd_member_mental_health_detail
	ADD COLUMN IF NOT EXISTS visit_type varchar(30);

ALTER TABLE ncd_member_diabetes_detail
	ADD COLUMN IF NOT EXISTS visit_type varchar(30);

update system_configuration set key_value = '42' where system_key = 'MOBILE_FORM_VERSION';

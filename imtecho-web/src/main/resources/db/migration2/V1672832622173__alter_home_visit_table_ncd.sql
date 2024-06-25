update system_configuration set key_value = '39' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE ncd_member_home_visit_detail
	ADD COLUMN IF NOT EXISTS reference_reason text,
	ADD COLUMN IF NOT EXISTS refer_status character varying(200),
    ADD COLUMN IF NOT EXISTS flag boolean,
    ADD COLUMN IF NOT EXISTS flag_reason character varying(200),
    ADD COLUMN IF NOT EXISTS other_reason text,
    ADD COLUMN IF NOT EXISTS followup_visit_type character varying(200),
    ADD COLUMN IF NOT EXISTS followup_date timestamp without time zone;
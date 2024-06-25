
ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS medicine_name;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS frequency;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS quantity;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS duration;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS special_instruction;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS excess_thirst;

ALTER TABLE IF EXISTS ncd_member_general_detail
 ADD COLUMN IF NOT EXISTS followup_place character varying(50);

ALTER TABLE IF EXISTS ncd_member_general_detail
 ADD COLUMN IF NOT EXISTS followup_date timestamp without time zone;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS rch;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS communicable_disease;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS minor_ailments;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS ophthalmic;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS oral_care;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS geriatric_medicine;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS ent;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS emergency_trauma;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS mental_health;

ALTER TABLE IF EXISTS ncd_member_general_detail
 DROP COLUMN IF EXISTS other;

ALTER TABLE IF EXISTS ncd_member_general_detail
 ADD COLUMN IF NOT EXISTS category character varying(50);

DROP TABLE IF EXISTS ncd_member_followup_detail;
CREATE TABLE IF NOT EXISTS ncd_member_followup_detail(
	id serial PRIMARY KEY,
    member_id integer,
	disease_code character varying(50),
	referral_id integer,
	reference_id integer,
	created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

alter table imt_family
drop column if exists vehicle_availability_flag,
add column vehicle_availability_flag boolean,
drop column if exists ration_card_type,
add column ration_card_type text,
drop column if exists pmjay_or_health_insurance,
add column pmjay_or_health_insurance text;

alter table imt_member
drop column if exists occupation,
add column occupation text,
drop column if exists currently_under_treatment,
add column currently_under_treatment boolean;

CREATE TABLE IF NOT EXISTS family_availability_detail
(
	id serial primary key,
	user_id integer not null,
	availability_status character varying(255),
	house_number character varying(255),
	address1 character varying(255),
    address2 character varying(255),
	created_on timestamp without time zone,
	modified_on timestamp without time zone,
	created_by integer,
	modified_by integer
);

update system_configuration set key_value = '56' where system_key = 'MOBILE_FORM_VERSION';
drop table if exists ncd_master;

create table ncd_master
(
	id serial primary key,
	member_id integer not null,
	health_infra_id integer,
	location_id integer,
	created_on timestamp without time zone,
	modified_on timestamp without time zone,
	created_by integer,
	modified_by integer,
	disease_code character varying(20),
	status character varying(50),
	sub_status character varying(50),
	is_active boolean
);

ALTER TABLE IF EXISTS ncd_member_hypertension_detail ADD COLUMN IF NOT EXISTS master_id integer;
ALTER TABLE IF EXISTS ncd_member_diabetes_detail ADD COLUMN IF NOT EXISTS master_id integer;
ALTER TABLE IF EXISTS ncd_member_oral_detail ADD COLUMN IF NOT EXISTS master_id integer;
ALTER TABLE IF EXISTS ncd_member_breast_detail ADD COLUMN IF NOT EXISTS master_id integer;
ALTER TABLE IF EXISTS ncd_member_cervical_detail ADD COLUMN IF NOT EXISTS master_id integer;
ALTER TABLE IF EXISTS ncd_member_mental_health_detail ADD COLUMN IF NOT EXISTS master_id integer;
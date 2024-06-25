create table if not exists rch_institution_master
(
	id bigserial primary key,
	name text not null,
	location_id bigint not null,
	type character varying(10),
	is_location boolean,
	state text,
	created_on timestamp without time zone,
	created_by bigint,
	modified_by bigint,
	modified_on timestamp without time zone
)
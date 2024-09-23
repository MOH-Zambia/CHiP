drop table if exists medplat_form_master;
drop table if exists medplat_form_version_history;
drop table if exists medplat_field_master;
drop table if exists medplat_field_key_master;
drop table if exists medplat_form_data_master;

create table medplat_form_master(
	"uuid" uuid primary key,
	form_name text not null,
	form_code character varying(50) not null unique,
	current_version text,
	state text not null,
	menu_config_id integer not null,
	description text,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

create table medplat_form_version_history(
	"uuid" uuid primary key,
	form_master_uuid uuid not null,
	form_object text,
	form_vm text,
	execution_sequence text,
	template_config text,
	template_css text,
	field_config text,
  query_config text,
	version text not null,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null,
	CONSTRAINT medplat_form_version_history_form_master_uuid_version UNIQUE (form_master_uuid, version)
);

create table medplat_field_master(
	"uuid" uuid primary key,
	field_code character varying(50) not null unique,
	field_name text not null,
	state text not null,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

create table medplat_field_key_master(
	"uuid" uuid primary key,
	field_master_uuid uuid not null,
	field_key_code character varying(50) not null,
	field_key_name text not null,
	field_key_value_type character varying(50) not null,
	default_value text,
	is_required boolean,
  order_no smallint,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

create table medplat_form_data_master (
	id serial primary key,
	form_code text not null,
	data text not null,
	version text not null,
	is_processed bool,
	has_error bool,
	error text,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);


drop table if exists system_constraint_form_master;
create table if not exists system_constraint_form_master (
	uuid uuid primary key,
	form_name varchar(255) unique not null,
	form_code varchar(50) unique not null,
	menu_config_id integer,
	web_template_config text,
	mobile_template_config text,
	state varchar(50) default 'ACTIVE' not null,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

drop table if exists system_constraint_field_master;
create table if not exists system_constraint_field_master (
	uuid uuid primary key,
	form_master_uuid uuid not null,
	field_key varchar(255) not null,
	field_name varchar(255) not null,
	field_type varchar(255) not null,
	ng_model text,
    app_name varchar(50),
	standard_field_master_uuid uuid,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

drop table if exists system_constraint_field_value_master;
create table if not exists system_constraint_field_value_master (
	uuid uuid primary key,
	field_master_uuid uuid not null,
	value_type varchar(255) not null,
	key varchar(255) not null,
	value text,
	default_value text not null,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

drop table if exists system_constraint_standard_field_master;
create table if not exists system_constraint_standard_field_master (
	uuid uuid primary key,
	field_key varchar(255) not null,
	field_name varchar(255) not null,
	field_type varchar(255) not null,
    app_name varchar(50),
	category_id integer,
	state varchar(50) default 'ACTIVE' not null,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

drop table if exists system_constraint_standard_field_mapping_master;
create table if not exists system_constraint_standard_field_mapping_master (
	uuid uuid primary key,
	standard_master_id integer not null,
	standard_field_master_uuid uuid not null,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

drop table if exists system_constraint_standard_field_value_master;
create table if not exists system_constraint_standard_field_value_master (
	uuid uuid primary key,
	standard_field_mapping_master_uuid uuid not null,
	value_type varchar(255) not null,
	key varchar(255) not null,
	value text,
	default_value text not null,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

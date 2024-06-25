drop table if exists chardham_tourist_master;

create table if not exists chardham_tourist_master(
	member_id serial primary key,
	first_name text not null,
	middle_name text,
	last_name text,
	unique_id text unique not null,
	gender character varying(1) not null,
	dob date not null,
	contact_number text,
	language_preference character varying(2) not null,
	screening_status text,
	is_active bool,
	journey_start_date date,
	journey_end_date date,
	is_journey_over bool,
	created_by integer,
	created_on timestamp without time zone,
	modified_by integer,
	modified_on timestamp without time zone
);

drop table if exists chardham_tourist_locations;

create table if not exists chardham_tourist_locations
(
	id serial primary key,
	unique_id text unique not null,
	lat text not null,
	long text not null,
	screening_status text,
	sync_time timestamp without time zone not null,
	created_by integer NOT NULL,
	created_on timestamp without time zone NOT NULL,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

drop table if exists chardham_tourist_locations_dump;

create table if not exists chardham_tourist_locations_dump
(
	id serial primary key,
	unique_id text not null,
	lat text not null,
	long text not null,
	sync_time timestamp without time zone not null,
	created_by integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by integer not null,
    modified_on timestamp without time zone not null
);
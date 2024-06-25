drop table if exists idsp_2_member_screening_details;
DROP TABLE if exists idsp_2_family_screening_details;

create table idsp_2_member_screening_details (
    id serial primary key,
    member_id integer,
    family_id integer,
    location_id integer,
    latitude text,
    longitude text,
    mobile_number character varying(10),
    service_date date,
    idsp_family_id integer,
    any_illness_or_discomfort smallint,
    travelled_in_past smallint,
    country integer,
    other_country_name text,
    symptoms text,
    condition_worsened smallint,
    illness text,
    other_illness text,
    have_complaint smallint,
    complaints text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

create table idsp_2_family_screening_details(
	id serial primary key,
	family_id integer,
	location_id integer,
	service_date timestamp without time zone,
	any_one_with_illness smallint,
	any_one_travelled_past_weeks smallint,
	any_one_covid_contact smallint,
	longitude text,
    latitude text,
	created_by int,
    created_on timestamp without time zone,
    modified_by int,
    modified_on timestamp without time zone
);

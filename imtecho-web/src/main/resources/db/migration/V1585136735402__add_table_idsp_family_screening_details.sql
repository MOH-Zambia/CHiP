DROP TABLE if exists idsp_family_screening_details;
create table idsp_family_screening_details(
	id serial primary key,
	family_id integer,
	location_id integer,
	service_date timestamp without time zone,
	any_one_with_illness boolean,
	any_one_travelled_past_weeks boolean,
	any_one_covid_contact boolean,
	longitude text,
    latitude text,
	created_by int,
    created_on timestamp without time zone,
    modified_by int,
    modified_on timestamp without time zone
);

alter table idsp_member_screening_details
drop column if exists idsp_family_id,
add column idsp_family_id integer,
drop column if exists difficulty_in_breathing,
add column difficulty_in_breathing boolean;

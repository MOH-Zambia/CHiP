insert into menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values
((select id from menu_group where group_name='COVID-19'),true,'Track 104 Calls','techo.manage.104calls','manage');

drop table if exists gvk_covid_104_calls_response;
drop table if exists gvk_covid_104_calls_contact_response;

create table gvk_covid_104_calls_response
(
	id serial primary key,
	date_of_calling date not null,
	person_name text not null,
	age integer not null,
	gender character varying(1) not null,
	contact_no text not null,
	address text not null,
	pin_code integer not null,
	district integer not null,
	block integer not null,
	village integer not null,
	is_information_call boolean not null,
	has_fever boolean,
	fever_days integer,
	having_cough boolean,
	cough_days integer,
	has_shortness_of_breath boolean,
	has_travel_abroad_in_15_days boolean,
	country integer,
	arrival_date date,
	in_touch_with_anyone_travelled_recently boolean,
	created_by integer not null,
	created_on timestamp without time zone not null,
	modified_by integer not null,
	modified_on timestamp without time zone not null
);

create table gvk_covid_104_calls_contact_response
(
	id serial primary key,
	gvk_response_id integer not null,
	person_name text,
	contact_no text,
	district integer,
	other_detail text
);
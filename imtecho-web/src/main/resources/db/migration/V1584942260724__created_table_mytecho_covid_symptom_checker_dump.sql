drop table if exists mytecho_covid_symptom_checker_dump;

create table mytecho_covid_symptom_checker_dump (
	id serial primary key,
	name varchar(100),
	mobile_number varchar(10),
	data text,

	created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
	modified_on timestamp without time zone
);
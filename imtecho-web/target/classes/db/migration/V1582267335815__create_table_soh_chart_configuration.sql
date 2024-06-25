-- for feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3215

drop table if exists public.soh_chart_configuration;
CREATE TABLE public.soh_chart_configuration (
	id serial NOT NULL,
	"name" varchar(50),
	display_name varchar(50),
	from_date date,
	"to_date" date,
	configuration_json text,
    created_by integer not null,
    created_on timestamp without time zone not null,
    modified_by integer not null,
    modified_on timestamp without time zone not null
);

-- add column in soh_element_configuration

alter table soh_element_configuration
drop COLUMN IF EXISTS is_timeline_enable,
add COLUMN is_timeline_enable boolean;

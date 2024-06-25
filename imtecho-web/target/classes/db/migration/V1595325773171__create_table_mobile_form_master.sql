drop table if exists mobile_form_master;

create table mobile_form_master (
	id integer,
	form_code text,
	title text,
	subtitle text,
	instruction text,
	question text,
	type text,
	is_mandatory boolean,
	mandatory_message text,
	"length" integer,
	validation text,
	formula text,
	datamap text,
	"options" text,
	"next" integer,
	subform text,
	related_property_name text,
	is_hidden boolean,
	"event" text,
	binding integer,
	page integer,
	hint text,
	help_video text,
	primary key (form_code, id)
);
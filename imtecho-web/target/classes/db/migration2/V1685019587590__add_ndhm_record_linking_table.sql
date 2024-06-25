drop table if exists ndhm_record_linking;
create table ndhm_record_linking (
	member_id integer,
	service_id integer,
	service_type varchar(250),
	hfr_facility_id varchar(250),
	health_infra_id integer,
	record_linking_state varchar(1),
	is_from_form_submission boolean,
	modified_on timestamp without time zone,
	CONSTRAINT ndhm_record_linking_pkey PRIMARY KEY (service_id, service_type)
);

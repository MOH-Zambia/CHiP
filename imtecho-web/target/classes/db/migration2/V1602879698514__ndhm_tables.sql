drop table if exists ndhm_care_context_master;
create table ndhm_care_context_master (
	id serial,
	member_id Integer NOT NULL,
	patient_reference_number varchar(250),
    patient_display varchar(250),
	health_infra_id Integer ,
	health_infra_name varchar(250) ,
	location_id Integer ,
    health_id varchar(250) NOT NULL,
    created_by Integer NOT NULL, 
    created_on timestamp without time zone NOT NULL, 
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_care_context_master_pkey PRIMARY KEY(id)
);

comment ON TABLE ndhm_care_context_master IS 'This is master table to store care context of national digital health mission';
comment on column ndhm_care_context_master.id is 'Primary key of table';
comment on column ndhm_care_context_master.member_id is 'Id from imt_member';
comment on column ndhm_care_context_master.patient_reference_number is 'Reference number is id of member';
comment on column ndhm_care_context_master.patient_display is 'Full name of member';
comment on column ndhm_care_context_master.health_infra_id is 'Id from health_infrastructure_details';
comment on column ndhm_care_context_master.health_infra_name is 'Name from health_infrastructure_details';
comment on column ndhm_care_context_master.location_id is 'Id from location_master';
comment on column ndhm_care_context_master.health_id is 'Health Id of member';
comment on column ndhm_care_context_master.created_by is 'Id from um_user';
comment on column ndhm_care_context_master.created_on is 'Created on timestamp';
comment on column ndhm_care_context_master.modified_by is 'Id from um_user';
comment on column ndhm_care_context_master.modified_on is 'Modified on timestamp';

drop table if exists ndhm_care_context_info;
create table ndhm_care_context_info(
	id serial,
	ndhm_care_context_master_id Integer,
	call_type varchar(250),
	request_id varchar(250),
    response_id text,
	api_version varchar(250),
	request_status_code Integer,
    request_json text,
	on_request_json text,
	error text,
	created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_care_context_info_pkey PRIMARY KEY (id)
);

comment ON TABLE ndhm_care_context_info IS 'This table used to store request response from NDHM';
comment on column ndhm_care_context_info.id is 'Primary key of table';
comment on column ndhm_care_context_info.ndhm_care_context_master_id is 'Id from ndhm_care_context_master';
comment on column ndhm_care_context_info.call_type is 'Type of call i.e. INIT_LINKING,OTP_VERIFY';
comment on column ndhm_care_context_info.request_id is 'Id of request';
comment on column ndhm_care_context_info.response_id is 'Stores transaction id or consent id or access token based on call type';
comment on column ndhm_care_context_info.api_version is 'Version of ndhm api';
comment on column ndhm_care_context_info.request_status_code is 'Status code received after submitting requset';
comment on column ndhm_care_context_info.request_json is 'Request json send to NDHM';
comment on column ndhm_care_context_info.on_request_json is 'Response json received from NDHM';
comment on column ndhm_care_context_info.error is 'Error string received from ndhm or time out exception while waiting for callback';
comment on column ndhm_care_context_info.created_by is 'Id from um_user';
comment on column ndhm_care_context_info.created_on is 'Created on timestamp';
comment on column ndhm_care_context_info.modified_by is 'Id from um_user';
comment on column ndhm_care_context_info.modified_on is 'Modified on timestamp';

drop table if exists ndhm_care_context_service_info;
create table ndhm_care_context_service_info(
	id serial,
	ndhm_care_context_master_id Integer,
	care_context_type varchar(250),
	state varchar(250),
	service_type varchar(250),
	service_id Integer,
	service_reference_number varchar(250),
	service_display varchar(250),
	fhir_json text,
	created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_care_context_service_info_pkey PRIMARY KEY (id)
);

comment ON TABLE ndhm_care_context_service_info IS 'This table is used to store services to be available digitally';
comment on column ndhm_care_context_service_info.id is 'Primary key of table';
comment on column ndhm_care_context_service_info.ndhm_care_context_master_id is 'Id from ndhm_care_context_master';
comment on column ndhm_care_context_service_info.care_context_type is 'Type of care context i.e. OPConsultation, DiagnosticReport, DischargeSummary, Prescription';
comment on column ndhm_care_context_service_info.state is 'State of data. i.e. DISCOVERED, LINKED';
comment on column ndhm_care_context_service_info.service_type is 'Type of service i.e.IMMUNISATION';
comment on column ndhm_care_context_service_info.service_id is 'Id From service table i.e Id of rch_immunisation_master';
comment on column ndhm_care_context_service_info.service_reference_number is 'Generated string from service date and service type i.e 2020-09-22_HEPATITIS_B_0';
comment on column ndhm_care_context_service_info.service_display is 'Generated string from service date and service type i.e 2020-09-22 HEPATITIS_B_0';
comment on column ndhm_care_context_service_info.fhir_json is 'Generated FHIR json';
comment on column ndhm_care_context_service_info.created_by is 'Id from um_user';
comment on column ndhm_care_context_service_info.created_on is 'Created on timestamp';
comment on column ndhm_care_context_service_info.modified_by is 'Id from um_user';
comment on column ndhm_care_context_service_info.modified_on is 'Modified on timestamp';

-- HIU Tables

drop table if exists ndhm_hiu_master;
create table ndhm_hiu_master (
	id serial,
	member_id Integer NOT NULL,
	patient_reference_number varchar(250),
    patient_display varchar(250),
	health_infra_id Integer ,
	health_infra_name varchar(250) ,
	location_id Integer ,
    health_id varchar(250) NOT NULL,
    name_with_health_id varchar(250),
    created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_hiu_master_pkey PRIMARY KEY(id)
);

comment ON TABLE ndhm_hiu_master IS 'This is master table to store care context of national digital health mission';
comment on column ndhm_hiu_master.id is 'Primary key of table';
comment on column ndhm_hiu_master.member_id is 'Id from imt_member';
comment on column ndhm_hiu_master.patient_reference_number is 'Reference number is id of member';
comment on column ndhm_hiu_master.patient_display is 'Full name of member';
comment on column ndhm_hiu_master.health_infra_id is 'Id from health_infrastructure_details';
comment on column ndhm_hiu_master.health_infra_name is 'Name from health_infrastructure_details';
comment on column ndhm_hiu_master.location_id is 'Id from location_master';
comment on column ndhm_hiu_master.health_id is 'Health Id of member';
comment on column ndhm_hiu_master.name_with_health_id is 'Health Id of member';
comment on column ndhm_hiu_master.created_by is 'Id from um_user';
comment on column ndhm_hiu_master.created_on is 'Created on timestamp';
comment on column ndhm_hiu_master.modified_by is 'Id from um_user';
comment on column ndhm_hiu_master.modified_on is 'Modified on timestamp';

drop table if exists ndhm_hiu_request_response_log;
create table ndhm_hiu_request_response_log(
	id serial,
	ndhm_hiu_master_id Integer,
	call_type varchar(250),
	consent_status varchar(250),
	request_id varchar(250),
    response_id varchar(250),
    consent_request_id varchar(250),
    consent_id varchar(250),
    transaction_id varchar(250),
	api_version varchar(250),
	request_status_code Integer,
    request_json text,
	on_request_json text,
	error text,
	created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_hiu_request_response_log_pkey PRIMARY KEY (id)
);

comment ON TABLE ndhm_hiu_request_response_log IS 'This table used to store request response from NDHM';
comment on column ndhm_hiu_request_response_log.id is 'Primary key of table';
comment on column ndhm_hiu_request_response_log.ndhm_hiu_master_id is 'Id from ndhm_care_context_master';
comment on column ndhm_hiu_request_response_log.call_type is 'Type of call i.e. INIT_LINKING,OTP_VERIFY';
comment on column ndhm_hiu_request_response_log.consent_status is 'Type of call i.e. INIT_LINKING,OTP_VERIFY';
comment on column ndhm_hiu_request_response_log.request_id is 'Id of request';
comment on column ndhm_hiu_request_response_log.response_id is 'Stores transaction id or consent id or access token based on call type';
comment on column ndhm_hiu_request_response_log.consent_request_id is 'Stores transaction id or consent id or access token based on call type';
comment on column ndhm_hiu_request_response_log.consent_id is 'Stores transaction id or consent id or access token based on call type';
comment on column ndhm_hiu_request_response_log.transaction_id is 'Stores transaction id or consent id or access token based on call type';
comment on column ndhm_hiu_request_response_log.api_version is 'Version of ndhm api';
comment on column ndhm_hiu_request_response_log.request_status_code is 'Status code received after submitting requset';
comment on column ndhm_hiu_request_response_log.request_json is 'Request json send to NDHM';
comment on column ndhm_hiu_request_response_log.on_request_json is 'Response json received from NDHM';
comment on column ndhm_hiu_request_response_log.error is 'Error string received from ndhm or time out exception while waiting for callback';
comment on column ndhm_hiu_request_response_log.created_by is 'Id from um_user';
comment on column ndhm_hiu_request_response_log.created_on is 'Created on timestamp';
comment on column ndhm_hiu_request_response_log.modified_by is 'Id from um_user';
comment on column ndhm_hiu_request_response_log.modified_on is 'Modified on timestamp';

drop table if exists ndhm_hiu_care_context_info;
create table ndhm_hiu_care_context_info(
	id serial,
	ndhm_hiu_master_id Integer,
	consent_id varchar(250),
	care_context_type varchar(250),
	state varchar(250),
	care_context_reference varchar(250),
	fhir_json text,
	created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT ndhm_hiu_care_context_info_pkey PRIMARY KEY (id)
);

comment ON TABLE ndhm_hiu_care_context_info IS 'This table is used to store services to be available digitally';
comment on column ndhm_hiu_care_context_info.id is 'Primary key of table';
comment on column ndhm_hiu_care_context_info.ndhm_hiu_master_id is 'Id from ndhm_care_context_master';
comment on column ndhm_hiu_care_context_info.consent_id is 'Id from ndhm_care_context_master';
comment on column ndhm_hiu_care_context_info.care_context_type is 'Type of care context i.e. OPConsultation, DiagnosticReport, DischargeSummary, Prescription';
comment on column ndhm_hiu_care_context_info.state is 'State of data. i.e. DISCOVERED, LINKED';
comment on column ndhm_hiu_care_context_info.care_context_reference is 'Generated string from service date and service type i.e 2020-09-22_HEPATITIS_B_0';
comment on column ndhm_hiu_care_context_info.fhir_json is 'Generated FHIR json';
comment on column ndhm_hiu_care_context_info.created_by is 'Id from um_user';
comment on column ndhm_hiu_care_context_info.created_on is 'Created on timestamp';
comment on column ndhm_hiu_care_context_info.modified_by is 'Id from um_user';
comment on column ndhm_hiu_care_context_info.modified_on is 'Modified on timestamp';
create table if not exists ndhm_hiu_fhir_info (
	id uuid DEFAULT uuid_generate_v4() NOT null primary key,
	care_context_info_id integer not null,
	fhir_json text,
	error text,
	created_by int NOT NULL,
  	created_on timestamp without time zone NOT NULL,
  	modified_by int not NULL,
  	modified_on timestamp without time zone not null,
	FOREIGN KEY (care_context_info_id) REFERENCES ndhm_hiu_care_context_info(id)
);

create index ndhm_hiu_fhir_info_care_context_info_id_idx
on ndhm_hiu_fhir_info (care_context_info_id);

alter table ndhm_hiu_care_context_info
drop column if exists fhir_json;
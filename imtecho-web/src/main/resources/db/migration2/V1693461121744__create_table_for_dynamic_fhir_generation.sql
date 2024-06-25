drop table if exists fhir_mapper_equation;

CREATE TABLE fhir_mapper_equation (
    	id serial,
    	fhir text,
    	field_description varchar(255),
    	field_name varchar(50),
    	hi_type_code varchar(50),
    	is_active boolean,
    	snomed_ct_code varchar(100),
    	type varchar(100),
    	value_type varchar(50),
    	CONSTRAINT wr_mapper_equation_pkey PRIMARY KEY (id)
);


create table if not exists ndhm_field_master (
	id serial,
	field_name varchar(50) unique not null,
	CONSTRAINT ndhm_field_master_pkey PRIMARY KEY (id)
);


create table if not exists ndhm_field_key_value_details (
	field_master_id integer,
	key varchar(50) not null,
	value varchar(100) not null,
	FOREIGN KEY (field_master_id)
      REFERENCES ndhm_field_master (id)
);

drop table if exists snomed_code_info;

CREATE TABLE snomed_code_info (
  id bigserial ,
  snomed_ct_code varchar(255) DEFAULT NULL,
  value varchar(255),
  url varchar(255) ,
  CONSTRAINT snomed_code_info_pkey PRIMARY KEY (id)
);

drop table if exists hi_type_query_builder_mapper;

create table hi_type_query_builder_mapper (
	hi_type_code varchar(50),
	query_code varchar(255),
	is_active boolean
);


drop table if exists wt_cfhc_suspected_disease;

create table if not exists wt_cfhc_suspected_disease (
	id serial primary key,
	member_id int,
	location_id int,
	family_id varchar,
	type_of_disease text,
	identified_on timestamp,
	modified_by int,
	modified_on timestamp,
	status varchar
);

insert into system_configuration (system_key,is_active,key_value) values ('LAST_EXECUTION_DATE_FOR_INSERTING_DATA_INTO_WT_CFHC_DISEASE',true,now() - interval '2 years')
	ON CONFLICT ON CONSTRAINT system_configuration_pkey DO nothing;

insert into listvalue_field_master(field_key, field, is_active, field_type)
values('cfhc_suspected_disease_status', 'cfhc_suspected_disease_status', true, 'T');

insert into listvalue_field_value_detail (is_active,is_archive,last_modified_by,last_modified_on,value,field_key,code,file_size)
values(true,false,'akhokhariya',now(),'Suspected','cfhc_suspected_disease_status','cfhc_suspected',0),
(true,false,'akhokhariya',now(),'Confirmed','cfhc_suspected_disease_status','cfhc_Confirmed',0),
(true,false,'akhokhariya',now(),'Negative','cfhc_suspected_disease_status','cfhc_Negative',0),
(true,false,'akhokhariya',now(),'Treatment Started','cfhc_suspected_disease_status','cfhc_Treat_Started',0);
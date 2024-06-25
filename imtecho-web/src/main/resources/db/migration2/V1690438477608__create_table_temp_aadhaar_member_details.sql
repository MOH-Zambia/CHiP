drop table if exists temp_aadhaar_member_details;

create table temp_aadhaar_member_details (
	unique_health_id text,
	aadhaar_number text,
	is_aadhaar_updated boolean,
	error text
);

COMMENT ON TABLE temp_aadhaar_member_details IS 'This is table for one time saving aadhaar number for member';


delete from system_function_master
where name='updateOneTimeAadhaarNumber'
and class_name='com.argusoft.imtecho.aadhaarvault.common.service.AadhaarVaultCommonUtilService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('updateOneTimeAadhaarNumber','com.argusoft.imtecho.aadhaarvault.common.service.AadhaarVaultCommonUtilService','','[]',-1,now());
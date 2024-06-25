delete from system_configuration where system_key = 'FAMILY_FOLDER_RECORD_LINKING_LIMIT';

insert into system_configuration (system_key, is_active, key_value)
    values ('FAMILY_FOLDER_RECORD_LINKING_LIMIT', true, '0');


delete from system_function_master
where name='linkHealthRecordForFamilyFolder'
and class_name='com.argusoft.imtecho.ndhmmobile.hip.service.HIPDemoAuthUtilService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('linkHealthRecordForFamilyFolder','com.argusoft.imtecho.ndhmmobile.hip.service.HIPDemoAuthUtilService','','[]',-1,now());


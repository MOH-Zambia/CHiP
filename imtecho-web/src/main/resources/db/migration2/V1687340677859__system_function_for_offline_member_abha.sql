delete from system_function_master
where name='offlineMemberAbhaCreation'
and class_name='com.argusoft.imtecho.ndhmmobile.healthid.service.OfflineAbhaCreationService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('offlineMemberAbhaCreation','com.argusoft.imtecho.ndhmmobile.healthid.service.OfflineAbhaCreationService','','[]',-1,now());
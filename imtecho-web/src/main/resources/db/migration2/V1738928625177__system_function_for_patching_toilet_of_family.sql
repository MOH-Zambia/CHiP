delete from system_function_master where name = 'patchFixForReplacingToiletType';
insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('patchFixForReplacingToiletType','com.argusoft.imtecho.chip.service.MobileHouseHoldLineListService','','[]',-1,now());
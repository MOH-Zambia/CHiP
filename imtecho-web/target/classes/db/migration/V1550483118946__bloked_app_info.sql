DELETE FROM public.query_master  WHERE code='blocked_app_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'blocked_app_info','imei','select imei from blocked_devices_master where imei in (#imei#)',true,'ACTIVE','Retrieve blocked imei info');

DELETE FROM public.query_master  WHERE code='unblock_imei_number';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'unblock_imei_number','imei','delete from blocked_devices_master where imei = ''#imei#''',false,'ACTIVE','Unblock the Imei Number');

DELETE FROM public.query_master  WHERE code='block_imei_number';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'block_imei_number','imei,userid','insert into blocked_devices_master values(''#imei#'',#userid#,localtimestamp)',false,'ACTIVE','Block the Imei Number');


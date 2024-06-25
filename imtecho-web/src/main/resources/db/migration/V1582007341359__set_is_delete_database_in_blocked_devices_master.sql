delete from query_master where code='delete_imei_database';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'delete_imei_database','imei,userid','
INSERT INTO blocked_devices_master (imei, created_by, created_on,is_delete_database)
VALUES (''#imei#'', ''#userid#'', localtimestamp,true)
ON CONFLICT (imei) DO UPDATE
  SET is_delete_database = true
',false,'ACTIVE');
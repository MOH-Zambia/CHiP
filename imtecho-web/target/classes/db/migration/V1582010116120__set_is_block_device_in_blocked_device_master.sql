delete from query_master where code='block_imei_number';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'block_imei_number','imei,userid','
INSERT INTO blocked_devices_master (imei, created_by, created_on,is_block_device)
VALUES (''#imei#'', ''#userid#'', localtimestamp,true)
ON CONFLICT (imei) DO UPDATE
  SET is_block_device = true
',false,'ACTIVE');
delete from query_master where code = 'no_of_deliveries_conducted'; 

INSERT INTO public.query_master(
           created_by,created_on,code, params, 
           query, returns_result_set, state, description)
   VALUES (1,now(),'no_of_deliveries_conducted', 'hid,performanceDate'
,'SELECT count(*) from rch_wpd_mother_master where health_infrastructure_id=#hid#  and
created_on between cast(date_trunc(''day'', cast(''#performanceDate#'' as date)) + ''00:00:00'' as timestamp)
	and
cast(date_trunc(''day'', cast(''#performanceDate#'' as date)) + ''23:59:59'' as timestamp)'
,true,'ACTIVE','To get number of deliveries conducted at health infrastructure on date.');


delete from query_master where code = 'no_of_caesarean_deliveries_conducted'; 

INSERT INTO public.query_master(
           created_by,created_on,code, params, 
           query, returns_result_set, state, description)
   VALUES (1,now(),'no_of_caesarean_deliveries_conducted','hid,performanceDate'
,'SELECT count(*) from rch_wpd_mother_master where health_infrastructure_id=#hid# and  type_of_delivery = ''CAESAREAN'' and
created_on between cast(date_trunc(''day'', cast(''#performanceDate#'' as date)) + ''00:00:00'' as timestamp)
	and
cast(date_trunc(''day'', cast(''#performanceDate#'' as date)) + ''23:59:59'' as timestamp)'
,true,'ACTIVE','To get number of caesarean deliveries conducted at health infrastructure on date');
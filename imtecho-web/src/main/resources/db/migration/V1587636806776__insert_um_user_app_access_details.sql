DELETE FROM QUERY_MASTER WHERE CODE='insert_um_user_app_access_details';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'insert_um_user_app_access_details',
'deviceType,appVersion,appName,imei,userId',
'insert
	into
		um_user_app_access_details( user_id, app_name, app_version, device_type, created_on, imei_number )
	values(#userId#, ''#appName#'', ''#appVersion#'', ''#deviceType#'', now(),
(case when ''#imei#''  = ''null'' then null else  ''#imei#''  end)
)',
null,
false, 'ACTIVE');
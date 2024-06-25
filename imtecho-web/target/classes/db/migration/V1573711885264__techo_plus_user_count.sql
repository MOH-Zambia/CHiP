insert into query_master( created_by,
	created_on,
	code,
	query,
	returns_result_set,
	state,
	description)
values (-1,
now(),
'techo_plus_user_count',
'WITH
 web_active_user_query AS 
    (select count(1) as web_active_user from um_user where state = ''ACTIVE''),
 mobile_active_user_query AS 
    (select count(1) as mobile_active_user from um_user where role_id in (select id from um_role_master where "name" in (''FHW'',''MPHW'',''Asha'',''CHO-HWC'') and state = ''ACTIVE'') and state = ''ACTIVE''),
 digital_form_query AS 
    (select count(1) as digital_form_count from system_sync_status where action_date > now() - interval ''7 days''),
 population_empanlled_query AS 
    ( select cast(sum(total_members)/10000000 as decimal(10,2)) as population_empanlled_count from location_wise_analytics)
SELECT
  (SELECT web_active_user FROM web_active_user_query) AS web_active_user,
  (SELECT mobile_active_user FROM mobile_active_user_query) AS mobile_active_user,
  (SELECT digital_form_count FROM digital_form_query) AS digital_form_count,
  (SELECT population_empanlled_count FROM population_empanlled_query) AS population_empanlled_count;',
true,
'ACTIVE',
'techo_plus_user_count');
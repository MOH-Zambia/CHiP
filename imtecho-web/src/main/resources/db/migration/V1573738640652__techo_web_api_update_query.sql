update
	query_master
set
	query = 'WITH
 web_active_user_query AS 
    (select count(1) as webActiveUser from um_user where state = ''ACTIVE''),
 mobile_active_user_query AS 
    (select count(1) as mobileActiveUser from um_user where role_id in (select id from um_role_master where "name" in (''FHW'',''MPHW'',''Asha'',''CHO-HWC'') and state = ''ACTIVE'') and state = ''ACTIVE''),
 digital_form_query AS 
    (select count(1) as digitalFormCount from system_sync_status where action_date > now() - interval ''7 days''),
 population_empanlled_query AS 
    ( select cast(sum(total_members)/10000000 as decimal(10,2)) as populationEmpanlledCount from location_wise_analytics)
SELECT
  (SELECT webActiveUser FROM web_active_user_query) AS "webActiveUser",
  (SELECT mobileActiveUser FROM mobile_active_user_query) AS "mobileActiveUser",
  (SELECT digitalFormCount FROM digital_form_query) AS "digitalFormCount",
  (SELECT populationEmpanlledCount FROM population_empanlled_query) AS "populationEmpanlledCount";'
where
	code = 'techo_plus_user_count'
create table if not exists request_response_navigation_state_mapping(
	id serial,
	navigation_state text UNIQUE NOT NULL,
	PRIMARY KEY (id)
);



DELETE FROM QUERY_MASTER WHERE CODE='menu_list_by_role_ids';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e0f63992-28a8-4e78-a199-9d441d36582c', 97070,  current_date , 97070,  current_date , 'menu_list_by_role_ids', 
'rids', 
'select distinct(menu_name) from menu_config menuC join user_menu_item on menuC.id=user_menu_item.menu_config_id where user_menu_item.role_id in (#rids#)', 
null, 
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='feature_usage_analytics';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'244931a0-eebc-4ee8-a953-2e072a28dfd0', 97070,  current_date , 97070,  current_date , 'feature_usage_analytics', 
'end_date,rids,from_date', 
'select menu_config.menu_name,endData.navigation_state,avg_time,max_time,page_count,user_count,finaltotal,percentValue from (select data001.navigation_state,avg_time,max_time,page_count,user_count,finaltotal,(user_count/finaltotal)*100 as percentValue from (select sum(sum+count) as finalTotal,menu_config.navigation_state from (select data1.sum,data2.count,data2.menu_config_id from (select sum(count),menu_config_id from (SELECT * FROM 
   (select count(id),role_id from um_user group by role_id) a
INNER JOIN 
   (select * from user_menu_item ) b
ON a.role_id = b.role_id) rawData group by menu_config_id) data1
JOIN
(select count(user_id),menu_config_id from user_menu_item group by menu_config_id) data2
on data1.menu_config_id=data2.menu_config_id 
) finalData join menu_config on finalData.menu_config_id=menu_config.id group by menu_config.navigation_state order by finalTotal DESC) data001
join
(select request_response_navigation_state_mapping.navigation_state,avg(avg_active_time) as avg_time,max(max_active_time) as max_time,sum(userAna.no_of_times) as page_count, count(distinct(user_id)) as user_count from analytics.user_wise_feature_time_taken_detail_analytics userAna join request_response_navigation_state_mapping on userAna.page_title_id=request_response_navigation_state_mapping.id where on_date between #from_date# and #end_date# and role_id in (#rids#) group by request_response_navigation_state_mapping.navigation_state) data002 on data001.navigation_state=data002.navigation_state) endData
join menu_config on endData.navigation_state=menu_config.navigation_state
order by page_count DESC;', 
null, 
true, 'ACTIVE');
insert into menu_config (feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id,
menu_type,"uuid", group_name_uuid, sub_group_uuid)
values('{}'
,null,true, false,'All Service Dashboard',
'techo.manage.allservicedashboard.householddashboard',null,'manage','4fd42a4a-d5ec-fd10-a487-84f04ef68ab9',null,null)
on conflict(navigation_state,active) do update
SET feature_json = excluded.feature_json,
	group_id= excluded.group_id,
 	menu_name = excluded.menu_name,
	sub_group_id= excluded.sub_group_id,
 	menu_type= excluded.menu_type;
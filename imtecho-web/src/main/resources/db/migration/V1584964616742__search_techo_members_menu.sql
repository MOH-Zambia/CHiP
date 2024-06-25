insert into menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values
((select id from menu_group where group_name='COVID-19'),true,'Search Techo Members','techo.manage.searchcovidtechomembers','manage');
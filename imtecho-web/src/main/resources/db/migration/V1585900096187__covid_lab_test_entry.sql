delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'COVID-19 Lab Test Entry');
delete from menu_config where menu_name = 'COVID-19 Lab Test Entry';

insert
	into
	menu_config (
	feature_json,
	group_id,
	active,
	is_dynamic_report,
	menu_name,
	navigation_state,
	sub_group_id,
	menu_type,
	only_admin,
	menu_display_order)
values (
'{}',
(select id from menu_group where group_name='COVID-19'),
true,
null,
'COVID-19 Lab Test Entry',
'techo.manage.covidLabTestEntry',
null,
'manage',
null,
null) ;
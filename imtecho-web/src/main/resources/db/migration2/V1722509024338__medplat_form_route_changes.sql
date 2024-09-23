update menu_config
set navigation_state = 'techo.admin.medplatForms'
where navigation_state = 'techo.admin.systemConstraints';


insert into menu_config (feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id,
menu_type,"uuid", group_name_uuid, sub_group_uuid)
values('{"canSaveStableVersion":false,"canChangeStableVersion":false}'
,(select id from menu_group mg where group_name = 'Application Management'),true, false,'Form Configurator',
'techo.admin.medplatForms',null,'admin','48833f6d-41a4-f4cf-ec4f-4347fb34a442','d7617a5c-5d79-c4e4-dbb0-04226466b09d',null)
on conflict(navigation_state,active) do update
SET feature_json = excluded.feature_json,
	group_id= excluded.group_id,
 	menu_name = excluded.menu_name,
	sub_group_id= excluded.sub_group_id,
 	menu_type= excluded.menu_type;
delete from query_master where code = 'update_user_pin';

insert into query_master( created_by,
	created_on,
	code,
	query,
	returns_result_set,
	state,
	description)
values (-1,
now(),
'update_user_pin',
'UPDATE um_user SET pin = #pin# ,modified_on = now() WHERE id = #id#;',
false,
'ACTIVE',
'update_user_pin');
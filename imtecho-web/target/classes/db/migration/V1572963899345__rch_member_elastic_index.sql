insert
	into
	system_configuration (system_key,
	is_active,
	key_value)
values('LAST_INDEX_DATE_OF_RCH_MEMBER_FOR_ELASTICSEARCH',
true,
now());

insert
	into
	system_configuration (system_key,
	is_active,
	key_value)
values('LAST_INDEX_DATE_OF_FAQ_FOR_ELASTICSEARCH',
true,
now());

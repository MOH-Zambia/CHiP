insert into listvalue_field_role (role_id, field_key) values (30, 'countries');

update system_configuration set key_value = cast(key_value as int) + 1 where system_key = 'FHW SHEET VERSION';
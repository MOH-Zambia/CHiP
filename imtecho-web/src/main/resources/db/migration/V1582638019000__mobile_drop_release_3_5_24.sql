update system_configuration set key_value = cast(key_value as integer) + 1 where system_key = 'ASHA SHEET VERSION';
update system_configuration set key_value = cast(key_value as integer) + 1 where system_key = 'FHW SHEET VERSION';

update system_configuration set key_value = '80-78' where system_key = 'ANDROID_VERSION';

delete from app_version_response;
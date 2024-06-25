update system_configuration set key_value = cast(key_value as integer) + 1 where system_key = 'ASHA SHEET VERSION';
update system_configuration set key_value = cast(key_value as integer) + 1 where system_key = 'FHW SHEET VERSION';

update system_configuration set key_value = '84-81' where system_key = 'ANDROID_VERSION';

delete from app_version_response;

insert into mobile_version_mapping(apk_version, text_version) values(84, '3.5.29');
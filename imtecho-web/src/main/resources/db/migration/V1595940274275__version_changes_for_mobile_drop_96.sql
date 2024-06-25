update system_configuration set key_value = '96-94' where system_key = 'ANDROID_VERSION';

delete from app_version_response;

insert into mobile_version_mapping(apk_version, text_version) values(96, '4.0.9');

update system_configuration set key_value = cast(key_value as int) + 1 where system_key  = 'FHW SHEET VERSION';

update system_configuration set key_value = cast(key_value as int) + 1 where system_key  = 'ASHA SHEET VERSION';

update system_configuration set key_value = '95-92' where system_key = 'ANDROID_VERSION';

delete from app_version_response;

insert into mobile_version_mapping(apk_version, text_version) values(95, '4.0.8');
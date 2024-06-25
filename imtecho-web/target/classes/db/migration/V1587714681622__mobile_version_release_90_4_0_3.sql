update system_configuration set key_value = '90-89' where system_key = 'ANDROID_VERSION';

delete from app_version_response;

insert into mobile_version_mapping(apk_version, text_version) values(87, '4.0.0');
insert into mobile_version_mapping(apk_version, text_version) values(88, '4.0.1');
insert into mobile_version_mapping(apk_version, text_version) values(89, '4.0.2');
insert into mobile_version_mapping(apk_version, text_version) values(90, '4.0.3');

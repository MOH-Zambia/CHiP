update system_configuration set key_value = '36' where system_key = 'MOBILE_FORM_VERSION';

update mobile_feature_master
set feature_name = 'FHW NCD Weekly Visit', mobile_display_name = 'NCD Weekly Visit'
where mobile_constant = 'FHW_NCD_WEEKLY_VISIT';

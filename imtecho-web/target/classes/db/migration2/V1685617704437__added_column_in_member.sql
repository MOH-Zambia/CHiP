alter table imt_member
add column if not exists other_disability text;

update system_configuration set key_value = '63' where system_key = 'MOBILE_FORM_VERSION';
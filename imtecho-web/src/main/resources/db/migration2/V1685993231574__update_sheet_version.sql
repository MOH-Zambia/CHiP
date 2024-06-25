update system_configuration set key_value = '68' where system_key = 'MOBILE_FORM_VERSION';

alter table imt_member
add column if not exists other_eye_issue text;
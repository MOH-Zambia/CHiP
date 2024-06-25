update system_configuration set key_value = '71' where system_key = 'MOBILE_FORM_VERSION';

alter table imt_member
add column if not exists current_studying_standard character varying(5),
add column if not exists is_child_going_school boolean;

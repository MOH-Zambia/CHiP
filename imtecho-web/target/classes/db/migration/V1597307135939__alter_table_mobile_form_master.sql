alter table mobile_form_master
drop column if exists list_value_field_key,
add column list_value_field_key text;
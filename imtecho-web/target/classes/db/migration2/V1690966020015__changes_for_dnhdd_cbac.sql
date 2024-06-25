
alter table ncd_member_cbac_detail
drop column if exists consume_alcohol,
add column consume_alcohol text;

alter table ncd_member_cbac_detail
drop column if exists smoke,
add column smoke text;

alter table ncd_member_cbac_detail
drop column if exists consume_gutka,
add column consume_gutka text;

update system_configuration set key_value = '91' where system_key = 'MOBILE_FORM_VERSION';

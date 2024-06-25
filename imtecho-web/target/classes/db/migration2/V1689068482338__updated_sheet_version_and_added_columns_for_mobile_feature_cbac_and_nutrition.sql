
alter table ncd_member_cbac_detail
drop column if exists hmis_id,
add column hmis_id bigint;

alter table ncd_member_cbac_detail
drop column if exists growth_in_mouth,
add column growth_in_mouth boolean;

alter table ncd_member_cbac_detail
drop column if exists known_disabilities,
add column known_disabilities text;

alter table ncd_member_cbac_detail
drop column if exists blurred_vision_eye,
add column blurred_vision_eye text;

alter table ncd_member_cbac_detail
drop column if exists physical_activity_30_min,
add column physical_activity_30_min text;

update system_configuration set key_value = '83' where system_key = 'MOBILE_FORM_VERSION';
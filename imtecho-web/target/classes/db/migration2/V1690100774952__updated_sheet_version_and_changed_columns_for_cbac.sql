
alter table child_nutrition_sam_screening_master
drop column if exists hmis_id;

alter table child_nutrition_sam_screening_master
drop column if exists cloudy_vision;

alter table child_nutrition_sam_screening_master
drop column if exists blurred_vision_eye;

alter table child_nutrition_sam_screening_master
drop column if exists fits_history;

alter table child_nutrition_sam_screening_master
drop column if exists hearing_difficulty;

alter table ncd_cbac_nutrition_master
drop column if exists location_id,
add column location_id integer;

alter table ncd_cbac_nutrition_master
drop column if exists service_date,
add column service_date timestamp without time zone;

update system_configuration set key_value = '86' where system_key = 'MOBILE_FORM_VERSION';




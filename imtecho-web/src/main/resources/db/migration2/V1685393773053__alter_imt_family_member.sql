update system_configuration set key_value = '58' where system_key = 'MOBILE_FORM_VERSION';

alter table imt_family
drop column if exists ration_card_type,
add column if not exists other_toilet text,
add column if not exists other_water_source text;

alter table imt_member rename column currently_under_treatment to under_treatment_chronic;
alter table imt_member add column if not exists other_chronic text;
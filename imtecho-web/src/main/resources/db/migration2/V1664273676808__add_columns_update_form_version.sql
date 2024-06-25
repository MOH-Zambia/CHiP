alter table ncd_member_hypertension_detail
    add column if not exists current_treatment_place_other text;

alter table ncd_member_mental_health_detail
    add column if not exists current_treatment_place_other text;

alter table ncd_member_diabetes_detail
    add column if not exists current_treatment_place_other text;

update system_configuration set key_value = '27' where system_key = 'MOBILE_FORM_VERSION';
update system_configuration set key_value = '90' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE ncd_general_screening
add column if not exists image text,
add column if not exists had_cervical_cancer_test boolean,
add column if not exists had_breast_cancer_test boolean,
add column if not exists had_oral_cancer_test boolean;
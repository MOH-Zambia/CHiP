INSERT INTO internationalization_label_master
(country, key, language, created_by, created_on, custom3b, text, translation_pending, app_name)
SELECT
l2.country, CONCAT(l2.key, '_', system_constraint_form_master.form_code), l2.language, -1, now(), l2.custom3b, now(), l2.translation_pending, l2.app_name
FROM internationalization_label_master l2
INNER JOIN system_constraint_field_value_master on system_constraint_field_value_master.key = 'label' and l2.key = system_constraint_field_value_master.default_value
INNER JOIN system_constraint_field_master on system_constraint_field_master.uuid = system_constraint_field_value_master.field_master_uuid
INNER JOIN system_constraint_form_master on system_constraint_form_master.uuid = system_constraint_field_master.form_master_uuid
where
l2.language = 'EN'
ON conflict on constraint internationalization_label_master_pkey
DO NOTHING;


-- For issue - https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2472
-- Add key value pair in db for wpd child referral reasons

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'wpd_child_referral_reasons', 'WPD child referral reasons', true, 'T', 'WPD'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='wpd_child_referral_reasons');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Birth Disability', 'wpd_child_referral_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='wpd_child_referral_reasons' AND value='Birth Disability');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Fever', 'wpd_child_referral_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='wpd_child_referral_reasons' AND value='Fever');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'LBW', 'wpd_child_referral_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='wpd_child_referral_reasons' AND value='LBW');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Jaundice', 'wpd_child_referral_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='wpd_child_referral_reasons' AND value='Jaundice');

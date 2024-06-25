INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'gvk_no_pregnancy_reasons', 'GVK no pregnancy reasons', true, 'T', 'MYTECHO'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='gvk_no_pregnancy_reasons');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Wrongly marked as pregnant', 'gvk_no_pregnancy_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='gvk_no_pregnancy_reasons' AND value='Wrongly marked as pregnant');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Already delivered', 'gvk_no_pregnancy_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='gvk_no_pregnancy_reasons' AND value='Already delivered');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Abortion', 'gvk_no_pregnancy_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='gvk_no_pregnancy_reasons' AND value='Abortion');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'MTP', 'gvk_no_pregnancy_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='gvk_no_pregnancy_reasons' AND value='MTP');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Dead', 'gvk_no_pregnancy_reasons', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='gvk_no_pregnancy_reasons' AND value='Dead');
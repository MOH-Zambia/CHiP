-- Add key value pair for school grant types and school types
-- For issue - https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3036

-- school grant types

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'school_grant_types', 'School grant types', true, 'T', 'WEB'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='school_grant_types');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Government', 'school_grant_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='school_grant_types' AND value='Government');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Private', 'school_grant_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='school_grant_types' AND value='Private');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Grant-In Aid', 'school_grant_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='school_grant_types' AND value='Grant-In Aid');

-- school types

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
    SELECT 'school_types', 'School types', true, 'T', 'WEB'
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_master WHERE field_key='school_types');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Primary School', 'school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='school_types' AND value='Primary School');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'High School', 'school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='school_types' AND value='High School');

INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
    SELECT true, false, 'dhirpara', now(), 'Others', 'school_types', 0
    WHERE NOT EXISTS (SELECT 1 FROM listvalue_field_value_detail WHERE field_key='school_types' AND value='Others');
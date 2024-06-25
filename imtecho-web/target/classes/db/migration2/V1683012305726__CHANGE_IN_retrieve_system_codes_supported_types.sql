-- ADD code support for icd 11 and LOINC

DELETE FROM 
  listvalue_field_value_detail 
where 
  field_key = 'system_codes_supported_types' 
  AND (value = 'ICD_11' OR value = 'LOINC');
insert into listvalue_field_value_detail(
  is_active, is_archive, last_modified_by, 
  last_modified_on, value, field_key, 
  file_size
) 
values 
  (
    true, false, 'superadmin', now(), 'ICD_11', 
    'system_codes_supported_types', 
    0
  ), 
  (
    true, false, 'superadmin', now(), 'LOINC', 
    'system_codes_supported_types', 
    0
  );
  
-- update query to return resule by order

DELETE FROM 
  QUERY_MASTER 
WHERE 
  CODE = 'retrieve_system_codes_supported_types';
INSERT INTO QUERY_MASTER (
  uuid, created_by, created_on, modified_by, 
  modified_on, code, params, query, 
  description, returns_result_set, 
  state
) 
VALUES 
  (
    '4b0571bc-1847-467a-aeb1-3b97de948ac0', 
    85436, current_date, 85436, current_date, 
    'retrieve_system_codes_supported_types', 
    null, 'select value as "codeType" from listvalue_field_value_detail as lvd where field_key  = ''system_codes_supported_types''  AND is_active = true ORDER BY value', 
    'this query retrieve the list of codes supported by system', 
    true, 'ACTIVE'
  );


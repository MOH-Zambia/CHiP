DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_code_mapping_by_field_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4fa948d6-ac57-4913-be18-6e6b62ad779f', 80251,  current_date , 80251,  current_date , 'retrieve_system_code_mapping_by_field_id', 
'fieldId', 
'WITH LIST_VALUE  AS
(select * from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = #fieldId# AND is_active = true )  AND is_active =true),
CODES AS ( select value as "code" from listvalue_field_value_detail as lvd where field_key  = ''system_codes_supported_types''  AND is_active = true ) ,
CODE_MASTER AS ( select CAST ( id AS TEXT),table_id as table_id,code_type ,code,parent_code,description from system_code_master where table_type  = ''LIST_VALUE'' ) ,
TEMP_TEB AS  ( SELECT lv.id ,
count ( codes.code ) ,lv.value from
LIST_VALUE lv,CODES codes group by lv.id ,lv.value
) 
select tt.id,tt.value as name, 
cast(array_to_json(array_agg(json_build_object( ''id'', CAST ( cm.id AS TEXT), ''tableId'',cm.table_id,''codeType'',cm.code_type
,''code'',cm.code,''description'',cm.description,''parentCode'',cm.parent_code ))) as text) as "SYSTEM_CODE"
  from  
TEMP_TEB tt left JOIN CODE_MASTER cm ON tt.id  = cm.table_id group by tt.id,tt.value', 
'retrieve system code mapping along with list value id and names', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_code_mapping_by_opd_lab_test';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e87df1dd-3873-4054-8552-cf758c1fd63a', 80251,  current_date , 80251,  current_date , 'retrieve_system_code_mapping_by_opd_lab_test', 
 null, 
'WITH LIST_VALUE  AS
(select * from rch_opd_lab_test_master where is_active = true ) ,
CODES AS ( select value as "code" from listvalue_field_value_detail as lvd where field_key  = ''system_codes_supported_types''  AND is_active = true ) ,
CODE_MASTER AS ( select * from system_code_master where table_type = ''OPD_LAB_TEST'' ) ,
TEMP_TEB AS  ( SELECT lv.id ,lv.name from
LIST_VALUE lv,CODES codes group by lv.id,lv.name 
) 
select tt.id,tt.name,
cast(array_to_json(array_agg(json_build_object( ''id'', CAST ( cm.id AS TEXT), ''tableId'',cm.table_id, ''tableType'',cm.table_type,''codeType'',cm.code_type
,''code'',cm.code,''description'',cm.description,''parentCode'',cm.parent_code ))) as text) as "SYSTEM_CODE"
  from  
TEMP_TEB tt LEFT  JOIN CODE_MASTER cm ON tt.id  = cm.table_id group by tt.id,tt.name', 
'retrieve system code mapping along with opd lab test id and names', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_codes_supported_types';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4b0571bc-1847-467a-aeb1-3b97de948ac0', 80251,  current_date , 80251,  current_date , 'retrieve_system_codes_supported_types', 
 null, 
'select value as "codeType" from listvalue_field_value_detail as lvd where field_key  = ''system_codes_supported_types''  AND is_active = true', 
'this query retrieve the list of codes supported by system', 
true, 'ACTIVE');

UPDATE system_code_master set table_type = 'OPD_LAB_TEST' where table_type =  'LAB_TEST' ;


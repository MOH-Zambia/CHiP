DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_code_mapping_by_opd_lab_test';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e87df1dd-3873-4054-8552-cf758c1fd63a', 80251,  current_date , 80251,  current_date , 'retrieve_system_code_mapping_by_opd_lab_test', 
 null, 
'WITH LIST_VALUE  AS
(select * from rch_opd_lab_test_master where is_active = true ) ,
CODES AS ( select value as "code" from listvalue_field_value_detail as lvd where field_key  = ''system_codes_supported_types''  AND is_active = true ) ,
CODE_MASTER AS ( select * from system_code_master ) ,
TEMP_TEB AS  ( SELECT lv.id ,
count ( codes.code ) ,
cast(array_to_json(array_agg( json_build_object(''codeType'', codes.code ) )) as text) as CODE_LIST ,
cast(array_to_json(array_agg( json_build_object(''id'', lv.id, ''name'', lv.name) )) as text) as LIST_VALUE from
LIST_VALUE lv,CODES codes group by lv.id
) 
select tt.id,tt.count as codeCount, tt.CODE_LIST as codeList,LIST_VALUE as listValue,

cast(array_to_json(array_agg(json_build_object( ''id'', CAST ( cm.id AS TEXT), ''tableId'',cm.table_id, ''tableType'',cm.table_type,''codeType'',cm.code_type
,''code'',cm.code,''description'',cm.description,''parentCode'',cm.parent_code ))) as text) as "SYSTEM_CODE"
  from  
TEMP_TEB tt LEFT  JOIN CODE_MASTER cm ON tt.id  = cm.table_id group by tt.id,tt.count,tt.CODE_LIST,LIST_VALUE', 
null, 
true, 'ACTIVE');

DELETE FROM listvalue_field_value_detail where field_key  = 'system_codes_supported_types';
DELETE FROM listvalue_field_master where field_key = 'system_codes_supported_types';

INSERT INTO listvalue_field_master(
           field_key, field, is_active, field_type, form, role_type)
VALUES ('system_codes_supported_types','Types of System Code Supported',TRUE,'T','WEB',null);

insert into listvalue_field_value_detail(
	is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size) values
	 (true,false,'superadmin',now(),'SNOMED_CT_CONCEPT','system_codes_supported_types',0);
insert into listvalue_field_value_detail(
	is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size) values
	 (true,false,'superadmin',now(),'ICD_10','system_codes_supported_types',0);

delete from system_code_master;

INSERT INTO system_code_master (table_id,table_type,code_type,code,parent_code,description,created_by) values (
(select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdProvisionalDiagnosis' ) and is_active = true and value = 'Fever of Unknown Origin (PUO)')
,'LIST_VALUE','SNOMED_CT_CONCEPT','386661006',null,'Fever (finding)',1);


INSERT INTO system_code_master (table_id,table_type,code_type,code,parent_code,description,created_by) values (
(select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdProvisionalDiagnosis' ) and is_active = true and value = 'Bacillary Dysentery')
,'LIST_VALUE','SNOMED_CT_CONCEPT','274081004',null,'Bacillary dysentery (disorder)',1);


INSERT INTO system_code_master (table_id,table_type,code_type,code,parent_code,description,created_by) values (
(select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdProvisionalDiagnosis' ) and is_active = true and value = 'Viral Hepatitis')
,'LIST_VALUE','SNOMED_CT_CONCEPT','3738000',null,'Viral hepatitis (disorder)',1);


INSERT INTO system_code_master (table_id,table_type,code_type,code,parent_code,description,created_by) values (
(select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdProvisionalDiagnosis' ) and is_active = true and value = 'Enteric Fever')
,'LIST_VALUE','SNOMED_CT_CONCEPT','250511008',null,'Enteric fever antibody titer measurement (procedure)',1);


INSERT INTO system_code_master (table_id,table_type,code_type,code,parent_code,description,created_by) values (
(select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdProvisionalDiagnosis' ) and is_active = true and value = 'Malaria')
,'LIST_VALUE','SNOMED_CT_CONCEPT','386661044',null,'Malaria (disorder)',1);


INSERT INTO system_code_master (table_id,table_type,code_type,code,parent_code,description,created_by) values (
(select id from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = 'opdProvisionalDiagnosis' ) and is_active = true and value = 'Malaria')
,'LIST_VALUE','ICD_10','386661999',null,'ICD 10 Malaria (disorder)',1);

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_code_mapping_by_field_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4fa948d6-ac57-4913-be18-6e6b62ad779f', 80251,  current_date , 80251,  current_date , 'retrieve_system_code_mapping_by_field_id', 
'fieldId', 
'WITH LIST_VALUE  AS
(select * from listvalue_field_value_detail where field_key = (select field_key from listvalue_field_master where field = #fieldId# AND is_active )  AND is_active =true),
CODES AS ( select value as "code" from listvalue_field_value_detail as lvd where field_key  = ''system_codes_supported_types''  AND is_active = true ) ,
CODE_MASTER AS ( select * from system_code_master ) ,
TEMP_TEB AS  ( SELECT lv.id ,
count ( codes.code ) ,
cast(array_to_json(array_agg( json_build_object(''codeType'', codes.code ) )) as text) as CODE_LIST ,
cast(array_to_json(array_agg( json_build_object(''id'', lv.id, ''name'', lv.value) )) as text) as LIST_VALUE from
LIST_VALUE lv,CODES codes group by lv.id
) 
select tt.id,tt.count as codeCount, tt.CODE_LIST as codeList,LIST_VALUE as listValue,

cast(array_to_json(array_agg(json_build_object( ''id'', CAST ( cm.id AS TEXT), ''tableId'',cm.table_id, ''tableType'',cm.table_type,''codeType'',cm.code_type
,''code'',cm.code,''description'',cm.description,''parentCode'',cm.parent_code ))) as text) as "SYSTEM_CODE"
  from  
TEMP_TEB tt left JOIN CODE_MASTER cm ON tt.id  = cm.table_id group by tt.id,tt.count,tt.CODE_LIST,LIST_VALUE', 
null, 
true, 'ACTIVE');

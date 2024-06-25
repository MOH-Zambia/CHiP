-- system_code_master;
DROP TABLE IF EXISTS system_code_master;

CREATE TABLE if not exists system_code_master
(
   id uuid DEFAULT uuid_generate_v4 (),
  table_id int4 NOT NULL ,
  table_type character varying(255) NOT NULL,
  code_type character varying(255) NOT NULL,
  code character varying(255) NOT NULL,
  parent_code character varying(255),
  description character varying(255),
  created_by int4 NOT NULL  ,
  created_on timestamp NOT NULL DEFAULT current_timestamp,
  modified_by int4 ,
  modified_on timestamp DEFAULT current_timestamp,
  CONSTRAINT system_code_master_pkey PRIMARY KEY (id),
  CONSTRAINT system_code_master_ukey UNIQUE (table_id,table_type,code_type)
);

COMMENT ON TABLE system_code_master IS 'This is master table for code and its management like ICD-10,SNOMED CT,etc';

comment on column system_code_master.table_id is 'Id of related table';
comment on column system_code_master.table_type is 'Type of related table';
comment on column system_code_master.code_type is 'Tyoe of code like SNOMED CT,ICD-10';
comment on column system_code_master.code is 'code like SNOMED CT concept id,ICD-10 id';
comment on column system_code_master.parent_code is 'Parent code like SNOMED CT concept id,ICD-10 id';
comment on column system_code_master.description is 'Description of entity';


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
,'LIST_VALUE','SNOMED_CT_CONCEPT','386661006',null,'Malaria (disorder)',1);

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_snomed_ct_single_expresion';

INSERT INTO QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state,uuid ) 
VALUES (  75398,  current_date , 75398,  current_date , 'retrieve_snomed_ct_single_expresion', 
'opdId', 
'select concat_ws('' | '', scm.code,scm.description ) from rch_opd_member_master romm inner join rch_opd_lab_test_provisional_rel rolt on rolt.opd_member_master_id = romm.id 
inner join listvalue_field_value_detail listvalue on  rolt.provisional_id = listvalue.id inner join system_code_master scm on listvalue.id = scm.table_id where scm.table_type = ''LIST_VALUE'' and scm.code_type = ''SNOMED_CT_CONCEPT'' and romm.id = #opdId# ', 
'Fire postgres query to get snomed ct expressions for given opdId', 
true, 'ACTIVE',uuid_generate_v4());

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_icd_10_single_expresion';

INSERT INTO QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state,uuid ) 
VALUES (  75398,  current_date , 75398,  current_date , 'retrieve_icd_10_single_expresion', 
'opdId', 
'select scm.code,scm.description from rch_opd_member_master romm inner join rch_opd_lab_test_provisional_rel rolt on rolt.opd_member_master_id = romm.id 
inner join listvalue_field_value_detail listvalue on  rolt.provisional_id = listvalue.id inner join system_code_master scm on listvalue.id = scm.table_id where scm.table_type = ''LIST_VALUE'' and scm.code_type = ''ICD_10'' and romm.id = #opdId# ', 
'Fire postgres query to get icd 10 expressions for given opdId', 
true, 'ACTIVE',uuid_generate_v4());

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_limited_system_code';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
uuid_generate_v4(), 75398,  current_date , 75398,  current_date , 'retrieve_limited_system_code', 
'limit,searchKey', 
'SELECT * from system_code_master where  ( #searchKey# = null OR code ILIKE CONCAT(''%'', #searchKey#, ''%'' )) order by modified_on desc limit #limit#', 
'Fire postgres query to get limited records from system_code_master table ', 
true, 'ACTIVE');

DELETE FROM menu_config where menu_name = 'System Code Management Tool';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('System Code Management Tool','manage',TRUE,'techo.manage.systemcode','{}');
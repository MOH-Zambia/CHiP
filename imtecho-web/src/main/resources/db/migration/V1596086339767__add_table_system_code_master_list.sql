-- system_code_master_list;
DROP TABLE IF EXISTS system_code_master_list;

CREATE TABLE if not exists system_code_master_list
(
  id uuid DEFAULT uuid_generate_v4() NOT NULL,
  code_type character varying(255) NOT NULL,
  code_category character varying(255),
  code_id character varying(255) NOT NULL,
  code character varying(255) NOT NULL,
  parent_code character varying(255),
  name character varying(255),
  description character varying(255),
  desc_type_id character varying(255),
  effective_date timestamp,
  other_details text,
  published_edition character varying(255),
  is_active boolean,
  created_by int4 NOT NULL ,
  created_on timestamp NOT NULL DEFAULT current_timestamp,
  modified_by int4 ,
  modified_on timestamp DEFAULT current_timestamp,
  CONSTRAINT system_code_master_list_pkey PRIMARY KEY (id),
  CONSTRAINT system_code_master_list_ukey UNIQUE (code_id)
);

COMMENT ON TABLE system_code_master_list IS 'This is master table for code and its management like ICD-10,SNOMED CT,etc';
comment on column system_code_master_list.id is 'UUID as primary key of table';
comment on column system_code_master_list.code_type is 'Tyoe of code like SNOMED CT,ICD-10';
comment on column system_code_master_list.code_category is 'Category of code like A00...Z99,finding,procedure..';
comment on column system_code_master_list.code_id is 'unique id of code from where code was imported';
comment on column system_code_master_list.code is 'code like A00.01,U34.99D,386661006';
comment on column system_code_master_list.parent_code is 'Parent code like SNOMED CT concept id,ICD-10 id';
comment on column system_code_master_list.name is 'name of entity';
comment on column system_code_master_list.description is 'Description of entity';
comment on column system_code_master_list.desc_type_id is 'Description Type of entity';
comment on column system_code_master_list.effective_date is 'The Date on which this code comes to an effect';
comment on column system_code_master_list.other_details is 'Other details of code like type_id,module_id,case_significance_id';
comment on column system_code_master_list.published_edition is 'Code published edition like India COVID-19 Extension for SNOMED CT,Common Drug Codes for India (Terminology Integrated Package),India Reference Sets for SNOMED CT,SNOMED CT International Edition';
comment on column system_code_master_list.is_active is 'Code is active for use or not';

DELETE FROM QUERY_MASTER WHERE CODE='insert_into_system_code_master_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e9ce70dd-8f58-4b57-ae36-c0b51c591bac', 80251,  current_date , 80251,  current_date , 'insert_into_system_code_master_list', 
'codeCategory,code,otherDetails,description,publishedEdition,isActive,codeId,descTypeId,parentCode,createdBy,name,modifiedBy,id,effectiveDate,code_type', 
'insert into system_code_master_list (id,code_type
,code_category,code_id,code,parent_code,name,description,desc_type_id,effective_date,
other_details,published_edition,is_active,created_by,created_on,modified_by,modified_on )
values 
(  CAST (  #id#  AS uuid )  ,#code_type#
,#codeCategory#,#codeId#,#code#,#parentCode#,#name#,#description#,#descTypeId#,#effectiveDate#,
#otherDetails#,#publishedEdition#,#isActive#,#createdBy#,now(),#modifiedBy#, now() )
ON CONFLICT (code_id) 
DO 
UPDATE SET  
modified_on  = now() ,
 modified_by = EXCLUDED.modified_by,
 code_category= EXCLUDED.code_category,
 code= EXCLUDED.code,
 code_type= EXCLUDED.code_type,
 name= EXCLUDED.name,
 parent_code= EXCLUDED.parent_code,
 description= EXCLUDED.description,
 desc_type_id= EXCLUDED.desc_type_id,
 effective_date= EXCLUDED.effective_date,
 other_details= EXCLUDED.other_details,
 published_edition= EXCLUDED.published_edition,
 is_active= EXCLUDED.is_active;', 
'this query is used to insert or update into system code master list table', 
false, 'ACTIVE');

delete from system_configuration where system_key IN (
'WHO_ICD_CODE_10_DEFAULT_START_CATEGOY',
'WHO_ICD_CODE_10_DEFAULT_END_CATEGOY',
'SNOMED_CT_CSV_FILE_DATE_FROMAT',
'WHO_ICD_CODE_REST_API_TOKEN_ENPOINT',
'WHO_ICD_CODE_REST_API_CLIENT_ID',
'WHO_ICD_CODE_REST_API_CLIENT_SECRET',
'WHO_ICD_CODE_REST_API_BASE_URL');

INSERT INTO system_configuration( system_key, is_active, key_value)
    VALUES 
    ('WHO_ICD_CODE_10_DEFAULT_START_CATEGOY', true,'A00'),
    ('WHO_ICD_CODE_10_DEFAULT_END_CATEGOY', true,'Z99'),
    ('SNOMED_CT_CSV_FILE_DATE_FROMAT', true,'yyyyMMdd'),
    ('WHO_ICD_CODE_REST_API_TOKEN_ENPOINT', true,'https://icdaccessmanagement.who.int/connect/token'),
    ('WHO_ICD_CODE_REST_API_CLIENT_ID', true,'5a492542-fe85-4ba0-a230-a3b65915aeb1_9bf81b8d-7041-49a2-99ce-b92b5b15f1e9'),
    ('WHO_ICD_CODE_REST_API_CLIENT_SECRET', true,'JUqVkARO95AuDDVMLvyyl95wjOXRc4kafrygfcfWZy8='),
    ('WHO_ICD_CODE_REST_API_BASE_URL',true,'https://id.who.int/icd/release/');

UPDATE listvalue_field_value_detail SET value = 'SNOMED_CT' where value = 'SNOMED_CT_CONCEPT';

UPDATE system_code_master SET code_type = 'SNOMED_CT' where code_type = 'SNOMED_CT_CONCEPT';

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_snomed_ct_single_expresion';

INSERT INTO QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state,uuid ) 
VALUES (  75398,  current_date , 75398,  current_date , 'retrieve_snomed_ct_single_expresion', 
'opdId', 
'select concat_ws('' | '', scm.code,scm.description ) from rch_opd_member_master romm inner join rch_opd_lab_test_provisional_rel rolt on rolt.opd_member_master_id = romm.id 
inner join listvalue_field_value_detail listvalue on  rolt.provisional_id = listvalue.id inner join system_code_master scm on listvalue.id = scm.table_id where scm.table_type = ''LIST_VALUE'' and scm.code_type = ''SNOMED_CT'' and romm.id = #opdId# ', 
'Fire postgres query to get snomed ct expressions for given opdId', 
true, 'ACTIVE',uuid_generate_v4());

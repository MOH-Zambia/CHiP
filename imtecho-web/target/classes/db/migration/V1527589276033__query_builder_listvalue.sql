INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'insert_listvalues', 'lastModifiedBy,lastModifiedOn,value,fieldKey,multimediaType,fileSize',
    'INSERT INTO public.listvalue_field_value_detail(
            id, is_active, is_archive, last_modified_by, last_modified_on, multimedia_type,
            value, field_key,file_size) VALUES (true, false,''#lastModifiedBy#'', ''#lastModifiedOn#'', ''#multimediaType#''
            ''#value#'', ''#fieldKey#'',''#fileSize#'')',false,'ACTIVE');

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'update_listvalues', 'lastModifiedBy,lastModifiedOn,value,fileSize,id,multimediaType',
    'UPDATE public.listvalue_field_value_detail
   SET last_modified_by=''#lastModifiedBy#'', last_modified_on=''#lastModifiedOn#'',multimedia_type=''#multimediaType#'', 
       value=''#value#'', file_size=#fileSize#
 WHERE id=#id#',false,'ACTIVE');

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'retrival_listvalues_mobile', 'roleId,lastUpdatedOn',
    'select values.id as "idOfValue" ,fields.form as "formCode", 
    fields.field as  "field",
    fields.field_type as "fieldType", values.value as value, 
    values.last_modified_on as "lastUpdateOfFieldValue" ,values.is_active as "isActive"
    from   listvalue_field_value_detail values
    join listvalue_field_master fields
    on fields.field_key = values.field_key
    inner join  listvalue_field_role  vr
    on values.field_key=vr.field_key
    where role_id=#roleId#
	and values.last_modified_on >=(case when #lastUpdatedOn# is null then ''01/01/1970'' else ''#lastUpdatedOn#'' end) \:\:Date ',false,'ACTIVE');


INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'update_active_inactive_listvalues', 'id,isActive',
    'UPDATE public.listvalue_field_value_detail
   SET is_active=#isActive#
 WHERE id=#id#;',false,'ACTIVE');


INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'retrival_listvalue_active_forms', '','select form_key as key,form as name from listvalue_form_master ;'

            ,true,'ACTIVE');
INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'retrival_listvalue_active_fields_acc_form', 'formKey','select * from listvalue_field_master where form=''#formKey#'' and is_active =true'

            ,true,'ACTIVE');
INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'retrival_listvalue_values_acc_field', 'fieldKey','select * from listvalue_field_value_detail where  field_key=''#fieldKey#'' '
            ,true,'ACTIVE');

-- field role table and migration
CREATE TABLE public.listvalue_field_role
(
  role_id bigint,
  id bigserial,
  field_key character varying,
  CONSTRAINT id PRIMARY KEY (id)
);

INSERT INTO public.listvalue_field_role(
            field_key, role_id)
     (

SELECT field_key,
 case when split_part(role_type, ',', 1)='A' then (select id from um_role_master where name='Asha')
 when split_part(role_type, ',', 1)='E' then (select id from um_role_master where name='ERT') 
 when split_part(role_type, ',', 1)='O' then  (select id from um_role_master where name='Observer' )
when split_part(role_type, ',', 1) ='ES69' then (select id from um_role_master where name='Child Data Collector' )
 when split_part(role_type, ',', 1) ='ES14' then (select id from um_role_master where name='PNC Data Collector')
 when split_part(role_type, ',', 1)='F' then (select id from um_role_master where name= 'FHW' ) 
 when split_part(role_type, ',', 1)='S' then (select id from um_role_master where name= 'Setu' ) end as role_id from listvalue_field_master  
 WHERE split_part(role_type, ',', 1) <> '');

INSERT INTO public.listvalue_field_role(
            field_key, role_id)
     (

SELECT field_key,
 case when split_part(role_type, ',', 2)='A' then (select id from um_role_master where name='Asha')
 when split_part(role_type, ',', 2)='E' then (select id from um_role_master where name='ERT') 
 when split_part(role_type, ',', 2)='O' then  (select id from um_role_master where name='Observer' )
when split_part(role_type, ',', 2) ='ES69' then (select id from um_role_master where name='Child Data Collector' )
 when split_part(role_type, ',', 2) ='ES14' then (select id from um_role_master where name='PNC Data Collector')
 when split_part(role_type, ',', 2)='F' then (select id from um_role_master where name= 'FHW' ) 
 when split_part(role_type, ',', 2)='S' then (select id from um_role_master where name= 'Setu' ) end as role_id from listvalue_field_master  
 WHERE split_part(role_type, ',', 2) <> '');

INSERT INTO public.listvalue_field_role(
            field_key, role_id)
     (

SELECT field_key,
 case when split_part(role_type, ',', 3)='A' then (select id from um_role_master where name='Asha')
 when split_part(role_type, ',', 3)='E' then (select id from um_role_master where name='ERT') 
 when split_part(role_type, ',', 3)='O' then  (select id from um_role_master where name='Observer' )
when split_part(role_type, ',', 3) ='ES69' then (select id from um_role_master where name='Child Data Collector' )
 when split_part(role_type, ',', 3) ='ES14' then (select id from um_role_master where name='PNC Data Collector')
 when split_part(role_type, ',', 3)='F' then (select id from um_role_master where name= 'FHW' ) 
 when split_part(role_type, ',', 3)='S' then (select id from um_role_master where name= 'Setu' ) end as role_id from listvalue_field_master  
 WHERE split_part(role_type, ',', 3) <> '');

-- add column media type for audio video and image
ALTER TABLE public.listvalue_field_value_detail
  ADD COLUMN multimedia_type character varying(250);




-- Team Type Config
DELETE FROM QUERY_MASTER WHERE CODE='team_type_mark_team_type_active_or_inactive';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd314e205-a40a-4fed-9619-fa5fd9a92cf0', 75398,  current_date , 75398,  current_date , 'team_type_mark_team_type_active_or_inactive', 
'state,id', 
'update team_type_master set state = #state#  , modified_on = now() where id = #id# ;', 
null, 
false, 'ACTIVE');

-- Manage Value and Multi Media
DELETE FROM QUERY_MASTER WHERE CODE='retrival_listvalue_active_fields_acc_form';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0053b8ef-1113-4f97-ad71-5dd4c67b2002', 75398,  current_date , 75398,  current_date , 'retrival_listvalue_active_fields_acc_form', 
'formKey', 
'select * from listvalue_field_master where form=#formKey# and is_active =true', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_list_values_by_field_key';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bb1ec205-a1ab-424a-9b63-c6198777fe2a', 75398,  current_date , 75398,  current_date , 'retrieve_list_values_by_field_key', 
'fieldKey', 
'select * from listvalue_field_value_detail where field_key=#fieldKey#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='insert_listvalues';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'136eee66-c5d5-4455-9858-cde74048045f', 75398,  current_date , 75398,  current_date , 'insert_listvalues', 
'multimediaType,fieldKey,fileSize,loggedInUserId,value', 
'INSERT INTO public.listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, multimedia_type,value,field_key,file_size) VALUES (true, false, #loggedInUserId# , now() , 
#multimediaType#, #value# , #fieldKey# , #fileSize# );', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_listvalues';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'45b9b75e-aeb7-449a-a3c7-72b89cf98509', 75398,  current_date , 75398,  current_date , 'update_listvalues', 
'multimediaType,fileSize,loggedInUserId,id,value', 
'UPDATE public.listvalue_field_value_detail
   SET last_modified_by=#loggedInUserId#, last_modified_on=now(),multimedia_type=#multimediaType#, 
       value=#value#, file_size=#fileSize#
 WHERE id=#id#', 
null, 
false, 'ACTIVE');


-- Roles

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_field_values_for_form_field';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'931f76f0-7c59-490d-ace0-023ba4414912', 75398,  current_date , 75398,  current_date , 'retrieve_field_values_for_form_field', 
'form,fieldKey', 
'select value as value , v.id as id from listvalue_field_master f , listvalue_field_value_detail  v
where f.field_key=v.field_key and f.form = #form# and v.field_key=#fieldKey#
and v.is_active=true', 
'Retrieve field values for particular field key and form ', 
true, 'ACTIVE');


-- Manage Translations

-- DELETE FROM QUERY_MASTER WHERE CODE='translation_label_retrival';
-- 
-- INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
-- VALUES ( 
-- '578b67fd-94cb-44f0-9e86-ff8ed9536f50', 75398,  current_date , 75398,  current_date , 'translation_label_retrival', 
-- 'searchText,offset,limit,language,isPending,onlyMobile,startsWith', 
-- 'select labelMaster1.key as key, labelMaster1.language as language ,labelMaster2.text as label ,labelMaster1.text ,case when labelMaster1.language=''EN'' then ''English'' else ''Gujarati'' end as languageToDisplay,labelMaster1.translation_pending as "isTranslationPending", labelMaster1.custom3b as "isMobileLabel" from internationalization_label_master as labelMaster1 join internationalization_label_master as labelMaster2 on labelMaster2.key = labelMaster1.key where labelMaster2.language=''EN'' and (#onlyMobile# is null or labelMaster1.custom3b=#onlyMobile#) and (#isPending# is null or labelMaster1.translation_pending=#isPending#) and (#language# = ''null'' or labelMaster1.language=#language# ) and (#startsWith# = ''null'' or labelMaster2.text ilike CONCAT(#startsWith# ,''%'')) and (#searchText# = ''null'' or labelMaster2.text ilike CONCAT(''%'',#searchText# ,''%'')) 
-- order by labelMaster1.key
-- limit #limit# offset #offset#', 
-- null, 
-- true, 'ACTIVE');
-- 
-- 
-- DELETE FROM QUERY_MASTER WHERE CODE='translation_label_update';
-- 
-- INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
-- VALUES ( 
-- 'ca191c03-3147-4e9f-be41-7e6ce31878ad', 75398,  current_date , 75398,  current_date , 'translation_label_update', 
-- 'oldKey,isMobileLabel,isTranslationPending,language,text', 
-- 'UPDATE public.internationalization_label_master SET custom3b=#isMobileLabel#, text =#text#, translation_pending=#isTranslationPending#,modified_on=now()
--  WHERE key = #oldKey# and language=#language#;', 
-- null, 
-- false, 'ACTIVE');
-- 
-- 
-- DELETE FROM QUERY_MASTER WHERE CODE='translation_label_check';
-- 
-- INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
-- VALUES ( 
-- '305ca773-b081-462f-ba6a-6928a4056406', 75398,  current_date , 75398,  current_date , 'translation_label_check', 
-- 'key', 
-- 'select * from internationalization_label_master where key = #key#', 
-- null, 
-- true, 'ACTIVE');
-- 
-- 
-- DELETE FROM QUERY_MASTER WHERE CODE='translation_label_add';
-- 
-- INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
-- VALUES ( 
-- 'ef3a751e-377b-4113-8016-5d97f4100baa', 75398,  current_date , 75398,  current_date , 'translation_label_add', 
-- 'isMobileLabel,text,loggedInUserId', 
-- 'INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
-- VALUES (''IN'', REPLACE(#text#,'' '',''''), ''EN'', #loggedInUserId# , now(), #isMobileLabel# , #text# ,false );
-- 
-- INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
-- VALUES (''IN'', REPLACE(#text#,'' '',''''), ''GU'', #loggedInUserId# , now(), #isMobileLabel#, #text#,true );', 
-- null, 
-- false, 'ACTIVE');
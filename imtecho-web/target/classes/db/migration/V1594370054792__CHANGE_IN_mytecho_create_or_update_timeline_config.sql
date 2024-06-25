DELETE FROM QUERY_MASTER WHERE CODE='mytecho_create_or_update_timeline_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'95cad377-a11d-41a9-9cf3-3d819d3f4565', 75398,  current_date , 75398,  current_date , 'mytecho_create_or_update_timeline_config', 
'component_type,expier_after_number_of_days,is_active,category_id,timeline_theme,name,id,schedule_after_number_of_days,base_date_type', 
'INSERT INTO mytecho_timeline_config_det(
            id, name, component_type, is_any_condition, base_date_type, schedule_after_number_of_days, 
            expier_after_number_of_days, timeline_theme, is_important, is_active, category_id)
VALUES (case when #id# is null then nextval(''mytecho_timeline_config_det_id_seq'') else #id# end,#name#
,#component_type#, false, #base_date_type#, #schedule_after_number_of_days#
,cast (case when #expier_after_number_of_days# = null then null else #expier_after_number_of_days# end as smallint)
, #timeline_theme#, true, true, cast (case when  #category_id#= null then null else  #category_id# end as smallint))
on conflict (id)
DO UPDATE
set name = #name#,component_type=#component_type#,is_any_condition=false,base_date_type = #base_date_type#
,schedule_after_number_of_days = #schedule_after_number_of_days# 
,expier_after_number_of_days =  cast (case when #expier_after_number_of_days# = null then null else #expier_after_number_of_days# end as smallint)
,timeline_theme = #timeline_theme#
,is_important = true
,is_active = #is_active#
,category_id = cast (case when  #category_id#= null then null else  #category_id# end as smallint)
returning id;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='mytecho_delete_timeline_audiance_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4756bd2f-f2d8-4cd5-becc-b75dfaaaba81', 75398,  current_date , 75398,  current_date , 'mytecho_delete_timeline_audiance_det', 
'mt_timeline_config_id', 
'DELETE FROM mytecho_timeline_audience_det
                WHERE mt_timeline_config_id = #mt_timeline_config_id#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_delete_timeline_context_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'29c44d7d-9e9c-4a60-8955-bc8ae4f7c11c', 75398,  current_date , 75398,  current_date , 'mytecho_delete_timeline_context_det', 
'mt_timeline_config_id', 
'DELETE FROM mytecho_timeline_context_det
                WHERE mt_timeline_config_id = #mt_timeline_config_id#', 
'Delete Context of given Timeline', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_delete_timeline_event_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e409b0af-8a0e-49d1-87f3-db98b6facd13', 75398,  current_date , 75398,  current_date , 'mytecho_delete_timeline_event_det', 
'mt_timeline_config_id', 
'DELETE FROM mytecho_timeline_event_det
                WHERE mt_timeline_config_id = #mt_timeline_config_id#', 
'Delete events of timeline', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_create_timeline_audiance_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ad8b24dd-69a9-492e-818a-370b2063cbbe', 75398,  current_date , 75398,  current_date , 'mytecho_create_timeline_audiance_det', 
'audience_type,mt_timeline_config_id', 
'INSERT INTO mytecho_timeline_audience_det(
           mt_timeline_config_id, audience_type)
VALUES (#mt_timeline_config_id#, 
#audience_type#)
returning mt_timeline_config_id;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_create_timeline_context_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'620f8bc7-e1f1-496f-a0dd-6680ef8b1e94', 75398,  current_date , 75398,  current_date , 'mytecho_create_timeline_context_det', 
'context_type,mt_timeline_config_id', 
'INSERT INTO mytecho_timeline_context_det(
           mt_timeline_config_id, context_type)
VALUES (#mt_timeline_config_id#, 
#context_type#)
returning mt_timeline_config_id;', 
'Create Timeline Context', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_create_timeline_event_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c20bdb2a-bfa2-447b-a27c-2d497b947a0b', 75398,  current_date , 75398,  current_date , 'mytecho_create_timeline_event_det', 
'event_type,mt_timeline_config_id', 
'INSERT INTO mytecho_timeline_event_det(
           mt_timeline_config_id, event_type)
VALUES (#mt_timeline_config_id#, 
#event_type#)
returning mt_timeline_config_id;', 
'Create timeline event', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='mytecho_create_or_update_timeline_languagewise_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'7f5b881a-5611-4b20-82ae-38167b6c14fb', 75398,  current_date , 75398,  current_date , 'mytecho_create_or_update_timeline_languagewise_config', 
'original_media_name,description,language,short_descr,button_text,media_name,mt_timeline_config_id,tittle,url', 
'INSERT INTO mytecho_timeline_language_wise_config_det(
           mt_timeline_config_id, language, tittle, button_text, description, media_name, original_media_name, url, short_descr)
VALUES ( #mt_timeline_config_id# , #language#,
#tittle#, 
case when #button_text# = null then NULL else #button_text# end, 
#description#
,cast (case when #media_name# = null then null else #media_name# end as bigint),
case when #original_media_name# = null then NULL else #original_media_name# end,
case when #url# = null then NULL else #url# end,
#short_descr#)
ON CONFLICT ON CONSTRAINT mytecho_timeline_language_wise_config_det_pkey
DO UPDATE
set
tittle=#tittle#,
button_text = case when #button_text# = null then NULL else #button_text# end,
description = #description#,
media_name = cast (case when #media_name# = null then null else #media_name# end as bigint),
original_media_name = case when #original_media_name# = null then NULL else #original_media_name# end,
url= case when #url# = null then NULL else #url# end,
short_descr=#short_descr#
returning mt_timeline_config_id;', 
null, 
true, 'ACTIVE');
ALTER TABLE public.mytecho_timeline_language_wise_config_det
ALTER COLUMN media_name TYPE bigint USING (media_name::bigint);

DELETE FROM query_master where code='mytecho_create_or_update_timeline_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_config', 'component_type,expier_after_number_of_days,is_active,category_id,timeline_theme,name,id,schedule_after_number_of_days,base_date_type', 'INSERT INTO public.mytecho_timeline_config_det(
            id, name, component_type, is_any_condition, base_date_type, schedule_after_number_of_days, 
            expier_after_number_of_days, timeline_theme, is_important, is_active, category_id)
VALUES (case when ''#id#'' = ''null'' then nextval(''mytecho_timeline_config_det_id_seq'') else #id# end,''#name#''
,''#component_type#'', false, ''#base_date_type#'', ''#schedule_after_number_of_days#''
,cast (case when ''#expier_after_number_of_days#'' = ''null'' then null else ''#expier_after_number_of_days#'' end as smallint)
, ''#timeline_theme#'', true, true, ''#category_id#'')
on conflict (id)
DO UPDATE
set name = ''#name#'',component_type=''#component_type#'',is_any_condition=false,base_date_type = ''#base_date_type#''
,schedule_after_number_of_days = ''#schedule_after_number_of_days#'' 
,expier_after_number_of_days =  cast (case when ''#expier_after_number_of_days#'' = ''null'' then null else ''#expier_after_number_of_days#'' end as smallint)
,timeline_theme = ''#timeline_theme#''
,is_important = true
,is_active = ''#is_active#''
,category_id = ''#category_id#''
returning id;', true, 'ACTIVE', NULL);


DELETE FROM query_master where code='mytecho_create_or_update_timeline_languagewise_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_languagewise_config', 'original_media_name,description,language,short_descr,button_text,media_name,mt_timeline_config_id,tittle,url', 'INSERT INTO public.mytecho_timeline_language_wise_config_det(
           mt_timeline_config_id, language, tittle, button_text, description, media_name, original_media_name, url, short_descr)
VALUES ( ''#mt_timeline_config_id#'' , ''#language#'',
''#tittle#'', 
case when ''#button_text#'' = ''null'' then NULL else ''#button_text#'' end, 
''#description#''
,cast (case when ''#media_name#'' = ''null'' then null else ''#media_name#'' end as bigint),
case when ''#original_media_name#'' = ''null'' then NULL else ''#original_media_name#'' end,
case when ''#url#'' = ''null'' then NULL else ''#url#'' end,
''#short_descr#'')
ON CONFLICT ON CONSTRAINT mytecho_timeline_language_wise_config_det_pkey
DO UPDATE
set
tittle=''#tittle#'',
button_text = case when ''#button_text#'' = ''null'' then NULL else ''#button_text#'' end,
description = ''#description#'',
media_name = cast (case when ''#media_name#'' = ''null'' then null else ''#media_name#'' end as bigint),
original_media_name = case when ''#original_media_name#'' = ''null'' then NULL else ''#original_media_name#'' end,
url= case when ''#url#'' = ''null'' then NULL else ''#url#'' end,
short_descr=''#short_descr#''
returning mt_timeline_config_id;', true, 'ACTIVE', NULL);

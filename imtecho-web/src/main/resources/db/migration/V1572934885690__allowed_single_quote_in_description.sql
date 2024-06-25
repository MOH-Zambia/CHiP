DELETE FROM query_master where code='mytecho_create_or_update_timeline_languagewise_config';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_languagewise_config', 'original_media_name,description,language,short_descr,button_text,media_name,mt_timeline_config_id,tittle,url', 'INSERT INTO public.mytecho_timeline_language_wise_config_det(
           mt_timeline_config_id, language, tittle, button_text, description, media_name, original_media_name, url, short_descr)
VALUES ( ''#mt_timeline_config_id#'' , ''#language#'',
''#tittle#'', 
case when ''#button_text#'' = ''null'' then NULL else ''#button_text#'' end, 
$$#description#$$
,cast (case when ''#media_name#'' = ''null'' then null else ''#media_name#'' end as bigint),
case when ''#original_media_name#'' = ''null'' then NULL else ''#original_media_name#'' end,
case when ''#url#'' = ''null'' then NULL else ''#url#'' end,
''#short_descr#'')
ON CONFLICT ON CONSTRAINT mytecho_timeline_language_wise_config_det_pkey
DO UPDATE
set
tittle=''#tittle#'',
button_text = case when ''#button_text#'' = ''null'' then NULL else ''#button_text#'' end,
description = $$#description#$$,
media_name = cast (case when ''#media_name#'' = ''null'' then null else ''#media_name#'' end as bigint),
original_media_name = case when ''#original_media_name#'' = ''null'' then NULL else ''#original_media_name#'' end,
url= case when ''#url#'' = ''null'' then NULL else ''#url#'' end,
short_descr=''#short_descr#''
returning mt_timeline_config_id;', true, 'ACTIVE', NULL);

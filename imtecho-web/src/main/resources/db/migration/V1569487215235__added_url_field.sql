-- Added column URL
DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE mytecho_timeline_language_wise_config_det ADD COLUMN url varchar(300);
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column url already exists in mytecho_timeline_language_wise_config_det.';
        END;
    END;
$$;

-- Create or update language wise timeline
DELETE FROM query_master where code='mytecho_create_or_update_timeline_languagewise_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_languagewise_config', 'original_media_name,description,language,button_text,media_name,mt_timeline_config_id,tittle,url', 'INSERT INTO public.mytecho_timeline_language_wise_config_det(
           mt_timeline_config_id, language, tittle, button_text, description, media_name, original_media_name, url)
VALUES ( ''#mt_timeline_config_id#'' , ''#language#'',
''#tittle#'', 
''#button_text#'', 
''#description#''
,''#media_name#'',
''#original_media_name#'',
''#url#'')
ON CONFLICT ON CONSTRAINT mytecho_timeline_language_wise_config_det_pkey
DO UPDATE
set
tittle=''#tittle#'',
button_text = ''#button_text#'',
description = ''#description#'',
media_name = ''#media_name#'',
original_media_name = ''#original_media_name#'',
url=''#url#''
returning mt_timeline_config_id;', true, 'ACTIVE', NULL);


--Create or update timeline config
DELETE FROM query_master where code='mytecho_create_or_update_timeline_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_config', 'component_type,expier_after_number_of_days,is_active,category_id,timeline_theme,name,id,schedule_after_number_of_days,base_date_type', 'INSERT INTO public.mytecho_timeline_config_det(
            id, name, component_type, is_any_condition, base_date_type, schedule_after_number_of_days, 
            expier_after_number_of_days, timeline_theme, is_important, is_active, category_id)
VALUES (case when ''#id#'' = ''null'' then nextval(''mytecho_timeline_config_det_id_seq'') else #id# end,''#name#''
,''#component_type#'', false, ''#base_date_type#'', ''#schedule_after_number_of_days#''
,#expier_after_number_of_days#, ''#timeline_theme#'', true, true, ''#category_id#'')
on conflict (id)
DO UPDATE
set name = ''#name#'',component_type=''#component_type#'',is_any_condition=false,base_date_type = ''#base_date_type#''
,schedule_after_number_of_days = ''#schedule_after_number_of_days#'' 
,expier_after_number_of_days = ''#expier_after_number_of_days#'' 
,timeline_theme = ''#timeline_theme#''
,is_important = true
,is_active = ''#is_active#''
,category_id = ''#category_id#''
returning id;', true, 'ACTIVE', NULL);


DELETE FROM query_master where code='mytecho_retrive_timeline_config_by_id';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_retrive_timeline_config_by_id', 'id', 'with timeline_language as(
	select cast(json_agg(json_build_object(''language'',t.language, ''buttonText'',t.button_text,
''description'',t.description,''mediaName'',t.media_name,''originalMediaName'', COALESCE(t.original_media_name, ''''), ''tittle'', t.tittle, ''url'', COALESCE(t.url, '''') 
)) as text) as "languageWiseTimeline"
, mt_timeline_config_id  as id from mytecho_timeline_language_wise_config_det t
	where mt_timeline_config_id = #id# group by mt_timeline_config_id
),
audience_details as (
select cast(json_agg(t.* ) as text) as "audienceType", mt_timeline_config_id as id from mytecho_timeline_audience_det t
	where mt_timeline_config_id = #id# group by mt_timeline_config_id
),
context_details as (
select cast(json_agg(t.* ) as text) as "contextType", mt_timeline_config_id as id from mytecho_timeline_context_det t
	where mt_timeline_config_id = #id# group by mt_timeline_config_id
),
event_details as (
select cast(json_agg(t.* ) as text) as "eventType", mt_timeline_config_id as id from mytecho_timeline_event_det t
	where mt_timeline_config_id = #id# group by mt_timeline_config_id
)
select timeline.id as "id", timeline.name as "timelineName", component_type as "componentType", timeline.base_date_type as "baseDateType", 
timeline.expier_after_number_of_days as "expireAfterNoOfDays",
timeline.schedule_after_number_of_days as "scheduleAfterNoOfDays",
timeline.is_active as "isActive",
timeline.category_id as "categoryId",
audience."audienceType" as "audienceType",
timeline_lan."languageWiseTimeline" as "languageWiseTimeline",
context."contextType" as "context",
event."eventType" as "timelineEventType"
from mytecho_timeline_config_det timeline
left join timeline_language timeline_lan on timeline.id = timeline_lan.id
left join audience_details audience on timeline.id  = audience.id
left join context_details context on timeline.id  = context.id
left join event_details event on timeline.id  = event.id
where timeline.id = #id#', true, 'ACTIVE', NULL);

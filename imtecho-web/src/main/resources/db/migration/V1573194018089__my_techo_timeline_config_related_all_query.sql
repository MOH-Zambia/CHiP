DELETE FROM query_master where code='mytecho_cards_conf_retrieval';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_cards_conf_retrieval', 'member_id,user_id', 'with user_det as(
select language_preference,is_gujarat_user 
from mytecho_user 
where id = #user_id#
),member_det as (
select case when tm.id is not null then tm.id else mtm.id end as member_id
,case when tm.id is not null 
	then (case when tm.is_pregnant = true then ''PREGNANT'' 
	when tm.dob >= current_date - interval ''2 year'' then ''CHILD''
	else null end) 
 else (case when mtm.is_pregnant = true then ''PREGNANT'' 
	when mtm.dob >= current_date - interval ''2 year'' then ''CHILD''
	else null end)
 end as audiance_type
,case when tm.id is not null then tm.lmp else mtm.lmp_date end as lmp_date
,case when tm.id is not null then tm.dob else mtm.dob end as dob
,case when tm.id is not null then tm.created_on else mtm.created_on end as registration_date
,user_det.language_preference
from user_det 
left join imt_member tm on tm.id = #member_id# and user_det.is_gujarat_user = true
left join mytecho_member mtm on mtm.id = #member_id# and user_det.is_gujarat_user = false
)
select * from 
(
select 
mt_config.id
,mt_language_config.language as language
,mt_language_config.tittle as title
,mt_language_config.description as "description"
,mt_config.component_type as "componentType"
,mt_language_config.button_text as "buttonText"
,case when (mt_language_config.url is null or mt_language_config.url = ''null'')
	then cast (mt_language_config.media_name as text)  else mt_language_config.url end as "mediaUrl"
,case when (mt_language_config.url is null or mt_language_config.url = ''null'')
	then ''SYSTEM'' else ''URL'' end as "mediaType"
,(case	when mt_config.base_date_type = ''LMP'' then mem.lmp_date
	when mt_config.base_date_type = ''DOB'' then mem.dob
	when mt_config.base_date_type = ''REG_DATE'' then mem.registration_date
end) +  schedule_after_number_of_days* interval ''1 day'' as "scheduleDate"
,(case	when mt_config.base_date_type = ''LMP'' then mem.lmp_date
	when mt_config.base_date_type = ''DOB'' then mem.dob
	when mt_config.base_date_type = ''REG_DATE'' then mem.registration_date
end) +  mt_config.expier_after_number_of_days * interval ''1 day'' as "expiryDate"
, CAST(''thumbnail.jpg'' as text) as thumbnail
from 
member_det mem
inner join mytecho_timeline_audience_det aud 
on mem.audiance_type = aud.audience_type 
inner join mytecho_timeline_config_det mt_config 
on mt_config.id = aud.mt_timeline_config_id  and mt_config.is_active = true
inner join mytecho_timeline_language_wise_config_det mt_language_config
on mt_config.id = mt_language_config.mt_timeline_config_id 
and mt_language_config.language = mem.language_preference
) as t where current_date between t."scheduleDate" and t."expiryDate";', true, 'ACTIVE', NULL);

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

DELETE FROM query_master where code='mytecho_create_timeline_audiance_det';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_timeline_audiance_det', 'audience_type,mt_timeline_config_id', 'INSERT INTO public.mytecho_timeline_audience_det(
           mt_timeline_config_id, audience_type)
VALUES (''#mt_timeline_config_id#'', 
''#audience_type#'')
returning mt_timeline_config_id;', true, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_create_timeline_context_det';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_timeline_context_det', 'context_type,mt_timeline_config_id', 'INSERT INTO public.mytecho_timeline_context_det(
           mt_timeline_config_id, context_type)
VALUES (''#mt_timeline_config_id#'', 
''#context_type#'')
returning mt_timeline_config_id;', true, 'ACTIVE', 'Create Timeline Context');

DELETE FROM query_master where code='mytecho_create_timeline_event_det';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_timeline_event_det', 'event_type,mt_timeline_config_id', 'INSERT INTO public.mytecho_timeline_event_det(
           mt_timeline_config_id, event_type)
VALUES (''#mt_timeline_config_id#'', 
''#event_type#'')
returning mt_timeline_config_id;', true, 'ACTIVE', 'Create timeline event');

DELETE FROM query_master where code='mytecho_delete_timeline_audiance_det';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_delete_timeline_audiance_det', 'mt_timeline_config_id', 'DELETE FROM public.mytecho_timeline_audience_det
                WHERE mt_timeline_config_id = ''#mt_timeline_config_id#''', false, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_delete_timeline_context_det';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_delete_timeline_context_det', 'mt_timeline_config_id', 'DELETE FROM public.mytecho_timeline_context_det
                WHERE mt_timeline_config_id = ''#mt_timeline_config_id#''', false, 'ACTIVE', 'Delete Context of given Timeline');

DELETE FROM query_master where code='mytecho_delete_timeline_event_det';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_delete_timeline_event_det', 'mt_timeline_config_id', 'DELETE FROM public.mytecho_timeline_event_det
                WHERE mt_timeline_config_id = ''#mt_timeline_config_id#''', false, 'ACTIVE', 'Delete events of timeline');

DELETE FROM query_master where code='mytecho_get_my_timeline';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_get_my_timeline', 'member_id,user_id', 'with user_det as(
select language_preference,is_gujarat_user 
from mytecho_user 
where id = #user_id#
),member_det as (
select case when tm.id is not null then tm.id else mtm.id end as member_id
,case when tm.id is not null 
	then (case when tm.is_pregnant = true then ''PREGNANT'' 
	when tm.dob >= current_date - interval ''2 year'' then ''CHILD''
	else null end) 
 else (case when mtm.is_pregnant = true then ''PREGNANT'' 
	when mtm.dob >= current_date - interval ''2 year'' then ''CHILD''
	else null end)
 end as audiance_type
,case when tm.id is not null then tm.lmp else mtm.lmp_date end as base_date
,case when tm.id is not null then tm.dob else mtm.dob end as dob
,case when tm.id is not null then tm.created_on else mtm.created_on end as registration_date
,user_det.language_preference
from user_det 
left join imt_member tm on tm.id = #member_id# and user_det.is_gujarat_user = true
left join mytecho_member mtm on mtm.id = #member_id# and user_det.is_gujarat_user = false
)
,user_time_line_detail as (
select 
utr.*,utr.service_date - mem.base_date as number_of_days
from 
member_det mem,mytecho_user_timeline_response_det utr
where utr.member_id = mem.member_id
and utr.status != ''ARCHIVED''
),timeline_detail as (
select tmd."name" as milestone_name
,tmd.start_day
,user_det.*
from 
member_det mem
inner join mytecho_timeline_milestone_det tmd 
	on tmd.audiance_type = mem.audiance_type
inner join
(select 
utr.id
,mem.audiance_type
,mt_config.id as mt_timeline_config_id
,case when utr.event_code is null then mt_event.event_type else utr.event_code end as event_code
,case when utr.service_date is not null then utr.service_date else mem.base_date + interval ''1 day''*mt_config.schedule_after_number_of_days end as service_date
,utr.response_json
,case when mt_config.schedule_after_number_of_days is not null then mt_config.schedule_after_number_of_days else  utr.number_of_days end as number_of_days
from 
member_det mem
inner join mytecho_timeline_audience_det aud 
	on mem.audiance_type = aud.audience_type 
inner join mytecho_timeline_config_det mt_config
on mt_config.id = aud.mt_timeline_config_id and mt_config.is_active = true
inner join mytecho_timeline_context_det mt_context
	on  mt_context.context_type = ''TIMELINE''
	and mt_config.id = mt_context.mt_timeline_config_id
inner join mytecho_timeline_event_det mt_event on mt_event.mt_timeline_config_id = mt_config.id
FULL OUTER JOIN user_time_line_detail utr 
	on utr.mt_timeline_config_id = mt_config.id) as user_det
	on user_det.number_of_days between tmd.start_day and tmd.end_day
order by start_day,number_of_days
)
select timeline_detail.milestone_name as "milestoneName",
cast(jsonb_agg(json_build_object(''id'', id, ''timelineConfigId'', mt_timeline_config_id,''eventCode'',event_code,''serviceDate'',service_date,''responseJson'',response_json)) as text) as "timeLineDetails"
from timeline_detail
group by timeline_detail.start_day,timeline_detail.milestone_name
order by timeline_detail.start_day,timeline_detail.milestone_name', true, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_get_timeline_config';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_get_timeline_config', NULL, 'with context_details as (
select cast(json_agg(t.* ) as text) as "contextType", mt_timeline_config_id as id from mytecho_timeline_context_det t
	group by mt_timeline_config_id
),
timeline_language as(
	select cast(json_agg(json_build_object(''language'',t.language, ''buttonText'',t.button_text,
''description'',t.description,''mediaName'',t.media_name,''originalMediaName'', COALESCE(t.original_media_name, ''''), ''tittle'', t.tittle 
)) as text) as "languageWiseTimeline"
, mt_timeline_config_id  as id from mytecho_timeline_language_wise_config_det t
	group by mt_timeline_config_id
),
event_details as (
select cast(json_agg(json_build_object(''eventType'',m.event)) as text) as "eventType", mt_timeline_config_id as id
from mytecho_timeline_event_det t
left join mytecho_timeline_event_master m on m.code=t.event_type
	group by mt_timeline_config_id
)
select  timeline.id as "id", timeline.name as "name", timeline.base_date_type as "baseDate",
timeline.schedule_after_number_of_days  as "scheduleAfterNumberOfDays",
timeline.expier_after_number_of_days  as "expireAfterNumberOfDays",
timeline.component_type as "componentType",
timeline.is_active as "isActive", 
timeline_lang."languageWiseTimeline" as "languageWiseTimeline",
context."contextType" as "context",
event."eventType" as "timelineEventType"
from mytecho_timeline_config_det timeline
left join context_details context on timeline.id  = context.id
left join timeline_language timeline_lang on timeline.id  = timeline_lang.id
left join event_details event on timeline.id  = event.id', true, 'ACTIVE', 'mytecho_get_timeline_config');

DELETE FROM query_master where code='mytecho_get_timeline_master_event';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_get_timeline_master_event', NULL, 'select  event as "event", description as "description", code as "code",input_type  as "inputType"  
from mytecho_timeline_event_master', true, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_retrive_timeline_config_by_id';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_retrive_timeline_config_by_id', 'id', 'with timeline_language as(
	select cast(json_agg(json_build_object(''language'',t.language, ''buttonText'',t.button_text,
''description'',t.description,''mediaName'',t.media_name,''originalMediaName'', COALESCE(t.original_media_name, ''''), ''tittle'', t.tittle, ''url'', COALESCE(t.url, ''''), ''shortDescription'', COALESCE(t.short_descr, '''') 
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

DELETE FROM query_master where code='mytecho_timeline_update_isactive';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_timeline_update_isactive', 'id,isActive', 'UPDATE public.mytecho_timeline_config_det 
   SET is_active=#isActive#
 WHERE id=#id#;', false, 'ACTIVE', NULL);

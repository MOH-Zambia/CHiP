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
)
select  timeline.id as "id", timeline.name as "name", timeline.base_date_type as "baseDate",
timeline.schedule_after_number_of_days  as "scheduleAfterNumberOfDays",
timeline.expier_after_number_of_days  as "expireAfterNumberOfDays",
timeline.component_type as "componentType",
timeline.is_active as "isActive", 
timeline_lang."languageWiseTimeline" as "languageWiseTimeline",
context."contextType" as "context"
from mytecho_timeline_config_det timeline
left join context_details context on timeline.id  = context.id
left join timeline_language timeline_lang on timeline.id  = timeline_lang.id', true, 'ACTIVE', 'mytecho_get_timeline_config');

DROP table if exists public.mytecho_timeline_milestone_det;

CREATE TABLE public.mytecho_timeline_milestone_det (
	id smallserial NOT NULL,
	name varchar(200) NOT NULL,
	audiance_type varchar(200) NOT NULL,
	start_day int2 NULL,
	end_day int2 NULL,
	CONSTRAINT mytecho_timeline_milestone_det_pkey PRIMARY KEY (id)
);

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

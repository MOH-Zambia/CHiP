DROP table if exists public.mytecho_timeline_config_det;

CREATE TABLE public.mytecho_timeline_config_det (
	id smallserial NOT NULL,
	name varchar(200) NOT NULL,
	component_type varchar(200) NOT NULL,
	is_any_condition bool NULL,
	base_date_type varchar(200) NULL,
	schedule_after_number_of_days int2 NULL,
	expier_after_number_of_days int2 NULL,
	timeline_theme varchar(200) NULL,
	is_important bool NULL,
        is_active boolean NOT NULL, 
	CONSTRAINT mytecho_timeline_config_det_pkey PRIMARY KEY (id)
);


DROP table if exists public.mytecho_timeline_language_wise_config_det;

CREATE TABLE public.mytecho_timeline_language_wise_config_det (
	mt_timeline_config_id int2 NOT NULL,
	language varchar(4) NOT NULL,
	tittle varchar(320) NOT NULL,
	button_text varchar(40) NULL,
	description varchar(4096) NULL,
	media_name text NULL,
	original_media_name text NULL,
	CONSTRAINT mytecho_timeline_language_wise_config_det_pkey PRIMARY KEY (mt_timeline_config_id, language)
);


DROP table if exists public.mytecho_timeline_audience_det;

CREATE TABLE public.mytecho_timeline_audience_det (
	mt_timeline_config_id int2 NOT NULL,
	audience_type varchar(50) NOT NULL,
	CONSTRAINT mytecho_timeline_audience_det_pkey PRIMARY KEY (mt_timeline_config_id, audience_type)
);


DROP table if exists public.mytecho_timeline_context_det;

CREATE TABLE public.mytecho_timeline_context_det (
	mt_timeline_config_id int2 NOT NULL,
	context_type varchar(50) NOT NULL,
	CONSTRAINT mytecho_timeline_context_det_pkey PRIMARY KEY (mt_timeline_config_id, context_type)
);


DROP table if exists public.mytecho_timeline_event_det;

CREATE TABLE public.mytecho_timeline_event_det (
	mt_timeline_config_id int2 NOT NULL,
	event_type varchar(50) NOT NULL,
	CONSTRAINT mytecho_timeline_event_det_pkey PRIMARY KEY (mt_timeline_config_id, event_type)
);


DROP table if exists public.mytecho_timeline_event_master;

CREATE TABLE public.mytecho_timeline_event_master (
	event varchar(320) NOT NULL,
	description varchar(320) NULL,
	code varchar(320) NOT NULL,
	input_type varchar(320) NULL,
	CONSTRAINT mytecho_timeline_event_master_pkey PRIMARY KEY (code)
);


--Insert event in event master
DELETE FROM public.mytecho_timeline_event_master where code='TT1';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('TT1', 'TT Injection 1st Dose', 'TT1', 'Date');

DELETE FROM public.mytecho_timeline_event_master where code='ANC';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('ANC', 'ANC Visit', 'ANC', 'Date');

DELETE FROM public.mytecho_timeline_event_master where code='MAMTA_DAY';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('Mamta Day Visit', 'Mamta Day Visit Done By The Beneficiary', 'MAMTA_DAY', 'Date');

DELETE FROM public.mytecho_timeline_event_master where code='SELFIE';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('SELFIE', 'Selfie Added By Beneficiary', 'SELFIE', 'Image');

DELETE FROM public.mytecho_timeline_event_master where code='CUSTOM';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('CUSTOM', 'Any event added by user from Mobile for eg. baby shower, kick by baby, foetal heart sound heard, personal doctor visit etc.', 'CUSTOM', 'Event Name & Event Date');

DELETE FROM public.mytecho_timeline_event_master where code='IFA_150';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('IFA Tablets Milestone', 'On reaching 100 or 150 tablets', 'IFA_150', 'Numeric');

DELETE FROM public.mytecho_timeline_event_master where code='SYMP_CHECK_FORM';
INSERT INTO public.mytecho_timeline_event_master
("event", description, code, input_type)
VALUES('Symptom Checker Form', 'On filling symptom checker form', 'SYMP_CHECK_FORM', 'NONE');


--Get all timeline config.
DELETE FROM query_master where code='mytecho_get_timeline_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_get_timeline_config', NULL, 'with context_details as (
select cast(json_agg(t.* ) as text) as "contextType", mt_timeline_config_id as id from mytecho_timeline_context_det t
	group by mt_timeline_config_id
)
select  timeline.id as "id", timeline.name as "name", timeline.base_date_type as "baseDate",
timeline.schedule_after_number_of_days  as "scheduleAfterNumberOfDays", timeline.is_active as "isActive", 
context."contextType" as "context"
from mytecho_timeline_config_det timeline
left join context_details context on timeline.id  = context.id', true, 'ACTIVE', 'mytecho_get_timeline_config');

--Get timeline config by id
DELETE FROM query_master where code='mytecho_retrive_timeline_config_by_id';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_retrive_timeline_config_by_id', 'id', 'with timeline_language as(
	select cast(json_agg(json_build_object(''language'',t.language, ''buttonText'',t.button_text,
''description'',t.description,''mediaName'',t.media_name,''originalMediaName'', COALESCE(t.original_media_name, ''''), ''tittle'', t.tittle 
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
audience."audienceType" as "audienceType",
timeline_lan."languageWiseTimeline" as "languageWiseTimeline",
context."contextType" as "context",
event."eventType" as "timelineEventType"
from mytecho_timeline_config_det timeline
left join timeline_language timeline_lan on timeline.id = timeline_lan.id
left join audience_details audience on timeline_lan.id  = audience.id
left join context_details context on timeline_lan.id  = context.id
left join event_details event on timeline_lan.id  = event.id
where timeline.id = #id#', true, 'ACTIVE', NULL);


--Create or update timeline config
DELETE FROM query_master where code='mytecho_create_or_update_timeline_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_config', 'component_type,expier_after_number_of_days,timeline_theme,name,id,schedule_after_number_of_days,base_date_type,is_active', 'INSERT INTO public.mytecho_timeline_config_det(
            id, name, component_type, is_any_condition, base_date_type, schedule_after_number_of_days, 
            expier_after_number_of_days, timeline_theme, is_important, is_active)
VALUES (case when ''#id#'' = ''null'' then nextval(''mytecho_timeline_config_det_id_seq'') else #id# end,''#name#''
,''#component_type#'', false, ''#base_date_type#'', ''#schedule_after_number_of_days#''
,#expier_after_number_of_days#, ''#timeline_theme#'', true, true)
on conflict (id)
DO UPDATE
set name = ''#name#'',component_type=''#component_type#'',is_any_condition=false,base_date_type = ''#base_date_type#''
,schedule_after_number_of_days = ''#schedule_after_number_of_days#'' 
,timeline_theme = ''#timeline_theme#''
,is_important = true
,is_active = ''#is_active#''
returning id;', true, 'ACTIVE', NULL);


-- Create or update language wise timeline
DELETE FROM query_master where code='mytecho_create_or_update_timeline_languagewise_config';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_languagewise_config', 'original_media_name,description,language,button_text,media_name,mt_timeline_config_id,tittle', 'INSERT INTO public.mytecho_timeline_language_wise_config_det(
           mt_timeline_config_id, language, tittle, button_text, description, media_name, original_media_name)
VALUES ( ''#mt_timeline_config_id#'' , ''#language#'',
''#tittle#'', 
''#button_text#'', 
''#description#''
,''#media_name#'',
''#original_media_name#'')
ON CONFLICT ON CONSTRAINT mytecho_timeline_language_wise_config_det_pkey
DO UPDATE
set
tittle=''#tittle#'',
button_text = ''#button_text#'',
description = ''#description#'',
media_name = ''#media_name#'',
original_media_name = ''#original_media_name#''
returning mt_timeline_config_id;', true, 'ACTIVE', NULL);


-- Create audience details
DELETE FROM query_master where code='mytecho_create_timeline_audiance_det';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_timeline_audiance_det', 'audience_type,mt_timeline_config_id', 'INSERT INTO public.mytecho_timeline_audience_det(
           mt_timeline_config_id, audience_type)
VALUES (''#mt_timeline_config_id#'', 
''#audience_type#'')
returning mt_timeline_config_id;', true, 'ACTIVE', NULL);


-- Delete audience details
DELETE FROM query_master where code='mytecho_delete_timeline_audiance_det';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_delete_timeline_audiance_det', 'mt_timeline_config_id', 'DELETE FROM public.mytecho_timeline_audience_det
                WHERE mt_timeline_config_id = ''#mt_timeline_config_id#''', false, 'ACTIVE', NULL);


-- Create timeline event 
DELETE FROM query_master where code='mytecho_create_timeline_event_det';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_timeline_event_det', 'event_type,mt_timeline_config_id', 'INSERT INTO public.mytecho_timeline_event_det(
           mt_timeline_config_id, event_type)
VALUES (''#mt_timeline_config_id#'', 
''#event_type#'')
returning mt_timeline_config_id;', true, 'ACTIVE', 'Create timeline event');


-- Delete timeline event
DELETE FROM query_master where code='mytecho_delete_timeline_event_det';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_delete_timeline_event_det', 'mt_timeline_config_id', 'DELETE FROM public.mytecho_timeline_event_det
                WHERE mt_timeline_config_id = ''#mt_timeline_config_id#''', false, 'ACTIVE', 'Delete events of timeline');


-- Create timeline context
DELETE FROM query_master where code='mytecho_create_timeline_context_det';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_timeline_context_det', 'context_type,mt_timeline_config_id', 'INSERT INTO public.mytecho_timeline_context_det(
           mt_timeline_config_id, context_type)
VALUES (''#mt_timeline_config_id#'', 
''#context_type#'')
returning mt_timeline_config_id;', true, 'ACTIVE', 'Create Timeline Context');


-- Delete timeline context
DELETE FROM query_master where code='mytecho_delete_timeline_context_det';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_delete_timeline_context_det', 'mt_timeline_config_id', 'DELETE FROM public.mytecho_timeline_context_det
                WHERE mt_timeline_config_id = ''#mt_timeline_config_id#''', false, 'ACTIVE', 'Delete Context of given Timeline');


-- Get events from event master
DELETE FROM query_master where code='mytecho_get_timeline_master_event';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_get_timeline_master_event', NULL, 'select  event as "event", description as "description", code as "code",input_type  as "inputType"  
from mytecho_timeline_event_master', true, 'ACTIVE', NULL);

UPDATE menu_config
SET feature_json ='{"canAddNewTimeline":false, "canManageEnglishTimeline":false, "canManageHindiTimeline":false,
                "canManageGujaratiTimeline":false}'
WHERE menu_name = 'Timeline Configuration';

-- Create Card Menu.
delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Card Configuration');

delete from menu_config where id in (select id from menu_config where menu_name = 'Card Configuration');

INSERT INTO  menu_config(
                active, menu_name, navigation_state, menu_type, feature_json) 
        VALUES('TRUE','Card Configuration', 'techo.manage.cardconfigs', 'admin',
                '{"canAddMasterCard":false, "canModifyEnglishCard":false, "canModifyHindiCard":false,
                "canModifyGujaratiCard":false}');      
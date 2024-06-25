DELETE FROM query_master where code='mytecho_cards_conf_retrieval';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_cards_conf_retrieval', 'loggedInUserId', 'with user_det as(
select language_preference,mytecho_member_id as member_id
from mytecho_user 
where id = #loggedInUserId#
),member_det as (
select mtm.id as member_id
,case when mtm.is_pregnant = true then ''PREGNANT''
when cast(mtm.last_delivery_date as date) >= current_date - interval ''60 day'' then ''MOTHER''
when mtm.dob >= current_date - interval ''5 year'' then ''CHILD''
when mtm.gender = ''F'' and mtm.dob >= current_date - interval ''18 year'' then ''ELIGIBLE_COUPLE''
else null end as audiance_type
,case when mtm.is_pregnant = true then mtm.lmp_date 
when mtm.dob >= current_date - interval ''5 year'' then mtm.dob
when mtm.gender = ''F'' and mtm.dob >= current_date - interval ''18 year'' then cast(mtm.created_on as date)
else null end as base_date
,user_det.language_preference
from user_det 
left join mytecho_member mtm on mtm.id = user_det.member_id
),user_tip_of_day as (
select 
mt_config.category_id
,mt_config.id
,0 as catagory_order
,mt_language_config.language as language
,mt_language_config.tittle as title
,mt_language_config.description as "description"
,mt_config.component_type as "componentType"
,mt_language_config.button_text as "buttonText"
,case when (mt_language_config.url is null or mt_language_config.url = ''null'')
	then cast (mt_language_config.media_name as text)  else mt_language_config.url end as "mediaUrl"
,case when (mt_language_config.url is null or mt_language_config.url = ''null'')
	then ''SYSTEM'' else ''URL'' end as "mediaType"
,cast (null as timestamp without time zone) as "scheduleDate"
,cast (null as timestamp without time zone) as "expiryDate"
, CAST(''thumbnail.jpg'' as text) as thumbnail 
from 
member_det mem 
inner join mytecho_user_tip_of_the_day mt_tod on mt_tod.member_id = mem.member_id
inner join mytecho_timeline_config_det mt_config 
on mt_tod.tip_id = mt_config.id and mt_config.is_active = true
inner join mytecho_timeline_language_wise_config_det mt_language_config
	on mt_config.id = mt_language_config.mt_timeline_config_id 
	and mt_language_config.language = mem.language_preference
where  cast(schedule_date as date) = current_date
limit 1
)
select * from user_tip_of_day
union all
select * from (
select DISTINCT ON (category_id,catagory_order)*
from
(
select 
mt_config.category_id
,mt_config.id
,cast(lv.code as int) as catagory_order
,mt_language_config.language as language
,mt_language_config.tittle as title
,mt_language_config.description as "description"
,mt_config.component_type as "componentType"
,mt_language_config.button_text as "buttonText"
,case when (mt_language_config.url is null or mt_language_config.url = ''null'')
	then cast (mt_language_config.media_name as text)  else mt_language_config.url end as "mediaUrl"
,case when (mt_language_config.url is null or mt_language_config.url = ''null'')
	then ''SYSTEM'' else ''URL'' end as "mediaType"
,mem.base_date + schedule_after_number_of_days* interval ''1 day'' as "scheduleDate"
,case 
	when mt_config.expier_after_number_of_days is not null 
		then mem.base_date + mt_config.expier_after_number_of_days * interval ''1 day'' 
	when mem.base_date + schedule_after_number_of_days* interval ''1 day'' > current_date 
		then mem.base_date + schedule_after_number_of_days* interval ''1 day''
	else
		current_date
end as "expiryDate"
, CAST(''thumbnail.jpg'' as text) as thumbnail
from 
member_det mem
inner join mytecho_timeline_audience_det aud 
	on mem.audiance_type = aud.audience_type 
inner join mytecho_timeline_config_det mt_config 
	on mt_config.id = aud.mt_timeline_config_id  and mt_config.is_active = true
left join listvalue_field_value_detail lv 
	on lv.id = mt_config.category_id
inner join mytecho_timeline_language_wise_config_det mt_language_config
	on mt_config.id = mt_language_config.mt_timeline_config_id 
	and mt_language_config.language = mem.language_preference

) as t where current_date between t."scheduleDate" and t."expiryDate"
order by category_id,catagory_order,random()) as t order by catagory_order;', true, 'ACTIVE', NULL);

DELETE FROM query_master where code='mytecho_get_my_timeline';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_get_my_timeline', 'member_id,loggedInUserId', 'with user_det as(
select language_preference,is_gujarat_user 
from mytecho_user 
where id = #loggedInUserId#
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
left join mytecho_member mtm on mtm.id = #member_id#
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
,cast(base_date + interval ''1 day''*tmd.start_day as date)  as start_day
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
order by service_date
)
select timeline_detail.milestone_name as "milestoneName",
timeline_detail.start_day as "milestoneDate",
cast(jsonb_agg(json_build_object(''id'', id, ''timelineConfigId'', mt_timeline_config_id,''eventCode'',event_code,''serviceDate'',service_date,''responseJson'',response_json)) as text) as "timeLineDetails"
from timeline_detail
group by timeline_detail.start_day,timeline_detail.milestone_name
order by timeline_detail.start_day,timeline_detail.milestone_name', true, 'ACTIVE', NULL);

UPDATE menu_config
   SET group_id=(select id from menu_group where group_name = 'My Techo' limit 1)
 WHERE menu_name = 'Tip Of The Day';
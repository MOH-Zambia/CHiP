DROP TABLE if exists public.mytecho_user_starred_card_master;

CREATE TABLE public.mytecho_user_starred_card_master
(
  user_id integer NOT NULL,
  mt_timeline_config_id integer NOT NULL,
  language text NOT NULL,
  created_on timestamp without time zone,
  created_by bigint,
  CONSTRAINT mytecho_user_starred_card_master_pkey PRIMARY KEY (user_id, mt_timeline_config_id, language)
);

delete from query_master where code = 'mytecho_delete_starred_card';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mytecho_delete_starred_card', 'loggedInUserId,languageCode,cardConfigId',
 'delete from mytecho_user_starred_card_master where user_id=#loggedInUserId# 
and mt_timeline_config_id=#cardConfigId# and language=''#languageCode#'' '
, false, 'ACTIVE', 'mytecho_delete_starred_card');


delete from query_master where code = 'mytecho_mark_card_as_starred';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mytecho_mark_card_as_starred', 'loggedInUserId,configId,languageCode',
 'insert into mytecho_user_starred_card_master(user_id,mt_timeline_config_id,language,created_on,created_by) 
values(#loggedInUserId#,#configId#,''#languageCode#'',now(),#loggedInUserId#)'
, false, 'ACTIVE', 'mytecho_retrieve_user_starred_cards');




delete from query_master where code = 'mytecho_retrieve_user_starred_cards';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mytecho_retrieve_user_starred_cards', 'loggedInUserId',
 'select 
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
, CAST(''thumbnail.jpg'' as text) as thumbnail
from 
mytecho_user_starred_card_master mt_star_card
inner join mytecho_timeline_config_det mt_config 
	on mt_config.id = mt_star_card.mt_timeline_config_id
left join listvalue_field_value_detail lv 
	on lv.id = mt_config.category_id
inner join mytecho_timeline_language_wise_config_det mt_language_config
	on mt_config.id = mt_language_config.mt_timeline_config_id 
	and mt_language_config.language = mt_star_card.language
	where mt_star_card.user_id=#loggedInUserId#'
, true, 'ACTIVE', 'mytecho_retrieve_user_starred_cards');

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
, CAST(''thumbnail.jpg'' as text) as thumbnail,
case when mt_user_starred.user_id is not null
	then true
	else false
	end as "isCardStarred"
from 
member_det mem 
inner join mytecho_user_tip_of_the_day mt_tod on mt_tod.member_id = mem.member_id
inner join mytecho_timeline_config_det mt_config 
on mt_tod.tip_id = mt_config.id and mt_config.is_active = true
inner join mytecho_timeline_language_wise_config_det mt_language_config
	on mt_config.id = mt_language_config.mt_timeline_config_id 
	and mt_language_config.language = mem.language_preference
left join mytecho_user_starred_card_master mt_user_starred
	on mt_user_starred.mt_timeline_config_id = mt_language_config.mt_timeline_config_id 
	and mt_language_config.language = mt_language_config.language and mt_user_starred.user_id=#loggedInUserId#
	
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
, CAST(''thumbnail.jpg'' as text) as thumbnail,
case when mt_user_starred.user_id is not null
	then true
	else false
	end as "isCardStarred"
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
left join mytecho_user_starred_card_master mt_user_starred
	on mt_user_starred.mt_timeline_config_id = mt_language_config.mt_timeline_config_id 
	and mt_language_config.language = mt_language_config.language and mt_user_starred.user_id=#loggedInUserId#

) as t where current_date between t."scheduleDate" and t."expiryDate"
order by category_id,catagory_order,random()) as t order by catagory_order;', true, 'ACTIVE', NULL);

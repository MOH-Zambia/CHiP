--Feature Usage

DELETE FROM QUERY_MASTER WHERE CODE='user_analytics_top_usage_feature';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f1bfec2c-8c7f-4143-93e8-60d550fb863b', 75398,  current_date , 75398,  current_date , 'user_analytics_top_usage_feature', 
'role_name,date_filter', 
'with date_filter as (
	select
	current_date as cur_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''1 week''
		when #date_filter# = ''month'' then current_date - interval ''1 month''
		when #date_filter# = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''2 week''
		when #date_filter# = ''month'' then current_date - interval ''2 month''
		when #date_filter# = ''year'' then current_date - interval ''2 year''
		end
	as prev_to_prev_date
)
,prev_week_data as (
	select
	page_title_id as prev_page_title_id,
	avg(avg_active_time) as prev_avg_time,
	sum(no_of_times) as prev_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_to_prev_date and date_filter.prev_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,compare_det as (
	select
	*
	from current_week_data cur left join prev_week_data prev  on cur.cur_page_title_id = prev.prev_page_title_id
)

,final_det as (
	select
	page_title.page_title,
	round(coalesce(prev_avg_time,0),2) as prev_avg_time,
	round(coalesce(cur_avg_time,0),2) as cur_avg_time,
	coalesce(prev_no_of_click,0) as prev_no_of_click,
	coalesce(cur_no_of_click,0) as cur_no_of_click,
	(coalesce(cur_no_of_click,0) - coalesce(prev_no_of_click,0)) as diff_no_of_click
	from
	compare_det comp inner join request_response_page_title_mapping page_title on comp.cur_page_title_id = page_title.id
	order by cur_no_of_click desc

)
select
 page_title as "pageTitle",
 TO_CHAR(cast (prev_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "prevAvgTime",
TO_CHAR(cast (cur_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "currAvgTime",
 prev_no_of_click as "prevClicks",
 cur_no_of_click as "currClicks",
 diff_no_of_click as "diffOfClicks"
 from final_det
 limit 50', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='user_analytics_not_used_in_current_week_feature';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0340f798-b4fa-416b-91d8-ceed30b34d8c', 75398,  current_date , 75398,  current_date , 'user_analytics_not_used_in_current_week_feature', 
'role_name,date_filter', 
'with date_filter as (
	select
	current_date as cur_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''1 week''
		when #date_filter# = ''month'' then current_date - interval ''1 month''
		when #date_filter# = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''2 week''
		when #date_filter# = ''month'' then current_date - interval ''2 month''
		when #date_filter# = ''year'' then current_date - interval ''2 year''
		end
	as prev_to_prev_date
)
,prev_week_data as (
	select
	page_title_id as prev_page_title_id,
	avg(avg_active_time) as prev_avg_time,
	sum(no_of_times) as prev_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_to_prev_date and date_filter.prev_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,compare_det as (
	select * from prev_week_data prev right join current_week_data cur  on cur.cur_page_title_id = prev.prev_page_title_id
	where prev.prev_page_title_id is null
)
,final_det as (
	select
	page_title.page_title,
	round(coalesce(prev_avg_time,0),2) as prev_avg_time,
	round(coalesce(cur_avg_time,0),2) as cur_avg_time,
	round(coalesce(cur_avg_time,0) - (coalesce(prev_avg_time,0)),2) as diff_avg_time,
	coalesce(prev_no_of_click,0) as prev_no_of_click,
	coalesce(cur_no_of_click,0) as cur_no_of_click,
	(coalesce(cur_no_of_click,0) - coalesce(prev_no_of_click,0)) as diff_no_of_click
	from
	compare_det comp inner join request_response_page_title_mapping page_title on comp.cur_page_title_id = page_title.id
)
select
 page_title as "pageTitle",
 TO_CHAR(cast (prev_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "prevAvgTime",
TO_CHAR(cast (cur_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "currAvgTime",
case when round(diff_avg_time,2) < 0 then concat(''- '',TO_CHAR(cast (abs(round(diff_avg_time,2))/1000 || ''second'' as interval), ''HH24 h MI m SS s''))
 	else TO_CHAR(cast (abs(round(diff_avg_time,2))/1000 || ''second'' as interval), ''HH24 h MI m SS s'') end
 	as "diffTime",
 prev_no_of_click as "prevClicks",
 cur_no_of_click as "currClicks",
 diff_no_of_click as "diffInClicks"
 from final_det
 order by cur_no_of_click asc
 limit 50', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='user_analytics_top_increase_in_feature_usage';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6cd2e534-b5f3-4f5d-b378-7d9faeaa8e95', 75398,  current_date , 75398,  current_date , 'user_analytics_top_increase_in_feature_usage', 
'role_name,date_filter', 
'with date_filter as (
	select
	current_date as cur_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''1 week''
		when #date_filter# = ''month'' then current_date - interval ''1 month''
		when #date_filter# = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''2 week''
		when #date_filter# = ''month'' then current_date - interval ''2 month''
		when #date_filter# = ''year'' then current_date - interval ''2 year''
		end
	as prev_to_prev_date
)
,prev_week_data as (
	select
	page_title_id as prev_page_title_id,
	avg(avg_active_time) as prev_avg_time,
	sum(no_of_times) as prev_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_to_prev_date and date_filter.prev_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,compare_det as (
	select * from prev_week_data prev right join current_week_data cur on cur.cur_page_title_id = prev.prev_page_title_id
)
,final_det as (
	select
	page_title.page_title,
	round(coalesce(prev_avg_time,0),2) as prev_avg_time,
	round(coalesce(cur_avg_time,0),2) as cur_avg_time,
	(coalesce(cur_avg_time,0) - coalesce(prev_avg_time,0)) as diff_avg_time,
	coalesce(prev_no_of_click,0) as prev_no_of_click,
	coalesce(cur_no_of_click,0) as cur_no_of_click,
	(coalesce(cur_no_of_click,0) - coalesce(prev_no_of_click,0)) as diff_no_of_click,
	case when prev_no_of_click = 0 then 0 else ( coalesce(cur_no_of_click,0) - coalesce(prev_no_of_click,0)) * 100 / prev_no_of_click end as diff_count_time_in_percent
	from
	compare_det comp inner join request_response_page_title_mapping page_title on comp.cur_page_title_id = page_title.id
)
select
page_title as "pageTitle",
TO_CHAR(cast (prev_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "prevAvgTime",
TO_CHAR(cast (cur_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "currAvgTime",
case when round(diff_avg_time,2) < 0 then concat(''- '',TO_CHAR(cast (abs(round(diff_avg_time,2))/1000 || ''second'' as interval), ''HH24 h MI m SS s''))
 	else TO_CHAR(cast (abs(round(diff_avg_time,2))/1000 || ''second'' as interval), ''HH24 h MI m SS s'') end
 	as "diffOfAvgTime",
 prev_no_of_click as "prevClicks",
 cur_no_of_click as "currClicks",
 diff_no_of_click as "diffInClicks",
 round(coalesce(diff_count_time_in_percent,0),2) as "percentColTopIncreaseInFeatureusage"
 from final_det
 order by diff_no_of_click desc
 limit 50', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='user_analytics_top_decrease_in_feature_usage';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8711d37d-553e-4740-bb2f-dce086956c01', 75398,  current_date , 75398,  current_date , 'user_analytics_top_decrease_in_feature_usage', 
'role_name,date_filter', 
'with date_filter as (
	select
	current_date as cur_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''1 week''
		when #date_filter# = ''month'' then current_date - interval ''1 month''
		when #date_filter# = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when #date_filter# = ''week'' then current_date - interval ''2 week''
		when #date_filter# = ''month'' then current_date - interval ''2 month''
		when #date_filter# = ''year'' then current_date - interval ''2 year''
		end
	as prev_to_prev_date
)
,prev_week_data as (
	select
	page_title_id as prev_page_title_id,
	avg(avg_active_time) as prev_avg_time,
	sum(no_of_times) as prev_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_to_prev_date and date_filter.prev_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when #role_name# =  ''All'' then true else role_id = (select id from um_role_master where name = #role_name#) end
	group by page_title_id
)
,compare_det as (
	select * from prev_week_data prev right join current_week_data cur on cur.cur_page_title_id = prev.prev_page_title_id
)
,final_det as (
	select
	page_title.page_title,
	round(coalesce(prev_avg_time,0),2) as prev_avg_time,
	round(coalesce(cur_avg_time,0),2) as cur_avg_time,
	(coalesce(prev_avg_time,0) - coalesce(cur_avg_time,0)) as diff_avg_time,
	coalesce(prev_no_of_click,0) as prev_no_of_click,
	coalesce(cur_no_of_click,0) as cur_no_of_click,
	(coalesce(cur_no_of_click,0) - coalesce(prev_no_of_click,0)) as diff_no_of_click,
	case when prev_no_of_click = 0 then 0 else (coalesce(cur_no_of_click,0) - coalesce(prev_no_of_click,0)) * 100 / prev_no_of_click end as diff_count_time_in_percent
	from
	compare_det comp inner join request_response_page_title_mapping page_title on comp.cur_page_title_id = page_title.id
)
select
 page_title as "pageTitle",
 TO_CHAR(cast (prev_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "prevAvgTime",
TO_CHAR(cast (cur_avg_time/1000 || ''second'' as interval), ''HH24 h MI m SS s'') as "currAvgTime",
case when round(diff_avg_time,2) < 0 then concat(''- '',TO_CHAR(cast (abs(round(diff_avg_time,2))/1000 || ''second'' as interval), ''HH24 h MI m SS s''))
 	else TO_CHAR(cast (abs(round(diff_avg_time,2))/1000 || ''second'' as interval), ''HH24 h MI m SS s'') end
 	as "diffOfAvgTime",
 prev_no_of_click as "prevClicks",
 cur_no_of_click as "currClicks",
 diff_no_of_click as "diffInClicks",
 round(coalesce(diff_count_time_in_percent,0),2) as "percentColTopDecreaseInFeatureUsage"
 from final_det
 order by diff_no_of_click asc
 limit 50', 
null, 
true, 'ACTIVE');

-- Manage Feature

DELETE FROM QUERY_MASTER WHERE CODE='user_search_for_selectize';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'cfcf6ca5-e7c9-495a-9368-67d5ebea26b1', 75398,  current_date , 75398,  current_date , 'user_search_for_selectize', 
'searchString', 
'select id,first_name as "firstName", last_name as "lastName", user_name as "userName" from um_user where first_name like CONCAT(''%'', #searchString#,''%'') or last_name like CONCAT(''%'', #searchString#, ''%'') or user_name like CONCAT(''%'',#searchString#) limit 50', 
null, 
true, 'ACTIVE');


-- GVK Call Center Dashboard

DELETE FROM QUERY_MASTER WHERE CODE='gvk_call_center_get_all_data';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'886c3433-fd19-48f3-96ca-5b1efacaf5f9', 75398,  current_date , 75398,  current_date , 'gvk_call_center_get_all_data', 
'screenContext,locationId', 
'with call_center_data as (
select ccdwa.main_type,ccdwa.sub_type,sum(ccdwa.cnt) as cnt,mct.query_code,mct.is_show_filter,mct.is_show_location_filter, mct.category_order
from gvk_call_center_date_wise_analytics ccdwa
inner join gvk_call_center_main_category_types mct on mct.main_type = ccdwa.main_type and mct.is_active = true
where call_date = current_date - interval ''1 day'' and mct.screen_context= #screenContext# 
and ccdwa.location_id = (case when #locationId# is null then 2 else #locationId# end)
group by ccdwa.main_type,sub_type,mct.query_code,is_show_filter,category_order ,is_show_location_filter
)
select ccdwa.main_type,STRING_AGG(ccdwa.sub_type,'','' order by ccdwa.sub_type) labels
,STRING_AGG(CAST(ccdwa.cnt as text),'','' order by ccdwa.sub_type) "countData"
,sum(ccdwa.cnt) as total
,query_code as "queryCode"
,is_show_filter as "isShowFilter"
,is_show_location_filter as "isShowLocationFilter"
from call_center_data ccdwa
group by main_type,query_code,is_show_filter,category_order,is_show_location_filter 
order by category_order', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='gvk_call_center_data_by_period';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9fa383bc-33f0-40e1-972e-9f7e88253624', -1,  current_date , -1,  current_date , 'gvk_call_center_data_by_period', 
'period,main_catogry,period_no,location_id', 
'with date_period as(
SELECT to_char(d, ''DD-MM'') as series_label, Cast(''(Day-Month)'' as text) x_axis_label, d as from_date, d + interval ''1 day'' - interval ''1 milliseconds'' as to_date
	FROM  generate_series(
	current_date - #period_no# * interval ''1 day'',
	current_date - interval ''1 day'' , ''1 day'') d
	where ''day'' = #period#
Union all
SELECT to_char(d, ''DD-MM'') as series_label, Cast(''(Day-Month)'' as text) x_axis_label,
 d as from_date, d + interval ''1 week'' - interval ''1 milliseconds'' as to_date
	FROM   generate_series(
	current_date - #period_no# * interval ''1 week'',
	current_date - interval ''1 day'' , ''1 week'') d
	where ''week'' = #period#
Union all
SELECT to_char(d + interval ''1 month'', ''MM-YY'') as series_label, Cast(''(Month-Year)'' as text) x_axis_label,
d as from_date, d + interval ''1 month'' - interval ''1 milliseconds'' as to_date
	FROM   generate_series(
	current_date - #period_no# * interval ''1 month'',
	current_date - interval ''1 day'' , ''1 month'') d
	where ''month'' = #period#
Union all
SELECT to_char(d + interval ''1 month'', ''MM-YY'') as series_label, Cast(''(Month-Year)'' as text) x_axis_label,
 d as from_date, d + interval ''1 month'' - interval ''1 milliseconds'' as to_date
	FROM  generate_series(
	current_date - (EXTRACT(MONTH FROM current_date) - 4) * interval ''1 month'',
	current_date - interval ''1 day'' , ''1 month'') d
	where ''financial'' = #period#
),
selected_sub_category as(
select d.series_label, d.x_axis_label, ccdwa.sub_type labels
,case when mc.operation_type=''sum'' then sum(ccdwa.cnt)
	else case when mc.operation_type=''avg'' then round(avg(coalesce(ccdwa.cnt, 0)), 2) else 0 end 
	end as total
/*,sum(ccdwa.cnt) as total*/
from gvk_call_center_date_wise_analytics ccdwa
left join  date_period d
on call_date between d.from_date and d.to_date
left join gvk_call_center_main_category_types mc on mc.main_type =  #main_catogry#
where ccdwa.main_type= #main_catogry#
and ccdwa.location_id = (case when #location_id# is null then 2 else #location_id# end) 
group by d.series_label, ccdwa.sub_type, d.x_axis_label,mc.operation_type
)
select  STRING_AGG(CAST(dp.series_label as text),'','' order by dp.from_date) labels ,
sc.labels as "subCatogary"
,STRING_AGG(CAST(COALESCE(dc.total,0) as text),'','' order by dp.from_date) as "countData",mc.operation_type as "operationType",
sum(dc.total) as total, dp.x_axis_label as "xAxisLabel"
from 
date_period dp
inner join (select distinct labels from selected_sub_category) as sc on true = true
left join selected_sub_category dc on dp.series_label = dc.series_label and dc.labels = sc.labels
left join gvk_call_center_main_category_types mc on mc.main_type =  #main_catogry#
group by sc.labels, dp.x_axis_label,  mc.operation_type', 
null, 
true, 'ACTIVE');


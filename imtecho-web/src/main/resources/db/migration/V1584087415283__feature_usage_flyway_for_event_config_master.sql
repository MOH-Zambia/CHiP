begin;
delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Feature Usage Analytics');
  delete from menu_config where menu_name = 'Feature Usage Analytics';
  INSERT INTO menu_config (feature_json,group_id,active,is_dynamic_report,menu_name,navigation_state,sub_group_id,menu_type,only_admin,menu_display_order) VALUES 
	('{}',NULL,true,NULL,'Feature Usage Analytics','techo.manage.featureUsage',NULL,'admin',NULL,NULL)
  ;
commit;

begin;
delete from public.query_master where code = 'user_analytics_top_usage_feature';
INSERT INTO public.query_master(
            created_by,
            created_on,
            code,
            params,
            query,
            returns_result_set,
            state
            )
    VALUES (
        1,
        localtimestamp,
        'user_analytics_top_usage_feature',
        'date_filter,role_name',
        'with date_filter as (
	select
	current_date as cur_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''1 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''1 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''2 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''2 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''2 year''
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
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
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
        true,
        'ACTIVE'
        );
commit;
--


begin;
delete from public.query_master where code = 'user_analytics_not_used_in_current_week_feature';
INSERT INTO public.query_master(
            created_by,
            created_on,
            code,
            params,
            query,
            returns_result_set,
            state
            )
    VALUES (
        1,
        localtimestamp,
        'user_analytics_not_used_in_current_week_feature',
        'date_filter,role_name',
        'with date_filter as (
	select
	current_date as cur_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''1 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''1 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''2 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''2 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''2 year''
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
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
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
        true,
        'ACTIVE'
        );
commit;

--

begin;
delete from public.query_master where code = 'user_analytics_top_increase_in_feature_usage';
INSERT INTO public.query_master(
            created_by,
            created_on,
            code,
            params,
            query,
            returns_result_set,
            state
            )
    VALUES (
        1,
        localtimestamp,
        'user_analytics_top_increase_in_feature_usage',
        'date_filter,role_name',
        'with date_filter as (
	select
	current_date as cur_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''1 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''1 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''2 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''2 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''2 year''
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
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
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
        true,
        'ACTIVE'
        );
commit;

--
begin;
delete from public.query_master where code = 'user_analytics_top_decrease_in_feature_usage';
INSERT INTO public.query_master(
            created_by,
            created_on,
            code,
            params,
            query,
            returns_result_set,
            state
            )
    VALUES (
        1,
        localtimestamp,
        'user_analytics_top_decrease_in_feature_usage',
        'date_filter,role_name',
        'with date_filter as (
	select
	current_date as cur_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''1 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''1 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''1 year''
	end as prev_date,
	case
		when ''#date_filter#'' = ''week'' then current_date - interval ''2 week''
		when ''#date_filter#'' = ''month'' then current_date - interval ''2 month''
		when ''#date_filter#'' = ''year'' then current_date - interval ''2 year''
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
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
	group by page_title_id
)
,current_week_data as (
	select
	page_title_id as cur_page_title_id,
	avg(avg_active_time) as cur_avg_time,
	sum(no_of_times) as cur_no_of_click
	from user_wise_feature_time_taken_detail_analytics,date_filter
	where user_wise_feature_time_taken_detail_analytics.on_date between date_filter.prev_date + interval ''1 day''  and date_filter.cur_date
	and case when ''#role_name#'' =  ''All'' then true else role_id = (select id from um_role_master where name = ''#role_name#'') end
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
 limit 50
',
        true,
        'ACTIVE'
        );
commit;

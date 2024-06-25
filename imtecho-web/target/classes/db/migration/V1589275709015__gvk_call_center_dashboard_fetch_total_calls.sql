DELETE FROM QUERY_MASTER WHERE CODE='gvk_call_center_verification_dashboard_total_calls';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
80240,  current_date , 80240,  current_date , 'gvk_call_center_verification_dashboard_total_calls',
'userId',
'with today_date as (
	select cast(now() as date) today_date
)
,all_dates as (
	select
	cast(today_date as date) as from_date,
	cast (today_date as date) as to_date,
	''TODAY'' as type
	from today_date
	union all
	SELECT today_date - cast(extract(dow from today_date) as int) as from_date,
	today_date - cast(extract(dow from today_date) as int) + 6 as to_date,
	''WEEK'' as type

	from today_date
	union all
	select cast( date_trunc(''month'', today_date) as date) as from_date,
	cast(date_trunc(''month'', today_date) + interval ''1 month'' - interval ''1 day'' as date) as to_date,
	''MONTH'' as type

	from today_date
)
select
sum (  case when type=''TODAY'' then 1 else 0 end ) as day_call,
sum (  case when type=''WEEK'' then 1 else 0 end ) as week_call,
sum (  case when type=''MONTH'' then 1 else 0 end ) as month_call

from gvk_manage_call_master master inner join all_dates on true
where cast(master.created_on as date) between all_dates.from_date and all_dates.to_date and master.created_by = #userId#',
null,
true, 'ACTIVE');
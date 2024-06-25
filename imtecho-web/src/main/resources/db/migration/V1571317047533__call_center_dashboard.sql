--create table gvk_call_center_date_wise_analytics
Drop table if exists public.gvk_call_center_date_wise_analytics;
CREATE TABLE public.gvk_call_center_date_wise_analytics (
	id bigserial NOT NULL,
	call_date timestamp NULL,
	main_type varchar(300) NULL,
	sub_type varchar(300) NULL,
	call_count int8 NULL,
	CONSTRAINT gvk_call_center_date_wise_analytics_pkey PRIMARY KEY (id)
);

--Get All data for call center dashboard
DELETE FROM query_master where code='gvk_call_center_get_all_data';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'gvk_call_center_get_all_data', 'date', 'select main_type,STRING_AGG(ccdwa.sub_type,'','' order by ccdwa.sub_type) labels
,STRING_AGG(CAST(ccdwa.call_count as text),'','' order by ccdwa.sub_type) count_data
,sum(ccdwa.call_count) as total
from gvk_call_center_date_wise_analytics ccdwa
where CAST(call_date AS DATE) = ''#date#''
group by ccdwa.main_type', true, 'ACTIVE', NULL);


--Get call center dashboard data by time period
DELETE FROM query_master where code='gvk_call_center_data_by_period';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'gvk_call_center_data_by_period', 'period,main_catogry,period_no', 'with date_period as(
SELECT to_char(d, ''DD-MM'') as series_label, Cast(''(Day-Month)'' as text) x_axis_label, d as from_date, d + interval ''1 day'' - interval ''1 milliseconds'' as to_date
	FROM  generate_series(
	current_date - ''#period_no#'' * interval ''1 day'',
	current_date - interval ''1 day'' , ''1 day'') d
	where ''day'' = ''#period#''
Union all
SELECT to_char(d, ''DD-MM'') as series_label, Cast(''(Day-Month)'' as text) x_axis_label,
 d as from_date, d + interval ''1 week'' - interval ''1 milliseconds'' as to_date
	FROM   generate_series(
	current_date - ''#period_no#'' * interval ''1 week'',
	current_date - interval ''1 day'' , ''1 week'') d
	where ''week'' = ''#period#''
Union all
SELECT to_char(d + interval ''1 month'', ''MM-YY'') as series_label, Cast(''(Month-Year)'' as text) x_axis_label,
d as from_date, d + interval ''1 month'' - interval ''1 milliseconds'' as to_date
	FROM   generate_series(
	current_date - ''#period_no#'' * interval ''1 month'',
	current_date - interval ''1 day'' , ''1 month'') d
	where ''month'' = ''#period#''
Union all
SELECT to_char(d + interval ''1 month'', ''MM-YY'') as series_label, Cast(''(Month-Year)'' as text) x_axis_label,
 d as from_date, d + interval ''1 month'' - interval ''1 milliseconds'' as to_date
	FROM  generate_series(
	current_date - (EXTRACT(MONTH FROM current_date) - 4) * interval ''1 month'',
	current_date - interval ''1 day'' , ''1 month'') d
	where ''financial'' = ''#period#''
),
selected_sub_category as(
select d.series_label, d.x_axis_label, ccdwa.sub_type labels
,sum(ccdwa.call_count) as total
from gvk_call_center_date_wise_analytics ccdwa
left join  date_period d
on call_date between d.from_date and d.to_date
where ccdwa.main_type= ''#main_catogry#''
group by d.series_label, ccdwa.sub_type, d.x_axis_label
)
select  STRING_AGG(CAST(dp.series_label as text),'','' order by dp.from_date) labels ,
sc.labels as sub_catogary
,STRING_AGG(CAST(COALESCE(dc.total,0) as text),'','' order by dp.from_date) as call_count,
sum(dc.total) as total, dp.x_axis_label 
from 
date_period dp
inner join (select distinct labels from selected_sub_category) as sc on true = true
left join selected_sub_category dc on dp.series_label = dc.series_label and dc.labels = sc.labels
group by sub_catogary, dp.x_axis_label', true, 'ACTIVE', NULL);


-- Create Call Center Dashboard Menu.
delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Call Center Dashboard');

delete from menu_config where id in (select id from menu_config where menu_name = 'Call Center Dashboard');

--INSERT INTO  menu_config(
--                active, menu_name, navigation_state, menu_type, group_id)
--        VALUES('TRUE','Call Center Dashboard', 'techo.dashboard.callcenter', 'manage', 7);
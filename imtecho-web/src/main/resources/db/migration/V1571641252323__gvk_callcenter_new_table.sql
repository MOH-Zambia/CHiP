drop table if exists public.gvk_call_center_main_category_types;
create table gvk_call_center_main_category_types (
	main_type varchar(300) NOT NULL,
	is_active boolean,
	operation_type varchar(300) NULL,
	query_code varchar(300) NULL,
	CONSTRAINT gvk_call_center_main_category_types_pkey PRIMARY KEY (main_type)
);


INSERT into gvk_call_center_main_category_types(main_type, is_active, operation_type, query_code)
VALUES('New Call Added', true, 'sum', 'gvk_call_center_data_by_period');

INSERT into gvk_call_center_main_category_types(main_type, is_active, operation_type, query_code)
VALUES('Successful Call', true, 'sum', 'gvk_call_center_data_by_period');

INSERT into gvk_call_center_main_category_types(main_type, is_active, operation_type, query_code)
VALUES('Total Call Done', true, 'sum', 'gvk_call_center_data_by_period');

INSERT into gvk_call_center_main_category_types(main_type, is_active, operation_type, query_code)
VALUES('Unsuccessful Call', true, 'sum', 'gvk_call_center_data_by_period');

INSERT into gvk_call_center_main_category_types(main_type, is_active, operation_type, query_code)
VALUES('Number Of Resource', true, 'avg', 'gvk_call_center_data_by_period');


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
,sum(ccdwa.cnt) as total
from gvk_call_center_date_wise_analytics ccdwa
left join  date_period d
on call_date between d.from_date and d.to_date
where ccdwa.main_type= ''#main_catogry#''
group by d.series_label, ccdwa.sub_type, d.x_axis_label
)
select  STRING_AGG(CAST(dp.series_label as text),'','' order by dp.from_date) labels ,
sc.labels as "subCatogary"
,STRING_AGG(CAST(COALESCE(dc.total,0) as text),'','' order by dp.from_date) as "countData",mc.operation_type as "operationType",
case when mc.operation_type=''sum'' then sum(dc.total)
	else case when mc.operation_type=''avg'' then round(avg(coalesce(dc.total, 0)), 2) else 0 end 
	end as total, dp.x_axis_label as "xAxisLabel"
from 
date_period dp
inner join (select distinct labels from selected_sub_category) as sc on true = true
left join selected_sub_category dc on dp.series_label = dc.series_label and dc.labels = sc.labels
left join gvk_call_center_main_category_types mc on mc.main_type =  ''#main_catogry#''
group by sc.labels, dp.x_axis_label,  mc.operation_type', true, 'ACTIVE', NULL);


--Get All data for call center dashboard
DELETE FROM query_master where code='gvk_call_center_get_all_data';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'gvk_call_center_get_all_data', 'date', 'select ccdwa.main_type,STRING_AGG(ccdwa.sub_type,'','' order by ccdwa.sub_type) labels
,STRING_AGG(CAST(ccdwa.cnt as text),'','' order by ccdwa.sub_type) "countData"
,sum(ccdwa.cnt) as total
,mct.query_code as "queryCode"
from gvk_call_center_date_wise_analytics ccdwa
inner join gvk_call_center_main_category_types mct on mct.main_type = ccdwa.main_type and mct.is_active = true
where CAST(call_date AS DATE) = ''#date#''
group by ccdwa.main_type, mct.query_code', true, 'ACTIVE', NULL);


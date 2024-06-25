DELETE FROM QUERY_MASTER WHERE CODE='soh_performance_line_chart';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
66522,  current_date , 66522,  current_date , 'soh_performance_line_chart',
'locationId',
'with json_to_row as (
select
	json_array_elements(cast(configuration_json as json)) as fields,
	from_date,
	to_date,
	id
from
	soh_chart_configuration
),
chart_details as (
select
	jtr.id,
	jtr.from_date,
	jtr.to_date,
	json_array_elements(jtr.fields -> ''fields'') as config,
	jtr.fields ->> ''elementName'' as element_name,
	jtr.fields ->> ''color'' as color,
	jtr.fields ->> ''displayName'' as display_name
from
	json_to_row jtr),
json_with_row_number as (
select
	*,
	row_number () over() as serial
from
	chart_details
),
axis_data as (
select
	*,
	row_to_json(t) as json
from
	(
	select
		jtr.element_name as name,
		jtr.color as color,
		jtr.display_name as display_name,
		jtr.id,
		array_agg(
		    case
		        when jtr.config ->> ''field'' = ''chart1'' then cast(coalesce(soh.chart1, 0) as text)
		        when jtr.config ->> ''field'' = ''timeline'' then (
                    case
                        when soh.timeline_sub_type = ''DAY'' then concat(''Day '', (cast(timeline_type as date) - cast(''2020-03-18'' as date)))
                        else to_char(cast(soh.timeline_type as date),''DD-Mon'')
                    end
                )
                when jtr.config ->> ''field'' = ''chart2'' then cast(coalesce(soh.chart2, 0) as text)
                when jtr.config ->> ''field'' = ''chart3'' then cast(coalesce(soh.chart3, 0) as text)
                when jtr.config ->> ''field'' = ''chart4'' then cast((soh.chart4, 0) as text)
                when jtr.config ->> ''field'' = ''chart5'' then cast(soh.chart5 as text)
		        when jtr.config ->> ''field'' = ''chart6'' then cast(soh.chart6 as text)
                when jtr.config ->> ''field'' = ''chart7'' then cast(soh.chart7 as text)
                when jtr.config ->> ''field'' = ''chart8'' then cast(soh.chart8 as text)
                when jtr.config ->> ''field'' = ''chart9'' then cast(soh.chart9 as text)
                when jtr.config ->> ''field'' = ''chart10'' then cast(soh.chart10 as text)
                when jtr.config ->> ''field'' = ''chart11'' then cast(soh.chart11 as text)
                when jtr.config ->> ''field'' = ''chart12'' then cast(soh.chart12 as text)
                when jtr.config ->> ''field'' = ''chart13'' then cast(soh.chart13 as text)
                when jtr.config ->> ''field'' = ''chart14'' then cast(soh.chart14 as text)
                when jtr.config ->> ''field'' = ''chart15'' then cast(soh.chart15 as text)
                when jtr.config ->> ''field'' = ''percentage'' then cast(coalesce(soh.percentage, 0) as text)
                when jtr.config ->> ''field'' = ''displayValue'' then cast(soh.displayValue as text)
                when jtr.config ->> ''field'' = ''value'' then cast(coalesce(soh.value, 0) as text)
                when jtr.config ->> ''field'' = ''calculatedTarget'' then cast(soh.calculatedTarget as text)
            end order by cast(soh.timeline_type as date) asc) as value,
		jtr.config ->> ''type'' as "axis"
	from
		soh_timeline_analytics soh
	inner join json_with_row_number jtr on
		jtr.element_name = soh.element_name
	where
		soh.timeline_sub_type IN (''DATE'',''DAY'')
		and soh.location_id = #locationId#
        and cast(soh.timeline_type as date) between jtr.from_date and jtr.to_date
	group by
		jtr.id,
		jtr.element_name,
		jtr.config ->> ''type'',
		jtr.color,
		jtr.display_name) as t),
result_set as (
select
	t.id,
	json_agg(t) as element_name
from
	(
	select
		id,
		name,
		json_agg(json) as json
	from
		axis_data
	group by
		id,
		name,
		color) as t
group by
	id
)
select
	scc.id,
	name,
    module as module,
	display_name,
	cast(element_name as text) as data
from
	result_set rs
	inner join soh_chart_configuration scc
	on scc.id = rs.id',
null,
true, 'ACTIVE');
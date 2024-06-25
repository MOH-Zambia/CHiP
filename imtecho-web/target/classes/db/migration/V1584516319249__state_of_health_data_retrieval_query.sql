delete from query_master where code='state_of_health_data_retrieval_11';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'state_of_health_data_retrieval_11','locationId,timeline_type','
with elements_details as (
       select lt.level,lt.type,closer.child_id as "locationId",
        case when lt.type =''C'' or lt.type =''D'' then ''Districts/Corporation'' else lt.name end as "locationType",
        case when l.english_name is not null then l.english_name else l.name end as english_name,
config.element_name as "elementName",
        value as value,sh.target,male as male,female as female,
        chart1 as chart1,chart2 as chart2,chart3 as chart3,chart4 as chart4,
        cast(''#timeline_type#'' as text) as timeline_type,
        days as days,
        reporting as reporting,
        calculatedTarget as calculatedTarget,
        color as color,
        percentage as percentage,
        sortPriority as "sortPriority",
        displayValue as displayValue
        from location_hierchy_closer_det closer
        inner join location_master l on closer.child_id = l.id
        inner join location_type_master lt on l.type = lt.type
        left join soh_element_configuration config on TRUE
        left join soh_timeline_analytics_temp sh on sh.location_id = closer.parent_id and config.element_name = sh.element_name
        --inner join location_hierchy_closer_det closer on closer.parent_id = 2 and depth=case when 2 = 2 then 2 else 1 end and timeline_type = ''#timeline_type#''
	and timeline_type = ''#timeline_type#''
        where closer.parent_id = ''#locationId#'' and depth=0
	--and timeline_sub_type=''PERIOD''
        order by english_name),
unique_locations as (
        select distinct "locationId" from elements_details
        ),
user_details_ids as (
        select uul.loc_id as location_id, concat(uu.first_name,'' '',uu.middle_name,'' '', uu.last_name)
				 as "userName",
				 case when uu.role_id = 39 then ''CDHO''
				when uu.role_id = 41 then ''THO''
				when uu.role_id = 66 then ''MO PHC''
when uu.role_id = 86 then ''MO UPHC''

				when uu.role_id = 67 then ''MO AYUSH''
				when uu.role_id = 63 then ''RCHO''
                                when uu.role_id = 85 then ''MOH Co.''
				when uu.role_id = 99 then ''RCHO Co.''
				when uu.role_id = 204 then ''MPHW''
				when uu.role_id = 30 then ''FHW''
				when uu.role_id = 24 then ''ASHA''
				when uu.role_id = 108 then ''DHO''
                                when uu.role_id = 179 then ''CHO-HWC''
				else ''(Other)'' end as "roleName",
				uu.contact_number as "contactNumber",
				uu.id as user_id
        from unique_locations elements
        inner join um_user_location uul on elements."locationId" = uul.loc_id
        inner join um_user uu on uu.id = uul.user_id
        inner join location_master lm on lm.id =  uul.loc_id
        where uul.state=''ACTIVE''
        and uu.state=''ACTIVE''
	and uu.role_id in (39,41,67,66,63,85,99,204,24,108,30,86,179)
),
remaining_user_data as (
	select "locationId" as location_id,
	cast(''-'' as text) as "userName",
	t.roleName,
	cast(''-'' as text) as "contactNumber",
	cast(0 as numeric) as "user_id"

	from unique_locations
	inner join location_master lm on lm.id = "locationId"
	inner join (
	select ''C'' as type_id, unnest(array[''MOH Co.'', ''RCHO Co.'']) as roleName
	union all
	select ''D'' as type_id, unnest(array[''CDHO'', ''RCHO'']) as roleName
	union all
	select ''B'' as type_id, ''THO'' as roleName
	union all
	select ''Z'' as type_id, ''DHO'' as roleName
	union all
	select ''P'' as type_id, unnest(array[''MO PHC'', ''MO AYUSH'']) as roleName
	union all
	select ''U'' as type_id, unnest(array[''MO UPHC'', ''MO AYUSH'']) as roleName
	union all
	select ''V'' as type_id, unnest(array[''FHW'',''MPHW'']) as roleName
	union all
	select ''ANG'' as type_id, unnest(array[''FHW'',''MPHW'']) as roleName
	union all
	select ''SC'' as type_id, unnest(array[''CHO-HWC'']) as roleName
	union all
--select ''ANM'' as type_id, unnest(array[''CHO-HWC'']) as roleName
	--union all
	select ''A'' as type_id, unnest(array[''ASHA'']) as roleName
	union all
	select ''AA'' as type_id, unnest(array[''ASHA'']) as roleName
	) as t on t.type_id = lm."type"
),
remaining_user_data_1 as (
	select users.*
	from remaining_user_data remains
	left join user_details_ids users  on users.location_id = remains.location_id
	and users."roleName"  = remains.roleName
	where users.user_id is not null
	union
	select remains.*
        from remaining_user_data remains
	left join user_details_ids users  on users.location_id = remains.location_id
	and users."roleName"  = remains.roleName
	where users.user_id is null
),
user_details as (
	       select
	       cast(array_to_json(array_agg(row_to_json(ud.*))) as text) as user_name,ud.location_id
	       from remaining_user_data_1 ud
	       group by ud.location_id
)
select elements.*,
case when users.user_name is null then null else users.user_name end as  "userDetail"
from elements_details elements
--inner join calculations cal on cal."locationId" = elements."locationId"
left join user_details users
on elements."locationId" = users.location_id
',true,'ACTIVE');




delete from query_master where code='state_of_health_data_retrieval_12';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'state_of_health_data_retrieval_12','locationId,columnName,timeline_type,element_name','
with elements_details as (
       select lt.level,lt.type,closer.child_id as "locationId",
        case when lt.type =''C'' or lt.type =''D'' then ''Districts/Corporation'' else lt.name end as "locationType",
        case when l.english_name is not null then l.english_name else l.name end as english_name,
 cast(''#element_name#'' as  text) as "elementName",
        value as value,sh.target,male as male,female as female,
        chart1 as chart1,chart2 as chart2,chart3 as chart3,chart4 as chart4,
        cast(''#timeline_type#'' as text) as timeline_type,
        days as days,
        reporting as reporting,
        calculatedTarget as calculatedTarget,
        color as color,
        percentage as percentage,
        sortPriority as "sortPriority",
        displayValue as displayValue
        from location_hierchy_closer_det closer
        inner join location_master l on closer.child_id = l.id
        inner join location_type_master lt on l.type = lt.type
        left join soh_element_configuration config on config.element_name = ''#element_name#''
        left join soh_timeline_analytics_temp sh on sh.location_id = closer.child_id and config.element_name = sh.element_name
        --inner join location_hierchy_closer_det closer on closer.parent_id = 2 and depth=case when 2 = 2 then 2 else 1 end and timeline_type = ''#timeline_type#''
	and timeline_type = ''#timeline_type#''
        where closer.parent_id = ''#locationId#'' and depth=case when #locationId# = 2 then 2 else 1 end
	--and timeline_sub_type=''PERIOD''
        order by english_name),
unique_locations as (
        select distinct "locationId" from elements_details
        ),
user_details_ids as (
        select uul.loc_id as location_id, concat(uu.first_name,'' '',uu.middle_name,'' '', uu.last_name)
				 as "userName",
				 case when uu.role_id = 39 then ''CDHO''
				when uu.role_id = 41 then ''THO''
				when uu.role_id = 66 then ''MO PHC''
when uu.role_id = 86 then ''MO UPHC''

				when uu.role_id = 67 then ''MO AYUSH''
				when uu.role_id = 63 then ''RCHO''
                                when uu.role_id = 85 then ''MOH Co.''
				when uu.role_id = 99 then ''RCHO Co.''
				when uu.role_id = 204 then ''MPHW''
				when uu.role_id = 30 then ''FHW''
				when uu.role_id = 24 then ''ASHA''
				when uu.role_id = 108 then ''DHO''
                                when uu.role_id = 179 then ''CHO-HWC''
				else ''(Other)'' end as "roleName",
				uu.contact_number as "contactNumber",
				uu.id as user_id
        from unique_locations elements
        inner join um_user_location uul on elements."locationId" = uul.loc_id
        inner join um_user uu on uu.id = uul.user_id
        inner join location_master lm on lm.id =  uul.loc_id
        where uul.state=''ACTIVE''
        and uu.state=''ACTIVE''
	and uu.role_id in (39,41,67,66,63,85,99,204,24,108,30,86,179)
),
remaining_user_data as (
	select "locationId" as location_id,
	cast(''-'' as text) as "userName",
	t.roleName,
	cast(''-'' as text) as "contactNumber",
	cast(0 as numeric) as "user_id"

	from unique_locations
	inner join location_master lm on lm.id = "locationId"
	inner join (
	select ''C'' as type_id, unnest(array[''MOH Co.'', ''RCHO Co.'']) as roleName
	union all
	select ''D'' as type_id, unnest(array[''CDHO'', ''RCHO'']) as roleName
	union all
	select ''B'' as type_id, ''THO'' as roleName
	union all
	select ''Z'' as type_id, ''DHO'' as roleName
	union all
	select ''P'' as type_id, unnest(array[''MO PHC'', ''MO AYUSH'']) as roleName
	union all
	select ''U'' as type_id, unnest(array[''MO UPHC'', ''MO AYUSH'']) as roleName
	union all
	select ''V'' as type_id, unnest(array[''FHW'',''MPHW'']) as roleName
	union all
	select ''ANG'' as type_id, unnest(array[''FHW'',''MPHW'']) as roleName
	union all
	select ''SC'' as type_id, unnest(array[''CHO-HWC'']) as roleName
	union all
--select ''ANM'' as type_id, unnest(array[''CHO-HWC'']) as roleName
	--union all
	select ''A'' as type_id, unnest(array[''ASHA'']) as roleName
	union all
	select ''AA'' as type_id, unnest(array[''ASHA'']) as roleName
	) as t on t.type_id = lm."type"
),
remaining_user_data_1 as (
	select users.*
	from remaining_user_data remains
	left join user_details_ids users  on users.location_id = remains.location_id
	and users."roleName"  = remains.roleName
	where users.user_id is not null
	union
	select remains.*
        from remaining_user_data remains
	left join user_details_ids users  on users.location_id = remains.location_id
	and users."roleName"  = remains.roleName
	where users.user_id is null
),
user_details as (
	       select
	       cast(array_to_json(array_agg(row_to_json(ud.*))) as text) as user_name,ud.location_id
	       from remaining_user_data_1 ud
	       group by ud.location_id
)
select elements.*,
case when users.user_name is null then null else users.user_name end as  "userDetail"
from elements_details elements
--inner join calculations cal on cal."locationId" = elements."locationId"
left join user_details users on elements."locationId" = users.location_id
',true,'ACTIVE');

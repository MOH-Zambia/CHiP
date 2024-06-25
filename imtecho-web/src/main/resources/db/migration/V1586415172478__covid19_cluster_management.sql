drop table if exists location_cluster_master;
create table location_cluster_master (
id serial primary key,
name text,
state text,
population integer,
created_by integer,
created_on timestamp without time zone,
modified_by integer,
modified_on timestamp without time zone
);

drop table if exists location_cluster_mapping_detail;
create table location_cluster_mapping_detail(
cluster_id integer,
location_id integer,
state text,
created_by integer,
created_on timestamp without time zone,
modified_by integer,
modified_on timestamp without time zone,
primary key (cluster_id,location_id)
);

delete from user_menu_item where menu_config_id = 
(select id from menu_config where navigation_state = 'techo.manage.locationClusterManagement');

delete from menu_config where navigation_state = 'techo.manage.locationClusterManagement';

insert into menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, 
sub_group_id, menu_type, only_admin, menu_display_order)
values('{}', (select id from menu_group where group_name='COVID-19'),
 true, null, 'COVID-19 Cluster Management', 'techo.manage.locationClusterManagement', null, 'manage', null, null);

 delete from QUERY_MASTER where CODE='covid19_insert_location_cluster_master';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_insert_location_cluster_master',
'name,userId,population',
'insert into location_cluster_master
(name,state,population,created_by,created_on,modified_by,modified_on)
values(''#name#'',''ACTIVE'',#population#,#userId#,now(),#userId#,now())
returning id;',
'',
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_insert_location_cluster_mapping_detail';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_insert_location_cluster_mapping_detail',
'locations,clusterId,userId',
'insert into location_cluster_mapping_detail
(cluster_id,location_id,state,created_by,created_on,modified_by,modified_on)
select #clusterId#,x,''ACTIVE'',#userId#,now(),#userId#,now()
from unnest(array[#locations#]) x;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_get_location_clusters';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_get_location_clusters',
 null,
'select location_cluster_master.id,
location_cluster_master.name,
location_cluster_master.population,
location_cluster_master.state,
string_agg(get_location_hierarchy(location_cluster_mapping_detail.location_id),'',<br>'') as "locations"
from location_cluster_master
inner join location_cluster_mapping_detail on location_cluster_master.id = location_cluster_mapping_detail.cluster_id
group by location_cluster_master.id,
location_cluster_master.name,
location_cluster_master.population,
location_cluster_master.state',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_get_location_cluster_by_id';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_get_location_cluster_by_id',
'id',
'select location_cluster_master.id as "clusterId",
location_cluster_master.name as "clusterName",
location_cluster_master.population,
location_cluster_mapping_detail.location_id as "locationId",
location_master.type as "locationType",
location_master.name as "locationName",
location_type_master.level as "locationLevel",
replace(get_location_hierarchy(location_master.id),'' > '','','') as "locationFullName"
from location_cluster_master
inner join location_cluster_mapping_detail on location_cluster_master.id = location_cluster_mapping_detail.cluster_id
inner join location_master on location_cluster_mapping_detail.location_id = location_master.id
inner join location_type_master on location_master.type = location_type_master.type
where location_cluster_master.id = #id#',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_update_location_cluster_master';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_update_location_cluster_master',
'name,id,userId,population',
'update location_cluster_master
set name = ''#name#'',
population = #population#,
modified_by = #userId#,
modified_on = now()
where id = #id#;
delete from location_cluster_mapping_detail where cluster_id = #id#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_update_location_cluster_state';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_update_location_cluster_state',
'state,id',
'update location_cluster_master
set state = ''#state#''
where id = #id#',
null,
false, 'ACTIVE');

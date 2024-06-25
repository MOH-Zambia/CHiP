DELETE FROM QUERY_MASTER WHERE CODE='get_feature_name_with_uuid';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ccd5e720-f4db-4407-b2ef-0e1dc7d8c759', 74840,  current_date , 74840,  current_date , 'get_feature_name_with_uuid',
'searchText,offset,featureType,limit',
'with unique_uuid as (
	select
	distinct on (feature_uuid )
	feature_uuid,feature_name,feature_type
	from sync_system_configuration_master scs
	where feature_uuid is not null
	and feature_type = #featureType#
    and case when #searchText# != null then feature_name ilike ''%#searchText#%'' else true end
	order by feature_uuid,id desc
	limit #limit# offset #offset#
)
,server_id_merger as (
	select
	u.feature_uuid,
	feature_name,
	feature_type,
	string_agg(cast(master.id as text),'','') as server_ids,
	string_agg(master.server_name,'','') as server_names
	from unique_uuid u
	left join sync_server_feature_mapping_detail map on map.feature_uuid = u.feature_uuid
	left join server_list_master master on map.server_id = master.id
	group by u.feature_uuid,u.feature_name,u.feature_type
)
select cast(feature_uuid as text) as feature_uuid,feature_name,feature_type,server_names,server_ids from server_id_merger',
'get feature name',
true, 'ACTIVE');
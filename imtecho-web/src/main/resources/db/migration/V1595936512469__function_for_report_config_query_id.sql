CREATE OR REPLACE FUNCTION insert_uuid_in_report_master_UUID_for_query_id_specific (query_master_id int)
RETURNS text AS $final_json$
declare
	final_json jsonb;
begin

	with cte as (
		select id
		 ,json_array_elements(config_json::json->'containers' -> 'fieldsContainer') ->> 'queryId' as query_param_id
		,jsonb_array_elements(jsonb_extract_path(config_json::jsonb, 'containers','fieldsContainer')::jsonb) "objects" from report_master
		where id = $1 and config_json::jsonb -> 'containers' -> 'fieldsContainer' is not null
	)
	,final_array as (
		select jsonb_build_array(d) "array_data" from
		(
		select array_agg(objects::jsonb || jsonb_build_object('queryUUID',(master.uuid))) "fieldsContainer" from cte
		left join report_query_master master on cast(master.id as text) = query_param_id
	--	where cte.query_param_id is not null
		)d
	)


	update report_master set config_json = (
		select jsonb_set(
	        config_json::jsonb,
	        '{containers,fieldsContainer}', (f.array_data -> 0 -> 'fieldsContainer'),false)
	 	from report_master, final_array f
	 	where id = $1)
	 	where id = $1;

	select config_json into final_json  from report_master where id = $1;

	RETURN final_json;

 	exception
 		when others THEN RAISE NOTICE 'Error Occured while inserting UUID, % ', $1 ;
		select cast($1 as text) into final_json;
		RETURN final_json;


	END;
$final_json$ LANGUAGE plpgsql;


select id,uuid,insert_uuid_in_report_master_UUID_for_query_id_specific(id) from report_master rm
where jsonb_array_length(config_json::jsonb -> 'containers' -> 'fieldsContainer') != 0
order by id asc;
DELETE FROM QUERY_MASTER WHERE CODE='get_locations_usages_places_for_delete_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a9b1931f-975f-427a-bfa6-0244eee86bb8', 60512,  current_date , 60512,  current_date , 'get_locations_usages_places_for_delete_location',
'location_id',
'with loc_to_delete as (
	select id as loc_id, "type" from location_master where id = #location_id#
), active_user_loc as (
	select count(*) as total  from loc_to_delete
	inner join um_user_location ul on ul.loc_id = loc_to_delete.loc_id and ul.state = ''ACTIVE''
	inner join um_user u on u.id = ul.user_id and u.state = ''ACTIVE''
),family_exists_on_loc as (
	select count(*) as total  from loc_to_delete
	inner join imt_family if2 on if2.area_id = loc_to_delete.loc_id or if2.location_id = loc_to_delete.loc_id
	where if2.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'') or if2.state=''com.argusoft.imtecho.family.state.migrated''
),
 migrated_in_member_exists as (
	select count(*) as total from migration_master mm,imt_member mem where
	mm.member_id = mem.id and mem.basic_state in (''NEW'',''VERIFIED'',''TEMPORARY'') and mm.state = ''REPORTED'' and
	location_migrated_to in (select loc_id from loc_to_delete)
),
 health_infra_exists as (
 	select count(*) as total from health_infrastructure_details  where
 	location_id in (select loc_id from loc_to_delete) and state = ''ACTIVE''
 )
select
(select total from active_user_loc) as "Active User",
(select total from family_exists_on_loc) as "Available Family",
(select total from migrated_in_member_exists) as "Migrated Member",
(select total from health_infra_exists) as "Active Health Infrastructure"',
'Check if there are any valid families or members in the location to be deleted',
true, 'ACTIVE');
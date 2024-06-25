delete from query_master qm where qm.code = 'team_filter_teams_by_location_id';
INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1,'2020-02-18 00:00:00.000',80208,now(),'team_filter_teams_by_location_id','locationId,loggedInUserId','with 
allowed_team_types as(
	select ttrm.team_type_id from um_user uu inner join team_type_role_master ttrm on ttrm.role_id =uu.role_id and ttrm.state =''ACTIVE'' where uu.id = #loggedInUserId#
	
),
loggedin_user_location as ( 
	select uul.loc_id as location_id from um_user_location uul where uul.user_id = #loggedInUserId#
),
locations as (
	select lm.name , lm.id from location_master lm 
	inner join location_hierchy_closer_det lhcd  on lhcd.child_id = lm.id 
	where (#locationId# is not null or  lhcd.parent_id in (select location_id 
	from loggedin_user_location)  ) and (#locationId# is null or lhcd.parent_id = #locationId# ) and lm.state =''ACTIVE''
),
teams as(
	select distinct tm.* from locations inner join  team_location_master tlm on tlm.location_id = locations.id  and tlm.state =''ACTIVE''
	inner join team_master tm on tm.id = tlm.team_id where tm.team_type_id in (select team_type_id from allowed_team_types)
)
,
team_locations as (
	select * from teams inner join team_location_master tlm on tlm.team_id =teams.id and tlm.state =''ACTIVE''
)
,
parent_locations as(
	select distinct lhcd.parent_id , lhcd.child_id, lhcd.depth from team_locations inner join location_hierchy_closer_det lhcd on lhcd.child_id = team_locations.location_id order by lhcd.depth desc
),
location_full_name as (
	select distinct parent_locations.child_id as location_id, string_agg(lm.name, ''>'' ) as "locationFullName" 
	from parent_locations inner join location_master lm on lm.id = parent_locations.parent_id group by parent_locations.child_id 
)
,
team_locations_dto as(
select t.id,
cast(json_agg(json_build_object(''locationId'',lfn.location_id, ''locationFullName'',lfn."locationFullName" )) as text ) as locations
from teams t left join team_location_master tlm on tlm.team_id = t.id and tlm.state= ''ACTIVE''
left join location_full_name lfn on lfn.location_id = tlm.location_id group by t.id
)
,
team_users_dto as(
select t.id,
cast(json_agg(json_build_object(''userId'',uu.id,''firstName'',uu.first_name ,''lastName'',uu.last_name ,''userName'',uu.user_name ,''roleId'', uu.role_id ,''roleName'',urm.name )) as text) as users
from teams t  
left join team_member_det tmd on tmd.team_id = t.id and tmd.state = ''ACTIVE''
inner join um_user uu on uu.id = tmd.user_id 
inner join um_role_master urm on urm.id = uu.role_id
 group by t.id
)
select t.id,t.team_type_id as "teamTypeId",t.name ,ttm.type as "teamType",ttm.state as "teamTypeState" ,t.state,tld.locations, tud.users from teams t left join  team_locations_dto tld on t.id = tld.id
left join team_users_dto tud on t.id = tud.id
left join team_type_master ttm on t.team_type_id = ttm.id ;',true,'ACTIVE',NULL,true);

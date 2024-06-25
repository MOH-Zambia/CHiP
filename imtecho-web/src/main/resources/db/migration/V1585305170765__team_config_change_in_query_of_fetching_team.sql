delete from query_master qm where qm.code = 'retrieve_team_with_members_by_id';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1,'2020-02-17 18:49:00.084',80208,'2020-03-27 12:13:44.657','retrieve_team_with_members_by_id','teamId','with team as (
	select id , tm.team_type_id ,tm.name, tm.state from team_master tm where id = #teamId# and state=''ACTIVE''
) ,
teams_locations as (
select team.* , tlm.location_id from team inner join team_location_master tlm on team.id = tlm.team_id  and tlm.state =''ACTIVE''
)
,
location_subloc as (
	select lhcd.parent_id , lhcd.child_id  from location_hierchy_closer_det lhcd where lhcd.child_id in (select location_id from teams_locations)  order by lhcd.depth desc
)
,
location_fullname as(
	select ls.child_id as location_id ,string_agg(lm.name , ''>'')  as "locationFullName" from location_subloc ls inner join location_master lm on lm.id = ls.parent_id group by ls.child_id 
),
location_detail as (
	select lm.id , lm.name, lm.type from location_master lm inner join teams_locations on teams_locations.location_id = lm.id
)
,
team_location_dto as (
	select teams_locations.id ,
	cast (json_agg(json_build_object(''locationFullName'',location_fullname."locationFullName",''name'',location_detail.name, ''id'',location_detail.id ,''locationId'',location_detail.id)) as text ) as locations
	from teams_locations inner join location_fullname on location_fullname.location_id = teams_locations.location_id 
	inner join  location_detail on location_detail.id =  teams_locations.location_id group by teams_locations.id
)
,
team_members_dto as (
	select tm.id, tm.name ,cast(jsonb_build_object(''id'', ttm.id, ''type'',ttm.type,''state'',ttm.state ) as text) as "teamType",
	cast(json_agg(json_build_object(''id'',uu.id ,''firstName'', uu.first_name,''lastName''  ,
			uu.last_name,''userName'' ,uu.user_name ,''middleName'',uu.middle_name ,''roleId'',
			uu.role_id,''roleName'' ,urm.name )
			) as text) as users 
	from team_master tm  
	inner join team_type_master ttm on ttm.id = tm.team_type_id 
	inner join team_member_det tmd on tm.id = tmd.team_id 
	inner join um_user uu on uu.id = tmd.user_id 
	inner join um_role_master urm on urm.id = uu.role_id where tmd.state = ''ACTIVE'' and tm.id = #teamId# group by tm.id , ttm.id 
)
select team_members_dto.* , team_location_dto.locations from team_members_dto inner join team_location_dto on team_location_dto.id = team_members_dto.id;',true,'ACTIVE',NULL,true)
;
Delete from menu_config where menu_name='Manage Teams';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Manage Teams','manage',TRUE,'techo.manage.teams','{}');

Drop table if exists team_type_master;

CREATE TABLE if not exists team_type_master
(
  id serial NOT NULL ,
  type character varying(200) NOT NULL,
  state character varying(200) ,
  max_position integer,
  created_by integer,
  created_on timestamp without time zone ,
  modified_by integer ,
  modified_on timestamp without time zone , 
  CONSTRAINT team_type_master_pkey PRIMARY KEY (id)
);

Drop table if exists team_type_role_master;

CREATE TABLE if not exists team_type_role_master
(
  id serial NOT NULL ,
  team_type_id integer NOT NULL,
  role_id integer NOT NULL,
  state character varying(200) ,
  CONSTRAINT team_type_role_master_pkey PRIMARY KEY (id)
);

Drop table if exists team_configuration_det;

CREATE TABLE if not exists team_configuration_det
(
  id serial NOT NULL ,
  team_type_id integer NOT NULL,
  role_id integer NOT NULL,
  min_member smallint ,
  max_member smallint,
  state character varying(200),
  created_by integer ,
  created_on timestamp without time zone,
  modified_by integer ,
  modified_on timestamp without time zone ,
  CONSTRAINT team_configuration_det_pkey PRIMARY KEY (id)
);

Drop table if exists team_master;

CREATE TABLE if not exists team_master
(
  id serial NOT NULL ,
  team_type_id integer NOT NULL,
  name character varying(200),
  created_by integer ,
  state character varying(200),
  created_on timestamp without time zone,
  modified_by integer ,
  modified_on timestamp without time zone ,
  CONSTRAINT team_master_pkey PRIMARY KEY (id)
);

Drop table if exists team_member_det;

CREATE TABLE if not exists team_member_det
(
  id serial NOT NULL ,
  team_id integer NOT NULL,
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  state character varying(200),
  created_by integer ,
  created_on timestamp without time zone,
  modified_by integer ,
  modified_on timestamp without time zone ,
  CONSTRAINT team_member_det_pkey PRIMARY KEY (id)
);

Drop table if exists team_location_master;

CREATE TABLE if not exists team_location_master
(
  id serial NOT NULL ,
  team_id integer NOT NULL,
  location_id integer NOT NULL,
  state character varying(200),
  CONSTRAINT team_location_master_pkey PRIMARY KEY (id)
);

Drop table if exists team_type_location_management;
CREATE TABLE team_type_location_management
(
 created_by integer NOT NULL,
 created_on timestamp without time zone NOT NULL,
 modified_by integer,
 modified_on timestamp without time zone,
 team_type_id integer NOT NULL,
 location_type character varying(255) NOT NULL,
 state character varying(255),
 level integer,
 CONSTRAINT team_type_location_management_pkey PRIMARY KEY (team_type_id, location_type)
);

delete from query_master where code='team_type_retrival';

INSERT INTO public.query_master(created_by, created_on, modified_by, modified_on, code, params,query, returns_result_set, state)
VALUES (1,now(),null,null,'team_type_retrival','roleId',
'select ttm.id , ttm.type, ttm.max_position as "maxPosition" from team_type_master ttm inner join (select * from team_type_role_master ttrm where role_id = #roleId# AND state = ''ACTIVE'') as team_role on team_role.team_type_id = ttm.id where ttm.state =''ACTIVE'';',true,'ACTIVE');

delete from query_master  where code ='retriveal_of_team_conf_detail_by_team_type';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'retriveal_of_team_conf_detail_by_team_type', 'SELECT tcd.id as id,  
tcd.team_type_id as "teamTypeId", 
tcd.min_member as "minMember",
tcd.max_member as "maxMember",
rm.name as "roleName",
rm.id as "roleId" 
from team_configuration_det tcd  inner join um_role_master rm on rm.id = tcd.role_id where tcd.team_type_id = #teamTypeId# and tcd.state =''ACTIVE'' ;', 
            'teamTypeId',true,'ACTIVE');

delete from query_master  where code ='user_search_for_selectize_by_role';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'user_search_for_selectize_by_role', 'select um_user.id,
first_name as "firstName", 
last_name as "lastName", 
user_name as "userName", 
role_id as "roleId",
um_role_master.name as "roleName"
from um_user 
inner join um_role_master on um_role_master.id = um_user.role_id
where role_id in (#roleIds#) and  ( first_name like ''%#searchString#%'' or last_name like ''%#searchString#%'' or user_name like ''%#searchString#''  ) limit 50', 
            'roleIds,searchString,searchString,searchString',true,'ACTIVE');


delete from query_master  where code ='retrieve_all_teams_with_members';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'retrieve_all_teams_with_members', 'select tm.id, tm.name , tm.state ,tm.team_type_id as "teamTypeId" ,ttm.type as "teamType",
cast( json_agg(json_build_object(''id'',uu.id ,''firstName'', uu.first_name,''lastName''  ,uu.last_name,''userName'' ,uu.user_name ,''middleName'',uu.middle_name ,''roleId'', uu.role_id,''roleName'' ,urm.name )) as text)as users from team_master tm  
inner join team_type_master ttm on ttm.id = tm.team_type_id 
inner join team_member_det tmd on tm.id = tmd.team_id 
inner join um_user uu on uu.id = tmd.user_id 
inner join um_role_master urm on urm.id = uu.role_id where tmd.state = ''ACTIVE'' group by tm.id , ttm.type ;', 
            '',true,'ACTIVE');  


delete from query_master  where code ='retrieve_team_with_members_by_id';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'retrieve_team_with_members_by_id', 'with team as (
	select id , tm.team_type_id ,tm.name, tm.state from team_master tm where id = #teamId# and state=''ACTIVE''
) ,
teams_locations as (
select team.* , tlm.location_id from team inner join team_location_master tlm on team.id = tlm.team_id 
)
,
location_subloc as (
	select lhcd.parent_id , lhcd.child_id  from location_hierchy_closer_det lhcd where lhcd.child_id in (select location_id from teams_locations)  order by lhcd.depth desc
)
,
location_fullname as(
	select ls.child_id as location_id ,string_agg(lm.name , '','')  as "locationFullName" from location_subloc ls inner join location_master lm on lm.id = ls.parent_id group by ls.child_id 
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
	select tm.id, tm.name ,cast(jsonb_build_object(''id'', ttm.id ,''maxPosition'',ttm.max_position,''type'',ttm.type,''state'',ttm.state ) as text) as "teamType",
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
select team_members_dto.* , team_location_dto.locations from team_members_dto inner join team_location_dto on team_location_dto.id = team_members_dto.id;', 
            'teamId',true,'ACTIVE');

delete from query_master  where code ='mark_team_as_active_or_inactive';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'mark_team_as_active_or_inactive', 'update team_master set state = ''#state#'' where id = #teamId# ;', 
            'teamId,state',false,'ACTIVE');

delete from query_master  where code ='retrive_team_type_location';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'retrive_team_type_location', 'select * from team_type_location_management where team_type_id = ''#teamTypeId#'' and state = ''ACTIVE'';','teamTypeId',true,'ACTIVE');

delete from query_master  where code ='retrive_team_by_team_type_and_location';
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'retrive_team_by_team_type_and_location','select tm.id, tm.name ,tm.team_type_id as "teamTypeId" 
from team_master tm  
inner join team_location_master  tlm on tm.id =  tlm.team_id
where tm.team_type_id = ''#teamTypeId#'' and  cast( ''#locationId#'' as integer) in (tlm.location_id) and tm.state=''ACTIVE'';', 'teamTypeId,locationId',true,'ACTIVE');



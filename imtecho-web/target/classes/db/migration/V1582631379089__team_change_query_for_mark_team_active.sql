delete from query_master qm where code = 'mark_team_as_active_or_inactive';

INSERT INTO query_master (created_by,created_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1,now(),'mark_team_as_active_or_inactive','teamId,state','update team_master set state = ''#state#''  , modified_on = now() where id = #teamId# ;',false,'ACTIVE',NULL,true)
;

delete from query_master qm where code = 'team_user_search_for_selectize_by_role';
INSERT INTO query_master (created_by,created_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1,now(),'team_user_search_for_selectize_by_role','searchString,roleIds,teamTypeId','with exclude_user as(
	select tmd.user_id from team_master tm inner join team_member_det tmd on tm.id = tmd.team_id and tmd.state =''ACTIVE'' and tm.state = ''ACTIVE'' where tmd.role_id in(#roleIds#) and tm.team_type_id = #teamTypeId#
)
select um_user.id,
first_name as "firstName", 
last_name as "lastName", 
user_name as "userName", 
um_user.role_id as "roleId",
um_role_master.name as "roleName"
from um_user 
inner join um_role_master on um_role_master.id = um_user.role_id
where um_user.role_id in (#roleIds#) and  um_user.id not in (select * from exclude_user) and
( first_name like ''%#searchString#%'' or last_name like ''%#searchString#%'' or user_name like ''%#searchString#''  ) 
limit 50',true,'ACTIVE',NULL,true)
;